//
//  CSSFontWeight.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public enum CSSFontWeigthNumericValue: Int {
    
    case thin = 100
    case extraLight = 200
    case light = 300
    case normal = 400
    case medium = 500
    case semiBold = 600
    case bold = 700
    case extraBold = 800
    case black = 900
    
    public var numericWeight: Int {
        
        switch self {
            
        case .thin:
            
            return 2
            
        case .extraLight:
            
            return 3
            
        case .light:
            
            return 4
            
        case .normal:
            
            return 5
            
        case .medium:
            
            return 6
            
        case .semiBold:
            
            return 8
            
        case .bold:
            
            return 9
            
        case .extraBold:
            
            return 11
            
        case .black:
            
            return 13
        }
    }
}


public enum CSSFontWeigthRelativeValue: String  {
    
    case bolder = "bolder"
    case lighter = "lighter"
    
}

public enum CSSFontWeigthAbsoluteValue: String {
    
    case normal = "normal"
    case bold = "bold"
}


public enum CSSFontWeight: Equatable {
    
    case numeric(CSSFontWeigthNumericValue)
    case absolute(CSSFontWeigthAbsoluteValue)
    case relative(CSSFontWeigthRelativeValue)
    case defaulted(DefaultingType)
    
    var string: String {
        
        switch self {
            
        case .absolute(_):
            
            return "absolute"
            
        case .relative(_):
            
            return "relative"
            
        case .defaulted(_):
            
            return "defaulted"
            
        case .numeric(_):
            
            return "numeric"
        }        
    }
    
    func fontWeightValue() -> CSSFontWeigthNumericValue? {
        
        switch self {
            
        case .numeric(let value):
            
            return value
            
        case .absolute(let value):
            
            switch value {
                
            case .normal:
                return CSSFontWeigthNumericValue.normal
                
            case .bold:
                return CSSFontWeigthNumericValue.bold
            }
            
        case .relative(_):
            assert(false,"Should not ask this.")
            
        case .defaulted(_):
            assert(false, "Should not ask this.")
        }
        return nil
    }
    
    public static func ==(lhs: CSSFontWeight, rhs: CSSFontWeight) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.numeric(let fontWeigthNumericValue), .numeric(let otherFontWeigthNumericValue)):
            
            if fontWeigthNumericValue != otherFontWeigthNumericValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: fontWeigthNumericValue are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
          
        case (.absolute(let fontWeigthAbsoluteValue), .absolute(let otherFontWeigthAbsoluteValue)):
            
            if fontWeigthAbsoluteValue != otherFontWeigthAbsoluteValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: fontWeigthAbsoluteValue are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        case (.relative(let fontWeigthRelativeValue), .relative(let otherFontWeigthRelativeValue)):
            
            if fontWeigthRelativeValue != otherFontWeigthRelativeValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: fontWeigthRelativeValue are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        case (.defaulted(let defaultingType), .defaulted(let otherDefaultingType)):
            
            if defaultingType != otherDefaultingType {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: defaultingType are different.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            return true
            
        default:
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: ", log: Log.Web.all, type: .debug)
            #endif
            return false
            
        }
    }
}

