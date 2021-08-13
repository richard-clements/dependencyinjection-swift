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
    
    func testMutableInject() {
        struct Mock {
            @MutableInject var integer: Int
        }
        let graph = Graph {
            Dependency { 5 }
        }
        Graph.default = graph
        let mock = Mock()
        XCTAssertEqual(mock.integer, 5)
    }
    
    func testMutableInjectNamedScope() {
        struct Mock {
            @MutableInject(name: "1") var integer1: Int
            @MutableInject(name: "2") var integer2: Int
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
    
    func testMutableInjectArguments() {
        struct Mock {
            @MutableInject(arguments: 1) var integer: Int
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
    
    func testMutableInjectGraph() {
        struct Mock {
            static let graph = Graph {
                Dependency { 5 }
            }
            @MutableInject(graph: Self.graph) var integer: Int
        }
        let mock = Mock()
        XCTAssertEqual(mock.integer, 5)
    }
    
    func testMutableInjectIsMutable() {
        struct Mock {
            static let graph = Graph {
                Dependency { 5 }
            }
            @MutableInject(graph: Self.graph) var integer: Int
        }
        let mock = Mock()
        mock.integer = 7
        XCTAssertEqual(mock.integer, 7)
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
        var calledDependency = false
        let graph = Graph {
            Dependency { _, arguments -> Int in
                calledDependency = true
                return arguments[0] as! Int
            }
        }
        Graph.default = graph
        let mock = Mock()
        XCTAssertFalse(calledDependency)
        XCTAssertEqual(mock.integer, 1)
        XCTAssertTrue(calledDependency)
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
    
    func testLazyInjectGraph_OnInit() {
        struct Mock {
            static let graph = Graph {
                Dependency { Subclass() }
            }
            
            class Subclass {
                var integer: Int?
                var string: String?
                var nonOptional: Int = 0
            }
            
            @LazyInject(graph: Self.graph) var subclass: Subclass
        }
        let mock = Mock()
        mock.$subclass.integer = 5
        mock.$subclass.string = "My string"
        mock.$subclass.nonOptional = 1
        XCTAssertEqual(mock.subclass.integer, 5)
        XCTAssertEqual(mock.subclass.string, "My string")
        XCTAssertEqual(mock.subclass.nonOptional, 1)
    }
    
    func testMutableLazyInject() {
        struct Mock {
            @MutableLazyInject var integer: Int
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
    
    func testMutableLazyInjectNamedScope() {
        struct Mock {
            @MutableLazyInject(name: "1") var integer1: Int
            @MutableLazyInject(name: "2") var integer2: Int
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
    
    func testMutableLazyInjectArguments() {
        struct Mock {
            @MutableLazyInject(arguments: 1) var integer: Int
        }
        var calledDependency = false
        let graph = Graph {
            Dependency { _, arguments -> Int in
                calledDependency = true
                return arguments[0] as! Int
            }
        }
        Graph.default = graph
        let mock = Mock()
        XCTAssertFalse(calledDependency)
        XCTAssertEqual(mock.integer, 1)
        XCTAssertTrue(calledDependency)
    }
    
    func testMutableLazyInjectGraph() {
        struct Mock {
            static let graph = Graph {
                Dependency { 5 }
            }
            @MutableLazyInject(graph: Self.graph) var integer: Int
        }
        let mock = Mock()
        XCTAssertEqual(mock.integer, 5)
    }
    
    func testMutableLazyInjectIsMutable() {
        struct Mock {
            static let graph = Graph {
                Dependency { 5 }
            }
            @MutableLazyInject(graph: Self.graph) var integer: Int
        }
        let mock = Mock()
        mock.integer = 7
        XCTAssertEqual(mock.integer, 7)
    }

    func testMutableLazyInjectGraph_OnInit() {
        struct Mock {
            static let graph = Graph {
                Dependency { Subclass() }
            }
            
            class Subclass {
                var integer: Int?
                var string: String?
                var nonOptional: Int = 0
            }
            
            @MutableLazyInject(graph: Self.graph) var subclass: Subclass
        }
        let mock = Mock()
        mock.$subclass.integer = 5
        mock.$subclass.string = "My String"
        mock.$subclass.nonOptional = 2
        XCTAssertEqual(mock.subclass.integer, 5)
        XCTAssertEqual(mock.subclass.string, "My String")
        XCTAssertEqual(mock.subclass.nonOptional, 2)
    }
}

extension InjectTests {
    
    public static var allTests = [
        ("testInject", testInject),
        ("testInjectNamedScope", testInjectNamedScope),
        ("testInjectArguments", testInjectArguments),
        ("testInjectGraph", testInjectGraph),
        ("testMutableInject", testMutableInject),
        ("testMutableInjectNamedScope", testMutableInjectNamedScope),
        ("testMutableInjectArguments", testMutableInjectArguments),
        ("testMutableInjectGraph", testMutableInjectGraph),
        ("testMutableInjectIsMutable", testMutableInjectIsMutable),
        ("testLazyInject", testLazyInject),
        ("testLazyInjectNamedScope", testLazyInjectNamedScope),
        ("testLazyInjectArguments", testLazyInjectArguments),
        ("testLazyInjectGraph", testLazyInjectGraph),
        ("testMutableLazyInject", testMutableLazyInject),
        ("testMutableLazyInjectNamedScope", testMutableLazyInjectNamedScope),
        ("testMutableLazyInjectArguments", testMutableLazyInjectArguments),
        ("testMutableLazyInjectGraph", testMutableLazyInjectGraph),
        ("testMutableLazyInjectIsMutable", testMutableLazyInjectIsMutable)
    ]
    
}
