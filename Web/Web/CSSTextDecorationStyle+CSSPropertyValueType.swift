//
//  CSSTextDecorationStyle+CSSPropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-04-17.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

extension CSSTextDecorationStyle: CSSPropertyValueType {
    
    typealias PropertyValueType = CSSTextDecorationStyle
    
    static func valueFromKeyword(_ string: String) -> CSSTextDecorationStyle? {
        
        if let textDecorationStyleKeyword = CSSTextDecorationStyleKeyword(rawValue: string) {
            
            switch textDecorationStyleKeyword {
                
            case .solid:
                
                return CSSTextDecorationStyle.solid
                
            case .double:
                
                return CSSTextDecorationStyle.double
                
            case .dotted:
                
                return CSSTextDecorationStyle.dotted
                
            case .dashed:
                
                return CSSTextDecorationStyle.dashed
                
            case .wavy:
                
                return CSSTextDecorationStyle.wavy
            }
        }
        else if let defaultedKeyword = DefaultingType(rawValue: string) {
            
            return CSSTextDecorationStyle.defaulted(defaultedKeyword)
        }
        return nil
    }
}
