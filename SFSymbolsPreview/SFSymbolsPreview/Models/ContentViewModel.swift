//
//  ContentViewModel.swift
//  SFSymbolsPreview
//
//  Created by Richard Witherspoon on 11/15/21.
//

import Foundation
import SFSymbols


class ContentViewModel: ObservableObject{
    @Published var categories = [SFCategory]()
    
    var symbols = [SFSymbol]()
    private let decoder = PropertyListDecoder()
    private let bundle = Bundle.main
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    
    //MARK: Initializer
    init(){
        do{
            try loadCategories()
            try loadSymbols()
            try loadSymbolCategories()
            try loadSearchTerms()
            try createStaticVarFile()
            
            let symbols13   = symbols.filter({$0.releaseInfo.iOS == 13})
            let symbols14   = symbols.filter({$0.releaseInfo.iOS == 14})
            let symbols14P2 = symbols.filter({$0.releaseInfo.iOS == 14.2})
            let symbols14P5 = symbols.filter({$0.releaseInfo.iOS == 14.5})
            let symbols15   = symbols.filter({$0.releaseInfo.iOS == 15})
            let symbols15P1 = symbols.filter({$0.releaseInfo.iOS == 15.1})
            let symbols15P2 = symbols.filter({$0.releaseInfo.iOS == 15.2})

            try createAllSymbolsFile(symbols: symbols13, extensionName: "All13", variableName: "allSymbols13", iOSVersion: 13)
            try createAllSymbolsFile(symbols: symbols14, extensionName: "All14", variableName: "allSymbols14", iOSVersion: 14)
            try createAllSymbolsFile(symbols: symbols14P2, extensionName: "All14P2", variableName: "allSymbols14P2", iOSVersion: 14.2)
            try createAllSymbolsFile(symbols: symbols14P5, extensionName: "All14P5", variableName: "allSymbols14P5", iOSVersion: 14.5)
            try createAllSymbolsFile(symbols: symbols15, extensionName: "All15", variableName: "allSymbols15", iOSVersion: 15)
            try createAllSymbolsFile(symbols: symbols15P1, extensionName: "All15P1", variableName: "allSymbols15P1", iOSVersion: 15.1)
            try createAllSymbolsFile(symbols: symbols15P2, extensionName: "All15P2", variableName: "allSymbols15P2", iOSVersion: 15.2)

            print("Finished creating the swift files. They can be found in the `Files` app.")
        } catch{
            print("ERROR: \(error)")
        }
    }
        
    
    //MARK: Private Helpers
    private func createStaticVarFile() throws{
        var staticVars = symbols.map({convertSymbolToStaticVar($0)}).joined(separator: "\n\n")
        let i = staticVars.index(staticVars.startIndex, offsetBy: 0)
        staticVars.insert(contentsOf: "import Foundation\n\n\npublic extension SFSymbol {\n", at: i)
        staticVars.append("\n}")
        
        let url = documentsDirectory.appendingPathComponent("SFSymbol+StaticVariables.swift")
        
        try staticVars.write(to: url, atomically: true, encoding: .utf8)
    }
    
    private func createAllSymbolsFile(symbols: [SFSymbol], extensionName: String, variableName: String, iOSVersion: Double) throws{
        let titles = symbols.map({convertTitleToCamelCased(string: $0.title)}).map({"         .\($0)"}).joined(separator: ",\n")
        
        var array = """
        \n
            static var \(variableName): [SFSymbol] {
                return [\n
        """
        
        array.append(contentsOf: titles)
        array.append(contentsOf: "\n      ]")
        
        
        let newestSymbol = symbols.first(where: {$0.releaseInfo.iOS == iOSVersion})!
        let header = """
        import Foundation
        
        @available(iOS \(newestSymbol.releaseInfo.iOS), macOS \(newestSymbol.releaseInfo.macOS), tvOS \(newestSymbol.releaseInfo.tvOS), watchOS \(newestSymbol.releaseInfo.watchOS), *)
        public extension SFSymbol {
        """
        
        let i = titles.index(titles.startIndex, offsetBy: 0)
        array.insert(contentsOf: header, at: i)
        array.append("\n   }\n}")
                
        let url = documentsDirectory.appendingPathComponent("SFSymbol+\(extensionName).swift")
        
        try array.write(to: url, atomically: true, encoding: .utf8)
    }
    
    private func convertSymbolToStaticVar(_ symbol: SFSymbol) -> String{
        let camelCased = convertTitleToCamelCased(string: symbol.title)

        var categoriesOptionalString  = "nil"
        var searchTermsOptionalString = "nil"

        if var categoriesString = symbol.categories?.map(\.title).map({".\($0)"}).joined(separator: ", "){
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
        
        
        let staticVar = """
                @available(iOS \(symbol.releaseInfo.iOS), macOS \(symbol.releaseInfo.macOS), tvOS \(symbol.releaseInfo.tvOS), watchOS \(symbol.releaseInfo.watchOS), *)
                static let \(camelCased) = SFSymbol(title: "\(symbol.title)",
                                                categories: \(categoriesOptionalString),
                                                searchTerms: \(searchTermsOptionalString),
                                                releaseInfo: ReleaseInfo(iOS: \(symbol.releaseInfo.iOS), macOS: \(symbol.releaseInfo.macOS), tvOS: \(symbol.releaseInfo.tvOS), watchOS: \(symbol.releaseInfo.watchOS)))
            """
        
        return staticVar
    }
    
    private func convertTitleToCamelCased(string: String)->String{
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
    
    private func loadCategories() throws{
        let url = bundle.url(forResource: "categories", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        
        categories = try decoder.decode([SFCategory].self, from: data)
    }
    
    private func loadSymbols() throws{
        let url = bundle.url(forResource: "name_availability", withExtension: "plist")!
        let data = try Data(contentsOf: url)
        let info = try decoder.decode(NameAvailabilityResults.self, from: data)
        let localizedRemovedSymbols = info.symbols.filter{!$0.title.contains(".zh")}
        
        symbols = localizedRemovedSymbols
    }
        
    private func loadSymbolCategories() throws{
        let url = bundle.url(forResource: "symbol_categories", withExtension: "plist")!
        let data = try Data(contentsOf: url)
        let dict = try decoder.decode([String: [String]].self, from: data)
        
        for (key, categoriesStringArray) in dict {
            guard let index = symbols.firstIndex(where: {$0.title == key}) else {
                continue
            }
            
            for string in categoriesStringArray{
                let category = categories.first(where: {$0.title == string})!
                                
                if symbols[index].categories == nil{
                    symbols[index].categories = [category]
                } else {
                    symbols[index].categories?.append(category)
                }
            }
        }
    }
    
    private func loadSearchTerms() throws{
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
