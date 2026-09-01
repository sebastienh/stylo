//
//  CSSProperty+PropertyValue.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

extension CSSProperty {
    
    /// This method is used to compute the value using the CSDeclaration
    func computePropertyValue(_ declaration: CSDeclaration) -> CSSPropertyValueContainer? {
        if let value = CSSPropertyEvaluator.parsePropertyValue(declaration) {
            return value
        }
        return CSSPropertyValueContainer.error
    }
}
