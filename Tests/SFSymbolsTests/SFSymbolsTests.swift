import XCTest
import SwiftUI
@testable import SFSymbols

final class SFSymbolsTests: XCTestCase {
#if canImport(UIKit)
    func testAllSymbolsExist() {
        for symbol in SFSymbol.allSymbols {
            let image = UIImage(systemName: symbol.title)
            XCTAssert(image != nil, "\(symbol.title) does not exist!")
        }
    }
#endif
    
    func testAllSymbolsAreUnique(){
        let regularArray = SFSymbol.allSymbols
        let uniqueSet    = Set(regularArray)
        
        XCTAssertEqual(regularArray.count, uniqueSet.count)
    }
    
    func testCorrectNumberOfSymbols(){
        XCTAssertEqual(SFSymbol.allSymbols.count, 8_150)
        XCTAssertEqual(SFSymbol.allSymbols13.count, 1_661)
        
        if #available(iOS 13.1, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols13P1.count, 18)
        }
        
        if #available(iOS 14, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols14.count, 1_066)
        }
        
        if #available(iOS 14.2, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols14P2.count, 96)
        }
        
        if #available(iOS 14.5, macOS 11.3, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols14P5.count, 31)
        }
        
        if #available(iOS 15.0, macOS 12.0, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols15.count, 835)
        }
        
        if #available(iOS 15.1, macOS 12.0, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols15P1.count, 13)
        }
        
        if #available(iOS 15.2, macOS 12.1, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols15P2.count, 15)
        }
        
        if #available(iOS 15.4, macOS 12.3, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols15P4.count, 7)
        }
        
        if #available(iOS 16.0, macOS 13.0, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols16.count, 932)
        }
        
        if #available(iOS 16.1, macOS 13.0, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols16P1.count, 373)
        }
        
        if #available(iOS 16.4, macOS 13.3, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols16P4.count, 32)
        }
        
        if #available(iOS 17.0, macOS 14.0, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols17.count, 999)
        }
        
        if #available(iOS 17.1, macOS 14.1, visionOS 1.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols17P1.count, 6)
        }
        
        if #available(iOS 17.2, macOS 14.2, visionOS 1.1, *) {
            XCTAssertEqual(SFSymbol.allSymbols17P2.count, 450)
        }
        
        if #available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, visionOS 1.1, *){
            XCTAssertEqual(SFSymbol.allSymbols17P4.count, 23)
        }
        
        if #available(iOS 17.6, macOS 14.6, tvOS 17.6, watchOS 10.6, visionOS 1.3, *){
            XCTAssertEqual(SFSymbol.allSymbols17P6.count, 7)
        }
        
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *){
            XCTAssertEqual(SFSymbol.allSymbols18.count, 1_586)
        }
    }
}
