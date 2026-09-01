//
//  AttributesBlocsChange.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-13.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public enum AttributesBlocsChange {
    
    case all
    case modified(attributes: Set<Attribute>)
    case none
    
    var isNone: Bool {
        
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
    
    var isAll: Bool {
        
        switch self {
        case .all:
            return true
        default:
            return false
        }
    }
    
    var isModified: Bool {
        
        switch self {
        case .modified(_):
            return true
        default:
            return false
        }
    }
    
    var modifiedCount: Int? {
        
        switch self {
        case .modified(let attributes):
            return attributes.count
        default:
            return nil
        }
    }
}
