import Foundation

protocol Module {

    associatedtype ResultType

    func module(with graph: Graph, arguments: [CVarArg]) -> ResultType

}

struct AnyModule {

    typealias Handler<ResultType> = (Graph, [CVarArg]) -> ResultType?

    let handler: Any
    let scope: Scope
    
    private init(handler: Any, scope: Scope) {
        self.handler = handler
        self.scope = scope
    }

    init<T: Module>(module: T) {
        let handler: Handler<T.ResultType> = { (graph: Graph, arguments: [CVarArg]) in
            return module.module(with: graph, arguments: arguments)
        }
        self.handler = handler
        self.scope = .new
    }
    
    func resolves<ResultType>(type: ResultType.Type, with scope: Scope?) -> Bool {
        guard self.handler as? Handler<ResultType> != nil else {
            return false
        }
        if case .named(_) = scope {
            return scope == self.scope
        } else if case .named(_) = self.scope {
            return false
        }
        return true
    }

    func perform<ResultType>(with graph: Graph, arguments: [CVarArg]) -> ResultType? {
        let handler = self.handler as? Handler<ResultType>
        return handler?(graph, arguments)
    }

    func withScope(_ scope: Scope) -> AnyModule {
        AnyModule(handler: handler, scope: scope)
    }
}

struct GraphModule<T>: Module {

    let resolver: (Graph, [CVarArg]) -> T
    
    init(resolver: @escaping (Graph, [CVarArg]) -> T) {
        self.resolver = resolver
    }

    func module(with graph: Graph, arguments: [CVarArg]) -> T {
        resolver(graph, arguments)
    }

}

struct IndependentGraphModule<T>: Module {

    let resolver: () -> T
    
    init(resolver: @escaping () -> T) {
        self.resolver = resolver
    }

    func module(with graph: Graph, arguments: [CVarArg]) -> T {
        resolver()
    }

}

extension Module {
    
    func eraseToAnyDependencyModule() -> AnyModule {
        return AnyModule(module: self)
    }
    
}
