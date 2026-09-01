//
//  CSSFontFamily+rere.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-21.
//  Copyright (c) 2015 NM. All rights reserved.
//
import Foundation
import Common

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: CSSPropertyValueType protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////


extension CSSFontFamily: CSSPropertyValueType {
    
    typealias PropertyValueType = CSSFontFamily
    
    static func valueFromKeyword(_ string: String) -> CSSFontFamily? {
        
        let userAgent = UserAgent.shared
        
        let explodedString = string.explode(" ")
        
        if let fontFamily = userAgent.fontFamilyCodeFromStringArray(explodedString) {
        
            if let genericFontFamily = CSSFontGenericFamily(rawValue: fontFamily) {
            
                switch genericFontFamily {
                 
                case .Serif:
                    return CSSFontFamily.serif
                    
                case .SansSerif:
                    return CSSFontFamily.sansSerif
                    
                case .Monospace:
                    return CSSFontFamily.monospace
                    
                case .Fantasy:
                    return CSSFontFamily.fantasy
                    
                case .Cursive:
                    return CSSFontFamily.cursive
                }
            }
            else {
            
                return CSSFontFamily.custom(fontFamily)
            }
        }
        else if let defaultedKeyword = DefaultingType(rawValue: string) {
            
            return CSSFontFamily.defaulted(defaultedKeyword)
        }

        return nil
    }
    
}
