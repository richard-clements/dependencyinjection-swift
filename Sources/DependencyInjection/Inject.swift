//
//  File.swift
//  
//
//  Created by Richard Clements on 06/08/2020.
//

import Foundation

@propertyWrapper
struct Inject<T> {
    var wrappedValue: T
    init(name: Scope.Name? = nil, graph: Graph = .default, arguments: CVarArg...) {
        if let name = name {
            wrappedValue = graph.argumentsResolver(scope: name, with: arguments)!
        } else {
            wrappedValue = graph.argumentsResolver(with: arguments)!
        }
    }
    
    init(name: Scope.Name? = nil, graph: Graph = .default) {
        if let name = name {
            wrappedValue = graph.resolve(scope: name)!
        } else {
            wrappedValue = graph.resolve()!
        }
    }
}
