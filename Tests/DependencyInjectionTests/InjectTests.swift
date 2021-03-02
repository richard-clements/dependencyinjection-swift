//
//  File.swift
//  
//
//  Created by Richard Clements on 12/08/2020.
//

import XCTest
@testable import DependencyInjection

public class InjectTests: XCTestCase {
    
    func testInject() {
        struct Mock {
            @Inject var integer: Int
        }
        let graph = Graph {
            Dependency { 5 }
        }
        Graph.default = graph
        let mock = Mock()
        XCTAssertEqual(mock.integer, 5)
    }
    
    func testInjectNamedScope() {
        struct Mock {
            @Inject(name: "1") var integer1: Int
            @Inject(name: "2") var integer2: Int
        }
        let graph = Graph {
            Dependency { 1 }
                .withScope(.named("1"))
            Dependency { 2 }
                .withScope(.named("2"))
        }
        Graph.default = graph
        let mock = Mock()
        XCTAssertEqual(mock.integer1, 1)
        XCTAssertEqual(mock.integer2, 2)
    }
    
    func testInjectArguments() {
        struct Mock {
            @Inject(arguments: 1) var integer: Int
        }
        let graph = Graph {
            Dependency { _, arguments in
                arguments[0] as! Int
            }
        }
        Graph.default = graph
        let mock = Mock()
        XCTAssertEqual(mock.integer, 1)
    }
    
    func testInjectGraph() {
        struct Mock {
            static let graph = Graph {
                Dependency { 5 }
            }
            @Inject(graph: Self.graph) var integer: Int
        }
        let mock = Mock()
        XCTAssertEqual(mock.integer, 5)
    }
    
    func testLazyInject() {
        struct Mock {
            @LazyInject var integer: Int
        }
        var calledDependency = false
        let graph = Graph {
            Dependency { (_) -> Int in
                calledDependency = true
                return 5
            }
        }
        Graph.default = graph
        let mock = Mock()
        XCTAssertFalse(calledDependency)
        XCTAssertEqual(mock.integer, 5)
        XCTAssertTrue(calledDependency)
    }
    
    func testLazyInjectNamedScope() {
        struct Mock {
            @LazyInject(name: "1") var integer1: Int
            @LazyInject(name: "2") var integer2: Int
        }
        let graph = Graph {
            Dependency { 1 }
                .withScope(.named("1"))
            Dependency { 2 }
                .withScope(.named("2"))
        }
        Graph.default = graph
        let mock = Mock()
        XCTAssertEqual(mock.integer1, 1)
        XCTAssertEqual(mock.integer2, 2)
    }
    
    func testLazyInjectArguments() {
        struct Mock {
            @LazyInject(arguments: 1) var integer: Int
        }
        let graph = Graph {
            Dependency { _, arguments in
                arguments[0] as! Int
            }
        }
        Graph.default = graph
        let mock = Mock()
        XCTAssertEqual(mock.integer, 1)
    }
    
    func testLazyInjectGraph() {
        struct Mock {
            static let graph = Graph {
                Dependency { 5 }
            }
            @LazyInject(graph: Self.graph) var integer: Int
        }
        let mock = Mock()
        XCTAssertEqual(mock.integer, 5)
    }
}

extension InjectTests {
    
    public static var allTests = [
        ("testInject", testInject),
        ("testInjectNamedScope", testInjectNamedScope),
        ("testInjectArguments", testInjectArguments),
        ("testInjectGraph", testInjectGraph),
        ("testLazyInject", testLazyInject),
        ("testLazyInjectNamedScope", testLazyInjectNamedScope),
        ("testLazyInjectArguments", testLazyInjectArguments),
        ("testLazyInjectGraph", testLazyInjectGraph)
    ]
    
}
