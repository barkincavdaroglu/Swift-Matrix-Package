import XCTest
@testable import Matrix_Package

final class Matrix_PackageTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Matrix_Package().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
