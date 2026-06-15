import Foundation
import CoreText

//  Decrypt.swift
//
//  Extracts symbol use-restriction text directly from the SF Symbols app's font.
//
//  Background: symbol use-restrictions live in the system CoreGlyphs bundle's
//  `symbol_restrictions.strings`, which is tied to the installed OS. When the
//  SF Symbols app ships symbols for an unreleased OS (e.g. iOS 27 in a beta app),
//  CoreGlyphs has no restriction text for them. The app, however, decrypts its
//  own font's obfuscated `symp` metadata table — a CSV that includes a
//  "Use Restrictions" column for every symbol, current with the app.
//
//  This tool reuses Apple's own deobfuscation routine
//  (`CoreGlyphsLib.Crypton.decryptObfuscatedFontTable`) to read that table and
//  emit `font_restrictions.tsv` ("name<TAB>restriction" per line), which the
//  symbols.json generation step picks up as an authoritative restriction source.
//
//  NOTE: This calls a PRIVATE Apple symbol via @_silgen_name, resolved at runtime
//  via dlopen of the app's CoreGlyphsLib. It is a local code-generation tool and
//  is never shipped. If Apple renames the symbol this will fail to resolve — the
//  update pipeline treats that as a soft failure and falls back to CoreGlyphs
//  restrictions.

// MARK: - Private decryptor binding
//
// Bound as a `static` method so Swift passes a valid metatype in the swiftself
// register (the routine ignores it, but this keeps the ABI well-formed).
fileprivate struct CryptonShim {}
fileprivate extension CryptonShim {
    @_silgen_name("$s13CoreGlyphsLib7CryptonV26decryptObfuscatedFontTable8tableTag4from10Foundation4DataVSgs6UInt32V_So9CTFontRefatFZ")
    static func decryptObfuscatedFontTable(_ tableTag: UInt32, _ from: CTFont) -> Data?
}

fileprivate func fourCC(_ s: String) -> UInt32 {
    s.utf8.reduce(0) { ($0 << 8) | UInt32($1) }
}

// MARK: - Minimal RFC-4180 CSV parser

fileprivate func parseCSV(_ text: String) -> [[String]] {
    var rows: [[String]] = []
    var row: [String] = []
    var field = ""
    var inQuotes = false
    var chars = Array(text.unicodeScalars)
    var i = 0
    while i < chars.count {
        let c = chars[i]
        if inQuotes {
            if c == "\"" {
                if i + 1 < chars.count, chars[i + 1] == "\"" {
                    field.unicodeScalars.append("\""); i += 1
                } else {
                    inQuotes = false
                }
            } else {
                field.unicodeScalars.append(c)
            }
        } else {
            switch c {
            case "\"": inQuotes = true
            case ",": row.append(field); field = ""
            case "\n": row.append(field); field = ""; rows.append(row); row = []
            case "\r": break
            default: field.unicodeScalars.append(c)
            }
        }
        i += 1
    }
    if !field.isEmpty || !row.isEmpty { row.append(field); rows.append(row) }
    chars.removeAll()
    return rows
}

// MARK: - Entry point

/// Decrypts the SF Symbols app's font `symp` metadata table and writes
/// `font_restrictions.tsv` ("name<TAB>restriction" per line) into `workingDir`.
///
/// Soft-fails: any problem (missing framework/font, the private decryptor symbol
/// changing, dlopen failure, etc.) just logs a warning and returns without
/// writing the file, leaving restrictions to be sourced from CoreGlyphs.
func generateFontRestrictions(appPath: String, workingDir: URL) {
    let frameworksDir = URL(fileURLWithPath: appPath)
        .appendingPathComponent("Contents/Frameworks/SFSymbolsShared.framework/Versions/A/Frameworks")
    let coreGlyphsLib = frameworksDir
        .appendingPathComponent("CoreGlyphsLib.framework/Versions/A/CoreGlyphsLib")

    guard FileManager.default.fileExists(atPath: coreGlyphsLib.path) else {
        print("⚠️  CoreGlyphsLib not found in the app bundle — using CoreGlyphs restrictions only.")
        return
    }

    // Resolve the private decryptor symbol at runtime. The @_silgen_name binding
    // stays undefined at link time (-undefined dynamic_lookup) and is satisfied
    // once CoreGlyphsLib is loaded here.
    guard dlopen(coreGlyphsLib.path, RTLD_NOW) != nil else {
        let message = dlerror().map { String(cString: $0) } ?? "unknown error"
        print("⚠️  Could not dlopen CoreGlyphsLib (\(message)). Falling back to CoreGlyphs restrictions.")
        return
    }

    print("🔓 Decrypting font metadata for use-restrictions...")

    let fontURL = URL(fileURLWithPath: appPath)
        .appendingPathComponent("Contents/Resources/Fonts/SFSymbolsFallback.otf")

    guard FileManager.default.fileExists(atPath: fontURL.path) else {
        print("⚠️  Font not found at \(fontURL.path). Falling back to CoreGlyphs restrictions.")
        return
    }

    guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(fontURL as CFURL) as? [CTFontDescriptor],
          let descriptor = descriptors.first else {
        print("⚠️  Could not create a font descriptor from the SF Symbols font. Falling back to CoreGlyphs restrictions.")
        return
    }
    let font = CTFontCreateWithFontDescriptor(descriptor, 12.0, nil)

    guard let sympData = CryptonShim.decryptObfuscatedFontTable(fourCC("symp"), font) else {
        print("⚠️  Failed to decrypt 'symp' metadata table (the private decryptor symbol may have changed). Falling back to CoreGlyphs restrictions.")
        return
    }

    guard let csv = String(data: sympData, encoding: .utf8) else {
        print("⚠️  Decrypted 'symp' table is not valid UTF-8. Falling back to CoreGlyphs restrictions.")
        return
    }

    let rows = parseCSV(csv)
    guard let header = rows.first,
          let nameIdx = header.firstIndex(of: "Name"),
          let restrIdx = header.firstIndex(of: "Use Restrictions") else {
        print("⚠️  Expected 'Name' and 'Use Restrictions' columns not found. Falling back to CoreGlyphs restrictions.")
        return
    }

    var lines: [String] = []
    for row in rows.dropFirst() {
        guard row.count > max(nameIdx, restrIdx) else { continue }
        let name = row[nameIdx].trimmingCharacters(in: .whitespacesAndNewlines)
        let restriction = row[restrIdx].trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty, !restriction.isEmpty else { continue }
        // Restriction text never contains tabs/newlines, so a TSV is unambiguous.
        lines.append("\(name)\t\(restriction)")
    }

    let outputURL = workingDir.appendingPathComponent("font_restrictions.tsv")
    do {
        try (lines.joined(separator: "\n") + "\n").write(to: outputURL, atomically: true, encoding: .utf8)
        print("☑️  Decrypted font restrictions: \(lines.count) symbols → font_restrictions.tsv")
    } catch {
        print("⚠️  Could not write font_restrictions.tsv: \(error). Falling back to CoreGlyphs restrictions.")
    }
}
