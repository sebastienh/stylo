//
//  SetEdit.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-01-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public enum SetEdit<T: Hashable>: Hashable {
    
    case add(value: T)
    case delete(value: T)
    
    public static func ==(lhs: SetEdit, rhs: SetEdit) -> Bool {
        switch (lhs, rhs) {
        case (.add(let value), .add(let value2)):
            if value != value2 {
                return false
            }
        case (.delete(let value), .delete(let value2)):
            if value != value2 {
                return false
            }
        default:
            return false
        }
        return true
    }
}
