//
//  File.swift
//  
//
//  Created by Richard Clements on 06/08/2020.
//

import Foundation

public struct Graph {
    
    public let dependencies: [Item]
    private let identifier = UUID()
    
    init(dependencies: [Item]) {
        self.dependencies = dependencies
    }
    
    private func resolve<T>(scope: Scope, with arguments: [CVarArg] = []) -> T? {
        guard let dependency = dependencies.first(where: { $0.resolves(type: T.self, with: scope) }) else {
            return nil
        }
        if let value: T = Self.resolve(scope: dependency.scope, for: identifier, arguments: arguments) {
            return value
        }
        guard let value: T = dependency.resolve(with: self, arguments: arguments) else {
            return nil
        }
        Self.store(object: value, with: dependency.scope, forIdentifier: identifier, arguments: arguments)
        return value
    }
    
    func argumentsResolver<T>(with arguments: [CVarArg]) -> T? {
        resolve(scope: .new, with: arguments)
    }
    
    func argumentsResolver<T>(scope: Scope.Name, with arguments: [CVarArg] = []) -> T? {
        Self.resolve(scope: .named(scope), for: identifier, arguments: arguments) ?? resolve(scope: .named(scope), with: arguments)
    }
    
    public func resolve<T>() -> T? {
        resolve(scope: .new, with: [])
    }
    
    public func resolve<T>(arguments: CVarArg...) -> T? {
        resolve(scope: .new, with: arguments)
    }
    
    public func resolve<T>(scope: Scope.Name, arguments: CVarArg...) -> T? {
        Self.resolve(scope: .named(scope), for: identifier, arguments: arguments) ?? resolve(scope: .named(scope), with: arguments)
    }
    
    public func resolve<T>(named name: Scope.Name) -> T? {
        Self.resolve(scope: .named(name), for: identifier, arguments: []) ?? resolve(scope: .named(name), with: [])
    }
    
}

extension Graph {
    
    static var storedDependencies = [UUID: [String: Any]]()
    
    static func scopeName(for scope: Scope) -> String {
        switch scope {
        case .new:
            return ""
        case .named(let scopeName):
            return "{NamedScope_\(scopeName)}"
        case .singleInstance:
            return "{SingleInstance}"
        }
    }
    
    static func argumentsName(for arguments: [CVarArg]) -> String {
        String(describing: arguments)
    }
    
    static func objectIdentifierName<T>(for type: T.Type, with scope: Scope, arguments: [CVarArg]) -> String {
        return String(describing: T.self) + "_" + scopeName(for: scope) + "_" + argumentsName(for: arguments)
    }
    
    static func resolve<T>(scope: Scope, for identifier: UUID, arguments: [CVarArg]) -> T? {
        guard scope != .new else {
            return nil
        }
        guard let storedObjects = storedDependencies[identifier] else {
            return nil
        }
        let objectStoreName = objectIdentifierName(for: T.self, with: scope, arguments: arguments)
        return storedObjects[objectStoreName] as? T
    }
    
    static func store<T>(object: T, with scope: Scope, forIdentifier identifier: UUID, arguments: [CVarArg]) {
        guard scope != .new else {
            return
        }
        var storedObjects = storedDependencies[identifier] ?? [:]
        storedObjects[objectIdentifierName(for: T.self, with: scope, arguments: arguments)] = object
        storedDependencies[identifier] = storedObjects
    }
}

public protocol PartialGraph {
    var dependencies: [Item] { get }
}

extension Graph: PartialGraph { }

extension Graph {
    
    public init(@GraphBuilder builder: () -> PartialGraph) {
        self.init(dependencies: builder().dependencies)
    }
    
}

extension Graph {
    
    public static var `default`: Graph = Graph(dependencies: [])
    
    public static func initialise(builder: () -> PartialGraph) {
        self.default = .init(builder: builder)
    }
    
}
