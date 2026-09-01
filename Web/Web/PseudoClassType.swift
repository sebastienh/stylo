//
//  PseudoClassType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-11.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

enum PseudoClassType : String {
    
    case active
    case checked
    case `default`
    case dir
    case disabled
    case empty
    case enabled
    case first
    case firstChild = "first-child"
    case firstOfType = "first-of-type"
    case fullscreen
    case flash
    case fade
    case focus
    case highlight
    case hover
    case indeterminate
    case inRange =  "in-range"
    case invalid
    case lang
    case lastChild = "last-child"
    case lastOfType = "last-of-type"
    case left = "left"
    case link = "link"
    case not = "not"
    case nthChild = "nth-child"
    case nthLastChild = "nth-last-child"
    case nthLastOfType = "nth-last-of-type"
    case nthOfType = "nth-of-type"
    case onlyChild = "only-child"
    case onlyOfType = "only-of-type"
    case optional = "optional"
    case outOfRange = "out-of-range"
    case readOnly = "read-only"
    case readWrite = "read-write"
    case required = "required"
    case right = "right"
    case root = "root"
    case scope = "scope"
    case target = "target"
    case valid = "valid"
    case visited = "visited"
    case unsupported = "Unsupported"
    
    static func supportedPseudoClassType(_ stringValue: String) -> PseudoClassType {
        if let supportedValue = PseudoClassType(rawValue: stringValue) {
            return supportedValue
        }
        return unsupported
    }
}
