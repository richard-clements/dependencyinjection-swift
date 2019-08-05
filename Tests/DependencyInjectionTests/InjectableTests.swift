//
//  DependencyInjectionTests.swift
//  DependencyInjectionTests
//
//  Created by Richard Clements on 04/04/2019.
//  Copyright © 2019 colouroncode. All rights reserved.
//

import XCTest
@testable import DependencyInjection

class MockInjectable {
    
    @Inject var someString: String!
    @Inject(name: "Named Int") var someInt: Int!
    
}

class InjectableTests: XCTestCase {
    
    var container: InjectionContainer!
    
    override func setUp() {
        container = .default
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        container = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_newInstance_resolvesFromContainer() {
        container.register(String.self, mode: .alwaysNew) {
            resolver in
            return "42"
        }
        
        container.register(Int.self, name: "Named Int", mode: .alwaysNew) {
            resolver in
            return 42
        }
        
        let object = MockInjectable()
        XCTAssertEqual(object.someString, "42")
        XCTAssertEqual(object.someInt, 42)
    }
    
    static var allTests = [
        ("test_newInstance_resolvesFromContainer", test_newInstance_resolvesFromContainer),
    ]
}
