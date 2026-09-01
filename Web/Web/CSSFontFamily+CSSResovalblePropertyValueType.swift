//
//  CSSFontFamily+CSSResovalblePropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import os

extension CSSFontFamily : CSSResovalblePropertyValueType {
    
    typealias ResovablePropertyValueType = CSSFontFamily
    
    func resolveComputedValueFromSpecifiedValue(_ specifiedValue: CSSFontFamily, container: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        let userAgent = UserAgent.shared
        
        switch specifiedValue {
            
        case .custom(_):
            return container
            
        case .defaulted(_):
            assert(false, "Specified value should not be of kind defaulted")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: specified value should not be of kind defaulted", log: Log.Web.all, type: .error)
            #endif
            return CSSPropertyValueContainer.fontFamily(
                CSSFontFamily.sansSerif
            )
            
        case .fantasy:
            return CSSPropertyValueContainer.fontFamily(userAgent.customFontFamilyFromFontGenericFontFamily(specifiedValue))
            
        case .monospace:
            return CSSPropertyValueContainer.fontFamily(userAgent.customFontFamilyFromFontGenericFontFamily(specifiedValue))
            
        case .sansSerif:
            return CSSPropertyValueContainer.fontFamily(userAgent.customFontFamilyFromFontGenericFontFamily(specifiedValue))
            
        case .serif:
            return CSSPropertyValueContainer.fontFamily(userAgent.customFontFamilyFromFontGenericFontFamily(specifiedValue))
            
        case .cursive:
            return CSSPropertyValueContainer.fontFamily(userAgent.customFontFamilyFromFontGenericFontFamily(specifiedValue))
        }
    }
    
}
