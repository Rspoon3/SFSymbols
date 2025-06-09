#!/usr/bin/env swift

import Foundation

// MARK: - Entry Config

fileprivate let metadataSubpath = "Contents/Resources/Metadata"

fileprivate let inputURL: URL = {
    guard let appPath = CommandLine.arguments.dropFirst().first else {
        print("Usage: UpdateScript.swift \"/Applications/SF Symbols beta.app\"")
        exit(1)
    }

    let url = URL(fileURLWithPath: appPath)
        .appendingPathComponent(metadataSubpath, isDirectory: true)

    guard FileManager.default.fileExists(atPath: url.path) else {
        print("❌ Could not find Metadata folder at expected path: \(url.path)")
        exit(1)
    }

    return url
}()

fileprivate let outputURL: URL = {
    let path = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("results", isDirectory: true)
    try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
    return path
}()

// MARK: - Models

fileprivate struct SFCategory: Codable {
    let icon: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case icon
        case title = "label"
    }
}

fileprivate struct Plist: Codable {
    let key: String
    let label: String
}

fileprivate struct ReleaseInfo: Codable {
    let iOS: Double
    let macOS: Double
    let tvOS: Double
    let watchOS: Double
    let visionOS: Double
    
    enum CodingKeys: String, CodingKey {
        case iOS, macOS, tvOS, watchOS, visionOS
    }
    
    init(iOS: Double, macOS: Double, tvOS: Double, watchOS: Double, visionOS: Double) {
        self.iOS = iOS
        self.macOS = macOS
        self.tvOS = tvOS
        self.watchOS = watchOS
        self.visionOS = visionOS
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iOS = try Double(values.decode(String.self, forKey: .iOS))!
        macOS = try Double(values.decode(String.self, forKey: .macOS))!
        tvOS = try Double(values.decode(String.self, forKey: .tvOS))!
        watchOS = try Double(values.decode(String.self, forKey: .watchOS))!
        visionOS = try Double(values.decode(String.self, forKey: .visionOS))!
    }
}

fileprivate struct SFSymbol: Codable {
    let title: String
    var categories: [SFCategory]?
    var searchTerms: [String]?
    let releaseInfo: ReleaseInfo
    
    init(title: String, categories: [SFCategory]? = nil, searchTerms: [String]? = nil, releaseInfo: ReleaseInfo) {
        self.title = title
        self.categories = categories
        self.searchTerms = searchTerms
        self.releaseInfo = releaseInfo
    }
}

fileprivate struct NameAvailabilityResults: Codable {
    let symbols: [SFSymbol]
    let yearToRelease: [String: ReleaseInfo]
    
    enum CodingKeys: String, CodingKey {
        case symbols
        case yearToRelease = "year_to_release"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let symbolsDict = try values.decode([String: String].self, forKey: .symbols)
        let yearToRelease = try values.decode([String: ReleaseInfo].self, forKey: .yearToRelease)
        
        self.yearToRelease = yearToRelease
        symbols = symbolsDict.map {
            SFSymbol(title: $0.key, releaseInfo: yearToRelease[$0.value]!)
        }.sorted(by: {$0.title < $1.title})
    }
}

// MARK: - Helpers

fileprivate func camelCase(_ title: String, modifyKeywords: Bool = true) -> String {
    var name = title.split(separator: ".").enumerated().map {
        $0.offset == 0 ? $0.element.lowercased() : $0.element.capitalized
    }.joined()

    let keywords = ["return", "repeat", "case"]
    if name.first?.isNumber == true {
        name = "_\(name)"
    } else if modifyKeywords && keywords.contains(name) {
        name = "`\(name)`"
    }

    return name
}

fileprivate func exportStaticVars(for symbols: [SFSymbol], fileName: String, plistDict: [String: String]) throws {
    guard let newest = symbols.first else { return }

    let header = """
    import Foundation

    @available(iOS \(newest.releaseInfo.iOS), macOS \(newest.releaseInfo.macOS), tvOS \(newest.releaseInfo.tvOS), watchOS \(newest.releaseInfo.watchOS), visionOS \(newest.releaseInfo.visionOS), *)
    public extension SFSymbol {

    """

    let vars = symbols.map { symbol -> String in
        let name = camelCase(symbol.title)
        let categories = symbol.categories?.compactMap { plistDict[$0.title] }.map { ".\($0)" }.joined(separator: ", ")
        let terms = symbol.searchTerms?.map { "\"\($0)\"" }.joined(separator: ", ")
        let categoryLine = categories != nil ? "[\(categories!)]" : "nil"
        let termsLine = terms != nil ? "[\(terms!)]" : "nil"
        let releaseString = "iOS: \(symbol.releaseInfo.iOS), macOS: \(symbol.releaseInfo.macOS), tvOS: \(symbol.releaseInfo.tvOS), watchOS: \(symbol.releaseInfo.watchOS), visionOS: \(symbol.releaseInfo.visionOS)"

        return """
            /// \(symbol.title)
            /// - Since: \(releaseString)
            static let \(name) = SFSymbol(
                title: "\(symbol.title)",
                categories: \(categoryLine),
                searchTerms: \(termsLine),
                releaseInfo: ReleaseInfo(\(releaseString))
            )
        """
    }.joined(separator: "\n\n")

    let contents = header + vars + "\n}"
    let url = outputURL.appendingPathComponent("SFSymbol+StaticVariables\(fileName).swift")
    try contents.write(to: url, atomically: true, encoding: .utf8)
}

// MARK: - Processing

fileprivate func main() {
    let decoder = PropertyListDecoder()

    do {
        // Load categories
        let categoriesData = try Data(contentsOf: inputURL.appendingPathComponent("categories.plist"))
        let categories = try decoder.decode([SFCategory].self, from: categoriesData)
        let plistArray = try decoder.decode([Plist].self, from: categoriesData)
        let plistDict = Dictionary(uniqueKeysWithValues: plistArray.map { ($0.label, $0.key) })

        // Load symbols using the correct NameAvailabilityResults structure
        let symbolsData = try Data(contentsOf: inputURL.appendingPathComponent("name_availability.plist"))
        let availabilityResults = try decoder.decode(NameAvailabilityResults.self, from: symbolsData)
        var symbols = availabilityResults.symbols.filter { !$0.title.contains(".zh") }

        // Add categories
        let categoryMapData = try Data(contentsOf: inputURL.appendingPathComponent("symbol_categories.plist"))
        let categoryMap = try decoder.decode([String: [String]].self, from: categoryMapData)
        for (symbolName, categoryKeys) in categoryMap {
            if let index = symbols.firstIndex(where: { $0.title == symbolName }) {
                symbols[index].categories = categoryKeys.compactMap { key in
                    categories.first(where: { plistDict[$0.title] == key })
                }
            }
        }

        // Add search terms
        let searchTermsData = try Data(contentsOf: inputURL.appendingPathComponent("symbol_search.plist"))
        let searchMap = try decoder.decode([String: [String]].self, from: searchTermsData)
        for (symbolName, terms) in searchMap {
            if let index = symbols.firstIndex(where: { $0.title == symbolName }) {
                symbols[index].searchTerms = terms
            }
        }

        // Export by iOS version
        let versions = Set(symbols.map(\.releaseInfo.iOS)).sorted()
        for version in versions {
            let filtered = symbols.filter { $0.releaseInfo.iOS == version }
            var fileName = version.description.replacingOccurrences(of: ".0", with: "")
            fileName = fileName.replacingOccurrences(of: ".", with: "P")
            try exportStaticVars(for: filtered, fileName: fileName, plistDict: plistDict)
        }

        print("✅ Export complete. Check the `results/` folder.")
    } catch {
        print("❌ Error: \(error)")
    }
}

main()
