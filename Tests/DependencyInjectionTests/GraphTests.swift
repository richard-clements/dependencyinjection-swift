//
//  File.swift
//  
//
//  Created by Richard Clements on 11/08/2020.
//

import XCTest
@testable import DependencyInjection

public class GraphTests: XCTestCase {
    
    func testResolve() {
        let graph = Graph(dependencies: [
            Dependency { 5 }
        ])
        XCTAssertEqual(graph.resolve(), 5)
    }
    
    func testResolveArguments() {
        let graph = Graph(dependencies: [
            Dependency { _, args in
                args[0] as! Int
            }
        ])
        XCTAssertEqual(graph.resolve(arguments: 1), 1)
    }
    
    func testResolveName() {
        let graph = Graph(dependencies: [
            Dependency { 1 }
                .withScope(.named("1")),
            Dependency { 2 }
                .withScope(.named("2"))
        ])
        XCTAssertEqual(graph.resolve(named: "1"), 1)
        XCTAssertEqual(graph.resolve(named: "2"), 2)
    }
    
    func testResolveNameAndArguments() {
        let graph = Graph(dependencies: [
            Dependency { _, args in
                args[0] as! Int
            }
            .withScope(.named("1")),
            Dependency { _, args in
                args[1] as! Int
            }
            .withScope(.named("2"))
        ])
        XCTAssertEqual(graph.resolve(scope: "1", arguments: 1, 2), 1)
        XCTAssertEqual(graph.resolve(scope: "2", arguments: 1, 2), 2)
    }
    
    func testResolveSingleInstance() {
        let graph = Graph(dependencies: [
            Dependency { NSObject() }
                .withScope(.singleInstance)
        ])
        let object1: NSObject = graph.resolve()!
        let object2: NSObject = graph.resolve()!
        XCTAssertTrue(object1 === object2)
    }
    
    func testResolveNew() {
        let graph = Graph(dependencies: [
            Dependency { NSObject() }
                .withScope(.new)
        ])
        let object1: NSObject = graph.resolve()!
        let object2: NSObject = graph.resolve()!
        XCTAssertFalse(object1 === object2)
    }
    
    func testResolveScope() {
        let graph = Graph(dependencies: [
            Dependency { NSObject() }
                .withScope(.named("Name 1")),
            Dependency { NSObject() }
                .withScope(.named("Name 2"))
        ])
        let object1: NSObject = graph.resolve(named: "Name 1")!
        let object2: NSObject = graph.resolve(named: "Name 2")!
        let object3: NSObject = graph.resolve(named: "Name 1")!
        XCTAssertTrue(object1 === object3)
        XCTAssertFalse(object1 === object2)
    }
    
    func testGraphBuilder() {
        let graph = Graph {
            Dependency { 5 }
        }
        XCTAssertEqual(graph.resolve(), 5)
    }
    
    func testGraphInitialise() {
        Graph.initialise {
            Dependency { 5 }
        }
        XCTAssertEqual(Graph.default.resolve(), 5)
    }
}

extension GraphTests {
    
    public static var allTests = [
        ("testResolve", testResolve),
        ("testResolveArguments", testResolveArguments),
        ("testResolveName", testResolveName),
        ("testResolveNameAndArguments", testResolveNameAndArguments),
        ("testResolveSingleInstance", testResolveSingleInstance),
        ("testResolveNew", testResolveNew),
        ("testResolveScope", testResolveScope),
        ("testGraphBuilder", testGraphBuilder),
        ("testGraphInitialise", testGraphInitialise)
    ]
}
