//
//  CSSLength.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

/// see http://dev.w3.org/csswg/css-values-3/#lengths
public enum CSSLength: Equatable {
    
    // relative lengths
    
    // 'ex' x-height of the element's font
    case ex(CGFloat)
    
    // ‘ch’ width of the "0" (ZERO, U+0030) glyph in the element's font
    case ch(CGFloat)
    
    // ‘rem’ font size of the root element
    case rem(CGFloat)
    
    // ‘vw’ 1% of viewport's width
    case vw(CGFloat)
    
    // ‘vh’ 1% viewport's height
    case vh(CGFloat)
    
    // ‘vmin’ 1% of viewport's smaller dimension
    case vmin(CGFloat)
    
    // ‘vmax’ 1% of viewport's larger dimension
    case vmax(CGFloat)
    
    // 'em' font size of the element
    case em(CGFloat)
    
    // absolute lengths 
    
    // ‘cm’	centimeters
    case centimeters(CGFloat)
    
    // ‘mm’	millimeters
    case mm(CGFloat)
    
    // ‘in’	inches; 1in is equal to 2.54cm
    case `in`(CGFloat)
    
    // ‘px’	pixels; 1px is equal to 1/96th of 1in
    case px(CGFloat)
    
    // ‘pt’	points; 1pt is equal to 1/72nd of 1in
    case pt(CGFloat)
    
    // ‘pc’	picas; 1pc is equal to 12pt
    case pc(CGFloat)

    // q	quarter-millimeters	1q = 1/40th of 1cm
    case q(CGFloat)
        
    func isRelative() -> Bool {
        switch self {
        case .em: fallthrough
        case .ex: fallthrough
        case .ch: fallthrough
        case .rem: fallthrough
        case .vw: fallthrough
        case .vh: fallthrough
        case .vmin: fallthrough
        case .vmax:
            return true
        default:
            return false
        }
    }
    
    func isAbsolute() -> Bool {
        
        return !isRelative()
    }
    
    public static func ==(lhs: CSSLength, rhs: CSSLength) -> Bool {
        
        switch (lhs, rhs) {

        // 'ex' x-height of the element's font
        case (.ex(let value), .ex(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: ex value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘ch’ width of the "0" (ZERO, U+0030) glyph in the element's font
        case (.ch(let value), .ch(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: ch value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘rem’ font size of the root element
        case (.rem(let value), .rem(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: rem value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘vw’ 1% of viewport's width
        case (.vw(let value), .vw(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: rem value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘vh’ 1% viewport's height
        case (.vh(let value), .vh(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: vh value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘vmin’ 1% of viewport's smaller dimension
        case (.vmin(let value), .vmin(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: vmin value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘vmax’ 1% of viewport's larger dimension
        case (.vmax(let value), .vmax(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: vmax value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // 'em' font size of the element
        case (.em(let value), .em(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: em value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
            // absolute lengths
            
        // ‘cm’    centimeters
        case (.centimeters(let value), .centimeters(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: centimeters value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘mm’    millimeters
        case (.mm(let value), .mm(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: mm value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘in’    inches; 1in is equal to 2.54cm
        case (.`in`(let value), .`in`(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: `in` value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘px’    pixels; 1px is equal to 1/96th of 1in
        case (.px(let value), .px(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: px value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘pt’    points; 1pt is equal to 1/72nd of 1in
        case (.pt(let value), .pt(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: pt value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // ‘pc’    picas; 1pc is equal to 12pt
        case (.pc(let value), .pc(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: pc value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        // q    quarter-millimeters    1q = 1/40th of 1cm
        case (.q(let value), .q(let otherValue)):
            
            if value != otherValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: q value are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        default:
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: case value are different.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        
    }
    
}
