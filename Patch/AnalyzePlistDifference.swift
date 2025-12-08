#!/usr/bin/env swift

import Foundation

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

// MARK: - Analysis

let nameSet = Set(nameSymbols.keys)
let layersetSet = Set(layersetSymbols.keys)

let onlyInName = nameSet.subtracting(layersetSet)
let onlyInLayerset = layersetSet.subtracting(nameSet)
let inBoth = nameSet.intersection(layersetSet)

print("=" .repeated(60))
print("PLIST COMPARISON ANALYSIS")
print("=" .repeated(60))
print()
print("SUMMARY:")
print("-" .repeated(40))
print("Symbols in name_availability.plist:     \(nameSet.count)")
print("Symbols in layerset_availability.plist: \(layersetSet.count)")
print("Difference:                             \(nameSet.count - layersetSet.count)")
print()
print("BREAKDOWN:")
print("-" .repeated(40))
print("Symbols in BOTH files:                  \(inBoth.count)")
print("Symbols ONLY in name_availability:      \(onlyInName.count)")
print("Symbols ONLY in layerset_availability:  \(onlyInLayerset.count)")
print()

// MARK: - Analyze what's missing from layerset

print("=" .repeated(60))
print("ANALYSIS: Why are \(onlyInName.count) symbols only in name_availability?")
print("=" .repeated(60))
print()

// Group symbols only in name_availability by suffix pattern
var suffixGroups: [String: [String]] = [:]
let knownSuffixes = [".ar", ".hi", ".ja", ".ko", ".th", ".zh", ".rtl", ".fill"]

for symbol in onlyInName {
    var foundSuffix = "no_special_suffix"
    for suffix in knownSuffixes {
        if symbol.hasSuffix(suffix) {
            foundSuffix = suffix
            break
        }
    }
    suffixGroups[foundSuffix, default: []].append(symbol)
}

print("Symbols only in name_availability, grouped by suffix:")
print("-" .repeated(40))
for (suffix, symbols) in suffixGroups.sorted(by: { $0.value.count > $1.value.count }) {
    print("\(suffix.padding(toLength: 20, withPad: " ", startingAt: 0)): \(symbols.count) symbols")
}
print()

// MARK: - Analyze layer types in layerset_availability

print("=" .repeated(60))
print("LAYER TYPES IN layerset_availability.plist")
print("=" .repeated(60))
print()

var layerTypeCounts: [String: Int] = [:]
var symbolsWithLayerType: [String: Set<String>] = [:]

for (symbol, layers) in layersetSymbols {
    for layerType in layers.keys {
        layerTypeCounts[layerType, default: 0] += 1
        symbolsWithLayerType[layerType, default: []].insert(symbol)
    }
}

print("Layer types and their counts:")
print("-" .repeated(40))
for (layerType, count) in layerTypeCounts.sorted(by: { $0.value > $1.value }) {
    print("\(layerType.padding(toLength: 20, withPad: " ", startingAt: 0)): \(count) symbols")
}
print()

// MARK: - Sample of symbols only in name_availability

print("=" .repeated(60))
print("SAMPLE: First 20 symbols ONLY in name_availability")
print("=" .repeated(60))
print()
for symbol in onlyInName.sorted().prefix(20) {
    let year = nameSymbols[symbol] ?? "?"
    print("  \(symbol) (introduced: \(year))")
}
if onlyInName.count > 20 {
    print("  ... and \(onlyInName.count - 20) more")
}
print()

// MARK: - Check if symbols without layerset have a base version that does

print("=" .repeated(60))
print("HYPOTHESIS: Do missing symbols have localized variants?")
print("=" .repeated(60))
print()

let localeSuffixes = [".ar", ".hi", ".ja", ".ko", ".th", ".zh", ".rtl"]
var missingDueToNoLayerset = 0
var missingLocaleVariants = 0

for symbol in onlyInName {
    var isLocaleVariant = false
    var baseSymbol: String? = nil

    for suffix in localeSuffixes {
        if symbol.hasSuffix(suffix) {
            isLocaleVariant = true
            baseSymbol = String(symbol.dropLast(suffix.count))
            break
        }
    }

    if isLocaleVariant, let base = baseSymbol {
        if layersetSet.contains(base) {
            missingLocaleVariants += 1
        }
    } else {
        missingDueToNoLayerset += 1
    }
}

print("Locale variants (e.g., .ar, .hi) whose base IS in layerset: \(missingLocaleVariants)")
print("Base symbols with no layerset info at all:                  \(missingDueToNoLayerset)")
print()

// MARK: - Check which base symbols have no layerset

print("=" .repeated(60))
print("BASE SYMBOLS WITHOUT LAYERSET INFO")
print("=" .repeated(60))
print()

let baseSymbolsWithoutLayerset = onlyInName.filter { symbol in
    !localeSuffixes.contains(where: { symbol.hasSuffix($0) })
}

print("Count: \(baseSymbolsWithoutLayerset.count)")
print()
print("Sample (first 30):")
print("-" .repeated(40))
for symbol in baseSymbolsWithoutLayerset.sorted().prefix(30) {
    let year = nameSymbols[symbol] ?? "?"
    print("  \(symbol) (introduced: \(year))")
}
if baseSymbolsWithoutLayerset.count > 30 {
    print("  ... and \(baseSymbolsWithoutLayerset.count - 30) more")
}

// MARK: - Check symbols ONLY in layerset (potential issue)

print()
print("=" .repeated(60))
print("⚠️  SYMBOLS ONLY IN layerset_availability (not in name)")
print("=" .repeated(60))
print()
print("These \(onlyInLayerset.count) symbols have layerset info but no name_availability entry:")
print("-" .repeated(40))
for symbol in onlyInLayerset.sorted() {
    let layers = layersetSymbols[symbol]?.keys.sorted().joined(separator: ", ") ?? "?"
    print("  \(symbol) (layers: \(layers))")
}

// Helper extension
extension String {
    func repeated(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}
