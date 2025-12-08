import Testing
@testable import SFSymbols

#if canImport(UIKit)
import UIKit
#endif

@Suite
struct SFSymbolsTests {

    // MARK: - Symbol Existence

//    #if canImport(UIKit)
//    @Test
//    func allSymbolsExist() {
//        let currentVersion = ProcessInfo.processInfo.operatingSystemVersion
//        let currentiOS = Double(currentVersion.majorVersion) + Double(currentVersion.minorVersion) / 10.0
//
//        for symbol in SFSymbol.allSymbols {
//            // Skip symbols that require a newer iOS version
//            guard symbol.releaseInfo.iOS <= currentiOS else { continue }
//            // Skip deprecated symbols as they may have been removed
//            guard !symbol.isDeprecated else { continue }
//
//            let image = UIImage(systemName: symbol.title)
//            #expect(image != nil, "\(symbol.title) does not exist!")
//        }
//    }
//    #endif

    // MARK: - Uniqueness

    @Test
    func allSymbolsAreUnique() {
        let regularArray = SFSymbol.allSymbols
        let uniqueSet = Set(regularArray)

        #expect(regularArray.count == uniqueSet.count)
    }

    // MARK: - Symbol Counts

    @Test
    func correctNumberOfSymbols13() {
        #expect(SFSymbol.allSymbols13.count == 1_626)
    }

    @Test
    @available(iOS 13.1, visionOS 1.0, *)
    func correctNumberOfSymbols13P1() {
        #expect(SFSymbol.allSymbols13P1.count == 18)
    }

    @Test
    @available(iOS 14, visionOS 1.0, *)
    func correctNumberOfSymbols14() {
        #expect(SFSymbol.allSymbols14.count == 988)
    }

    @Test
    @available(iOS 14.2, visionOS 1.0, *)
    func correctNumberOfSymbols14P2() {
        #expect(SFSymbol.allSymbols14P2.count == 44)
    }

    @Test
    @available(iOS 14.5, macOS 11.3, visionOS 1.0, *)
    func correctNumberOfSymbols14P5() {
        #expect(SFSymbol.allSymbols14P5.count == 15)
    }

    @Test
    @available(iOS 15.0, macOS 12.0, visionOS 1.0, *)
    func correctNumberOfSymbols15() {
        #expect(SFSymbol.allSymbols15.count == 808)
    }

    @Test
    @available(iOS 15.1, macOS 12.0, visionOS 1.0, *)
    func correctNumberOfSymbols15P1() {
        #expect(SFSymbol.allSymbols15P1.count == 13)
    }

    @Test
    @available(iOS 15.2, macOS 12.1, visionOS 1.0, *)
    func correctNumberOfSymbols15P2() {
        #expect(SFSymbol.allSymbols15P2.count == 15)
    }

    @Test
    @available(iOS 15.4, macOS 12.3, visionOS 1.0, *)
    func correctNumberOfSymbols15P4() {
        #expect(SFSymbol.allSymbols15P4.count == 8)
    }

    @Test
    @available(iOS 16.0, macOS 13.0, visionOS 1.0, *)
    func correctNumberOfSymbols16() {
        #expect(SFSymbol.allSymbols16.count == 893)
    }

    @Test
    @available(iOS 16.1, macOS 13.0, visionOS 1.0, *)
    func correctNumberOfSymbols16P1() {
        #expect(SFSymbol.allSymbols16P1.count == 334)
    }

    @Test
    @available(iOS 16.4, macOS 13.3, visionOS 1.0, *)
    func correctNumberOfSymbols16P4() {
        #expect(SFSymbol.allSymbols16P4.count == 8)
    }

    @Test
    @available(iOS 17.0, macOS 14.0, visionOS 1.0, *)
    func correctNumberOfSymbols17() {
        #expect(SFSymbol.allSymbols17.count == 969)
    }

    @Test
    @available(iOS 17.1, macOS 14.1, visionOS 1.0, *)
    func correctNumberOfSymbols17P1() {
        #expect(SFSymbol.allSymbols17P1.count == 6)
    }

    @Test
    @available(iOS 17.2, macOS 14.2, visionOS 1.1, *)
    func correctNumberOfSymbols17P2() {
        #expect(SFSymbol.allSymbols17P2.count == 2)
    }

    @Test
    @available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, visionOS 1.1, *)
    func correctNumberOfSymbols17P4() {
        #expect(SFSymbol.allSymbols17P4.count == 23)
    }

    @Test
    @available(iOS 17.6, macOS 14.6, tvOS 17.6, watchOS 10.6, visionOS 1.3, *)
    func correctNumberOfSymbols17P6() {
        #expect(SFSymbol.allSymbols17P6.count == 7)
    }

    @Test
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    func correctNumberOfSymbols18() {
        #expect(SFSymbol.allSymbols18.count == 1_397)
    }

    @Test
    @available(iOS 18.1, macOS 15.1, tvOS 18.1, watchOS 11.1, visionOS 2.1, *)
    func correctNumberOfSymbols18P1() {
        #expect(SFSymbol.allSymbols18P1.count == 46)
    }

    @Test
    @available(iOS 18.2, macOS 15.2, tvOS 18.2, watchOS 11.2, visionOS 2.2, *)
    func correctNumberOfSymbols18P2() {
        #expect(SFSymbol.allSymbols18P2.count == 19)
    }

    @Test
    @available(iOS 18.4, macOS 15.4, tvOS 18.4, watchOS 11.4, visionOS 2.4, *)
    func correctNumberOfSymbols18P4() {
        #expect(SFSymbol.allSymbols18P4.count == 117)
    }

    @Test
    @available(iOS 18.5, macOS 15.5, tvOS 18.5, watchOS 11.5, visionOS 2.5, *)
    func correctNumberOfSymbols18P5() {
        #expect(SFSymbol.allSymbols18P5.count == 6)
    }

    @Test
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    func correctNumberOfSymbols26() {
        #expect(SFSymbol.allSymbols26.count == 375)
    }

    // MARK: - Layersets

    @Test
    func allSymbolsHaveAtLeastMonochrome() {
        for symbol in SFSymbol.allSymbols {
            #expect(symbol.layersets.contains(.monochrome), "\(symbol.title) is missing monochrome layerset")
        }
    }

    @Test
    func layersetEnumHasAllCases() {
        #expect(Layerset.allCases.count == 3)
        #expect(Layerset.allCases.contains(.monochrome))
        #expect(Layerset.allCases.contains(.hierarchical))
        #expect(Layerset.allCases.contains(.multicolor))
    }

    @Test
    func someSymbolsHaveMultipleLayersets() {
        let symbolsWithMultipleLayersets = SFSymbol.allSymbols.filter { $0.layersets.count > 1 }
        #expect(!symbolsWithMultipleLayersets.isEmpty, "Expected some symbols to have multiple layersets")
    }

    // MARK: - Localizations

    @Test
    func localizationEnumHasAllCases() {
        #expect(Localization.allCases.count == 22)
    }

    @Test
    func someSymbolsHaveLocalizations() {
        let symbolsWithLocalizations = SFSymbol.allSymbols.filter { $0.localizations != nil }
        #expect(!symbolsWithLocalizations.isEmpty, "Expected some symbols to have localizations")
    }

    @Test
    func localizationsHaveValidCodes() {
        for symbol in SFSymbol.allSymbols {
            guard let localizations = symbol.localizations else { continue }
            for loc in localizations {
                #expect(Localization.allCases.contains(loc.code), "\(symbol.title) has invalid localization code: \(loc.code)")
            }
        }
    }

    // MARK: - Restrictions

    @Test
    func someSymbolsHaveRestrictions() {
        let symbolsWithRestrictions = SFSymbol.allSymbols.filter { $0.restriction != nil }
        #expect(!symbolsWithRestrictions.isEmpty, "Expected some symbols to have restrictions")
    }

    @Test
    func restrictionsAreNotEmpty() {
        for symbol in SFSymbol.allSymbols {
            if let restriction = symbol.restriction {
                #expect(!restriction.isEmpty, "\(symbol.title) has empty restriction string")
            }
        }
    }

    // MARK: - Deprecation

    @Test
    func someSymbolsAreDeprecated() {
        let deprecatedSymbols = SFSymbol.allSymbols.filter { $0.isDeprecated }
        #expect(!deprecatedSymbols.isEmpty, "Expected some symbols to be deprecated")
    }

    @Test
    func deprecatedSymbolsHaveNewName() {
        for symbol in SFSymbol.allSymbols {
            if symbol.isDeprecated {
                #expect(symbol.deprecatedNewName != nil, "\(symbol.title) is deprecated but has no new name")
                #expect(!symbol.deprecatedNewName!.isEmpty, "\(symbol.title) has empty deprecatedNewName")
            }
        }
    }

    @Test
    func isDeprecatedMatchesDeprecatedNewName() {
        for symbol in SFSymbol.allSymbols {
            #expect(symbol.isDeprecated == (symbol.deprecatedNewName != nil), "\(symbol.title) has inconsistent deprecation state")
        }
    }

    // MARK: - Categories

    @Test
    func categoriesHaveSymbols() {
        // "What's New" and "Draw" are special categories computed dynamically in SF Symbols app
        let specialCategories: Set<String> = ["Draw"]

        for category in SFCategory.allCategories {
            guard !specialCategories.contains(category.title) else { continue }
            #expect(!category.symbols.isEmpty, "\(category.title) has no symbols")
        }
    }

    // MARK: - Codable

    @Test
    func symbolIsEncodableAndDecodable() throws {
        let symbol = SFSymbol.star
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(symbol)
        let decoded = try decoder.decode(SFSymbol.self, from: data)

        #expect(decoded.title == symbol.title)
        #expect(decoded.layersets == symbol.layersets)
        #expect(decoded.releaseInfo == symbol.releaseInfo)
    }

    @Test
    func layersetIsEncodableAndDecodable() throws {
        let layerset = Layerset.hierarchical
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(layerset)
        let decoded = try decoder.decode(Layerset.self, from: data)

        #expect(decoded == layerset)
    }
}
