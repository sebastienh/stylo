//
//  SelectionAttributes.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-07-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common

public protocol SelectionAttributes {
    
    var backgroundBaseColor: PlateformColorType? { get }
    
    var foregroundBaseColor: PlateformColorType? { get }
    
}

extension TextStylePreview: SelectionAttributes {
    
    public var backgroundBaseColor: PlateformColorType? {
        
        return self.backgroundColor
    }
    
    public var foregroundBaseColor: PlateformColorType? {
        
        return self.h1Color
    }
}

extension CssStylePreview: SelectionAttributes {
 
    public var backgroundBaseColor: PlateformColorType? {
        
        return self.backgroundColor
    }
    
    public var foregroundBaseColor: PlateformColorType? {
        
        return self.propertyNameColor
    }
}
