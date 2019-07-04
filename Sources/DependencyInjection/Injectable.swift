//
//  Injectable.swift
//  DependencyInjection
//
//  Created by Richard Clements on 04/04/2019.
//  Copyright © 2019 colouroncode. All rights reserved.
//

import UIKit

/**
 The protocol for an injectable object. Must be a subclass of `NSObject`. All `UIViewController` classes conform to this protocol and are ready for injection, once the `injectionContainer` has been set.
 */
public protocol DependencyInjectable {
    
    associatedtype ObjectType: NSObject
    /**
     The container that the injectable should use to fetch injections
     */
    static var injectionContainer: DependencyInjectionContainer<ObjectType>? { get }
    
}

extension DependencyInjectable {
    
    /**
     Use this method to register an injection.
     - parameters:
         - injectable: The closure to use for injection
     
     ```
     UIViewController.registerInjectable {
         viewController, resolver in
         viewController.view.backgroundColor = resolve.resolve(UIColor.self, name: "background") ?? .blue
     }
     ```
     */
    public static func registerInjectable(_ injectable: @escaping (Self, InjectionContainer) -> Void) {
        let type = self as! ObjectType.Type
        injectionContainer?.register(type) {
            container, item in
            injectable(item as! Self, container)
        }
    }
    
    /**
     Use this method to inject an instance with injectable registrations.
     */
    public func inject() throws {
        guard let injectionContainer = type(of: self).injectionContainer else {
            throw InjectionError.notInjectable
        }
        try injectionContainer.inject(self as AnyObject)
    }
    
}

/**
 Subclass of NSObject, conforming to `DependencyInjectable`. Use this as the parent class for simple injectable objects.
 */
open class InjectableObject: NSObject, DependencyInjectable {
    
    public static var injectionContainer: DependencyInjectionContainer<InjectableObject>?
    
    public override init() {
        super.init()
        try? inject()
    }
    
}

extension UIViewController: DependencyInjectable {
    
    private static var hasSwizzled = false
    public static var injectionContainer: DependencyInjectionContainer<UIViewController>? {
        didSet {
            di_swizzle()
        }
    }
    
    class func swizzle(_ originalSelector: Selector, _ swizzledSelector: Selector) {
        if let originalMethod = class_getInstanceMethod(self, originalSelector), let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    class func di_swizzle() {
        guard !hasSwizzled else {
            return
        }
        
        swizzle(#selector(UIViewController.viewDidLoad), #selector(UIViewController.di_viewDidLoad))
        swizzle(#selector(UIViewController.awakeFromNib), #selector(UIViewController.di_awakeFromNib))
        
        hasSwizzled = true
    }
    
    private static var injectionField = UInt8(0)
    
    var hasInjected: Bool {
        get {
            let value: NSNumber? = associatedObject(base: self, key: &type(of: self).injectionField)
            return value?.boolValue ?? false
        }
        set {
            associateObject(base: self, key: &type(of: self).injectionField, value: NSNumber(value: newValue))
        }
    }
    
    @objc private func di_viewDidLoad() {
        if !hasInjected {
            try? inject()
            hasInjected = true
        }
        di_viewDidLoad()
    }
    
    @objc private func di_awakeFromNib() {
        if !hasInjected {
            try? inject()
            hasInjected = true
        }
        di_awakeFromNib()
    }
    
}

enum InjectionError: Error {
    case invalidClass(AnyClass, AnyClass)
    case notInjectable
}

public struct InjectionMode {
    
    let rawValue: String
    
}

extension InjectionMode {
    static let initial = InjectionMode(rawValue: "initial")
}

extension InjectionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidClass(let class1, let class2):
            return "Class \(class1.description()) is not a subclass of \(class2.description())"
        case .notInjectable:
            return "Not injectable"
        }
    }
}

/**
 Instances of this class are containers for injectable objects. Initialising all `DependencyInjectionContainer` instances with the same `InjectionContainer` will ensure that the same registrations are used across the app.
 */
public class DependencyInjectionContainer<T: AnyObject> {
    
    let container: InjectionContainer
    
    /**
     Initialiser
     
     - parameters:
        - container: The `InjectionContainer` from which injectable objects should resolve their registrations. Only use different containers between different `DependencyInjectionContainer` if you need a separate set of registrations.
     */
    public init(container: InjectionContainer) {
        self.container = container
    }
    
    fileprivate class DependencyInjection<T: AnyObject> {
        let type: String
        let dependencyInjection: (InjectionContainer, T) -> Void
        
        init(type: String, dependencyInjection: @escaping (InjectionContainer, T) -> Void) {
            self.type = type
            self.dependencyInjection = dependencyInjection
        }
    }
    
    private var dependencyInjections = [DependencyInjection<T>]()
    
    public func register<U: AnyObject>(_ type: U.Type, injection: @escaping (InjectionContainer, U) -> Void) {
        let dependencyInjection = DependencyInjection<T>(type: NSStringFromClass(type)) {
            container, item in
            let item = item as! U
            injection(container, item)
        }
        dependencyInjections.append(dependencyInjection)
    }
    
    public func resolve<U: AnyObject>(_ type: U.Type, withMode mode: InjectionMode?) -> ((InjectionContainer, U) -> Void)? {
        if let injection = (dependencyInjections.filter { $0.type == NSStringFromClass(type) }).first?.dependencyInjection {
            let auditedClosure: (InjectionContainer, U) -> Void = {
                container, u in
                let u = u as! T
                injection(container, u)
            }
            return auditedClosure
        }
        
        return nil
    }
    
    private func resolveParentInjections<U: AnyObject>(_ type: U.Type, withMode mode: InjectionMode? = nil) -> [((InjectionContainer, T) -> Void)] {
        var allDependencyInjections = [((InjectionContainer, T) -> Void)]()
        
        guard let aClass = NSClassFromString(NSStringFromClass(type)) else {
            return []
        }
        
        if aClass.superclass()?.isSubclass(of: T.self) == true {
            if let dependencyInjection = (dependencyInjections.filter { $0.type == NSStringFromClass(aClass.superclass()!) }).first?.dependencyInjection {
                allDependencyInjections.append(dependencyInjection)
            }
            
            allDependencyInjections.append(contentsOf: resolveParentInjections(aClass.superclass() as! T.Type, withMode: mode))
        }
        
        return allDependencyInjections
    }
    
    func inject<U: AnyObject>(_ item: U, withMode mode: InjectionMode? = nil) throws {
        if let item = item as? T {
            let parentInjections = resolveParentInjections(type(of: item), withMode: mode).reversed()
            for injection in parentInjections {
                injection(self.container, item)
            }
        } else {
            throw InjectionError.invalidClass(U.self, T.self)
        }
        
        resolve(type(of: item), withMode: mode)?(self.container, item)
    }
    
}
