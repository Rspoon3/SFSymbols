import XCTest
import SwiftUI
@testable import SFSymbols

@available(iOS 14, macOS 14.0, tvOS 14.0, watchOS 7.0,  *)
final class SFSymbolsTests: XCTestCase {
    func testAllSymbolsExist() {
        for symbol in SFSymbol.allSymbols {
            let image = UIImage(systemName: symbol.title)
            XCTAssert(image != nil, "\(symbol.title) does not exist!")
        }
    }
}
