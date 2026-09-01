//
//  CSSTextDecorationLine+CSSResolvablePropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

extension CSSTextDecorationLine: CSSResovalblePropertyValueType {
    
    typealias ResovablePropertyValueType = CSSTextDecorationLine
    
    func resolveComputedValueFromSpecifiedValue(_ specifiedValue: CSSTextDecorationLine, container: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        // there is nothing to resolve
        return container
    }
}
