import XCTest

import DependencyInjectionTests

let tests = [
    GraphTests.allTests,
    InjectTests.allTests,
    DependencyTests.allTests,
    ModuleTests.allTests,
    IndependentGraphModuleTests.allTests,
    GraphModuleTests.allTests,
    ScopeTests.allTests
].flatMap()
XCTMain(tests)
