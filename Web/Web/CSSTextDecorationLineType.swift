//
//  CSSTextDecorationLineKeyword.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public enum CSSTextDecorationLineType {
    
    case noUnderline
    case underline
    case overline
    case lineThrough
    case defaulted(DefaultingType)
    
    var string: String {
        
        switch self {
            
        case .noUnderline:
            
            return "none"
            
        case .underline:
            
            return "underline"
            
        case .overline:
            
            return "overline"
            
        case .lineThrough:
            
            return "line-through"
            
        case .defaulted(_):
            
            return "defaulted-value"
        }
    }
    
}

extension CSSTextDecorationLineType: Equatable {
    
    public static func ==(lhs: CSSTextDecorationLineType, rhs: CSSTextDecorationLineType) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.noUnderline, .noUnderline):
            return true
            
        case (.underline, .underline):
            return true
            
        case (.overline, .overline):
            return true
            
        case (.lineThrough, .lineThrough):
            return true
            
        case (.defaulted(let lhsValue), .defaulted(let rhsValue)):
            return lhsValue == rhsValue
            
        default:
            return false
        }
    }
    
}

