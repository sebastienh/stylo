//
//  CSSFontStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public enum CSSFontStyleKeywordValue: String {
    
    case normal = "normal"
    case italic = "italic"
    case oblique = "oblique"
    
    public static var values: [CSSFontStyleKeywordValue] {
        
        return [
            .normal,
            .italic,
            .oblique
        ]
    }
}


public enum CSSFontStyle: Equatable {
    
    case keyword(CSSFontStyleKeywordValue)
    case defaulted(DefaultingType)
    
    var string: String {
        
        switch self {
            
        case .keyword(_):
            
            return "keyword"
            
        case .defaulted(_):
            
            return "defaulted"
        }
    }
    
    public static func ==(lhs: CSSFontStyle, rhs: CSSFontStyle) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.keyword(let lKeywordValue), .keyword(let rKeywordValue)):
            
            switch (lKeywordValue, rKeywordValue) {
            case (.normal, .normal):
                return true
                
            case (.italic, .italic):
                return true
                
            case (.oblique, .oblique):
                return true
                
            default:
                return false
            }
            
        case (.defaulted(let lhsValue), .defaulted(let rhsValue)):
            return lhsValue == rhsValue
            
        default:
            return false
        }
    }
}


