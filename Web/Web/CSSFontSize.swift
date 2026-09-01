//
//  CSSFontSize.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public enum CSSFontSize: CSSPropertyValue, Equatable {
    
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    case smaller
    case larger
    case percentage(CGFloat)
    case length(CSSLength)
    case defaulted(DefaultingType)
    
    // FIXME: we should return to this to return the right values
    public func pixelValueFromKeyword() -> CGFloat {
        
        switch self {
            
        case .xxSmall:
            return CSSFontSize.medium.pixelValueFromKeyword() * 3/5
            
        case .xSmall:
            return CSSFontSize.medium.pixelValueFromKeyword() * 3/4
            
        case .small:
            return CSSFontSize.medium.pixelValueFromKeyword() * 8/9
          
        case .medium:
            return UserAgent.shared.mediumFontSizePixelValue
            
        case .large:
            return CSSFontSize.medium.pixelValueFromKeyword() * 6/5
        
        case .xLarge:
            return CSSFontSize.medium.pixelValueFromKeyword() * 3/2
            
        case .xxLarge:
            return CSSFontSize.medium.pixelValueFromKeyword() * 2/1
            
        default:
            assert(false, "Can not get absolute value from relative value.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Can not get absolute value from relative value.", log: Log.Web.all, type: .error)
            #endif
            return UserAgent.shared.mediumFontSizePixelValue
        }
    }
    
    public static func ==(lhs: CSSFontSize, rhs: CSSFontSize) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.large, .large):
            return true
            
        case (.larger, .larger):
            return true
            
        case (.length(let length), .length(let otherLength)):
            
            if length != otherLength {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: defaulted are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        case (.medium, .medium):
            return true
            
        case (.percentage(let percentage), .percentage(let otherPercentage)):
            
            if percentage != otherPercentage {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: percentage are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        case (.small, .small):
            return true
            
        case (.smaller, .smaller):
            return true
            
        case (.xLarge, .xLarge):
            return true
            
        case (.xSmall, .xSmall):
            return true
            
        case (.xxLarge, .xxLarge):
            return true
            
        case (.xxSmall, .xxSmall):
            return true
            
        case (.defaulted(let lhsValue), .defaulted(let rhsValue)):
            
            if lhsValue != rhsValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: defaulted are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        default:
            return false
        }
    }
    
}
