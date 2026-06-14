#!/usr/bin/env swift
//
//  DecryptFontMetadata.swift
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
//  emit `font_restrictions.tsv` ("name<TAB>restriction" per line), which
//  GenerateSymbolsJSON.swift picks up as an authoritative restriction source.
//
//  NOTE: This calls a PRIVATE Apple symbol via @_silgen_name. It is a local
//  code-generation tool and is never shipped. If Apple renames the symbol this
//  will fail to link — UpdateScript.swift treats that as a soft failure and
//  falls back to CoreGlyphs restrictions.
//
//  Build/run (handled automatically by UpdateScript.swift):
//    swiftc DecryptFontMetadata.swift -o <bin> \
//      "<app>/Contents/Frameworks/SFSymbolsShared.framework/Versions/A/Frameworks/CoreGlyphsLib.framework/Versions/A/CoreGlyphsLib" \
//      -Xlinker -rpath -Xlinker "<app>/Contents/Frameworks/SFSymbolsShared.framework/Versions/A/Frameworks"
//    <bin> "/Applications/SF Symbols Beta.app"

import Foundation
import CoreText

// MARK: - Private decryptor binding
//
// Bound as a `static` method so Swift passes a valid metatype in the swiftself
// register (the routine ignores it, but this keeps the ABI well-formed).
private struct CryptonShim {}
private extension CryptonShim {
    @_silgen_name("$s13CoreGlyphsLib7CryptonV26decryptObfuscatedFontTable8tableTag4from10Foundation4DataVSgs6UInt32V_So9CTFontRefatFZ")
    static func decryptObfuscatedFontTable(_ tableTag: UInt32, _ from: CTFont) -> Data?
}

private func fourCC(_ s: String) -> UInt32 {
    s.utf8.reduce(0) { ($0 << 8) | UInt32($1) }
}

// MARK: - Minimal RFC-4180 CSV parser

private func parseCSV(_ text: String) -> [[String]] {
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

// MARK: - Main

let appPath: String = {
    guard let p = CommandLine.arguments.dropFirst().first else {
        FileHandle.standardError.write(Data("Usage: DecryptFontMetadata <app path>\n".utf8))
        exit(2)
    }
    return p
}()

let fontURL = URL(fileURLWithPath: appPath)
    .appendingPathComponent("Contents/Resources/Fonts/SFSymbolsFallback.otf")

guard FileManager.default.fileExists(atPath: fontURL.path) else {
    FileHandle.standardError.write(Data("❌ Font not found at \(fontURL.path)\n".utf8))
    exit(1)
}

guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(fontURL as CFURL) as? [CTFontDescriptor],
      let descriptor = descriptors.first else {
    FileHandle.standardError.write(Data("❌ Could not create a font descriptor from the SF Symbols font\n".utf8))
    exit(1)
}
let font = CTFontCreateWithFontDescriptor(descriptor, 12.0, nil)

guard let sympData = CryptonShim.decryptObfuscatedFontTable(fourCC("symp"), font) else {
    FileHandle.standardError.write(Data("❌ Failed to decrypt 'symp' metadata table\n".utf8))
    exit(1)
}

guard let csv = String(data: sympData, encoding: .utf8) else {
    FileHandle.standardError.write(Data("❌ Decrypted 'symp' table is not valid UTF-8\n".utf8))
    exit(1)
}

let rows = parseCSV(csv)
guard let header = rows.first,
      let nameIdx = header.firstIndex(of: "Name"),
      let restrIdx = header.firstIndex(of: "Use Restrictions") else {
    FileHandle.standardError.write(Data("❌ Expected 'Name' and 'Use Restrictions' columns not found\n".utf8))
    exit(1)
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

let outputURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent("font_restrictions.tsv")
try (lines.joined(separator: "\n") + "\n").write(to: outputURL, atomically: true, encoding: .utf8)

print("☑️  Decrypted font restrictions: \(lines.count) symbols → font_restrictions.tsv")
