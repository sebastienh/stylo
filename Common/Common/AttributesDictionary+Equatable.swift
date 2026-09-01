//
//  AttributesDictionary+Equatable.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-07-14.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import os

fileprivate let overlineColorKey = StyloAttribute.overlineColor.key
fileprivate let strikethroughColorKey = StyloAttribute.strikethroughColor.key
fileprivate let caretColorKey = StyloAttribute.caretColor.key
fileprivate let overlineStyleKey = StyloAttribute.overlineStyle.key
fileprivate let underlineColorKey = NSAttributedString.Key.underlineColor
fileprivate let foregroundColorKey = NSAttributedString.Key.foregroundColor
fileprivate let backgroundColorKey = NSAttributedString.Key.backgroundColor
fileprivate let underlineStyleKey = NSAttributedString.Key.underlineStyle
fileprivate let strikethroughStyleKey = NSAttributedString.Key.strikethroughStyle
fileprivate let fontKey = NSAttributedString.Key.font
fileprivate let paragraphStyleKey = NSAttributedString.Key.paragraphStyle
fileprivate let headingTagBeforeKey = StyloAttribute.headingTagBefore.key
fileprivate let headingTagAfterKey = StyloAttribute.headingTagAfter.key

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    
    public func sameValuesForSameKeys(as other: [NSAttributedString.Key: Any]) -> Bool {
        
        for (key, otherValue) in other {
            
            if let value = self[key] {
                
                switch key {
                case underlineColorKey: fallthrough
                case overlineColorKey: fallthrough
                case strikethroughColorKey:
                    
                    // these attributes may not have been set
                    
                    let value = value as? PlateformColorType
                    let otherValue = otherValue as? PlateformColorType
                    
                    if let value = value, let otherValue = otherValue, value != otherValue {
                        
                        return false
                    }
                    else if value != nil && otherValue == nil {
                        
                        return false
                    }
                    
                    else if otherValue != nil && value == nil {
                        
                        return false
                    }
                    
                case caretColorKey: fallthrough
                case foregroundColorKey: fallthrough
                case backgroundColorKey:
                    
                    let value = value as? PlateformColorType
                    let otherValue = otherValue as? PlateformColorType
                    
                    // these values should always be defined
                    assert(value != nil)
                    assert(otherValue != nil)
                    if let value = value, let otherValue = otherValue, value != otherValue {
                        
                        return false
                    }
                    
                case underlineStyleKey: fallthrough
                case strikethroughStyleKey: fallthrough
                case overlineStyleKey:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("value: %@", log: Log.Common.all, type: .info, %%value)
                    #endif
                    let value = value as? Int
                    let otherValue = otherValue as? Int
                    
                    assert(value != nil)
                    assert(otherValue != nil)
                    
                    if let value = value, let otherValue = otherValue, value != otherValue {
                        
                        return false
                    }
                    
                case fontKey:
                    
                    let value = value as? PlateformFontType
                    let otherValue = otherValue as? PlateformFontType
                    
                    assert(value != nil)
                    assert(otherValue != nil)
                    if let value = value, let otherValue = otherValue, value != otherValue {
                        
                        return false
                    }
                
                case headingTagBeforeKey: fallthrough
                case headingTagAfterKey:
                    
                    let compiledValue = value as? NSNumber
                    let expectedValue = otherValue as? NSNumber
                    
                    // these values should always be defined
                    assert(compiledValue != nil)
                    assert(expectedValue != nil)
                    if let compiledValue = compiledValue, let expectedValue = expectedValue, compiledValue != expectedValue {
                        
                        return false
                    }
                
                case paragraphStyleKey:
                    // we don't care about paragraph style
                    break
                    
                default:
                    assert(false)
                    return false
                }
            }
            else {
                
                // no value for the key
                return false
            }
        }
        return true
    }
    
    public func equals(to other: [NSAttributedString.Key: Any]) -> Bool {
        
        if self.count != other.count {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("different attributes: count difference more than one.", log: Log.Common.all, type: .debug)
            #endif
            return false
        }
        
        for (key, value) in self {
            
            if let otherValue = other[key] {
                switch key {
                case underlineColorKey: fallthrough
                case overlineColorKey: fallthrough
                case strikethroughColorKey:
                    
                    // these attributes may not have been set
                    
                    let value = value as? PlateformColorType
                    let otherValue = otherValue as? PlateformColorType
                    
                    if let value = value, let otherValue = otherValue, value != otherValue {
                        return false
                    }
                    else if value != nil && otherValue == nil {
                        return false
                    }
                    else if otherValue != nil && value == nil {
                        return false
                    }
                    
                case caretColorKey: fallthrough
                case foregroundColorKey: fallthrough
                case backgroundColorKey:
                    
                    let value = value as? PlateformColorType
                    let otherValue = otherValue as? PlateformColorType
                    
                    // these values should always be defined
                    assert(value != nil)
                    assert(otherValue != nil)
                    if let value = value, let otherValue = otherValue, value != otherValue {
                        return false
                    }
                    
                case underlineStyleKey: fallthrough
                case strikethroughStyleKey: fallthrough
                case overlineStyleKey:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("value: %@", log: Log.Common.all, type: .info, %%value)
                    #endif
                    let value = value as? Int
                    let otherValue = otherValue as? Int
                    
                    assert(value != nil)
                    assert(otherValue != nil)
                    
                    if let value = value, let otherValue = otherValue, value != otherValue {
                        return false
                    }
                    
                case underlineStyleKey: fallthrough
                case strikethroughStyleKey: fallthrough
                case overlineStyleKey:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("value: %@", log: Log.Common.all, type: .info, %%value)
                    #endif
                    let value = value as? Int
                    let otherValue = otherValue as? Int
                    
                    assert(value != nil)
                    assert(otherValue != nil)
                    
                    if let value = value, let otherValue = otherValue, value != otherValue {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("different attributes for key: %@: own value: %@, other value: %@", log: Log.Common.all, type: .info, %%key, %%value, %%otherValue)
                        #endif
                        return false
                    }
                    
                case fontKey:

                    let value = value as? PlateformFontType
                    let otherValue = otherValue as? PlateformFontType
                    
                    assert(value != nil)
                    assert(otherValue != nil)
                    if let value = value, let otherValue = otherValue, value != otherValue {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("different attributes for key: %@: own value: %@, other value: %@", log: Log.Common.all, type: .info, %%key, %%value, %%otherValue)
                        #endif
                        return false
                    }
                    
                case headingTagBeforeKey: fallthrough
                case headingTagAfterKey:
                    
                    let compiledValue = value as? NSNumber
                    let expectedValue = otherValue as? NSNumber
                    
                    // these values should always be defined
                    assert(compiledValue != nil)
                    assert(expectedValue != nil)
                    if let compiledValue = compiledValue, let expectedValue = expectedValue, compiledValue != expectedValue {
                        return false
                    }
                
                case paragraphStyleKey:
                    // we don't care about paragraph style
                    break
                    
                default:
                    
                    assert(false)
                    return false
                }
            }
        }
        return true
    }
    
    fileprivate func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool? {
        guard let a = a as? T, let b = b as? T else { return nil }
        
        return a == b
    }
}


