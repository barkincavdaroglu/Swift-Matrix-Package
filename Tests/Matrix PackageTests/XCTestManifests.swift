import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Matrix_PackageTests.allTests),
    ]
}
#endif
