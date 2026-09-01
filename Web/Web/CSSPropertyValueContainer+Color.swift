//
//  CSSPropertyValueContainer+Color.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-13.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

public extension CSSPropertyValueContainer {
    
//    #if os(OSX)
//        typealias PlateformColorType = NSColor
//    #else
//        typealias PlateformColorType = UIColor
//    #endif
    
    func ciColorValue() -> CIColor? {
        
        switch self {
            
        case .color(let color):
            
            switch color {
                
                // genrics font families
            case .custom(let value):
                
                return value
                
            case .defaulted(_):
                
                assert(false, "Can not deduct font-family value from default value.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Can not deduct font-family value from default value.", log: Log.Web.all, type: .error)
                #endif
                return nil
            }
            
        default:
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Unexpected value type: %@.", log: Log.Web.all, type: .error, %%self)
            #endif
            assert(false, "Expecting color.")
            return nil
        }
    }
    
    func colorValue() -> PlateformColorType {
        
        switch self {
        case .color(let color): fallthrough
        case .backgroundColor(let color): fallthrough
        case .caretColor(let color): fallthrough
        case .textDecorationColor(let color):
            return color.plateformColorFromColorProperty()
        default:
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Unexpected value type: %@.", log: Log.Web.all, type: .error, %%self)
            #endif
            assert(false, "Expecting color.")
            return PlateformColorType(ciColor: CIColor.black)
        }
    }
    
}
