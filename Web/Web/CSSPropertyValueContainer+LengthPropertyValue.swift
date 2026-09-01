//
//  CSSPropertyValueContainer+LengthPropertyValue.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

extension CSSPropertyValueContainer {

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: LengthPropertyValue protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    typealias CSSPropertyType = CSSPropertyValueContainer

    public func pixelLengthPropertyValueFromPixelValue(_ pixel: CGFloat) -> CSSPropertyValueContainer {

        switch self {

        case .fontSize(let fontSize):
            
            if pixel < 0 {
                return CSSPropertyValueContainer.fontSize(fontSize.pixelLengthPropertyValueFromPixelValue(0))
            }
            else {
                return CSSPropertyValueContainer.fontSize(fontSize.pixelLengthPropertyValueFromPixelValue(pixel))
            }

        default:
            assert(false, "Error: Self is not font-size...")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error: Self is not font-size...", log: Log.Web.all, type: .error)
            #endif
            return CSSPropertyValueContainer.error
        }
    }
    
    public func pixelLengthValue() -> CGFloat {
        
        switch self {
            
        case .fontSize(let fontSize):
            return fontSize.pixelLengthValue()
            
        default:
            assert(false, "Error in pixelLengthValue(), unexpected type.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error in pixelLengthValue(), unexpected type: %@", log: Log.Web.all, type: .error, %%self)
            #endif
            return CSSFontSize.medium.pixelLengthValue()
        }
    }
    
}
