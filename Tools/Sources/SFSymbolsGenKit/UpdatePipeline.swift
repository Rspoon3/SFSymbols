import Foundation
import AppKit

// MARK: - Draw Category Input

/// Ensures `<repoRoot>/draw.txt` exists, prompting the user to paste the Draw
/// category from the clipboard when it is absent.
fileprivate func ensureDrawCategoryExists(drawFilePath: URL) {
    if FileManager.default.fileExists(atPath: drawFilePath.path) {
        print("📋 Found existing draw.txt")
        return
    }

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
        print("⏭️  Skipping draw category input.")
        return
    }

    // Read from clipboard
    print("Reading from clipboard...")
    guard let clipboardContents = NSPasteboard.general.string(forType: .string),
          !clipboardContents.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        print("⚠️  Clipboard is empty.")
        return
    }

    let lines = clipboardContents
        .components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { !$0.isEmpty }

    if lines.isEmpty {
        print("⚠️  No symbol names found in clipboard.")
        return
    }

    print("Found \(lines.count) symbols in clipboard.")

    let content = lines.joined(separator: "\n")
    do {
        try content.write(to: drawFilePath, atomically: true, encoding: .utf8)
        print("☑️  Saved \(lines.count) draw category symbols to draw.txt")
    } catch {
        print("⚠️  Could not save draw.txt: \(error)")
    }
}

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

// MARK: - Models from symbols.json

fileprivate struct PlatformAvailability: Codable {
    let iOS: String
    let macOS: String
    let tvOS: String
    let watchOS: String
    let visionOS: String

    var asReleaseInfo: ReleaseInfo {
        ReleaseInfo(
            iOS: Double(iOS) ?? 13.0,
            macOS: Double(macOS) ?? 10.15,
            tvOS: Double(tvOS) ?? 13.0,
            watchOS: Double(watchOS) ?? 6.0,
            visionOS: Double(visionOS) ?? 1.0
        )
    }
}

fileprivate struct LocalizationInfo: Codable {
    let code: String
    let name: String
    let availability: PlatformAvailability?
}

fileprivate struct JSONCategoryInfo: Codable {
    let icon: String
    let title: String
}

fileprivate struct JSONSymbol: Codable {
    let name: String
    let year: String?
    let availability: PlatformAvailability?
    let layersets: [String]
    let localizations: [LocalizationInfo]
    let categories: [JSONCategoryInfo]
    let restriction: String?
    let deprecatedNewName: String?
}

fileprivate struct SymbolsJSON: Codable {
    let generatedAt: String
    let totalCount: Int
    let symbols: [JSONSymbol]
}

fileprivate struct SFSymbol: Codable {
    let title: String
    var categories: [SFCategory]?
    var searchTerms: [String]?
    let releaseInfo: ReleaseInfo
    // New fields from symbols.json
    var layersets: [String]?
    var localizations: [LocalizationInfo]?
    var restriction: String?
    var deprecatedNewName: String?

    init(
        title: String,
        categories: [SFCategory]? = nil,
        searchTerms: [String]? = nil,
        releaseInfo: ReleaseInfo,
        layersets: [String]? = nil,
        localizations: [LocalizationInfo]? = nil,
        restriction: String? = nil,
        deprecatedNewName: String? = nil
    ) {
        self.title = title
        self.categories = categories
        self.searchTerms = searchTerms
        self.releaseInfo = releaseInfo
        self.layersets = layersets
        self.localizations = localizations
        self.restriction = restriction
        self.deprecatedNewName = deprecatedNewName
    }

    /// Creates an SFSymbol from a JSONSymbol
    init(from jsonSymbol: JSONSymbol) {
        self.title = jsonSymbol.name
        self.releaseInfo = jsonSymbol.availability?.asReleaseInfo ?? ReleaseInfo(
            iOS: 13.0, macOS: 10.15, tvOS: 13.0, watchOS: 6.0, visionOS: 1.0
        )
        self.layersets = jsonSymbol.layersets
        self.localizations = jsonSymbol.localizations.isEmpty ? nil : jsonSymbol.localizations
        self.restriction = jsonSymbol.restriction
        self.deprecatedNewName = jsonSymbol.deprecatedNewName
        // Convert JSONCategoryInfo to SFCategory
        self.categories = jsonSymbol.categories.isEmpty ? nil : jsonSymbol.categories.map {
            SFCategory(icon: $0.icon, title: $0.title)
        }
        self.searchTerms = nil
    }
}

// MARK: - Outputs

private func createSFCategoryFile(for categories: [SFCategory], plistDict: [String: String], repoRoot: URL) throws {
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

    let url = repoRoot
        .appendingPathComponent("Sources", isDirectory: true)
        .appendingPathComponent("SFSymbols", isDirectory: true)
        .appendingPathComponent("Models", isDirectory: true)
        .appendingPathComponent("SFCategory.swift")

    try fileContent.write(to: url, atomically: true, encoding: .utf8)
}

private func createStaticVarFile(for symbols: [SFSymbol], fileName: String, plistDict: [String: String], repoRoot: URL) throws {
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

    let url = repoRoot
        .appendingPathComponent("Sources", isDirectory: true)
        .appendingPathComponent("SFSymbols", isDirectory: true)
        .appendingPathComponent("SFSymbol+StaticVariables", isDirectory: true)
        .appendingPathComponent("SFSymbol+StaticVariables\(fileName).swift")

    try staticVars.write(to: url, atomically: true, encoding: .utf8)
}

private func createAllSymbolsFile(for symbols: [SFSymbol], fileName: String, plistDict: [String: String], repoRoot: URL) throws {
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

    let url = repoRoot
        .appendingPathComponent("Sources", isDirectory: true)
        .appendingPathComponent("SFSymbols", isDirectory: true)
        .appendingPathComponent("SFSymbol+All", isDirectory: true)
        .appendingPathComponent("SFSymbol+All\(fileName).swift")

    try array.write(to: url, atomically: true, encoding: .utf8)
}

private func createUnifiedAllSymbolsFile(from symbols: [SFSymbol], repoRoot: URL) throws {
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

    let url = repoRoot
        .appendingPathComponent("Sources", isDirectory: true)
        .appendingPathComponent("SFSymbols", isDirectory: true)
        .appendingPathComponent("SFSymbol+All", isDirectory: true)
        .appendingPathComponent("SFSymbol+All.swift")

    try file.write(to: url, atomically: true, encoding: .utf8)
}

// MARK: - Private Helpers

private func createHeader(title: String) -> String {
    """
    //
    //  \(title).swift
    //
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
            // 2d → 2D
            let numberPart = word.dropLast()
            let letter = word.last!.uppercased()
            result += numberPart + letter
        } else if let firstLetterIndex = word.firstIndex(where: \.isLetter), firstLetterIndex != word.startIndex {
            // 100percent → 100Percent
            let numberPart = word[..<firstLetterIndex]
            let letterPart = word[firstLetterIndex...]
            result += numberPart + letterPart.prefix(1).uppercased() + letterPart.dropFirst()
        } else {
            result += word.prefix(1).uppercased() + word.dropFirst()
        }
    }

    // Prefix with _ if starts with number
    let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    if let first = result.first, numbers.contains(String(first)) {
        result = "_\(result)"
    }

    // Lowercase 'X' if it appears between two numbers (e.g., 3X1 → 3x1)
    result = result.replacingOccurrences(of: #"(?<=\d)X(?=\d)"#, with: "x", options: .regularExpression)

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
    var layersetsArrayString = "[.monochrome]"
    var localizationsOptionalString = "nil"
    var restrictionOptionalString = "nil"
    var deprecatedNewNameOptionalString = "nil"

    if var categoriesString = symbol.categories?
        .map({ ".\(convertTitleToCamelCased(string: $0.title, modifyKeywords: false))" })
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

    // Layersets are always present (at minimum monochrome)
    let layersets = symbol.layersets ?? ["monochrome"]
    layersetsArrayString = "[" + layersets.map { ".\($0)" }.joined(separator: ", ") + "]"

    if let localizations = symbol.localizations, !localizations.isEmpty {
        let locStrings = localizations.map { loc -> String in
            if let avail = loc.availability {
                let releaseInfo = "ReleaseInfo(iOS: \(avail.asReleaseInfo.iOS), macOS: \(avail.asReleaseInfo.macOS), tvOS: \(avail.asReleaseInfo.tvOS), watchOS: \(avail.asReleaseInfo.watchOS), visionOS: \(avail.asReleaseInfo.visionOS))"
                return "LocalizationInfo(code: .\(loc.code), availability: \(releaseInfo))"
            } else {
                return "LocalizationInfo(code: .\(loc.code))"
            }
        }
        localizationsOptionalString = "[\(locStrings.joined(separator: ", "))]"
    }

    if let restriction = symbol.restriction {
        let escaped = restriction.replacingOccurrences(of: "\"", with: "\\\"")
        restrictionOptionalString = "\"\(escaped)\""
    }

    if let deprecatedNewName = symbol.deprecatedNewName {
        deprecatedNewNameOptionalString = "\"\(deprecatedNewName)\""
    }

    let releaseString = "iOS: \(symbol.releaseInfo.iOS), macOS: \(symbol.releaseInfo.macOS), tvOS: \(symbol.releaseInfo.tvOS), watchOS: \(symbol.releaseInfo.watchOS), visionOS: \(symbol.releaseInfo.visionOS)"

    // Build documentation comments
    var docComments = "/// \(symbol.title)\n"
    docComments += "    /// - Since: \(releaseString)"

    // Add layersets comment
    if let layersets = symbol.layersets, !layersets.isEmpty {
        docComments += "\n    /// - Layersets: \(layersets.joined(separator: ", "))"
    }

    // Add localizations comment
    if let localizations = symbol.localizations, !localizations.isEmpty {
        let locNames = localizations.map { $0.name }.joined(separator: ", ")
        docComments += "\n    /// - Localizations: \(locNames)"
    }

    // Add restriction warning
    if let restriction = symbol.restriction {
        docComments += "\n    /// - Warning: \(restriction)"
    }

    // Add deprecation attribute if deprecated
    var deprecationAttribute = ""
    if let newName = symbol.deprecatedNewName {
        let newNameCamelCased = convertTitleToCamelCased(string: newName, modifyKeywords: false)
        deprecationAttribute = "\n    @available(*, deprecated, renamed: \"\(newNameCamelCased)\", message: \"Use '\(newNameCamelCased)' instead. This symbol has been renamed.\")"
    }

    // Build optional parameters only when non-nil
    var optionalParams = ""
    if localizationsOptionalString != "nil" {
        optionalParams += ",\n        localizations: \(localizationsOptionalString)"
    }
    if restrictionOptionalString != "nil" {
        optionalParams += ",\n        restriction: \(restrictionOptionalString)"
    }
    if deprecatedNewNameOptionalString != "nil" {
        optionalParams += ",\n        deprecatedNewName: \(deprecatedNewNameOptionalString)"
    }

    let staticVar = """
        \(docComments)\(deprecationAttribute)
        static let \(camelCased) = SFSymbol(
            title: "\(symbol.title)",
            categories: \(categoriesOptionalString),
            searchTerms: \(searchTermsOptionalString),
            releaseInfo: ReleaseInfo(\(releaseString)),
            layersets: \(layersetsArrayString)\(optionalParams)
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

// MARK: - Pipeline

/// Runs the full in-process symbol update pipeline:
///   1. Ensure `<repoRoot>/draw.txt` exists (prompt user if needed).
///   2. Decrypt authoritative use-restrictions from the app's font.
///   3. Generate `symbols.json` with enriched data.
///   4. Read `symbols.json` + plists and write generated Swift sources into
///      `<repoRoot>/Sources/SFSymbols/...`.
///
/// File-based intermediate boundaries are preserved via a temp working directory:
/// the decrypt step writes `font_restrictions.tsv` there, the generate step writes
/// `symbols.json` there and reads `draw.txt` + `font_restrictions.tsv` from there.
public func runUpdate(appPath: String, repoRoot: URL) throws {
    let metadataSubpath = "Contents/Resources/Metadata"
    let inputURL = URL(fileURLWithPath: appPath)
        .appendingPathComponent(metadataSubpath, isDirectory: true)

    guard FileManager.default.fileExists(atPath: inputURL.path) else {
        throw GenError.missing("❌ Could not find Metadata folder at expected path: \(inputURL.path)")
    }

    // Temp working directory holds the file-based intermediates (symbols.json,
    // font_restrictions.tsv, and a copy of draw.txt) so the data flow matches the
    // original multi-process scripts.
    let workingDir = FileManager.default.temporaryDirectory
        .appendingPathComponent("sfsym-gen-\(ProcessInfo.processInfo.processIdentifier)", isDirectory: true)
    try? FileManager.default.removeItem(at: workingDir)
    try FileManager.default.createDirectory(at: workingDir, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: workingDir) }

    let repoDrawFilePath = repoRoot.appendingPathComponent("draw.txt")
    let symbolsJSONPath = workingDir.appendingPathComponent("symbols.json")

    // Step 1: Ensure draw.txt exists (prompt user if needed)
    ensureDrawCategoryExists(drawFilePath: repoDrawFilePath)

    // Make the repo-root draw.txt available to the generate step in the working dir.
    if FileManager.default.fileExists(atPath: repoDrawFilePath.path) {
        let workingDrawPath = workingDir.appendingPathComponent("draw.txt")
        try? FileManager.default.copyItem(at: repoDrawFilePath, to: workingDrawPath)
    }

    // Step 2: Decrypt authoritative use-restrictions from the app's font
    generateFontRestrictions(appPath: appPath, workingDir: workingDir)

    // Step 3: Generate symbols.json with enriched data
    print("📦 Generating symbols.json...")
    try generateSymbolsJSON(appPath: appPath, workingDir: workingDir)
    print("☑️  symbols.json generated successfully.")

    let plistDecoder = PropertyListDecoder()
    let jsonDecoder = JSONDecoder()

    do {
        // Load categories from plist (still needed for category metadata)
        let categoriesData = try Data(contentsOf: inputURL.appendingPathComponent("categories.plist"))
        let categories = try plistDecoder.decode([SFCategory].self, from: categoriesData)
        let plistArray = try plistDecoder.decode([Plist].self, from: categoriesData)
        let plistDict = Dictionary(uniqueKeysWithValues: plistArray.map { ($0.label, $0.key) })
        print("☑️  Loaded categories successfully.")

        // Load symbols from generated symbols.json (includes categories)
        let symbolsJSONData = try Data(contentsOf: symbolsJSONPath)
        let symbolsJSON = try jsonDecoder.decode(SymbolsJSON.self, from: symbolsJSONData)
        var symbols = symbolsJSON.symbols.map { SFSymbol(from: $0) }
        print("☑️  Loaded \(symbols.count) symbols from symbols.json (with categories)")

        // Add search terms from symbol_search.plist
        let searchTermsData = try Data(contentsOf: inputURL.appendingPathComponent("symbol_search.plist"))
        let searchMap = try plistDecoder.decode([String: [String]].self, from: searchTermsData)
        for (symbolName, terms) in searchMap {
            if let index = symbols.firstIndex(where: { $0.title == symbolName }) {
                symbols[index].searchTerms = terms
            }
        }
        print("☑️  Added search terms successfully.")

        try createSFCategoryFile(for: categories, plistDict: plistDict, repoRoot: repoRoot)
        print("☑️  Created SFCategory file successfully.")

        // Export by iOS version
        let versions = Set(symbols.map(\.releaseInfo.iOS)).sorted()

        for version in versions {
            let filtered = symbols.filter { $0.releaseInfo.iOS == version }
            var fileName = version.description.replacingOccurrences(of: ".0", with: "")
            fileName = fileName.replacingOccurrences(of: ".", with: "P")

            try createStaticVarFile(for: filtered, fileName: fileName, plistDict: plistDict, repoRoot: repoRoot)
            try createAllSymbolsFile(for: filtered, fileName: fileName, plistDict: plistDict, repoRoot: repoRoot)
        }

        try createUnifiedAllSymbolsFile(from: symbols, repoRoot: repoRoot)
        print("☑️  Created AllSFSymbols file successfully.")

        // Count statistics
        let deprecatedCount = symbols.filter { $0.deprecatedNewName != nil }.count
        let restrictedCount = symbols.filter { $0.restriction != nil }.count
        let localizedCount = symbols.filter { $0.localizations != nil }.count

        print()
        print("📊 Statistics:")
        print("   Total symbols: \(symbols.count)")
        print("   Deprecated: \(deprecatedCount)")
        print("   Restricted: \(restrictedCount)")
        print("   With localizations: \(localizedCount)")

        print()
        print("✅ Export complete. Please check the Sources folder.")
    } catch {
        print("❌ Error: \(error)")
    }

    // Cleanup: Delete generated files (symbols.json + font_restrictions.tsv live in
    // the temp working dir which is removed by the deferred cleanup; draw.txt lives
    // in the repo root and is removed here, matching the original script).
    do {
        try FileManager.default.removeItem(at: symbolsJSONPath)
        print("☑️  Cleaned up symbols.json")
    } catch {
        print("⚠️  Could not delete symbols.json: \(error)")
    }

    do {
        try FileManager.default.removeItem(at: repoDrawFilePath)
        print("☑️  Cleaned up draw.txt")
    } catch {
        print("⚠️  Could not delete draw.txt: \(error)")
    }

    let fontRestrictionsPath = workingDir.appendingPathComponent("font_restrictions.tsv")
    if FileManager.default.fileExists(atPath: fontRestrictionsPath.path) {
        do {
            try FileManager.default.removeItem(at: fontRestrictionsPath)
            print("☑️  Cleaned up font_restrictions.tsv")
        } catch {
            print("⚠️  Could not delete font_restrictions.tsv: \(error)")
        }
    }
}
