import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {[
    testCase(JsonConveniencesTests.allTests),
]}
#endif
