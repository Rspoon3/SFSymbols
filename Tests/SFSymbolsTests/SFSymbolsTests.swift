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
        
        XCTAssert(regularArray.count == uniqueSet.count)
    }
    
    func testCorrectNumberOfSymbols(){
        XCTAssertEqual(SFSymbol.allSymbols.count, 5047)
        XCTAssertEqual(SFSymbol.allSymbols13.count, 1661)
        
        if #available(iOS 13.1, *) {
            XCTAssertEqual(SFSymbol.allSymbols13P1.count, 18)
        }
        
        if #available(iOS 14, *) {
            XCTAssertEqual(SFSymbol.allSymbols14.count, 1066)
        }
        
        if #available(iOS 14.2, *) {
            XCTAssertEqual(SFSymbol.allSymbols14P2.count, 96)
        }
        
        if #available(iOS 14.5, macOS 11.3, *) {
            XCTAssertEqual(SFSymbol.allSymbols14P5.count, 31)
        }
        
        if #available(iOS 15.0, macOS 12.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols15.count, 835)
        }
        
        if #available(iOS 15.1, macOS 12.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols15P1.count, 13)
        }
        
        if #available(iOS 15.2, macOS 12.1, *) {
            XCTAssertEqual(SFSymbol.allSymbols15P2.count, 15)
        }
        
        if #available(iOS 15.4, macOS 12.3, *) {
            XCTAssertEqual(SFSymbol.allSymbols15P4.count, 7)
        }
        
        if #available(iOS 16.0, macOS 13.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols16.count, 932)
        }
        
        if #available(iOS 16.1, macOS 13.0, *) {
            XCTAssertEqual(SFSymbol.allSymbols16P1.count, 373)
        }
    }
}
