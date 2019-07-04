//
//  DependencyInjectionTests.swift
//  DependencyInjectionTests
//
//  Created by Richard Clements on 04/04/2019.
//  Copyright © 2019 colouroncode. All rights reserved.
//

import XCTest
@testable import DependencyInjection

class MockInjectable: NSObject, DependencyInjectable {
    
    static var injectionContainer: DependencyInjectionContainer<MockInjectable>?
    
    var someString: String?
    
    override init() {
        super.init()
        do {
            try type(of: self).injectionContainer?.inject(self)
        } catch {
            print(error)
        }
    }
    
}

class MockInjectableItem: InjectableObject {
    
    var something: String?
    
}

class MockViewController: UIViewController {
    
    var something: String?
    
}

class InjectableTests: XCTestCase {
    
    var container: InjectionContainer!
    
    override func setUp() {
        container = InjectionContainer()
        MockInjectable.injectionContainer = DependencyInjectionContainer<MockInjectable>(container: container)
        InjectableObject.injectionContainer = DependencyInjectionContainer<InjectableObject>(container: container)
        UIViewController.injectionContainer = DependencyInjectionContainer<UIViewController>(container: container)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        container = nil
        MockInjectable.injectionContainer = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_newInstance_resolvesFromContainer() {
        container.register(String.self, mode: .alwaysNew) {
            resolver in
            return "Test"
        }
        
        MockInjectable.registerInjectable {
            object, resolver in
            object.someString = resolver.resolve(String.self)
        }
        
        let object = MockInjectable()
        XCTAssertEqual(object.someString, "Test")
    }
    
    func test_inject_injectableObject() {
        container.register(String.self, mode: .alwaysNew) {
            resolver in
            return "Test"
        }
        
        MockInjectableItem.registerInjectable {
            object, resolver in
            object.something = resolver.resolve(String.self)
        }
        
        let object = MockInjectableItem()
        XCTAssertEqual(object.something, "Test")
    }
    
    func test_inject_viewController_viewDidLoad() {
        container.register(String.self, mode: .alwaysNew) {
            resolver in
            return "Test"
        }
        
        MockViewController.registerInjectable {
            object, resolver in
            object.something = resolver.resolve(String.self)
        }
        
        let vc = MockViewController()
        vc.viewDidLoad()
        XCTAssertEqual(vc.something, "Test")
    }
    
    func test_inject_viewController_awakeFromNib() {
        container.register(String.self, mode: .alwaysNew) {
            resolver in
            return "Test"
        }
        
        MockViewController.registerInjectable {
            object, resolver in
            object.something = resolver.resolve(String.self)
        }
        
        let vc = MockViewController()
        vc.awakeFromNib()
        XCTAssertEqual(vc.something, "Test")
    }
    
    static var allTests = [
        ("test_newInstance_resolvesFromContainer", test_newInstance_resolvesFromContainer),
        ("test_inject_injectableObject", test_inject_injectableObject),
        ("test_inject_viewController_viewDidLoad", test_inject_viewController_viewDidLoad),
        ("test_inject_viewController_awakeFromNib", test_inject_viewController_awakeFromNib),
    ]
}
