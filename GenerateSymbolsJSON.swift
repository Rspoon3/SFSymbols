#!/usr/bin/env swift

import Foundation
import AppKit

// MARK: - Entry Config

fileprivate let metadataSubpath = "Contents/Resources/Metadata"
fileprivate let coreGlyphsBundlePath = "/System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources"

fileprivate let inputURL: URL = {
    guard let appPath = CommandLine.arguments.dropFirst().first else {
        print("Usage: GenerateSymbolsJSON.swift \"/Applications/SF Symbols.app\"")
        exit(1)
    }

    let url = URL(fileURLWithPath: appPath)
        .appendingPathComponent(metadataSubpath, isDirectory: true)

    guard FileManager.default.fileExists(atPath: url.path) else {
        print("Error: Could not find Metadata folder at expected path: \(url.path)")
        exit(1)
    }

    return url
}()

fileprivate let scriptDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
fileprivate let drawFilePath = scriptDirectory.appendingPathComponent("draw.txt")

// MARK: - Draw Category Input
//
// The "Draw" category symbols cannot be automatically extracted from the SF Symbols app
// metadata because Apple does not include this category in the symbol_categories.plist file.
//
// To populate the Draw category:
// 1. Open the SF Symbols app
// 2. Select the "Draw" category from the sidebar
// 3. Select all symbols (Cmd+A)
// 4. Copy the symbol names (Cmd+Shift+C)
// 5. Run this script - it will automatically read from your clipboard
//
// The script will save these to draw.txt for future runs.

/// Reads clipboard contents using NSPasteboard
func getClipboardContents() -> String? {
    return NSPasteboard.general.string(forType: .string)
}

/// Loads draw category symbols from draw.txt or clipboard
func loadDrawCategorySymbols() -> Set<String> {
    // Check if draw.txt already exists
    if FileManager.default.fileExists(atPath: drawFilePath.path) {
        if let contents = try? String(contentsOf: drawFilePath, encoding: .utf8) {
            let symbols = contents
                .components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            print("Loaded \(symbols.count) draw category symbols from draw.txt")
            return Set(symbols)
        }
    }

    // Check if running interactively (stdin is a TTY)
    let isInteractive = isatty(FileHandle.standardInput.fileDescriptor) != 0

    if isInteractive {
        // Prompt user to copy symbols, then read from clipboard
        print("")
        print("╔════════════════════════════════════════════════════════════════════╗")
        print("║                    DRAW CATEGORY INPUT REQUIRED                    ║")
        print("╠════════════════════════════════════════════════════════════════════╣")
        print("║ The 'Draw' category cannot be extracted automatically.             ║")
        print("║                                                                    ║")
        print("║ To populate it:                                                    ║")
        print("║   1. Open SF Symbols app                                           ║")
        print("║   2. Select 'Draw' from the sidebar                                ║")
        print("║   3. Select all symbols (Cmd+A)                                    ║")
        print("║   4. Copy symbol names (Cmd+Shift+C)                               ║")
        print("║   5. Press Enter to read from clipboard, or type 'skip' to skip    ║")
        print("╚════════════════════════════════════════════════════════════════════╝")
        print("")
        print("Press Enter when ready (or type 'skip'): ", terminator: "")
        fflush(stdout)

        let input = readLine() ?? ""
        if input.trimmingCharacters(in: .whitespaces).lowercased() == "skip" {
            print("Skipping draw category input.")
            return []
        }
    } else {
        // Non-interactive mode: just try to read from clipboard
        print("Non-interactive mode: reading Draw category from clipboard...")
    }

    // Read from clipboard
    guard let clipboardContents = getClipboardContents() else {
        print("Warning: Could not read clipboard.")
        return []
    }

    if clipboardContents.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        print("Warning: Clipboard is empty. Skipping Draw category.")
        return []
    }

    let lines = clipboardContents
        .components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { !$0.isEmpty }

    if lines.isEmpty {
        print("Warning: No symbol names found in clipboard.")
        return []
    }

    print("Found \(lines.count) symbols in clipboard.")

    // Save to draw.txt for future runs
    let content = lines.joined(separator: "\n")
    do {
        try content.write(to: drawFilePath, atomically: true, encoding: .utf8)
        print("Saved \(lines.count) draw category symbols to draw.txt")
    } catch {
        print("Warning: Could not save draw.txt: \(error)")
    }

    return Set(lines)
}

// MARK: - Localization

enum Localization: String, CaseIterable, Codable {
    // Original localizations
    case ar, he, hi, ja, km, ko, my, rtl, th, zh
    // New localizations added in SF Symbols 6
    case bn, el, gu, kn, ml, mr, or, pa, ru, si, ta, te

    var title: String {
        switch self {
        case .ar: return "Arabic"
        case .bn: return "Bengali"
        case .el: return "Greek"
        case .gu: return "Gujarati"
        case .he: return "Hebrew"
        case .hi: return "Hindi"
        case .ja: return "Japanese"
        case .km: return "Central Khmer"
        case .kn: return "Kannada"
        case .ko: return "Korean"
        case .ml: return "Malayalam"
        case .mr: return "Marathi"
        case .my: return "Burmese"
        case .or: return "Odia"
        case .pa: return "Punjabi"
        case .rtl: return "Right-to-Left"
        case .ru: return "Russian"
        case .si: return "Sinhala"
        case .ta: return "Tamil"
        case .te: return "Telugu"
        case .th: return "Thai"
        case .zh: return "Chinese"
        }
    }
}

/// Detects localization suffix from a symbol name
/// Returns (baseName, localization) tuple
func detectLocalization(from symbolName: String) -> (baseName: String, localization: Localization?) {
    for loc in Localization.allCases {
        let suffix = ".\(loc.rawValue)"
        if symbolName.hasSuffix(suffix) {
            let baseName = String(symbolName.dropLast(suffix.count))
            return (baseName, loc)
        }
    }
    return (symbolName, nil)
}

// MARK: - Models

struct PlatformAvailability: Codable {
    let iOS: String
    let macOS: String
    let tvOS: String
    let watchOS: String
    let visionOS: String
}

struct LocalizationInfo: Codable {
    let code: String
    let name: String
    let availability: PlatformAvailability?
}

struct SFCategoryInfo: Codable {
    let icon: String
    let title: String
}

struct SFSymbol: Codable {
    let name: String
    let year: String?
    let availability: PlatformAvailability?
    let layersets: [String]
    let localizations: [LocalizationInfo]
    let categories: [SFCategoryInfo]
    let restriction: String?
    let deprecatedNewName: String?
}

struct SymbolsOutput: Codable {
    let generatedAt: String
    let totalCount: Int
    let symbols: [SFSymbol]
}

// MARK: - Intermediate types for merging

struct ScannedSymbol {
    var name: String
    var year: String?
    var layersets: [String]
}

struct MergedSymbol {
    var baseName: String
    var baseSymbol: ScannedSymbol?
    var localizedVariants: [(localization: Localization, symbol: ScannedSymbol)]
}

// MARK: - Load PLists
//
// Primary data source: CoreGlyphs bundle (system runtime data)
// - Symbol names and availability
// - Aliases (deprecations)
// - Categories
// - Restrictions
//
// Secondary data source: SF Symbols app (supplementary data)
// - Layersets (hierarchical/multicolor support) - not available in CoreGlyphs

let coreGlyphsURL = URL(fileURLWithPath: coreGlyphsBundlePath)

// Load symbol names from CoreGlyphs (primary source)
let coreGlyphsNameAvailabilityURL = coreGlyphsURL.appendingPathComponent("name_availability.plist")
guard let nameData = try? Data(contentsOf: coreGlyphsNameAvailabilityURL),
      let namePlist = try? PropertyListSerialization.propertyList(from: nameData, format: nil) as? [String: Any],
      let nameSymbols = namePlist["symbols"] as? [String: String] else {
    print("Error: Could not read name_availability.plist from CoreGlyphs")
    exit(1)
}
print("Loaded \(nameSymbols.count) symbols from CoreGlyphs name_availability.plist")

// Load layersets from SF Symbols app (only source for this data)
let layersetAvailabilityURL = inputURL.appendingPathComponent("layerset_availability.plist")
var layersetSymbols: [String: [String: String]] = [:]
var layersetPlist: [String: Any] = [:]

if let layersetData = try? Data(contentsOf: layersetAvailabilityURL),
   let plist = try? PropertyListSerialization.propertyList(from: layersetData, format: nil) as? [String: Any],
   let symbols = plist["symbols"] as? [String: [String: String]] {
    layersetSymbols = symbols
    layersetPlist = plist
    print("Loaded \(layersetSymbols.count) layerset entries from SF Symbols app")
} else {
    print("Warning: Could not load layerset_availability.plist from SF Symbols app - layerset data will be incomplete")
}

// MARK: - Load Restrictions

let restrictionsURL = URL(fileURLWithPath: coreGlyphsBundlePath).appendingPathComponent("symbol_restrictions.strings")
var symbolRestrictions: [String: String] = [:]

if let restrictionsData = try? Data(contentsOf: restrictionsURL),
   let restrictions = try? PropertyListDecoder().decode([String: String].self, from: restrictionsData) {
    symbolRestrictions = restrictions
    print("Loaded \(symbolRestrictions.count) symbol restrictions from CoreGlyphs.bundle")
} else {
    print("Warning: Could not load symbol_restrictions.strings from CoreGlyphs.bundle")
}

// MARK: - Load Aliases (Deprecated Symbol Names)
//
// Aliases are loaded from CoreGlyphs, which is the runtime source of truth.
// Since we now use CoreGlyphs for symbol names, aliases will always point
// to symbols that exist in our output.

let coreGlyphsAliasesURL = coreGlyphsURL.appendingPathComponent("name_aliases.strings")
var symbolAliases: [String: String] = [:] // old name -> new name

if let aliasesData = try? Data(contentsOf: coreGlyphsAliasesURL),
   let aliases = try? PropertyListDecoder().decode([String: String].self, from: aliasesData) {
    symbolAliases = aliases
    print("Loaded \(aliases.count) symbol aliases from CoreGlyphs")
} else {
    print("Warning: Could not load name_aliases.strings from CoreGlyphs")
}

// MARK: - Load Categories

/// Category info from categories.plist
struct CategoryPlistEntry: Codable {
    let key: String
    let label: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case key
        case label
        case icon
    }
}

// Category definitions come from SF Symbols app (has labels)
// Category mappings come from CoreGlyphs (authoritative for which symbols are in which category)
let categoriesURL = inputURL.appendingPathComponent("categories.plist")
let symbolCategoriesURL = coreGlyphsURL.appendingPathComponent("symbol_categories.plist")

var allCategories: [CategoryPlistEntry] = []
var categoryKeyToInfo: [String: SFCategoryInfo] = [:]
var symbolToCategories: [String: [String]] = [:] // symbol name -> category keys

if let categoriesData = try? Data(contentsOf: categoriesURL),
   let categories = try? PropertyListDecoder().decode([CategoryPlistEntry].self, from: categoriesData) {
    allCategories = categories
    for cat in categories {
        categoryKeyToInfo[cat.key] = SFCategoryInfo(icon: cat.icon, title: cat.label)
    }
    print("Loaded \(allCategories.count) category definitions from SF Symbols app")
} else {
    print("Warning: Could not load categories.plist from SF Symbols app")
}

if let symbolCategoriesData = try? Data(contentsOf: symbolCategoriesURL),
   let symbolCats = try? PropertyListDecoder().decode([String: [String]].self, from: symbolCategoriesData) {
    symbolToCategories = symbolCats
    print("Loaded category mappings for \(symbolToCategories.count) symbols from CoreGlyphs")
} else {
    print("Warning: Could not load symbol_categories.plist from CoreGlyphs")
}

// MARK: - Load Draw Category

let drawCategorySymbols = loadDrawCategorySymbols()

// Add "draw" category to the category list if it doesn't exist
let drawCategoryKey = "draw"
let drawCategoryInfo = SFCategoryInfo(icon: "pencil.and.outline", title: "Draw")
if categoryKeyToInfo[drawCategoryKey] == nil {
    categoryKeyToInfo[drawCategoryKey] = drawCategoryInfo
    print("Added 'Draw' category definition")
}

// Add draw category to symbol mappings
for symbolName in drawCategorySymbols {
    if symbolToCategories[symbolName] == nil {
        symbolToCategories[symbolName] = [drawCategoryKey]
    } else if !symbolToCategories[symbolName]!.contains(drawCategoryKey) {
        symbolToCategories[symbolName]!.append(drawCategoryKey)
    }
}
if !drawCategorySymbols.isEmpty {
    print("Added \(drawCategorySymbols.count) symbols to Draw category")
}

// MARK: - Determine Best year_to_release
//
// Use year_to_release from CoreGlyphs (primary), with SF Symbols app layerset
// data as a fallback if it has more recent entries.

var nameYearToRelease = namePlist["year_to_release"] as? [String: [String: String]] ?? [:]
var layersetYearToRelease = layersetPlist["year_to_release"] as? [String: [String: String]] ?? [:]

// ============================================================================
// WORKAROUND: Apple's plist files are missing the 2025 release year entry.
// We manually inject it here. This can hopefully be removed in a future
// version of SF Symbols when Apple fixes their plist files.
// ============================================================================
let missing2025Entry: [String: String] = [
    "iOS": "26.0",
    "macOS": "26.0",
    "tvOS": "26.0",
    "watchOS": "26.0",
    "visionOS": "26.0"
]

if nameYearToRelease["2025"] == nil {
    nameYearToRelease["2025"] = missing2025Entry
    print("Injected missing 2025 release year into CoreGlyphs (Apple bug workaround)")
}

if layersetYearToRelease["2025"] == nil {
    layersetYearToRelease["2025"] = missing2025Entry
    print("Injected missing 2025 release year into SF Symbols app layersets (Apple bug workaround)")
}
// ============================================================================

func maxYear(in dict: [String: [String: String]]) -> String {
    dict.keys.max { a, b in
        let aParts = a.split(separator: ".").compactMap { Double($0) }
        let bParts = b.split(separator: ".").compactMap { Double($0) }
        let aValue = (aParts.first ?? 0) * 100 + (aParts.count > 1 ? aParts[1] : 0)
        let bValue = (bParts.first ?? 0) * 100 + (bParts.count > 1 ? bParts[1] : 0)
        return aValue < bValue
    } ?? ""
}

let nameMaxYear = maxYear(in: nameYearToRelease)
let layersetMaxYear = maxYear(in: layersetYearToRelease)

let yearToRelease: [String: [String: String]]
if nameMaxYear >= layersetMaxYear {
    yearToRelease = nameYearToRelease
    print("Using year_to_release from CoreGlyphs (max: \(nameMaxYear))")
} else {
    yearToRelease = layersetYearToRelease
    print("Using year_to_release from SF Symbols app layersets (max: \(layersetMaxYear))")
}

// Build version map from plist
var versionMap: [String: PlatformAvailability] = [:]
for (year, platforms) in yearToRelease {
    guard let iOS = platforms["iOS"],
          let macOS = platforms["macOS"],
          let tvOS = platforms["tvOS"],
          let watchOS = platforms["watchOS"],
          let visionOS = platforms["visionOS"] else {
        continue
    }
    versionMap[year] = PlatformAvailability(
        iOS: iOS,
        macOS: macOS,
        tvOS: tvOS,
        watchOS: watchOS,
        visionOS: visionOS
    )
}

// MARK: - Scan All Symbols
//
// Use CoreGlyphs as the authoritative source for symbol names.
// Layerset data comes from SF Symbols app where available.

let allSymbolNames = Set(nameSymbols.keys)
var scannedSymbols: [String: ScannedSymbol] = [:]
var skippedPhantomRtl = 0

for symbolName in allSymbolNames {
    // For ".slash.rtl" variants, check if the base symbol (e.g., "foo.slash") actually exists.
    // If it doesn't exist, this is a phantom symbol and should be skipped.
    // Example: "speaker.slash.rtl" → base "speaker.slash" exists → keep it
    // Example: "square.3.layers.3d.down.forward.slash.rtl" → base doesn't exist → skip it
    if symbolName.hasSuffix(".slash.rtl") {
        let potentialBase = String(symbolName.dropLast(".rtl".count)) // e.g., "foo.slash"
        if !allSymbolNames.contains(potentialBase) {
            skippedPhantomRtl += 1
            continue
        }
    }

    let year = nameSymbols[symbolName]
    let layersetInfo = layersetSymbols[symbolName]

    // Build layersets array (all symbols support monochrome)
    var layersets: [String] = ["monochrome"]
    if layersetInfo?["hierarchical"] != nil {
        layersets.append("hierarchical")
    }
    if layersetInfo?["multicolor"] != nil {
        layersets.append("multicolor")
    }

    scannedSymbols[symbolName] = ScannedSymbol(name: symbolName, year: year, layersets: layersets)
}

print("Scanned \(scannedSymbols.count) total symbol entries (including localized variants)")
if skippedPhantomRtl > 0 {
    print("Skipped \(skippedPhantomRtl) phantom .slash.rtl variants (base symbol doesn't exist)")
}

// MARK: - Merge Localized Variants

var mergedSymbols: [String: MergedSymbol] = [:]

for (symbolName, scanned) in scannedSymbols {
    let (baseName, localization) = detectLocalization(from: symbolName)

    if mergedSymbols[baseName] == nil {
        mergedSymbols[baseName] = MergedSymbol(baseName: baseName, baseSymbol: nil, localizedVariants: [])
    }

    if let loc = localization {
        mergedSymbols[baseName]!.localizedVariants.append((loc, scanned))
    } else {
        mergedSymbols[baseName]!.baseSymbol = scanned
    }
}

// MARK: - Build Final Symbols

var symbols: [SFSymbol] = []
var unmappedYears: Set<String> = []
var symbolsWithLocalizations = 0
var symbolsWithRestrictions = 0
var symbolsDeprecated = 0

for baseName in mergedSymbols.keys.sorted() {
    let merged = mergedSymbols[baseName]!

    // Use base symbol if available, otherwise use first localized variant
    let primarySymbol: ScannedSymbol
    if let base = merged.baseSymbol {
        primarySymbol = base
    } else if let firstVariant = merged.localizedVariants.first {
        primarySymbol = firstVariant.symbol
    } else {
        continue // Skip if no symbols at all
    }

    // Look up platform availability for primary symbol
    let availability: PlatformAvailability?
    if let year = primarySymbol.year {
        if let mapped = versionMap[year] {
            availability = mapped
        } else {
            unmappedYears.insert(year)
            availability = nil
        }
    } else {
        availability = nil
    }

    // Build localizations array
    var localizations: [LocalizationInfo] = []
    for (loc, variant) in merged.localizedVariants.sorted(by: { $0.localization.rawValue < $1.localization.rawValue }) {
        let locAvailability: PlatformAvailability?
        if let year = variant.year, let mapped = versionMap[year] {
            locAvailability = mapped
        } else {
            locAvailability = nil
        }

        localizations.append(LocalizationInfo(
            code: loc.rawValue,
            name: loc.title,
            availability: locAvailability
        ))
    }

    if !localizations.isEmpty {
        symbolsWithLocalizations += 1
    }

    // Look up restriction
    let restriction = symbolRestrictions[baseName]
    if restriction != nil {
        symbolsWithRestrictions += 1
    }

    // Check if this symbol is deprecated (has an alias pointing to a new name)
    let deprecatedNewName: String?
    if let newName = symbolAliases[baseName] {
        // Get the base name of the new symbol (without localization suffix)
        let (newBaseName, _) = detectLocalization(from: newName)
        deprecatedNewName = newBaseName
        symbolsDeprecated += 1
    } else {
        deprecatedNewName = nil
    }

    // Look up categories for this symbol
    var categories: [SFCategoryInfo] = []
    if let categoryKeys = symbolToCategories[baseName] {
        for key in categoryKeys {
            if let info = categoryKeyToInfo[key] {
                categories.append(info)
            }
        }
    }

    let symbol = SFSymbol(
        name: baseName,
        year: primarySymbol.year,
        availability: availability,
        layersets: primarySymbol.layersets,
        localizations: localizations,
        categories: categories,
        restriction: restriction,
        deprecatedNewName: deprecatedNewName
    )

    symbols.append(symbol)
}

if !unmappedYears.isEmpty {
    print("Warning: Unmapped years found: \(unmappedYears.sorted())")
}

// MARK: - Generate Output

let dateFormatter = ISO8601DateFormatter()
let output = SymbolsOutput(
    generatedAt: dateFormatter.string(from: Date()),
    totalCount: symbols.count,
    symbols: symbols
)

let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

guard let jsonData = try? encoder.encode(output) else {
    print("Error: Could not encode JSON")
    exit(1)
}

let outputURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent("symbols.json")

do {
    try jsonData.write(to: outputURL)
    print("Generated symbols.json successfully.")
} catch {
    print("Error writing file: \(error)")
    exit(1)
}

// MARK: - Summary

let withYear = symbols.filter { $0.year != nil }.count
let withHierarchical = symbols.filter { $0.layersets.contains("hierarchical") }.count
let withMulticolor = symbols.filter { $0.layersets.contains("multicolor") }.count
let withCategories = symbols.filter { !$0.categories.isEmpty }.count
let withDrawCategory = symbols.filter { $0.categories.contains { $0.title == "Draw" } }.count
let missingYear = symbols.filter { $0.year == nil }.count
let nonDeprecated = symbols.count - symbolsDeprecated

print()
print("Summary:")
print("  Total symbols (merged):    \(symbols.count)")
print("  Non-deprecated symbols:    \(nonDeprecated)")
print("  Deprecated symbols:        \(symbolsDeprecated)")
print("  Raw entries scanned:       \(scannedSymbols.count)")
print("  With localizations:        \(symbolsWithLocalizations)")
print("  With restrictions:         \(symbolsWithRestrictions)")
print("  With categories:           \(withCategories)")
print("  In Draw category:          \(withDrawCategory)")
print("  With year:                 \(withYear)")
print("  With hierarchical:         \(withHierarchical)")
print("  With multicolor:           \(withMulticolor)")
print("  Missing year:              \(missingYear)")
print()
print("Output: \(outputURL.path)")
