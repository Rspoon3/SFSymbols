import Testing
@testable import SFSymbols

#if canImport(UIKit)
import UIKit
#endif

@Suite
struct SFSymbolsTests {

    #if canImport(UIKit)
    @Test
    func allSymbolsExist() {
        for symbol in SFSymbol.allSymbols {
            let image = UIImage(systemName: symbol.title)
            #expect(image != nil, "\(symbol.title) does not exist!")
        }
    }
    #endif

    @Test
    func allSymbolsAreUnique() {
        let regularArray = SFSymbol.allSymbols
        let uniqueSet = Set(regularArray)

        #expect(regularArray.count == uniqueSet.count)
    }

    @Test
    func correctNumberOfSymbols13() {
        #expect(SFSymbol.allSymbols13.count == 1_661)
    }

    @Test
    @available(iOS 13.1, visionOS 1.0, *)
    func correctNumberOfSymbols13P1() {
        #expect(SFSymbol.allSymbols13P1.count == 18)
    }

    @Test
    @available(iOS 14, visionOS 1.0, *)
    func correctNumberOfSymbols14() {
        #expect(SFSymbol.allSymbols14.count == 1_066)
    }

    @Test
    @available(iOS 14.2, visionOS 1.0, *)
    func correctNumberOfSymbols14P2() {
        #expect(SFSymbol.allSymbols14P2.count == 96)
    }

    @Test
    @available(iOS 14.5, macOS 11.3, visionOS 1.0, *)
    func correctNumberOfSymbols14P5() {
        #expect(SFSymbol.allSymbols14P5.count == 31)
    }

    @Test
    @available(iOS 15.0, macOS 12.0, visionOS 1.0, *)
    func correctNumberOfSymbols15() {
        #expect(SFSymbol.allSymbols15.count == 835)
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
        #expect(SFSymbol.allSymbols15P4.count == 7)
    }

    @Test
    @available(iOS 16.0, macOS 13.0, visionOS 1.0, *)
    func correctNumberOfSymbols16() {
        #expect(SFSymbol.allSymbols16.count == 932)
    }

    @Test
    @available(iOS 16.1, macOS 13.0, visionOS 1.0, *)
    func correctNumberOfSymbols16P1() {
        #expect(SFSymbol.allSymbols16P1.count == 373)
    }

    @Test
    @available(iOS 16.4, macOS 13.3, visionOS 1.0, *)
    func correctNumberOfSymbols16P4() {
        #expect(SFSymbol.allSymbols16P4.count == 32)
    }

    @Test
    @available(iOS 17.0, macOS 14.0, visionOS 1.0, *)
    func correctNumberOfSymbols17() {
        #expect(SFSymbol.allSymbols17.count == 999)
    }

    @Test
    @available(iOS 17.1, macOS 14.1, visionOS 1.0, *)
    func correctNumberOfSymbols17P1() {
        #expect(SFSymbol.allSymbols17P1.count == 6)
    }

    @Test
    @available(iOS 17.2, macOS 14.2, visionOS 1.1, *)
    func correctNumberOfSymbols17P2() {
        #expect(SFSymbol.allSymbols17P2.count == 450)
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
        #expect(SFSymbol.allSymbols18.count == 1_586)
    }

    @Test
    @available(iOS 18.1, macOS 15.1, tvOS 18.1, watchOS 11.1, visionOS 2.1, *)
    func correctNumberOfSymbols18P1() {
        #expect(SFSymbol.allSymbols18P1.count == 91)
    }

    @Test
    @available(iOS 18.2, macOS 15.2, tvOS 18.2, watchOS 11.2, visionOS 2.2, *)
    func correctNumberOfSymbols18P2() {
        #expect(SFSymbol.allSymbols18P2.count == 23)
    }

    @Test
    @available(iOS 18.4, macOS 15.4, tvOS 18.4, watchOS 11.4, visionOS 2.4, *)
    func correctNumberOfSymbols18P4() {
        #expect(SFSymbol.allSymbols18P4.count == 237)
    }

    @Test
    @available(iOS 18.5, macOS 15.5, tvOS 18.5, watchOS 11.5, visionOS 2.5, *)
    func correctNumberOfSymbols18P5() {
        #expect(SFSymbol.allSymbols18P5.count == 6)
    }

    @Test
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    func correctNumberOfSymbols26() {
        #expect(SFSymbol.allSymbols26.count == 485)
    }
}
