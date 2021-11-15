import XCTest
import SwiftUI
@testable import SFSymbols

@available(iOS 15.1, *)
final class SFSymbolsTests: XCTestCase {
    func testAllSymbolsExist() {
        for symbol in SFSymbol.allSymbols {
            let image = UIImage(systemName: symbol.title)
            XCTAssert(image != nil, "\(symbol.title) does not exist!")
        }
    }
    
    
    func testAllSymbolsAreUnique(){
        let regularArray = SFSymbol.allSymbols
        let uniqueSet    = Set(regularArray)
        
        XCTAssert(regularArray.count == uniqueSet.count)
    }
}
