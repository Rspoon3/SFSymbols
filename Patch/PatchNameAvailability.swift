#!/usr/bin/env swift

import Foundation

// MARK: - Configuration

let currentDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let layersetURL = currentDir.appendingPathComponent("layerset_availability.plist")
let nameAvailabilityURL = currentDir.appendingPathComponent("name_availability.plist")

let year2025Release: [String: String] = [
    "iOS": "26.0",
    "macOS": "26.0",
    "tvOS": "26.0",
    "watchOS": "26.0",
    "visionOS": "26.0"
]

// MARK: - Main

func main() {
    do {
        // 1. Load layerset_availability.plist
        guard FileManager.default.fileExists(atPath: layersetURL.path) else {
            print("Error: layerset_availability.plist not found at \(layersetURL.path)")
            exit(1)
        }

        let layersetData = try Data(contentsOf: layersetURL)
        guard let layersetPlist = try PropertyListSerialization.propertyList(from: layersetData, format: nil) as? [String: Any],
              let layersetSymbols = layersetPlist["symbols"] as? [String: [String: String]] else {
            print("Error: Could not parse layerset_availability.plist")
            exit(1)
        }

        // 2. Find all symbols with "2025" in any layer set value
        var symbols2025 = Set<String>()
        for (symbolName, layerSets) in layersetSymbols {
            for (_, year) in layerSets {
                if year == "2025" {
                    symbols2025.insert(symbolName)
                    break
                }
            }
        }

        print("Found \(symbols2025.count) symbols with year 2025 in layerset_availability.plist")

        // 3. Load name_availability.plist
        guard FileManager.default.fileExists(atPath: nameAvailabilityURL.path) else {
            print("Error: name_availability.plist not found at \(nameAvailabilityURL.path)")
            exit(1)
        }

        let nameData = try Data(contentsOf: nameAvailabilityURL)
        guard var namePlist = try PropertyListSerialization.propertyList(from: nameData, format: nil) as? [String: Any],
              var existingSymbols = namePlist["symbols"] as? [String: String],
              var yearToRelease = namePlist["year_to_release"] as? [String: [String: String]] else {
            print("Error: Could not parse name_availability.plist")
            exit(1)
        }

        // 4. Add 2025 symbols to "symbols" dict (only if not already present)
        var addedCount = 0
        for symbolName in symbols2025 {
            if existingSymbols[symbolName] == nil {
                existingSymbols[symbolName] = "2025"
                addedCount += 1
            }
        }

        print("Added \(addedCount) new symbols to name_availability.plist")

        // 5. Add "2025" entry to "year_to_release" dict
        if yearToRelease["2025"] == nil {
            yearToRelease["2025"] = year2025Release
            print("Added 2025 to year_to_release mapping")
        } else {
            print("2025 already exists in year_to_release")
        }

        // 6. Update the plist dictionary
        namePlist["symbols"] = existingSymbols
        namePlist["year_to_release"] = yearToRelease

        // 7. Write back to name_availability.plist
        let outputData = try PropertyListSerialization.data(fromPropertyList: namePlist, format: .xml, options: 0)
        try outputData.write(to: nameAvailabilityURL)

        print("Successfully updated name_availability.plist")
        print("Total symbols now: \(existingSymbols.count)")

    } catch {
        print("Error: \(error)")
        exit(1)
    }
}

main()
