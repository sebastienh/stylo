//
//  DefaultingType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public enum DefaultingType: String, CSSPropertyValueAssociatedValueProtocol {

    case Inherit = "inherit"
    
    case Initial = "initial"
    
    case Unset = "unset"
    
    case Default = "default"
    
    case SelectedValue = "selected-value"
    
    static let ClassNameValue: String = "defaulted-value"
    
    /// Return the defaulting type of the value
    public func defaultingType() -> DefaultingType {
        return self
    }
    
    public func isRelative() -> Bool {
        return false 
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit
    public func isInherit() -> Bool {
        
        if self == .Inherit {
            
            return true
        }
        return false
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#initial
    public func isInitial() -> Bool {
        
        if self == .Initial {
            
            return true
        }
        return false
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit-initial
    public func isUnset() -> Bool {
        
        if self == .Unset {
            
            return true
        }
        return false
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#default
    public func isDefault() -> Bool {
        
        if self == .Default {
            
            return true
        }
        return false
    }

    public func isSelectedValue() -> Bool {
        
        if self == .SelectedValue {
            
            return true
        }
        return false
    }
    
}
