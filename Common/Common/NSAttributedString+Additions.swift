//
//  NSAttributedString+Additions.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-01-10.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import os

extension NSAttributedString {
    
    public static var spaceIncompatibleAttributes: [NSAttributedString.Key] = [
        StyloAttribute.headingTagAfter.key,
        StyloAttribute.headingTagBefore.key,
        NSAttributedString.Key.backgroundColor
    ]
    
    /// Return the attributes and their ranges in the current attributed string.
    public func attributes(in range: NSRange) -> [([NSAttributedString.Key: Any], NSRange)] {
        
        var attributesRanges = [([NSAttributedString.Key: Any], NSRange)]()
    
        var index = range.location
        
        while index < range.location + range.length {
            
            // get the attributes in the current attributed string
            var stringRange: NSRange = NSMakeRange(index, 1)
            let attributesInRange = attributes(at: index, longestEffectiveRange: &stringRange, in: range)
            
            attributesRanges.append((attributesInRange, stringRange))
        
            if stringRange.length > 0 {
                index += stringRange.length
            }
            else {
                index += 1
            }
        }
        return attributesRanges
    }
    
    /// Method that scan the range parameter of the current NSAttributedString
    /// to find all the ranges where the attribute parameter has been set 
    /// and return an array of range where this attribute is not present.
    public func rangesNotContaining(_ attribute: String, in range: NSRange) -> [NSRange] {
        
        var containingRanges = [NSRange]()
        
        enumerateAttribute(NSAttributedString.Key(rawValue: attribute), in: range ) {
            value, range, stop in
            if let _ = value {
                containingRanges.append(range)
            }
        }
        return range.substractsRanges(containingRanges)
    }
    
    /// This method returns an array of ranges in the
    /// target NSAttributedString which contains
    /// different attributes from the attribues parameter.
    public func differentAttributesRanges(in range: NSRange, from attributes: [NSAttributedString.Key: Any], shouldStop: Bool = true) -> [NSRange] {
        
        var changedAttributesRanges = [NSRange]()
        
        let updatedRange: NSRange = {
            let upperBound = min(range.upperBound, self.length)
            if upperBound != range.upperBound {
                os_log("Error: requested out of bounds range: %@, %@", log: Log.Common.all, type: .error, %%range.upperBound, %%self.length)
                assertionFailure("Error: requested out of bounds range: \(range.upperBound), \(self.length)")
            }
            return NSMakeRange(range.location, upperBound-range.location)
        }()
        
        self.enumerateAttributes(in: updatedRange, options: NSAttributedString.EnumerationOptions.reverse) { (_attributes, _range, stop) in
            
            if !attributes.equals(to: _attributes) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("different attributes for substring: %@", log: Log.Common.all, type: .info, %%self.string.substringWithUTF16Range(_range)!)
                #endif
                
                if shouldStop {
                    changedAttributesRanges.append(range)
                    stop.pointee = true
                }
                else {
                    changedAttributesRanges.append(_range)
                }
            }
        }
        return changedAttributesRanges
    }
    
    /// This method returns an array of ranges in the
    /// target NSAttributedString which contains
    /// different attributes from the attribues parameter.
    public func differentPermanentAttributesRanges(in range: NSRange, from attributes: [NSAttributedString.Key: Any], shouldStop: Bool = true) -> [NSRange] {
        
        var changedAttributesRanges = [NSRange]()
        
        let updatedRange: NSRange = {
            let upperBound = min(range.upperBound, self.length)
            if upperBound != range.upperBound {
                os_log("Error: requested out of bounds range: %@, %@", log: Log.Common.all, type: .error, %%range.upperBound, %%self.length)
                assertionFailure("Error: requested out of bounds range: \(range.upperBound), \(self.length)")
            }
            return NSMakeRange(range.location, upperBound-range.location)
        }()
        
        self.enumerateAttributes(in: updatedRange, options: NSAttributedString.EnumerationOptions.reverse) { (_attributes, _range, stop) in
            
            let permanentAttributes = attributes.filter { (element) -> Bool in
                return !element.key.isTemporary && element.key != .paragraphStyle
            }
            
            let _permanentAttributes = _attributes.filter { (element) -> Bool in
                return !element.key.isTemporary && element.key != .paragraphStyle
            }
            
            if !permanentAttributes.equals(to: _permanentAttributes) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("different attributes for substring: %@", log: Log.Common.all, type: .info, %%self.string.substringWithUTF16Range(_range)!)
                #endif
                
                if shouldStop {
                    changedAttributesRanges.append(range)
                    stop.pointee = true
                }
                else {
                    changedAttributesRanges.append(_range)
                }
            }
        }
        return changedAttributesRanges
    }
    
    /// This method returns an array of ranges in the
    /// target NSAttributedString which contains
    /// different attributes from the attribues parameter.
    public func differentTemporaryAttributesRanges(in range: NSRange, from attributes: [NSAttributedString.Key: Any], shouldStop: Bool = true) -> [NSRange] {
        
        var changedAttributesRanges = [NSRange]()
        
        self.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions.reverse) { (_attributes, _range, stop) in
            
            let temporaryAttributes = attributes.filter { (element) -> Bool in
                return element.key.isTemporary
            }
            
            let _temporaryAttributes = _attributes.filter { (element) -> Bool in
                return element.key.isTemporary
            }
            
            if !temporaryAttributes.equals(to: _temporaryAttributes) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("different attributes for substring: %@", log: Log.Common.all, type: .info, %%self.string.substringWithUTF16Range(_range)!)
                #endif
                
                if shouldStop {
                    changedAttributesRanges.append(range)
                    stop.pointee = true
                }
                else {
                    changedAttributesRanges.append(_range)
                }
            }
        }
        return changedAttributesRanges
    }
    
    
    public func containsAttribute(_ key: NSAttributedString.Key, in range: NSRange) -> Bool {
        
        var contains = false
        
        self.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions.reverse) { (attributes, _range, stop) in
            
            if attributes.index(forKey: key) != nil {
            
                contains = true
                stop.pointee = true
            }
        }
        return contains
    }
    
    /// Method 
    public func differentAttributesRanges(from otherAttributedString: NSAttributedString, in ranges: [NSRange]) -> [([NSAttributedString.Key: Any], NSRange)]  {
        
        // changed string should have been updated to match the currentString
        assert(otherAttributedString.length == length, "expected length \(length), received: \(otherAttributedString.length)")
        
        var changedAttributesRanges = [([NSAttributedString.Key: Any], NSRange)]()
        
        for range in ranges {
            
            var index = range.location
        
            while index < range.location + range.length {
            
                // get the attributes in the other attributed string
                var changedStringRange: NSRange = NSMakeRange(index, 1)
                let changedAttributes = otherAttributedString.attributes(at: index, longestEffectiveRange: &changedStringRange, in: range)
                
                // get the attributes in the current attributed string
                var currentStringRange: NSRange = NSMakeRange(index, 1)
                let currentAttributes = attributes(at: index, longestEffectiveRange: &currentStringRange, in: range)
                
                // add the 
                if !NSDictionary(dictionary: changedAttributes).isEqual(to: currentAttributes)
                    || changedStringRange.length != currentStringRange.length {
                
                    changedAttributesRanges.append((changedAttributes, changedStringRange))
                }
            
                if changedStringRange.length > 0 {
                
                    index += changedStringRange.length
                }
                else {
                
                    index += 1
                }
            }
        }
        return changedAttributesRanges
    }
    
    /// Function that compare if the attributes in a certain range
    /// are the same as the ones in the parameter
    public func hasDifferentAttributes(in range: NSRange, from attributes: [NSAttributedString.Key: Any], excludedAttributes: [NSAttributedString.Key]? = nil) -> Bool {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("requested index: %d", log: Log.Common.all, type: .info, range.location)
        #endif
        
        let index = range.location
        
        if index >= self.length {
            return true
        }
        
        var effectiveRange: NSRange = NSMakeRange(index, 0)
        var ownAttributes = self.attributes(at: index, effectiveRange: &effectiveRange)
        
        // take a copy since we may modify it
        var _attributes = attributes
        
        // remove the excluded attributes
        if let excludedAttributes = excludedAttributes {
            
            for excludedAttribute in excludedAttributes {
                _attributes.removeValue(forKey: excludedAttribute)
                ownAttributes.removeValue(forKey: excludedAttribute)
            }
        }
        
        // compare the attributes, if they are the same, we must test if they extend
        // to the same range
        if NSDictionary(dictionary: attributes).isEqual(to: NSDictionary(dictionary: ownAttributes)) {
            
            if effectiveRange.length < range.length {
                return true
            }
            else {
                return false
            }
        }
        else {
            return true
        }
    }
    
    public func hasSameAttributes(in range: NSRange, from attributes: [NSAttributedString.Key : Any], excludedAttributes: [NSAttributedString.Key]? = nil) -> Bool {
        
        let index = range.location
        var effectiveRange: NSRange = NSMakeRange(index, 1)
        var ownAttributes = self.attributes(at: index, effectiveRange: &effectiveRange)
        
        // take a copy since we may modify it
        var _attributes = attributes
        
        // remove the excluded attributes
        if let excludedAttributes = excludedAttributes {
            
            for excludedAttribute in excludedAttributes {
                _attributes.removeValue(forKey: excludedAttribute)
                ownAttributes.removeValue(forKey: excludedAttribute)
            }
        }
        
        // compare the attributes, if they are the same, we must test if they extend
        // to the same range
        if NSDictionary(dictionary: attributes).isEqual(to: NSDictionary(dictionary: ownAttributes)) {
            
            if effectiveRange.length < range.length {
                return false
            }
            else {
                return true
            }
        }
        else {
            return false
        }
    }
}
