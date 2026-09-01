//
//  CSSTextDecorationStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-04-17.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public enum CSSTextDecorationStyle: CSSPropertyValue {
    
    case solid
    case double
    case dotted
    case dashed
    case wavy
    case defaulted(DefaultingType)
    
}

extension CSSTextDecorationStyle: Equatable {
    
    public static func ==(lhs: CSSTextDecorationStyle, rhs: CSSTextDecorationStyle) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.solid, .solid):
            return true
            
        case (.double, .double):
            return true
            
        case (.dotted, .dotted):
            return true
            
        case (.dashed, .dashed):
            return true
            
        case (.wavy, .wavy):
            return true
            
        case (.defaulted(let lhsValue), .defaulted(let rhsValue)):
            return lhsValue == rhsValue
            
        default:
            return false
        }
    }
}

