//
//  CSSFontSize+CSSPropertyValueAssociatedValueProtocol.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: CSSPropertyValueAssociatedValueProtocol protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSSFontSize : CSSPropertyValueAssociatedValueProtocol {
    
    public func isRelative() -> Bool {
        
        switch self {
            
        case .smaller:
            return true
            
        case .larger:
            return true
            
        case .length(let length):
            return length.isRelative()
            
        case .percentage(_):
            return true
            
        case .defaulted(_):
            return true
            
        default:
            return false
        }
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit
    public func isInherit() -> Bool {
        
        switch self {
            
        case .defaulted(let defaultingType):
            return defaultingType.isInherit()
            
        default:
            return false
        }
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#initial
    public func isInitial() -> Bool {
        
        switch self {
            
        case .defaulted(let defaultingType):
            return defaultingType.isInitial()
            
        default:
            return false
        }
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit-initial
    public func isUnset() -> Bool {
        
        switch self {
            
        case .defaulted(let defaultingType):
            return defaultingType.isUnset()
            
        default:
            return false
        }
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#default
    public func isDefault() -> Bool {
        
        switch self {
            
        case .defaulted(let defaultingType):
            return defaultingType.isDefault()
            
        default:
            return false
        }
    }
    
    public func isSelectedValue() -> Bool {
        
        switch self {
            
        case .defaulted(let defaultingType):
            return defaultingType.isSelectedValue()
            
        default:
            return false
        }
    }
    
    /// Return defaulting type
    public func defaultingType() -> DefaultingType {
        
        switch self {
            
        case .defaulted(let defaultingType):
            return defaultingType
            
        default:
            
            assert(false, "Not a defaulted type: \(self)")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not a defaulted type: %@", log: Log.Web.all, type: .error, %%self)
            #endif
            return DefaultingType.Default
        }
    }
}
