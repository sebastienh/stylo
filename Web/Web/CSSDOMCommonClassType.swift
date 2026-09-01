//
//  CSSDOMClassType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-05.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

enum CSSDOMCommonClassType : String {
    
    case SelectorCombinator = "selector-combinator"
    case SimpleSelector = "simple-selector"
    
    case PropertyName = "property-name"
    case Keyword = "keyword"
    case Absolute = "absolute"
    case Relative = "relative"
    case RealNumber = "real-number"
    case IntegerNumber = "integer-number"
    case Number = "number"
    case Unit = "unit"
    case FontFamilyName = "font-family-name"
    case Error = "error"
    case Unsupported = "unsupported"
    case UniversalSelector = "universal-selector"
    case AtRule = "at-rule"
    
    case Nil = ""
    
    func isAllowedTokenClass() -> Bool {
        
        if let _ = TokenClassType(rawValue: self.rawValue) {
        
            return true
        }
        
        return false
    }
    
}
