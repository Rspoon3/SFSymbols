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
    
    init(
        title: String,
        categories: [SFCategory]? = nil,
        searchTerms: [String]? = nil,
        releaseInfo: ReleaseInfo
    ) {
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

// MARK: - Outputs

private func createSFCategoryFile(for categories: [SFCategory], plistDict: [String: String]) throws {
    let staticVars = categories.map { category in
        let camelCased = convertTitleToCamelCased(string: category.title, modifyKeywords: false)
        return "    public static let \(camelCased) = SFCategory(icon: \"\(category.icon)\", title: \"\(category.title)\")"
    }.joined(separator: "\n")

    let allCases = categories.map {
        let camelCased = convertTitleToCamelCased(string: $0.title, modifyKeywords: false)
        return "            .\(camelCased)"
    }.joined(separator: ",\n")

    let fileContent = """
    \(createHeader(title: "SFCategory"))

    public struct SFCategory: Identifiable, Codable, Equatable, Hashable, Sendable {
        public let icon: String
        public let title: String
        public var id: String { title }

        public var symbols: [SFSymbol] {
            if self == .all {
                return SFSymbol.allSymbols
            } else {
                return SFSymbol.allSymbols.filter { $0.categories?.contains(self) ?? false }
            }
        }

        enum CodingKeys: String, CodingKey {
            case icon
            case title = "label"
        }

        // MARK: - Static Data
    
    \(staticVars)

        public static var allCategories: [SFCategory] {
            return [
    \(allCases)
            ]
        }
    }
    """

    let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("Sources", isDirectory: true)
        .appendingPathComponent("SFSymbols", isDirectory: true)
        .appendingPathComponent("Models", isDirectory: true)
        .appendingPathComponent("SFCategory.swift")
    
    try fileContent.write(to: url, atomically: true, encoding: .utf8)
}

private func createStaticVarFile(for symbols: [SFSymbol], fileName: String, plistDict: [String: String]) throws {
    let newestSymbol = symbols.first!
    let header = """
    \(createHeader(title: "SFSymbol+StaticVariables\(fileName)"))
    import Foundation

    @available(iOS \(newestSymbol.releaseInfo.iOS), macOS \(newestSymbol.releaseInfo.macOS), tvOS \(newestSymbol.releaseInfo.tvOS), watchOS \(newestSymbol.releaseInfo.watchOS), visionOS \(newestSymbol.releaseInfo.visionOS), *)
    public extension SFSymbol {

    """

    var staticVars = symbols.map { convertSymbolToStaticVar($0, plistDict: plistDict) }.joined(separator: "\n\n")
    let i = staticVars.index(staticVars.startIndex, offsetBy: 0)
    staticVars.insert(contentsOf: header, at: i)
    staticVars.append("\n}")

    let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("Sources", isDirectory: true)
        .appendingPathComponent("SFSymbols", isDirectory: true)
        .appendingPathComponent("SFSymbol+StaticVariables", isDirectory: true)
        .appendingPathComponent("SFSymbol+StaticVariables\(fileName).swift")
    
    try staticVars.write(to: url, atomically: true, encoding: .utf8)
}

private func createAllSymbolsFile(for symbols: [SFSymbol], fileName: String, plistDict: [String: String]) throws {
    let titles = symbols.map {
        convertTitleToCamelCased(
            string: $0.title,
            modifyKeywords: false
        )
    }
        .map { "         .\($0)" }
        .joined(separator: ",\n")

    var array = """
    \n
        static var allSymbols\(fileName): [SFSymbol] {
            return [\n
    """

    array.append(contentsOf: titles)
    array.append(contentsOf: "\n      ]")

    let newestSymbol = symbols.first!
    let header = """
    \(createHeader(title: "SFSymbol+All\(fileName).swift"))
    import Foundation

    @available(iOS \(newestSymbol.releaseInfo.iOS), macOS \(newestSymbol.releaseInfo.macOS), tvOS \(newestSymbol.releaseInfo.tvOS), watchOS \(newestSymbol.releaseInfo.watchOS), visionOS \(newestSymbol.releaseInfo.visionOS), *)
    public extension SFSymbol {
    """

    let i = titles.index(titles.startIndex, offsetBy: 0)
    array.insert(contentsOf: header, at: i)
    array.append("\n   }\n}")
    
    let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("Sources", isDirectory: true)
        .appendingPathComponent("SFSymbols", isDirectory: true)
        .appendingPathComponent("SFSymbol+All", isDirectory: true)
        .appendingPathComponent("SFSymbol+All\(fileName).swift")

    try array.write(to: url, atomically: true, encoding: .utf8)
}

private func createUnifiedAllSymbolsFile(from symbols: [SFSymbol]) throws {
    let versions = Set(symbols.map(\.releaseInfo.iOS)).sorted()
    
    var file = """
    \(createHeader(title: "SFSymbol+All"))

    public extension SFSymbol {
        static var allSymbols: [SFSymbol] {
            var symbols = SFSymbol.allSymbols\(versionCode(versions[0]))

    """

    for version in versions.dropFirst() {
        let matchingSymbol = symbols.first { $0.releaseInfo.iOS == version }!
        let iOS = versionString(version)
        let mac = matchingSymbol.releaseInfo.macOS
        let tv = matchingSymbol.releaseInfo.tvOS
        let watch = matchingSymbol.releaseInfo.watchOS
        let vision = matchingSymbol.releaseInfo.visionOS

        file += """

                if #available(iOS \(iOS), macOS \(mac), tvOS \(tv), watchOS \(watch), visionOS \(vision), *) {
                    symbols.append(contentsOf: SFSymbol.allSymbols\(versionCode(version)))
                }\n
        """
    }

    file += """

            return symbols
        }
    }
    """

    let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("Sources", isDirectory: true)
        .appendingPathComponent("SFSymbols", isDirectory: true)
        .appendingPathComponent("SFSymbol+All", isDirectory: true)
        .appendingPathComponent("SFSymbol+All.swift")
    
    try file.write(to: url, atomically: true, encoding: .utf8)
}

// MARK: - Private Helpers

private func createHeader(title: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M/d/yy"
    let dateString = dateFormatter.string(from: .now)
    
    return """
    //
    //  \(title).swift
    //
    //  Generated Automatically on \(dateString)
    //

    import Foundation
    """
}

private func convertTitleToCamelCased(string: String, modifyKeywords: Bool) -> String {
    // Normalize special characters and separators
    let cleaned = string
        .replacingOccurrences(of: "&", with: "and")
        .replacingOccurrences(of: "’", with: "")
        .replacingOccurrences(of: "'", with: "")
        .replacingOccurrences(of: ".", with: " ")
        .replacingOccurrences(of: "-", with: " ")
        .replacingOccurrences(of: "_", with: " ")

    let words = cleaned
        .components(separatedBy: .whitespacesAndNewlines)
        .filter { !$0.isEmpty }

    guard !words.isEmpty else { return "" }

    // Always lowercase the first word
    var result = words[0].lowercased()

    for word in words.dropFirst() {
        if word.count == 2, word.last!.isLetter, word.dropLast().allSatisfy(\.isNumber) {
            // e.g. "2d" → "2D"
            let numberPart = word.dropLast()
            let letter = word.last!.uppercased()
            result += numberPart + letter
        } else if let firstLetterIndex = word.firstIndex(where: \.isLetter), firstLetterIndex != word.startIndex {
            // e.g. "100percent" → "100Percent"
            let numberPart = word[..<firstLetterIndex]
            let letterPart = word[firstLetterIndex...]
            result += numberPart + letterPart.prefix(1).uppercased() + letterPart.dropFirst()
        } else {
            // Normal word: capitalize first letter
            result += word.prefix(1).uppercased() + word.dropFirst()
        }
    }

    // Prefix underscore if result starts with a number
    let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    if let first = result.first, numbers.contains(String(first)) {
        result = "_\(result)"
    }

    // Escape Swift keywords
    let keywords = ["return", "repeat", "case"]
    if modifyKeywords && keywords.contains(result) {
        result = "`\(result)`"
    }

    return result
}

private func convertSymbolToStaticVar(_ symbol: SFSymbol, plistDict: [String: String]) -> String {
    let camelCased = convertTitleToCamelCased(
        string: symbol.title,
        modifyKeywords: true
    )

    var categoriesOptionalString = "nil"
    var searchTermsOptionalString = "nil"

    if var categoriesString = symbol.categories?
        .compactMap({ plistDict[$0.title] })
        .map({ ".\($0)" })
        .joined(separator: ", ") {
        categoriesString.insert("[", at: categoriesString.startIndex)
        categoriesString.append("]")
        categoriesOptionalString = categoriesString
    }

    if var searchTermsString = symbol.searchTerms?.map({ "\"\($0)\"" }).joined(separator: ", ") {
        searchTermsString.insert("[", at: searchTermsString.startIndex)
        searchTermsString.append("]")
        searchTermsOptionalString = searchTermsString
    }

    let releaseString = "iOS: \(symbol.releaseInfo.iOS), macOS: \(symbol.releaseInfo.macOS), tvOS: \(symbol.releaseInfo.tvOS), watchOS: \(symbol.releaseInfo.watchOS), visionOS: \(symbol.releaseInfo.visionOS)"

    let staticVar = """
            /// \(symbol.title)
            /// - Since: \(releaseString)
            static let \(camelCased) = SFSymbol(
                title: "\(symbol.title)",
                categories: \(categoriesOptionalString),
                searchTerms: \(searchTermsOptionalString),
                releaseInfo: ReleaseInfo(\(releaseString))
            )
        """

    return staticVar
}

private func versionCode(_ version: Double) -> String {
    let str = String(version).replacingOccurrences(of: ".0", with: "").replacingOccurrences(of: ".", with: "P")
    return str
}

private func versionString(_ version: Double) -> String {
    // Ensures at least one decimal (e.g., "13.0" instead of "13")
    return version == floor(version) ? "\(Int(version)).0" : "\(version)"
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
        print("☑️  Loaded categories successfully.")

        // Load symbols
        let symbolsData = try Data(contentsOf: inputURL.appendingPathComponent("name_availability.plist"))
        let availabilityResults = try decoder.decode(NameAvailabilityResults.self, from: symbolsData)
        var symbols = availabilityResults.symbols.filter { !$0.title.contains(".zh") }
        print("☑️  Loaded symbols successfully.")

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
        print("☑️  Added categories successfully.")

        // Add search terms
        let searchTermsData = try Data(contentsOf: inputURL.appendingPathComponent("symbol_search.plist"))
        let searchMap = try decoder.decode([String: [String]].self, from: searchTermsData)
        for (symbolName, terms) in searchMap {
            if let index = symbols.firstIndex(where: { $0.title == symbolName }) {
                symbols[index].searchTerms = terms
            }
        }
        print("☑️  Added search terms successfully.")

        try createSFCategoryFile(for: categories, plistDict: plistDict)
        print("☑️  Created SFCategory file successfully.")

        // Export by iOS version
        let versions = Set(symbols.map(\.releaseInfo.iOS)).sorted()
        
        for version in versions {
            let filtered = symbols.filter { $0.releaseInfo.iOS == version }
            var fileName = version.description.replacingOccurrences(of: ".0", with: "")
            fileName = fileName.replacingOccurrences(of: ".", with: "P")

            try createStaticVarFile(for: filtered, fileName: fileName, plistDict: plistDict)
            try createAllSymbolsFile(for: filtered, fileName: fileName, plistDict: plistDict)
        }
        
        try createUnifiedAllSymbolsFile(from: symbols)
        print("☑️  Created AllSFSymbols file successfully.")

        print("✅ Export complete. Please check the Results folder.")
    } catch {
        print("❌ Error: \(error)")
    }
}

main()
