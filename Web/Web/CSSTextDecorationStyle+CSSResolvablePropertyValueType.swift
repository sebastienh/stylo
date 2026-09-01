//
//  CSSTextDecorationStyle+CSSResolvablePropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import os

extension CSSTextDecorationStyle: CSSResovalblePropertyValueType {
    
    typealias ResovablePropertyValueType = CSSTextDecorationStyle
    
    func resolveComputedValueFromSpecifiedValue(_ specifiedValue: CSSTextDecorationStyle, container: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        switch specifiedValue {
            
        case .defaulted(_):
            
            assert(false, "Specified value should not be of kind defaulted")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: specified value should not be of kind defaulted", log: Log.Web.all, type: .error)
            #endif
            return CSSPropertyValueContainer.textDecorationStyle(
                CSSTextDecorationStyle.solid
            )
            
        default:
            return container
        }
    }
}
