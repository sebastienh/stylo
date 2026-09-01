//
//  CSSInheritPossibleValueProperty.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-18.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol CSSPropertyValueAssociatedValueProtocol {
    
    /// Return is the value is relative
    func isRelative() -> Bool
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit
    func isInherit() -> Bool
    
    /// see http://dev.w3.org/csswg/css-cascade/#initial
    func isInitial() -> Bool
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit-initial
    func isUnset() -> Bool
    
    /// see http://dev.w3.org/csswg/css-cascade/#default
    func isDefault() -> Bool
    
    /// Personnal addition
    func isSelectedValue() -> Bool
    
    /// Return the defaulting type of the value 
    func defaultingType() -> DefaultingType
}
