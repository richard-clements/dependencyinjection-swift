//
//  File.swift
//  
//
//  Created by Richard Clements on 06/08/2020.
//

import Foundation


public protocol Item {
    
    var scope: Scope { get }
    func resolve<T>(with graph: Graph, arguments: [CVarArg]) -> T?
    func resolves<T>(type: T.Type, with scope: Scope) -> Bool
    
}

public struct Dependency: Item {

    let module: AnyModule
    
    private init(module: AnyModule) {
        self.module = module
    }

    public init<T>(for type: T.Type, resolver: @escaping (Graph, [CVarArg]) -> T) {
        module = GraphModule(resolver: { (graph: Graph, arguments: [CVarArg]) in
            resolver(graph, arguments)
        }).eraseToAnyDependencyModule()
    }

    public init<T>(for type: T.Type, resolver: @escaping (Graph) -> T) {
        module = GraphModule(resolver: { (graph: Graph, arguments: [CVarArg]) in
            resolver(graph)
        }).eraseToAnyDependencyModule()
    }

    public init<T>(for type: T.Type, resolver: @escaping () -> T) {
        module = IndependentGraphModule(resolver: resolver).eraseToAnyDependencyModule()
    }

    public init<T>(for type: T.Type, resolver: @autoclosure @escaping () -> T) {
        module = IndependentGraphModule(resolver: resolver).eraseToAnyDependencyModule()
    }

    public init<T>(_ resolver: @escaping (Graph, [CVarArg]) -> T) {
        module = GraphModule(resolver: { (graph: Graph, arguments: [CVarArg]) in
            resolver(graph, arguments)
        }).eraseToAnyDependencyModule()
    }

    public init<T>(_ resolver: @escaping (Graph) -> T) {
        module = GraphModule(resolver: { (graph: Graph, arguments: [CVarArg]) in
            resolver(graph)
        }).eraseToAnyDependencyModule()
    }

    public init<T>(_ resolver: @escaping () -> T) {
        module = IndependentGraphModule(resolver: resolver).eraseToAnyDependencyModule()
    }

    public init<T>(_ resolver: @autoclosure @escaping () -> T) {
        module = IndependentGraphModule(resolver: resolver).eraseToAnyDependencyModule()
    }
    
    public var scope: Scope {
        return module.scope
    }
    
    public func resolves<T>(type: T.Type, with scope: Scope) -> Bool {
        return module.resolves(type: type, with: scope)
    }

    public func resolve<T>(with graph: Graph, arguments: [CVarArg]) -> T? {
        return module.perform(with: graph, arguments: arguments)
    }
    
    public func withScope(_ scope: Scope) -> Dependency {
        Dependency(module: module.withScope(scope))
    }

}

extension Dependency: PartialGraph {
    
    public var dependencies: [Item] {
        [self]
    }
    
}
