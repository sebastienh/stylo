//
//  CSSFontStyle+CSSPropertyValueAssociatedValueProtocol.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-04-26.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common
import os

extension CSSFontStyle: CSSPropertyValueAssociatedValueProtocol {
    
    /// Return the defaulting type of the value
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
    
    /// Personnal addition
    public func isSelectedValue() -> Bool {
        
        switch self {
            
        case .defaulted(let defaultingType):
            return defaultingType.isSelectedValue()
            
        default:
            return false
        }
    }
    
    /// Return is the value is relative
    public func isRelative() -> Bool {
        
        return false
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
}
