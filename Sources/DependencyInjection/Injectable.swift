//
//  Injectable.swift
//  DependencyInjection
//
//  Created by Richard Clements on 04/04/2019.
//  Copyright © 2019 colouroncode. All rights reserved.
//
import Foundation

@propertyWrapper
public struct Inject<Value> {
    
    public var wrappedValue: Value?
    
    public init(name: InjectionContainer.Key?, container: InjectionContainer) {
        wrappedValue = container.resolve(Value.self, name: name)
    }
    
    public init(container: InjectionContainer) {
        self.init(name: nil, container: container)
    }
    
    public init(name: InjectionContainer.Key?) {
        self.init(name: name, container: .default)
    }
    
    public init() {
        self.init(name: nil, container: .default)
    }
    
}
