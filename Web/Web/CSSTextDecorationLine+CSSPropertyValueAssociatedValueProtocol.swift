//
//  CSSTextDecorationLine+CSSPropertyValueAssociatedValueProtocol.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-04-17.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common
import os

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: CSSPropertyValueAssociatedValueProtocol protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSSTextDecorationLine: CSSPropertyValueAssociatedValueProtocol {

    ///
    public func isRelative() -> Bool {
        return false
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit
    public func isInherit() -> Bool {
        
        if textDecorationLineArray.count == 1 {
            
            let textDecorationLineDefaultingType = textDecorationLineArray.first!
            
            switch textDecorationLineDefaultingType {
                
            case .defaulted(let defaultingType):
                return defaultingType.isInherit()
                
            default:
                return false
            }
        }
        
        return false
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#initial
    public func isInitial() -> Bool {
    
        if textDecorationLineArray.count == 1 {
            
            let textDecorationLineDefaultingType = textDecorationLineArray.first!
            
            switch textDecorationLineDefaultingType {
                
            case .defaulted(let defaultingType):
                return defaultingType.isInitial()
                
            default:
                return false
            }
        }
        
        return false
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit-initial
    public func isUnset() -> Bool {
        
        if textDecorationLineArray.count == 1 {
            
            let textDecorationLineDefaultingType = textDecorationLineArray.first!
            
            switch textDecorationLineDefaultingType {
                
            case .defaulted(let defaultingType):
                return defaultingType.isUnset()
                
            default:
                return false
            }
        }
        
        return false
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#default
    public func isDefault() -> Bool {
        
        if textDecorationLineArray.count == 1 {
            
            let textDecorationLineDefaultingType = textDecorationLineArray.first!
            
            switch textDecorationLineDefaultingType {
                
            case .defaulted(let defaultingType):
                return defaultingType.isDefault()
                
            default:
                return false
            }
        }
        
        return false
    }
    
    public func isSelectedValue() -> Bool {
        
        if textDecorationLineArray.count == 1 {
            
            let textDecorationLineDefaultingType = textDecorationLineArray.first!
            
            switch textDecorationLineDefaultingType {
                
            case .defaulted(let defaultingType):
                return defaultingType.isSelectedValue()
                
            default:
                return false
            }
        }
        
        return false
    }
    
    /// Return defaulting type
    public func defaultingType() -> DefaultingType {
        
        if textDecorationLineArray.count == 1 {
            
            let textDecorationLineDefaultingType = textDecorationLineArray.first!
            
            switch textDecorationLineDefaultingType {
                
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
        
        return .Default
    }
}
