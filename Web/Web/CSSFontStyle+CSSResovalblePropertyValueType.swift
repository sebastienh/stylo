//
//  CSSFontStyle+CSSResovalblePropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import os

extension CSSFontStyle: CSSResovalblePropertyValueType {
    
    typealias ResovablePropertyValueType = CSSFontStyle
    
    func resolveComputedValueFromSpecifiedValue(_ specifiedValue: CSSFontStyle, container: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        switch specifiedValue {
            
        case .keyword(_):
            return container
            
        case .defaulted(_):
            assert(false, "Specified value should not be of kind defaulted")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: specified value should not be of kind defaulted", log: Log.Web.all, type: .error)
            #endif
            return CSSPropertyValueContainer.fontStyle(
                CSSFontStyle.keyword(
                    CSSFontStyleKeywordValue.normal))
        }
    }
    
}
