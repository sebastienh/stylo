//
//  CSSResovalblePropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

protocol CSSResovalblePropertyValueType {
    
    associatedtype ResovablePropertyValueType
    
    func resolveComputedValueFromSpecifiedValue(_ specifiedValue: ResovablePropertyValueType, container: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer
    
}
