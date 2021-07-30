import Foundation

public enum Scope {
    
    public struct Name: Hashable, ExpressibleByStringLiteral {
        
        let rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: StringLiteralType) {
            self.rawValue = value
        }
        
    }
    
    case new
    case named(Name)
    case singleInstance
}

extension Scope: Equatable {
    public static func == (lhs: Scope, rhs: Scope) -> Bool {
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
