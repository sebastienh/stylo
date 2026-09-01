//
//  CSSFontSize+LengthPropertyValue.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

extension CSSFontSize : LengthPropertyValue {

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: LengthPropertyValue protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    typealias CSSPropertyType = CSSFontSize

    public func pixelLengthPropertyValueFromPixelValue(_ pixel: CGFloat) -> CSSFontSize {
    
        return CSSFontSize.length(CSSLength.px(pixel))
    }
 
    
    public func pixelLengthValue() -> CGFloat {
        
        switch self {
            
        case .length(let length):
            
            switch length {

            case .px(let value):
                return value
                
            default:
                assert(false, "Not a pixel property value.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not a pixel property value.", log: Log.Web.all, type: .error)
                #endif
                return CSSFontSize.medium.pixelValueFromKeyword()
            }
        default:
            assert(false, "Not a length property value.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not a length property value.", log: Log.Web.all, type: .error)
            #endif
            return CSSFontSize.medium.pixelValueFromKeyword()
        }
        
    }
    
}
