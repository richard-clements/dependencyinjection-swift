//
//  File.swift
//  
//
//  Created by Richard Clements on 05/08/2019.
//

import Foundation

class DependencyInjectionManager {
    
    init(container: InjectionContainer = .default) {
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
        
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
        let actualClassCount: Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        
        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            if let currentClass: AnyClass = allClasses[Int(i)] {
                classes.append(currentClass)
            }
        }
        
        let dependencyInjectionModules = classes.filter { class_getSuperclass($0) != nil }.compactMap { $0 as? DependencyInjectionModule.Type }
        for module in dependencyInjectionModules {
            module.init(container: container)?.setUp()
        }
        
        allClasses.deallocate()
    }
    
}
