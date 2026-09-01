//
//  CSSColor+CSSPropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-20.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: CSSPropertyValueType protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////


extension CSSColor: CSSPropertyValueType {
    
    typealias PropertyValueType = CSSColor
    
    static func valueFromKeyword(_ string: String) -> CSSColor? {
        
        if let colorKeyword = ColorKeyword(rawValue: string) {
            
            return CSSColor.custom(colorKeyword.colorFromKeyword())
        }
        else if let defaultedKeyword = DefaultingType(rawValue: string) {
            
            return CSSColor.defaulted(defaultedKeyword)
        }
        
        return nil
    }
    
}
