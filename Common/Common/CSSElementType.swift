//
//  CSSElementLocalName.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-11.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation


enum CSSElementType : String, ElementType {

//    case StyleSheet = "style-sheet"
//    case AtKeywork = "at-keywork"
//    case Identifier = "identifier"
    case CSSStyleSheet = "css-style-sheet"
    
//    // Property
//    case Unit = "unit"
//    
//    
//    
//    case Unicode = "unicode"
//    case Number = "number"
//    case URL = "url"
//    
//    case PercentSign = "percent-sign"
//    
//    case Important = "important"
//    
//    // There is a conflict with String type returned
//    // by stringValue so we must chose another name.
//    case QuotedString = "string"
//    
//    // Comment
//    case CommentStart = "comment-start"
//    case CommentValue = "comment-value"
//    case CommentEnd = "comment-end"
    
    // Selector
    
//    
//    
//    case PseudoClass = "pseudo-class"
//    
//    //
//    
//    // Function
//    case Function = "function"
//    case FunctionName = "function-name"
//    case FunctionParameter = "function-parameter"
//    
//    // String match
//    case StringMatch = "string-match"
//    
//    
//    case PseudoElement = "pseudo-element"
    
    
    case Token = "css-token"
    
//    // unknown 
//    case Unknown = "unknown"
    
    var name: String {
        
        return self.rawValue
    }
    
    var hashValue: Int {
        
        get {
            return self.rawValue.hashValue
        }
    }
    
    static func allValues() -> [ElementType] {
        
        return [
            CSSElementType.CSSStyleSheet,
            CSSElementType.Token
        ]
    }
    
}

func ==(lhs: CSSElementType, rhs: CSSElementType) -> Bool {
    
    return lhs.rawValue == rhs.rawValue
}
