//
//  CSSPropertyValueString.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol CSSPropertyValueString {
    
    associatedtype CSSPropertyValueType
    
    func propertyValue() -> CSSPropertyValueType
    
}
