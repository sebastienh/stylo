//
//  CSDeclaration+PropertyValueComputing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

extension CSDeclaration {

    internal func computeAndSetPropertyValue() {
    
        if let property = CSSProperty(rawValue: self.propertyName) {
        
            // if the property has errors it won't compute to any value
            // the value handling should already consider the nil value
            // since value is optional.
            if !self.valueContainsVarFunctions {
                self.value = property.computePropertyValue(self)
            }
            else {
                // we can only evaluate custom properties at
                // cascading time
                self.value = CSSPropertyValueContainer.customValue(self)
            }
        }
        else if self.propertyName.starts(with: "--") {
            
            self.value = CSSPropertyValueContainer.customValue(self)
        }
    }
}
