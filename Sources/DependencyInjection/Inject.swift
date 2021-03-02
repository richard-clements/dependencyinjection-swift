//
//  File.swift
//  
//
//  Created by Richard Clements on 06/08/2020.
//

import Foundation

@propertyWrapper
public struct Inject<T> {
    public var wrappedValue: T
    public init(name: Scope.Name? = nil, graph: Graph = .default, arguments: CVarArg...) {
        if let name = name {
            wrappedValue = graph.argumentsResolver(scope: name, with: arguments)!
        } else {
            wrappedValue = graph.argumentsResolver(with: arguments)!
        }
    }
    
    public init(name: Scope.Name? = nil, graph: Graph = .default) {
        if let name = name {
            wrappedValue = graph.resolve(scope: name)!
        } else {
            wrappedValue = graph.resolve()!
        }
    }
}

@propertyWrapper
public class LazyInject<T> {
    var _wrappedValue: T?
    
    private var name: Scope.Name?
    private var graphResolver: () -> Graph
    private var arguments: [CVarArg]?
    
    public init(name: Scope.Name? = nil, graph: @escaping @autoclosure () -> Graph = .default, arguments: CVarArg...) {
        self.name = name
        self.graphResolver = graph
        self.arguments = arguments
    }
    
    public init(name: Scope.Name? = nil, graph: @escaping @autoclosure () -> Graph = .default) {
        self.name = name
        self.graphResolver = graph
        self.arguments = nil
    }
    
    func resolveValue() -> T {
        if let name = name, let arguments = arguments {
            return graphResolver().argumentsResolver(scope: name, with: arguments)!
        } else if let arguments = arguments {
            return graphResolver().argumentsResolver(with: arguments)!
        } else if let name = name {
            return graphResolver().resolve(scope: name)!
        } else {
            return graphResolver().resolve()!
        }
    }
    
    public var wrappedValue: T {
        if _wrappedValue == nil {
            _wrappedValue = resolveValue()
        }
        return _wrappedValue!
    }
}
