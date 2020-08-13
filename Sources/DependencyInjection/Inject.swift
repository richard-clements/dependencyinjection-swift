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
