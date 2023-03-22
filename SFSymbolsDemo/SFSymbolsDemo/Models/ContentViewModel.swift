//
//  ContentViewModel.swift
//  SFSymbolsDemo
//
//  Created by Richard Witherspoon on 11/15/21.
//

import Foundation
import SFSymbols


class ContentViewModel: ObservableObject{
    @Published var categories = [SFCategory]()
    
    private(set) var symbols = [SFSymbol]()
    private var categoriesPlistDict: [String: String] = [:]
    private let decoder = PropertyListDecoder()
    private let bundle = Bundle.main
    
#if os(iOS)
    private let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
#elseif os(macOS)
    private var directory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
#endif
    
    
    //MARK: Initializer
    init(){
        do{
            try loadCategories()
            try loadSymbols()
            try loadSymbolCategories()
            try loadSearchTerms()
            try createMacFolder()
            
            try createStaticVarFile(for: categories)
            
            let iOSVersions = Set(symbols.map(\.releaseInfo.iOS)).sorted()
            
            for version in iOSVersions {
                let symbols = symbols.filter{$0.releaseInfo.iOS == version}
                var fileName = version.description.replacingOccurrences(of: ".0", with: "")
                fileName = fileName.replacingOccurrences(of: ".", with: "P")
                
                try createStaticVarFile(for: symbols, fileName: fileName)
                try createAllSymbolsFile(for: symbols, fileName: fileName)
            }
            
#if os(iOS)
            print("Finished creating the swift files. They can be found in the `Files` app.")
#elseif os(macOS)
            print("Finished creating the swift files. They can be found your downloads folder.")
#endif
            
            print("Don't forget to update the package 'SFSymbol+All' files.")
        } catch{
            print("ERROR: \(error)")
        }
    }
    
    
    //MARK: Private Helpers
    private func createMacFolder() throws{
#if os(macOS)
        let appTitle = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        directory = directory.appendingPathComponent(appTitle)
        try FileManager.default.createDirectory(atPath: directory.path, withIntermediateDirectories: true)
#endif
    }
    
    private func createStaticVarFile(for categories: [SFCategory]) throws {
        let staticVars = categories.map { category in
            let plistTitle = categoriesPlistDict[category.title]!
            
            return """
            public static let \(plistTitle.lowercased()) = SFCategory(icon: "\(category.icon)", title: "\(category.title)", plistTitle: "\(plistTitle)")
            """
        }.joined(separator: "\n")
        
        let url = directory.appendingPathComponent("SFCategory.swift")
        try staticVars.write(to: url, atomically: true, encoding: .utf8)
    }
    
    private func createStaticVarFile(for symbols: [SFSymbol], fileName: String) throws {
        let newestSymbol = symbols.first!
        let header = """
        import Foundation
        
        @available(iOS \(newestSymbol.releaseInfo.iOS), macOS \(newestSymbol.releaseInfo.macOS), tvOS \(newestSymbol.releaseInfo.tvOS), watchOS \(newestSymbol.releaseInfo.watchOS), *)
        public extension SFSymbol {
        
        """
        
        var staticVars = symbols.map{convertSymbolToStaticVar($0)}.joined(separator: "\n\n")
        let i = staticVars.index(staticVars.startIndex, offsetBy: 0)
        staticVars.insert(contentsOf: header, at: i)
        staticVars.append("\n}")
        
        let url = directory.appendingPathComponent("SFSymbol+StaticVariables\(fileName).swift")
        try staticVars.write(to: url, atomically: true, encoding: .utf8)
    }
    
    private func createAllSymbolsFile(for symbols: [SFSymbol], fileName: String) throws {
        let titles = symbols.map({convertTitleToCamelCased(string: $0.title)}).map({"         .\($0)"}).joined(separator: ",\n")
        
        var array = """
        \n
            static var allSymbols\(fileName): [SFSymbol] {
                return [\n
        """
        
        array.append(contentsOf: titles)
        array.append(contentsOf: "\n      ]")
        
        
        let newestSymbol = symbols.first!
        let header = """
        import Foundation
        
        @available(iOS \(newestSymbol.releaseInfo.iOS), macOS \(newestSymbol.releaseInfo.macOS), tvOS \(newestSymbol.releaseInfo.tvOS), watchOS \(newestSymbol.releaseInfo.watchOS), *)
        public extension SFSymbol {
        """
        
        let i = titles.index(titles.startIndex, offsetBy: 0)
        array.insert(contentsOf: header, at: i)
        array.append("\n   }\n}")
        
        let url = directory.appendingPathComponent("SFSymbol+All\(fileName).swift")
        
        try array.write(to: url, atomically: true, encoding: .utf8)
    }
    
    private func convertSymbolToStaticVar(_ symbol: SFSymbol) -> String {
        let camelCased = convertTitleToCamelCased(string: symbol.title)
        
        var categoriesOptionalString  = "nil"
        var searchTermsOptionalString = "nil"
        
        if var categoriesString = symbol.categories?.map({ categoriesPlistDict[$0.title] }).map({".\($0!)"}).joined(separator: ", "){
            let i = categoriesString.index(categoriesString.startIndex, offsetBy: 0)
            categoriesString.insert("[", at: i)
            categoriesString.append(contentsOf: "]")
            
            categoriesOptionalString = categoriesString
        }
        
        
        if var searchTermsString = symbol.searchTerms?.map({"\"\($0)\""}).joined(separator: ", "){
            let i = searchTermsString.index(searchTermsString.startIndex, offsetBy: 0)
            searchTermsString.insert("[", at: i)
            searchTermsString.append(contentsOf: "]")
            
            searchTermsOptionalString = searchTermsString
        }
        
        let releaseString = "iOS: \(symbol.releaseInfo.iOS), macOS: \(symbol.releaseInfo.macOS), tvOS: \(symbol.releaseInfo.tvOS), watchOS: \(symbol.releaseInfo.watchOS)"
        
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
    
    private func convertTitleToCamelCased(string: String) -> String {
        var camelCased = string
            .split(separator: ".")  // split to components
            .map { String($0) }   // convert subsequences to String
            .enumerated()  // get indices
            .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() } // added lowercasing
            .joined() // join to one string
        
        let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        if numbers.contains(String(camelCased.first!)){
            camelCased = "number\(camelCased)"
        } else if camelCased == "return"{
            camelCased = "returnSymbol"
        } else if camelCased == "repeat"{
            camelCased = "repeatSymbol"
        } else if camelCased == "case"{
            camelCased = "caseSymbol"
        }
        
        return camelCased
    }
    
    private func loadCategories() throws {
        let url = bundle.url(forResource: "categories", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        
        categories = try decoder.decode([SFCategory].self, from: data)
        
        let plists = try decoder.decode([Plist].self, from: data)

        for plist in plists {
            categoriesPlistDict[plist.label] = plist.key
        }
    }
    
    private func loadSymbols() throws {
        let url = bundle.url(forResource: "name_availability", withExtension: "plist")!
        let data = try Data(contentsOf: url)
        let info = try decoder.decode(NameAvailabilityResults.self, from: data)
        let localizedRemovedSymbols = info.symbols.filter{!$0.title.contains(".zh")}
        
        symbols = localizedRemovedSymbols
    }
    
    private func loadSymbolCategories() throws {
        let url = bundle.url(forResource: "symbol_categories", withExtension: "plist")!
        let data = try Data(contentsOf: url)
        let dict = try decoder.decode([String: [String]].self, from: data)
        
        for (key, categoriesStringArray) in dict {
            guard let index = symbols.firstIndex(where: {$0.title == key}) else {
                continue
            }
            
            for string in categoriesStringArray {
                let category = categories.first(where: {categoriesPlistDict[$0.title] == string})!
                
                if symbols[index].categories == nil {
                    symbols[index].categories = [category]
                } else {
                    symbols[index].categories?.append(category)
                }
            }
        }
    }
    
    private func loadSearchTerms() throws {
        let url = bundle.url(forResource: "symbol_search", withExtension: "plist")!
        let data = try Data(contentsOf: url)
        let dict = try decoder.decode([String: [String]].self, from: data)
        
        for (key, searchTermsArray) in dict {
            guard let index = symbols.firstIndex(where: {$0.title == key}) else {
                continue
            }
            
            for searchTerm in searchTermsArray{
                if symbols[index].searchTerms == nil{
                    symbols[index].searchTerms = [searchTerm]
                } else {
                    symbols[index].searchTerms?.append(searchTerm)
                }
            }
        }
    }
}



fileprivate struct Plist: Decodable {
    let key: String
    let label: String
}
