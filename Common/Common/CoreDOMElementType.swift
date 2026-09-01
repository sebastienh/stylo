//
//  DOMElementType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public enum CoreDOMElementType : String, ElementType {
    
    case All = "*"
    
    public var name: String {
        
        return self.rawValue
    }
    
    public var hashValue: Int {
        
        get {
            return self.rawValue.hashValue
        }
    }
    
    public static func allValues() -> [ElementType] {
        
        return [CoreDOMElementType.All]
    }
    
}

public func ==(lhs: CoreDOMElementType, rhs: CoreDOMElementType) -> Bool {
    
    return lhs.rawValue == rhs.rawValue
}
