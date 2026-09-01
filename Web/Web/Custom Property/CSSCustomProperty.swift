//
//  CSSCustomProperty.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-12.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

public enum CSSCustomProperty: CSSPropertyValue, Equatable {

    case componentValues([ComponentValue])
    
    public static func ==(lhs: CSSCustomProperty, rhs: CSSCustomProperty) -> Bool {
        return true
    }
}
