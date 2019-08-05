//
//  DependencyInjectionManagerTests.swift
//  
//
//  Created by Richard Clements on 05/08/2019.
//

import XCTest
@testable import DependencyInjection

class TestModule: DependencyInjectionModule {
    
    override func setUp() {
        container.register(Int.self, mode: .alwaysNew) {
            resolver in
            return 5
        }
    }
    
}

class TestHiddenModule: DependencyInjectionModule {
    
    class override func isContainerAllowed(_ container: InjectionContainer) -> Bool {
        return false
    }
    
    override func setUp() {
        container.register(String.self, mode: .alwaysNew) {
            resolver in
            return "String"
        }
    }
    
}

class DependencyInjectionManagerTests: XCTestCase {
    
    var container: InjectionContainer!
    var manager: DependencyInjectionManager!
    
    override func setUp() {
        super.setUp()
        container = .default
        manager = DependencyInjectionManager(container: container)
    }
    
    override func tearDown() {
        container = nil
        manager = nil
        super.tearDown()
    }
    
    func testModule() {
        XCTAssertEqual(container.resolve(Int.self), 5)
    }
    
    func testModuleIsIgnored() {
        XCTAssertNil(container.resolve(String.self))
    }
}
