//
//  CSSPropertyValueContainer+FontWeight.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-04-25.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import os

extension CSSPropertyValueContainer {
    
    public func fontWeightNumericValue() -> CSSFontWeigthNumericValue {
        
        switch self {
            
        case .fontWeight(let fontWeight):
            
            return fontWeight.fontWeightValue()!
            
        default:
            assert(false, "Expected font-weight.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Expected font-weight.", log: Log.Web.all, type: .error)
            #endif
            return CSSFontWeigthNumericValue.medium
        }
    }
    
}
