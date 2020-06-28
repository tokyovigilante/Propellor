    import XCTest
    @testable import Propellor

    final class PropellorTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            XCTAssertEqual(Propellor().text, "Hello, World!")
        }

        static var allTests = [
            ("testExample", testExample),
        ]
    }
