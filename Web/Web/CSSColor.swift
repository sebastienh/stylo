//
//  CSSColor.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import CoreImage
import Common
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

public enum CSSColor: CSSPropertyValue, Equatable {
    
//    #if os(OSX)
//        typealias PlateformColorType = NSColor
//    #else
//        typealias PlateformColorType = UIColor
//    #endif
    
    case custom(CIColor)
    case defaulted(DefaultingType)
    
    func plateformColorFromColorProperty() -> PlateformColorType {
        
        switch self {
            
            // genrics font families
        case .custom(let value):
            
            return PlateformColorType(ciColor: value)
            
        case .defaulted(_):
            
            assert(false, "Can not deduct color value from default value.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Can not deduct color value from default value.", log: Log.Web.all, type: .error)
            #endif
            // black by default
            return PlateformColorType(ciColor: CIColor.black)
        }
    }
    
    public static func ==(lhs: CSSColor, rhs: CSSColor) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.custom(let color), .custom(let otherColor)):
            
            if color != otherColor {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: custom colors are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        case (.defaulted(let defaultingType), .defaulted(let otherDefaultingType)):
            
            if defaultingType != otherDefaultingType {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: defaulted colors are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        case (.defaulted(_), .custom(_)):
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: cases are different.", log: Log.Web.all, type: .debug)
            #endif
            return false
            
        case (.custom(_), .defaulted(_)):
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: cases are different.", log: Log.Web.all, type: .debug)
            #endif
            return false
            
        }
    }
}


















