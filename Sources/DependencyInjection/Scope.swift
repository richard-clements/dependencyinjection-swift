//
//  File.swift
//  
//
//  Created by Richard Clements on 06/08/2020.
//

import Foundation

enum Scope {
    
    struct Name: Hashable, ExpressibleByStringLiteral {
        
        let rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        init(stringLiteral value: StringLiteralType) {
            self.rawValue = value
        }
        
    }
    
    case new
    case named(Name)
    case singleInstance
}

extension Scope: Equatable {
    static func == (lhs: Scope, rhs: Scope) -> Bool {
        if case .new = lhs, case .new = rhs {
            return true
        } else if case .named(let lhsName) = lhs, case .named(let rhsName) = rhs {
            return lhsName == rhsName
        } else if case .singleInstance = lhs, case .singleInstance = rhs {
            return true
        }
        return false
    }
}
