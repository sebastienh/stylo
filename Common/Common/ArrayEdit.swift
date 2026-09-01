//
//  ArrayEdit.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-01-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public enum ArrayEdit<T: Equatable>: Equatable {
    
    case add(index: Int, value: T)
    case delete(index: Int)
    case replace(index: Int, value: T)
    
    public static func ==(lhs: ArrayEdit, rhs: ArrayEdit) -> Bool {
        
        switch (lhs, rhs) {
        case (.add(let index, let value), .add(let index2, let value2)):
            if index != index2 || value != value2 {
                return false
            }
        case (.delete(let index), .delete(let index2)):
            if index != index2 {
                return false
            }
        case (.replace(let index, let value), .replace(let index2, let value2)):
            if index != index2 || value != value2 {
                return false
            }
        default:
            return false
        }
        return true
    }
    
    var value: T? {
        switch self {
        case .add(_, let value):
            return value
        case .delete:
            return nil
        case .replace(_, let value):
            return value
        }
    }
    
    var isAdd: Bool {
        
        switch self {
        case .add:
            return true
        default:
            return false
        }
    }
    
    var isDelete: Bool {
        
        switch self {
        case .delete(let index):
            return true
        default:
            return false
        }
    }
    
    var index: Int {
        switch self {
            
        case .add(let index, _):
            return index
        case .delete(let index):
            return index
        case .replace(let index, _):
            return index
        }
        
    }
    
}

extension ArrayEdit: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .add(let index, let value):
            return ".add: \(index), value: \(value)"
        case .delete(let index):
            return ".delete: \(index)"
        case .replace(let index, let value):
            return ".replace: \(index), value: \(value)"
        }
    }
}
