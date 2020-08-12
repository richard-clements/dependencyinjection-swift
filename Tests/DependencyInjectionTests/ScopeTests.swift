//
//  ScopeTests.swift
//  
//
//  Created by Richard Clements on 06/08/2020.
//

import XCTest
@testable import DependencyInjection

class ScopeTests: XCTestCase {
    
    func testEquality_new() {
        XCTAssertEqual(Scope.new, Scope.new)
        XCTAssertNotEqual(Scope.new, Scope.singleInstance)
        XCTAssertNotEqual(Scope.new, Scope.named("Scope Name"))
    }
    
    func testEquality_scope() {
        XCTAssertEqual(Scope.named("Name"), Scope.named("Name"))
        XCTAssertNotEqual(Scope.named("Name"), Scope.named("Not Name"))
        XCTAssertNotEqual(Scope.named("Name"), Scope.new)
        XCTAssertNotEqual(Scope.named("Name"), Scope.singleInstance)
    }
    
    func testEquality_singleInstance() {
        XCTAssertEqual(Scope.singleInstance, Scope.singleInstance)
        XCTAssertNotEqual(Scope.singleInstance, Scope.new)
        XCTAssertNotEqual(Scope.singleInstance, Scope.named("Scope Name"))
    }
    
}
