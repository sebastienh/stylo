//
//  ComputedStyleDeclaration.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public protocol ComputedStyleDeclaration {
    
    var allPropertyValuesSpecified: Bool { get }
    
    var propertyValues: [DOMString: CSSPropertyValueContainer] { get }
    
    func setPropertyOrigin(_ propertyName: DOMString, origin: CSSOrigin)
    
    func getPropertyOrigin(_ propertyName: DOMString) -> CSSOrigin?
    
    func propertyCascadingPhaseOrigin(forPropertyWithName name: String) -> CascadingPhaseOrigin? 
    
    func getCSSPropertyValueContainer(_ property: DOMString) -> CSSPropertyValueContainer?
    
    func setCSSPropertyValueContainer(_ propertyName: DOMString, value: CSSPropertyValueContainer, cascadingPhase: CascadingPhaseOrigin)
    
    func setCSSPropertyValueContainer(_ propertyName: DOMString, value: CSSPropertyValueContainer)
    
    func equals(to other: Any?) -> Bool
}
