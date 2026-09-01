//
//  CSSPropertyValueContainer+FontSize.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-23.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import os

extension CSSPropertyValueContainer {
    
    public func pixelFontSizeValue() -> CGFloat {
        
        switch self {
            
        case .fontSize(let fontSize):
            
            switch fontSize {
                
            case .length(let cssLength):

                switch cssLength {
                    
                case .px(let value):
                    return value
                    
                default:
                    assert(false, "Expecting px value in pixelFontSizeValue().")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Expected px value in pixelFontSizeValue().", log: Log.Web.all, type: .error)
                    #endif
                    return CSSFontSize.medium.pixelLengthValue()
                }
                
            default:
                assert(false, "Expected length in pixelFontSizeValue().")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Expected length in pixelFontSizeValue().", log: Log.Web.all, type: .error)
                #endif
                return CSSFontSize.medium.pixelLengthValue()
            }
            
        default:
            assert(false, "Expected font-size in pixelFontSizeValue().")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Expected font-size in pixelFontSizeValue().", log: Log.Web.all, type: .error)
            #endif
            return CSSFontSize.medium.pixelLengthValue()
        }
    }
    
    public static func fontSizePropertyValueFromFontSize(_ fontSize: CSSFontSize) -> CSSPropertyValueContainer {
        
        return CSSPropertyValueContainer.fontSize(
            CSSFontSize.length(
                CSSLength.px(
                    fontSize.pixelLengthValue()
                )
            )
        )
    }
    
    public static func fontSizePropertyValueFromPixelValue(_ pixelValue: CGFloat) -> CSSPropertyValueContainer {
        
        return CSSPropertyValueContainer.fontSize(
            CSSFontSize.length(
                CSSLength.px(
                    pixelValue)))
    }
    
    public static func fontFamilyPropertyValueFromCSSFontFamily(_ fontFamily: CSSFontFamily) -> CSSPropertyValueContainer {
        
        return CSSPropertyValueContainer.fontFamily(fontFamily)
        
    }
}
