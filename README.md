# Dependency Injection

### Initialising a Graph

Graphs are built using closure syntax.

```
let graph = Graph {
    Dependency(for: SomeProtocol.self) { graph, args in 
        SomeConcrete(dependency: graph.resolve(), argument: args[0] as! Int)
    }
}
```

Dependencies can be declared also in closure syntax with the graph and added arguments as inputs to the closure.
```
Dependency(for: SomeProtocol.self) { graph, args in 
    SomeConcrete(dependency: graph.resolve(), argument: args[0] as! Int)
}
```

It's also possible to declare a very simple dependency with an autoclosure. These dependencies can not take an input.
```
Dependency(for: SomeProtocol.self, resolver: SomeConcrete())
Dependency(SomeConcrete())
```

### Scopes
There are multiple scopes available.

| Scope | Result |
| :-----: | ------ |
| `new` | Returns a new instance of the dependency each time. |
| `name(Name)` | Matches dependency based on `Name`. Will store the dependency and return this intance, if the name matches when resolving. |
| `singleInstance` | Stores the instance and will return whenever the dependency is resolved, unless there are stricter matches on the name. |

To define a scope, use `withScope`. If no scope is given, then `new` is the default value.

```
Dependency(SomeConcrete1()).withScope(.new)
Dependency(SomeConcrete2()).withScope(.named("A Name"))
Dependency(SomeConcrete3()).withScope(.singleInstance)
```

### Injecting

To inject a value outside of graph dependencies, use `@Inject`.

```
class SomeClass {
    @Inject(name: "A Name", graph: aGraph, arguments: 1, 2, 3) var value: Int
}
```

All paramaters of `@Inject` are optional. If the graph parameter is not passed, the default single value instance will be used.

### Initialising Default Graph

To initialise the default single value instance graph use `Graph.initialise`. The initialise method uses the same closure style as the `Graph.init` method.

```
Graph.initialise {
    Dependency(for: SomeProtocol.self) { graph, args in 
        SomeConcrete(dependency: graph.resolve(), argument: args[0] as! Int)
    }
}
```

To get the single instance of `Graph`, use `Graph.default`.
