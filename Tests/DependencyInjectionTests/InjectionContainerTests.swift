//
//  InjectionContainerTests.swift
//  DependencyInjectionTests
//
//  Created by Richard Clements on 05/04/2019.
//  Copyright © 2019 colouroncode. All rights reserved.
//

import XCTest
@testable import DependencyInjection

class InjectionContainerTests: XCTestCase {
    
    var container: InjectionContainer!
    
    override func setUp() {
        container = InjectionContainer()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        container = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_registerAlwaysNew() {
        container.register(String.self, mode: .alwaysNew) {
            resolver in
            return "Test"
        }
        
        XCTAssertEqual(container.resolve(String.self), "Test")
    }
    
    func test_registerAlwaysNew_createsNewInstance() {
        container.register(NSNumber.self, mode: .alwaysNew) {
            resolver in
            return NSNumber(value: Int.random(in: 0 ..< 1000))
        }
        
        let firstResolver = container.resolve(NSNumber.self)!
        let secondResolver = container.resolve(NSNumber.self)!
        
        XCTAssertFalse(firstResolver === secondResolver)
    }
    
    func test_registerAlwaysNew_WithName() {
        container.register(String.self, name: "Named", mode: .alwaysNew) {
            resolver in
            return "Test"
        }
        
        XCTAssertEqual(container.resolve(String.self, name: "Named"), "Test")
        XCTAssertNil(container.resolve(String.self, name: "Different Name"))
        XCTAssertNil(container.resolve(String.self))
    }
    
    func test_registerUseContainer() {
        container.register(String.self, mode: .useContainer) {
            resolver in
            return "Test"
        }
        
        XCTAssertEqual(container.resolve(String.self), "Test")
    }
    
    func test_registerUserContainer_usesSameInstance() {
        container.register(NSNumber.self, mode: .useContainer) {
            resolver in
            return NSNumber(value: Int.random(in: 0 ..< 1000))
        }
        
        let firstResolver = container.resolve(NSNumber.self)!
        let secondResolver = container.resolve(NSNumber.self)!
        
        XCTAssertTrue(firstResolver === secondResolver)
    }
    
    func test_registerUseContainer_WithName() {
        container.register(String.self, name: "Named", mode: .useContainer) {
            resolver in
            return "Test"
        }
        
        XCTAssertEqual(container.resolve(String.self, name: "Named"), "Test")
        XCTAssertNil(container.resolve(String.self, name: "Different Name"))
        XCTAssertNil(container.resolve(String.self))
    }
    
    static var allTests = [
        ("test_registerAlwaysNew", test_registerAlwaysNew),
        ("test_registerAlwaysNew_createsNewInstance", test_registerAlwaysNew_createsNewInstance),
        ("test_registerAlwaysNew_WithName", test_registerAlwaysNew_WithName),
        ("test_registerUseContainer", test_registerUseContainer),
        ("test_registerUserContainer_usesSameInstance", test_registerUserContainer_usesSameInstance),
        ("test_registerUseContainer_WithName", test_registerUseContainer_WithName)
    ]
}

