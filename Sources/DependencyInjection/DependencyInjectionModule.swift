//
//  DependencyInjection.swift
//  DependencyInjection
//
//  Created by Richard Clements on 04/04/2019.
//  Copyright © 2019 colouroncode. All rights reserved.
//

import Foundation

/**
 Dependency Injection base module. Subclass this to create modules for injection
 */
open class DependencyInjectionModule: NSObject {
    
    public let container: InjectionContainer
    
    open class func isContainerAllowed(_ container: InjectionContainer) -> Bool {
        return true
    }
    
    public required init?(container: InjectionContainer = .default) {
        guard Self.isContainerAllowed(container) else {
            return nil
        }
        self.container = container
        super.init()
    }
    
    open func setUp() { }
}
