//
//  CSSPropertyValue+FontFamily.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import os

extension CSSPropertyValueContainer {
    
    public func fontFamilyStringValue() -> DOMString {
        
        switch self {
            
        case .fontFamily(let fontFamily):
            
            return fontFamily.fontFamilyKeywordFromFontFamily()
            
        default:
            assert(false, "Expecting font-family.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Expected font-family in method fontFamilyStringValue().", log: Log.Web.all, type: .error)
            #endif
            return CSSFontFamily.sansSerif.fontFamilyKeywordFromFontFamily()
        }
    }
    
}
