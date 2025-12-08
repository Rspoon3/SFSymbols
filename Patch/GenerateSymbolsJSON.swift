#!/usr/bin/env swift

import Foundation

// MARK: - Models

struct PlatformAvailability: Codable {
    let iOS: String
    let macOS: String
    let tvOS: String
    let watchOS: String
    let visionOS: String
}

struct SFSymbol: Codable {
    let name: String
    let year: String?
    let availability: PlatformAvailability?
    let layersets: [String]
}

struct SymbolsOutput: Codable {
    let generatedAt: String
    let totalCount: Int
    let symbols: [SFSymbol]
}

// MARK: - Load PLists

let scriptDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let nameAvailabilityURL = scriptDir.appendingPathComponent("name_availability.plist")
let layersetAvailabilityURL = scriptDir.appendingPathComponent("layerset_availability.plist")

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

// Get year_to_release from both plists and use the most up-to-date one
let nameYearToRelease = namePlist["year_to_release"] as? [String: [String: String]] ?? [:]
let layersetYearToRelease = layersetPlist["year_to_release"] as? [String: [String: String]] ?? [:]

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

// MARK: - Merge Data

let allSymbolNames = Set(nameSymbols.keys).union(Set(layersetSymbols.keys))

var symbols: [SFSymbol] = []
var unmappedYears: Set<String> = []

for symbolName in allSymbolNames.sorted() {
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

    // Look up platform availability
    let availability: PlatformAvailability?
    if let year = year {
        if let mapped = versionMap[year] {
            availability = mapped
        } else {
            unmappedYears.insert(year)
            availability = nil
        }
    } else {
        availability = nil
    }

    let symbol = SFSymbol(
        name: symbolName,
        year: year,
        availability: availability,
        layersets: layersets
    )

    symbols.append(symbol)
}

if !unmappedYears.isEmpty {
    print("⚠️  Warning: Unmapped years found: \(unmappedYears.sorted())")
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

let outputURL = scriptDir.appendingPathComponent("symbols.json")
do {
    try jsonData.write(to: outputURL)
    print("✓ Generated symbols.json with \(symbols.count) symbols")
    print("  Location: \(outputURL.path)")
} catch {
    print("Error writing file: \(error)")
    exit(1)
}

// MARK: - Summary Statistics

let withYear = symbols.filter { $0.year != nil }.count
let withHierarchical = symbols.filter { $0.layersets.contains("hierarchical") }.count
let withMulticolor = symbols.filter { $0.layersets.contains("multicolor") }.count
let missingYear = symbols.filter { $0.year == nil }.count

print()
print("Summary:")
print("  Total symbols:      \(symbols.count)")
print("  With year:          \(withYear)")
print("  With hierarchical:  \(withHierarchical)")
print("  With multicolor:    \(withMulticolor)")
print("  Missing year:       \(missingYear)")
