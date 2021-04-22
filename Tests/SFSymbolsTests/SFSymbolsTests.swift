import XCTest
@testable import SFSymbols

final class SFSymbolsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SFSymbols().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
