//
//  CSSFontWeigth+CSSPropertyValueAssociatedValueProtocol.swift
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

extension CSSFontWeight: CSSPropertyValueAssociatedValueProtocol {
    
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
        
        switch self {
            
        case .relative(_):
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
}
