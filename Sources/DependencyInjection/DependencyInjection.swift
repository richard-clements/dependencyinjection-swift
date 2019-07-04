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
open class DependencyInjection {
    
    public let container: InjectionContainer
    
    public required init(container: InjectionContainer) {
        self.container = container
    }
    
    open func setUp() { }
}
