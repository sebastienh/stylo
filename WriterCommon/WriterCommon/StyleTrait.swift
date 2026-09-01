//
//  StyleTrait.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-12-13.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Common

/// A style trait define the specific caracteristics of
/// a style to apply.
public enum StyleTrait: Equatable, Comparable {
    
    public static func < (lhs: StyleTrait, rhs: StyleTrait) -> Bool {
        switch (lhs, rhs) {
        case (.source, _):
            return true
        case (.error(let messageId1), .error(let messageId2)):
            return messageId1 < messageId2
        case (.errors, _):
            return true
        case (.error, .source):
            return false
        case (.error, .errors):
            return true
        }
    }
    
    case source
    case error(messageId: String)
    case errors
    
    var key: String {
        switch self {
        case .source: return "source"
        case .error(let messageId): return "error:\(messageId))"
        case .errors: return "errors"
        }
    }
    
    static func from(key: String) -> StyleTrait? {
        
        switch key {
        case "source":
            return .source
        default:
            return nil
        }
    }
    
}
