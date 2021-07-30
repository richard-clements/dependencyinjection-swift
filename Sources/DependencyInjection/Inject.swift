import Foundation

@propertyWrapper
public class Inject<T> {
    var _wrappedValue: T
    public init(name: Scope.Name? = nil, graph: Graph = .default, arguments: CVarArg...) {
        if let name = name {
            _wrappedValue = graph.argumentsResolver(scope: name, with: arguments)!
        } else {
            _wrappedValue = graph.argumentsResolver(with: arguments)!
        }
    }
    
    public init(name: Scope.Name? = nil, graph: Graph = .default) {
        if let name = name {
            _wrappedValue = graph.resolve(scope: name)!
        } else {
            _wrappedValue = graph.resolve()!
        }
    }
    
    public var wrappedValue: T {
        _wrappedValue
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

@propertyWrapper
public class MutableInject<T>: Inject<T> {
    public override var wrappedValue: T {
        get {
            super.wrappedValue
        }
        set {
            _wrappedValue = newValue
        }
    }
}

@propertyWrapper
public class MutableLazyInject<T>: LazyInject<T> {
    public override var wrappedValue: T {
        get {
            super.wrappedValue
        }
        set {
            _wrappedValue = newValue
        }
    }
}
