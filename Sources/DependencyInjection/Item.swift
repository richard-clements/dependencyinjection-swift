//
//  File.swift
//  
//
//  Created by Richard Clements on 06/08/2020.
//

import Foundation


protocol Item {
    
    var scope: Scope { get }
    func resolve<T>(with graph: Graph, arguments: [CVarArg]) -> T?
    func resolves<T>(type: T.Type, with scope: Scope) -> Bool
    
}

struct Dependency: Item {

    let module: AnyModule
    
    private init(module: AnyModule) {
        self.module = module
    }

    init<T>(for type: T.Type, resolver: @escaping (Graph, [CVarArg]) -> T) {
        module = GraphModule(resolver: { (graph: Graph, arguments: [CVarArg]) in
            resolver(graph, arguments)
        }).eraseToAnyDependencyModule()
    }

    init<T>(for type: T.Type, resolver: @escaping (Graph) -> T) {
        module = GraphModule(resolver: { (graph: Graph, arguments: [CVarArg]) in
            resolver(graph)
        }).eraseToAnyDependencyModule()
    }

    init<T>(for type: T.Type, resolver: @escaping () -> T) {
        module = IndependentGraphModule(resolver: resolver).eraseToAnyDependencyModule()
    }

    init<T>(for type: T.Type, resolver: @autoclosure @escaping () -> T) {
        module = IndependentGraphModule(resolver: resolver).eraseToAnyDependencyModule()
    }

    init<T>(_ resolver: @escaping (Graph, [CVarArg]) -> T) {
        module = GraphModule(resolver: { (graph: Graph, arguments: [CVarArg]) in
            resolver(graph, arguments)
        }).eraseToAnyDependencyModule()
    }

    init<T>(_ resolver: @escaping (Graph) -> T) {
        module = GraphModule(resolver: { (graph: Graph, arguments: [CVarArg]) in
            resolver(graph)
        }).eraseToAnyDependencyModule()
    }

    init<T>(_ resolver: @escaping () -> T) {
        module = IndependentGraphModule(resolver: resolver).eraseToAnyDependencyModule()
    }

    init<T>(_ resolver: @autoclosure @escaping () -> T) {
        module = IndependentGraphModule(resolver: resolver).eraseToAnyDependencyModule()
    }
    
    var scope: Scope {
        return module.scope
    }
    
    func resolves<T>(type: T.Type, with scope: Scope) -> Bool {
        return module.resolves(type: type, with: scope)
    }

    func resolve<T>(with graph: Graph, arguments: [CVarArg]) -> T? {
        return module.perform(with: graph, arguments: arguments)
    }
    
    func withScope(_ scope: Scope) -> Dependency {
        Dependency(module: module.withScope(scope))
    }

}

extension Dependency: PartialGraph {
    
    var dependencies: [Item] {
        [self]
    }
    
}
