import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(InjectableTests.allTests),
        testCase(InjectionContainerTests.allTests)
    ]
}
#endif
