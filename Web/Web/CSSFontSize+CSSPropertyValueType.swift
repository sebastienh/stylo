//
//  CSSFontSize+CSSPropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: CSSPropertyValueType protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSSFontSize : CSSPropertyValueType {
    
    typealias PropertyValueType = CSSFontSize
    
    static func valueFromKeyword(_ string: String) -> CSSFontSize? {
        
        if let fontSizeKeyword = CSSFontSizeKeyword(rawValue: string) {
            
            switch fontSizeKeyword {
                
            case .XXSmall:
                return CSSFontSize.xxSmall
                
            case .XSmall:
                return CSSFontSize.xSmall
                
            case .Small:
                return CSSFontSize.small
                
            case .Medium:
                return CSSFontSize.medium
                
            case .Large:
                return CSSFontSize.large
                
            case .XLarge:
                return CSSFontSize.xLarge
                
            case .XXLarge:
                return CSSFontSize.xxLarge
                
            case .Larger:
                return CSSFontSize.larger
                
            case .Smaller:
                return CSSFontSize.smaller
            }
        }
        else if let defaultedKeyword = DefaultingType(rawValue: string) {
            
            return CSSFontSize.defaulted(defaultedKeyword)
        }
        return nil
    }
    
}
