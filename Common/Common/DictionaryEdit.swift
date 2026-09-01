//
//  DictionaryEdit.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-07-06.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
//
//  ArrayEdit.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-01-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public enum DictionaryEdit<Key: Hashable, Value>: Equatable {
    
    case add(index: Int, key: Key, value: Value)
    case delete(index: Int)
    
    public static func ==(lhs: DictionaryEdit, rhs: DictionaryEdit) -> Bool {
        
        switch (lhs, rhs) {
        case (.add(let index, let key, _), .add(let index2, let key2, _)):
            if index != index2 || key != key2 {
                return false
            }
        case (.delete(let index), .delete(let index2)):
            if index != index2 {
                return false
            }
        default:
            return false
        }
        return true
    }
    
    var value: Value? {
        switch self {
        case .add(_, _, let value):
            return value
        case .delete(_):
            return nil
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
        case .delete:
            return true
        default:
            return false
        }
    }
    
    var index: Int {
        switch self {
        case .add(let index, _, _):
            return index
        case .delete(let index):
            return index
        }
    }
}

extension DictionaryEdit: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .add(let index, let key, let value):
            return ".add: \(index), key: \(key), value: \(value)"
        case .delete(let index):
            return ".delete: \(index)"
        }
    }
}
