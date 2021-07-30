import Foundation

#if swift(>=5.4)
@resultBuilder
public struct GraphBuilder {
    
    public static func buildBlock(_ components: PartialGraph...) -> PartialGraph {
        Graph(dependencies: components.flatMap { $0.dependencies })
    }
    
    public static func buildBlock(_ component: PartialGraph) -> PartialGraph {
        component
    }
    
    public static func buildIf(_ component: PartialGraph?) -> PartialGraph {
        Graph(dependencies: component?.dependencies ?? [])
    }
    
    public static func buildEither(first: PartialGraph) -> PartialGraph {
        first
    }
    
    public static func buildEither(second: PartialGraph) -> PartialGraph {
        second
    }
    
}
#else
@_functionBuilder
public struct GraphBuilder {
    
    public static func buildBlock(_ components: PartialGraph...) -> PartialGraph {
        Graph(dependencies: components.flatMap { $0.dependencies })
    }
    
    public static func buildBlock(_ component: PartialGraph) -> PartialGraph {
        component
    }
    
    public static func buildIf(_ component: PartialGraph?) -> PartialGraph {
        Graph(dependencies: component?.dependencies ?? [])
    }
    
    public static func buildEither(first: PartialGraph) -> PartialGraph {
        first
    }
    
    public static func buildEither(second: PartialGraph) -> PartialGraph {
        second
    }
    
}

#endif
