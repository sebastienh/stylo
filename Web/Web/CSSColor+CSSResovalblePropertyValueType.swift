//
//  CSSColor+CSSResovalblePropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import os

extension CSSColor: CSSResovalblePropertyValueType {
    
    typealias ResovablePropertyValueType = CSSColor
    
    func resolveComputedValueFromSpecifiedValue(_ specifiedValue: CSSColor, container: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        switch specifiedValue {
            
        case .custom(_):
            return container
            
        case .defaulted(_):
            assert(false, "Specified value should not be of kind defaulted")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: specified value should not be of kind defaulted", log: Log.Web.all, type: .error)
            #endif
            return CSSPropertyValueContainer.color(
                CSSColor.custom(CIColor.black)
            )
        }
    }
    
}

