//
//  AttributesOperations.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-09-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public struct AttributesOperations: Equatable {
    
    public var addedAttributes: [AttributesRange]
    
    public var setAttributes: [AttributesRange]
    
    public var deletedAttributes: [AttributesRange]
    
    public init() {
        
        self.addedAttributes = [AttributesRange]()
        self.setAttributes = [AttributesRange]()
        self.deletedAttributes = [AttributesRange]()
    }
    
    public static func == (lhs: AttributesOperations, rhs: AttributesOperations) -> Bool {
        
        if lhs.addedAttributes != rhs.addedAttributes {
            return false
        }
        if lhs.setAttributes != rhs.setAttributes {
            return false
        }
        if lhs.deletedAttributes != rhs.deletedAttributes {
            return false
        }
        return true
    }
}
