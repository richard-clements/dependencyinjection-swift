//
//  File.swift
//  
//
//  Created by Richard Clements on 12/08/2020.
//

import XCTest
@testable import DependencyInjection

class DependencyTests: XCTestCase {
    
    func testWithScope() {
        let singleInstanceDependency = Dependency { 5 }
            .withScope(.singleInstance)
        XCTAssertEqual(singleInstanceDependency.scope, .singleInstance)
        
        let newDependency = Dependency { 5 }
            .withScope(.new)
        XCTAssertEqual(newDependency.scope, .new)
        
        let namedDependency = Dependency { 5 }
            .withScope(.named("Name"))
        XCTAssertEqual(namedDependency.scope, .named("Name"))
        
        let dependency = Dependency { 5 }
        XCTAssertEqual(dependency.scope, .new)
    }
    
}
