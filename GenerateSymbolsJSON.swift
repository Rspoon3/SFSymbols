#!/usr/bin/env swift

import Foundation

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

struct SFSymbol: Codable {
    let name: String
    let year: String?
    let availability: PlatformAvailability?
    let layersets: [String]
    let localizations: [LocalizationInfo]
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

let nameAvailabilityURL = inputURL.appendingPathComponent("name_availability.plist")
let layersetAvailabilityURL = inputURL.appendingPathComponent("layerset_availability.plist")

guard let nameData = try? Data(contentsOf: nameAvailabilityURL),
      let layersetData = try? Data(contentsOf: layersetAvailabilityURL) else {
    print("Error: Could not read plist files")
    exit(1)
}

guard let namePlist = try? PropertyListSerialization.propertyList(from: nameData, format: nil) as? [String: Any],
      let layersetPlist = try? PropertyListSerialization.propertyList(from: layersetData, format: nil) as? [String: Any] else {
    print("Error: Could not parse plist files")
    exit(1)
}

guard let nameSymbols = namePlist["symbols"] as? [String: String],
      let layersetSymbols = layersetPlist["symbols"] as? [String: [String: String]] else {
    print("Error: Could not extract symbols from plist files")
    exit(1)
}

print("Loaded plist files successfully.")

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

let nameAliasesURL = inputURL.appendingPathComponent("name_aliases.strings")
let legacyAliasesURL = inputURL.appendingPathComponent("legacy_aliases.strings")
var symbolAliases: [String: String] = [:] // old name -> new name

if let nameAliasesData = try? Data(contentsOf: nameAliasesURL),
   let nameAliases = try? PropertyListDecoder().decode([String: String].self, from: nameAliasesData) {
    symbolAliases.merge(nameAliases) { _, new in new }
    print("Loaded \(nameAliases.count) name aliases")
} else {
    print("Warning: Could not load name_aliases.strings")
}

if let legacyAliasesData = try? Data(contentsOf: legacyAliasesURL),
   let legacyAliases = try? PropertyListDecoder().decode([String: String].self, from: legacyAliasesData) {
    symbolAliases.merge(legacyAliases) { _, new in new }
    print("Loaded \(legacyAliases.count) legacy aliases")
} else {
    print("Warning: Could not load legacy_aliases.strings")
}

print("Total deprecated symbol aliases: \(symbolAliases.count)")

// MARK: - Determine Best year_to_release

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
    print("Injected missing 2025 release year into name_availability (Apple bug workaround)")
}

if layersetYearToRelease["2025"] == nil {
    layersetYearToRelease["2025"] = missing2025Entry
    print("Injected missing 2025 release year into layerset_availability (Apple bug workaround)")
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
    print("Using year_to_release from name_availability.plist (max: \(nameMaxYear))")
} else {
    yearToRelease = layersetYearToRelease
    print("Using year_to_release from layerset_availability.plist (max: \(layersetMaxYear))")
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

let allSymbolNames = Set(nameSymbols.keys).union(Set(layersetSymbols.keys))
var scannedSymbols: [String: ScannedSymbol] = [:]

for symbolName in allSymbolNames {
    var year = nameSymbols[symbolName]
    let layersetInfo = layersetSymbols[symbolName]

    // Build layersets array (all symbols support monochrome)
    var layersets: [String] = ["monochrome"]
    if layersetInfo?["hierarchical"] != nil {
        layersets.append("hierarchical")
    }
    if layersetInfo?["multicolor"] != nil {
        layersets.append("multicolor")
    }

    // If year is missing from name_availability, infer from layerset_availability
    if year == nil, let info = layersetInfo {
        year = info.values.min { a, b in
            let aParts = a.split(separator: ".").compactMap { Double($0) }
            let bParts = b.split(separator: ".").compactMap { Double($0) }
            let aValue = (aParts.first ?? 0) * 100 + (aParts.count > 1 ? aParts[1] : 0)
            let bValue = (bParts.first ?? 0) * 100 + (bParts.count > 1 ? bParts[1] : 0)
            return aValue < bValue
        }
    }

    scannedSymbols[symbolName] = ScannedSymbol(name: symbolName, year: year, layersets: layersets)
}

print("Scanned \(scannedSymbols.count) total symbol entries (including localized variants)")

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

    let symbol = SFSymbol(
        name: baseName,
        year: primarySymbol.year,
        availability: availability,
        layersets: primarySymbol.layersets,
        localizations: localizations,
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
print("  With year:                 \(withYear)")
print("  With hierarchical:         \(withHierarchical)")
print("  With multicolor:           \(withMulticolor)")
print("  Missing year:              \(missingYear)")
print()
print("Output: \(outputURL.path)")
