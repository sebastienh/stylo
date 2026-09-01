//
//  LengthPropertyValue.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol LengthPropertyValue {
    
    associatedtype CSSPropertyType
    
    func pixelLengthPropertyValueFromPixelValue(_ pixel: CGFloat) -> CSSPropertyType
    
    func pixelLengthValue() -> CGFloat 
    
}
