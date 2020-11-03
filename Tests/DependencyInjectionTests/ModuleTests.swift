//
//  ModuleTests.swift
//  
//
//  Created by Richard Clements on 06/08/2020.
//

import XCTest
@testable import DependencyInjection

public class ModuleTests: XCTestCase {
    
    func testEraseToAnyModule() {
        struct MockModule: Module {
            func module(with graph: Graph, arguments: [CVarArg]) -> String {
                "My String"
            }
        }
        
        let module = MockModule()
        let erasedModule = module.eraseToAnyDependencyModule()
        XCTAssertTrue(erasedModule.resolves(type: String.self, with: .new))
        XCTAssertEqual(erasedModule.perform(with: Graph(dependencies: []), arguments: []), "My String")
    }
    
}

public class IndependentGraphModuleTests: XCTestCase {
    
    func testModule() {
        let module = IndependentGraphModule {
            "My String"
        }
        XCTAssertEqual(module.module(with: Graph(dependencies: []), arguments: []), "My String")
    }
    
}

public class GraphModuleTests: XCTestCase {
    
    func testModule_dependency() {
        let module = GraphModule<String> { (graph: Graph, arguments: [CVarArg]) in
            let integer: Int = graph.resolve() ?? 0
            return "My String: \(integer)"
        }
        let graph = Graph(dependencies: [
            Dependency { 5 }
        ])
        XCTAssertEqual(module.module(with: graph, arguments: []), "My String: 5")
    }
    
    func testModule_arguments() {
        let module = GraphModule<String> { (graph: Graph, arguments: [CVarArg]) in
            let integer: Int = arguments[0] as! Int
            return "My String: \(integer)"
        }
        XCTAssertEqual(module.module(with: Graph(dependencies: []), arguments: [5]), "My String: 5")
    }
    
}

extension ModuleTests {
    
    public static var allTests = [
        ("testEraseToAnyModule", testEraseToAnyModule)
    ]
    
}

extension IndependentGraphModuleTests {
    
    public static var allTests = [
        ("testModule", testModule)
    ]
    
}

extension GraphModuleTests {
    
    public static var allTests = [
        ("testModule_dependency", testModule_dependency),
        ("testModule_arguments", testModule_arguments)
    ]
    
}
