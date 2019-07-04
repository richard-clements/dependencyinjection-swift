//
//  InjectionContainer.swift
//  DependencyInjection
//
//  Created by Richard Clements on 04/04/2019.
//  Copyright © 2019 colouroncode. All rights reserved.
//

import Foundation

/**
 Modes to use for each registered service
 */
public enum InjectionContainerMode {
    
    /**
     Always recreates the service when injecting an instance
     */
    case alwaysNew
    
    /**
     Keeps a reference to the service after intial injection. Subsequent injections will use the same instance of the service.
     */
    case useContainer
    
}

typealias FunctionType = Any

class Injection {
    
    let mode: InjectionContainerMode
    let resolver: FunctionType
    
    init(mode: InjectionContainerMode, resolver: FunctionType) {
        self.mode = mode
        self.resolver = resolver
    }
    
}

/**
 `InjectionContainer` contains all registered services to be passed to `DependencyInjectionContainer`.
 */
public class InjectionContainer {
    
    /**
     Used to name registrations on the injection container. Using different keys will use a different registration.
     */
    public struct Key: ExpressibleByStringLiteral {
        
        public typealias StringLiteralType = String
        
        let rawValue: String
        
        public init(stringLiteral value: String) {
            self.rawValue = value
        }
        
    }
    
    public init() {
        
    }
    
    private var registrations = [String: Injection]()
    private var savedValues = [String: Any]()
    
    private func name<T: Any>(forService service: T.Type, name: String?) -> String {
        if let name = name {
            return String(describing: service) + "-" + name
        } else {
            return String(describing: service) + #"/\"#
        }
    }
    
    /**
     Method for registering services to the container.
     
     - parameters:
         - service: The type of service to be registered
         - name: The name of this registration. Can be nil.
         - mode: The mode to use for this registration
         - resolver: The closure describing the result of resolving the registration. Should return the instance of the service to use.
     */
    public func register<T: Any>(_ service: T.Type, name: Key? = nil, mode: InjectionContainerMode, resolver: @escaping (InjectionContainer) -> T) {
        let usedName = self.name(forService: service, name: name?.rawValue)
        let injection = Injection(mode: mode, resolver: resolver)
        registrations[usedName] = injection
    }
    
    /**
     Method for resolving instances of services from the container.
     
     - parameters:
         - service: The type of service to be resolved
         - name: The name of the registration to resolve. Can be nil
     
     - returns:
         The instance of the service to be used. Will be nil if no registrations have been made
     */
    public func resolve<T: Any>(_ service: T.Type, name: Key? = nil) -> T? {
        let usedName = self.name(forService: service, name: name?.rawValue)
        guard let registration = registrations[usedName] else {
            return nil
        }
        
        if registration.mode == .useContainer, let savedValue = savedValues[usedName] as? T {
            return savedValue
        }
        
        let resolver = registration.resolver as! (InjectionContainer) -> T
        
        let value = resolver(self)
        
        if registration.mode == .useContainer {
            savedValues[usedName] = value
        }
        
        return value
    }
}
