//
//  StylableString.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-08-18.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import os

/// A StylableString defines methods which are mostly there to handle the
/// attributes of the string. This class exist in order for the NSMutableAttributedString
/// from the using framework (UIKit or AppKit) to create extension for the corresponding
/// implementations.
///
/// It allows to manipulate the NSMutableAttributedString regardless of it's implementation.
public protocol StylableString: class {
    
    var string: String { get }
    
    var length: Int { get }
    
    var completeRange: NSRange { get }
    
    var documentAttributes: DocumentAttributes? { get set }
    
    var debugAttributesString: String { get }
    
    var attributedString: NSMutableAttributedString { get }
    
    var allAttributes: [([NSAttributedString.Key: Any], NSRange)] { get }
    
    func attributedSubstring(from range: NSRange) -> NSAttributedString
    
    func attributes(in range: NSRange) -> [([NSAttributedString.Key: Any], NSRange)]
    
    func lineRange(for range: NSRange) -> NSRange
    
    func substring(from range: NSRange) -> String?
    
    func spacesCount(from index: Int) -> Int?
    
    func spacesCount(before index: Int) -> Int?
    
    func isValidRange(_ range: NSRange) -> Bool
    
    func update(with sourceStringChangeDescription: SourceStringChangeDescription)
    
    func setDocumentFont(fromAttributes attrs: [NSAttributedString.Key : Any])
    
    func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange)
    
    func addAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange)
    
    func addAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange)
    
    func removeAttribute(_ name: NSAttributedString.Key, range: NSRange)
    
    func setGlobalAttributes(_ attrs: [NSAttributedString.Key : Any])
    
    func attribute(_ : NSAttributedString.Key, at: Int, effectiveRange: NSRangePointer?) -> Any?
    
    func containsAttribute(_ key: NSAttributedString.Key, in range: NSRange) -> Bool 
    
    func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any]
    
    func hasDifferentAttributes(in range: NSRange, from attributes: [NSAttributedString.Key : Any], excludedAttributes: [NSAttributedString.Key]?) -> Bool
    
    func hasSameAttributes(in range: NSRange, from attributes: [NSAttributedString.Key : Any], excludedAttributes: [NSAttributedString.Key]?) -> Bool
    
    func differentAttributeRanges(in range: NSRange, from otherValue: Any, for attribute: NSAttributedString.Key) -> [NSRange]?
    
    func differentAttributesRanges(in range: NSRange, from attributes: [NSAttributedString.Key: Any]) -> [NSRange]
    
    func differentPermanentAttributesRanges(in range: NSRange, from attributes: [NSAttributedString.Key: Any]) -> [NSRange]
}

extension StylableString where Self == AttributedStringChangeRecorder {
    
    public var completeRange: NSRange {
        
        return NSMakeRange(0, self.attributedString.length)
    }
    
    public func attributedSubstring(from range: NSRange) -> NSAttributedString {
        
        return self.attributedString.attributedSubstring(from: range)
    }
    
    public func substring(from range: NSRange) -> String? {
        
        assert(range.length >= 0)
        return string.substringWithUTF16Range(range)
    }
    
    public var debugAttributesString: String {
        
        var debugAttributesString = ""
        
        let attributedString = self.attributedString
        attributedString.enumerateAttributes(in: NSMakeRange(0, attributedString.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributes, range, stop) in
            
            debugAttributesString += "attributes: \(attributes) in range: \(range)"
        }
        return debugAttributesString
    }
    
    public func isValidRange(_ range: NSRange) -> Bool {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self.length: %d", log: Log.Common.all, type: .debug, self.length)
        os_log("range.location: %d", log: Log.Common.all, type: .debug, range.location)
        #endif
        
        let length = self.length
        
        // if length is zero location can be equal to length
        assert(range.location >= 0 && range.location <= length)

        if range.location < 0 {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("range.location: %d", log: Log.Common.stylableString, type: .debug, range.location)
            #endif
            assert(false)
            return false
        }
        if range.location + range.length > length {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("range.location + range.length: %d", log: Log.Common.stylableString, type: .debug, range.location + range.length)
            os_log("length: %d", log: Log.Common.stylableString, type: .debug, length)
            #endif
            assert(false)
            return false
        }
        return true
    }
    
    public func spacesCount(from index: Int) -> Int? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Requesting spaces count from index: %d", log: Log.Common.stylableString, type: .info, index)
        #endif
        
        // early exit when index is beyond lenght
        if index >= self.length {
            return nil
        }
        
        if self.string.charAt(index) != 0x0020 {
            return nil
        }
        
        var index = index + 1
        var numberOfSpaces = 1
        
        while self.string.charAt(index) == 0x0020 {
            numberOfSpaces += 1
            index += 1
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Returning %d spaces count with end index: %d.", log: Log.Common.stylableString, type: .info, numberOfSpaces, index)
        #endif
        return numberOfSpaces
    }
    
    public func spacesCount(before index: Int) -> Int? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Requesting spaces count before index: %d", log: Log.Common.stylableString, type: .info, index)
        #endif
        
        // early exit when index is 0 or below..
        assert(index >= 0)
        if index <= 0 {
            return nil
        }
        
        var index = index-1
        
        if self.string.charAt(index) != 0x0020 {
            return nil
        }
        
        var numberOfSpaces = 1
        index -= 1
        
        while self.string.charAt(index) == 0x0020 {
            numberOfSpaces += 1
            index -= 1
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Returning %d spaces count with start index: %d.", log: Log.Common.stylableString, type: .info, numberOfSpaces, index)
        #endif
        return numberOfSpaces
    }
    
    public func differentAttributeRanges(in range: NSRange, from otherValue: Any, for attribute: NSAttributedString.Key) -> [NSRange]? {
        
        if range.isEmpty {
            return nil
        }
        
        var effectiveRange: NSRange = NSMakeRange(0, 0)
        var location = range.location
        var ranges = [NSRange]()
        
        while location < range.upperBound {
        
            if let currentValue = self.attribute(attribute, at: location, effectiveRange: &effectiveRange) {
            
                if !attributeValuesEquals(key: attribute, value: currentValue, other: otherValue) {
                    
                    if effectiveRange.upperBound > range.upperBound {
                        
                        let length = range.upperBound - effectiveRange.location
                        effectiveRange.length = length
                        ranges.append(effectiveRange)
                        break
                    }
                    else if effectiveRange.upperBound == range.upperBound {
                        
                        ranges.append(effectiveRange)
                        break
                    }
                    else {
                        ranges.append(effectiveRange)
                        location = effectiveRange.upperBound
                    }
                }
                else {
                    break
                }
            }
            else {
                ranges.append(NSMakeRange(location, 1))
                location += 1
            }
        }
        return ranges
    }
    
    private func attributeValuesEquals(key: NSAttributedString.Key, value: Any, other: Any) -> Bool {
            
        switch key {
            
        case NSAttributedString.Key.foregroundColor: fallthrough
        case NSAttributedString.Key.underlineColor: fallthrough
        case NSAttributedString.Key(rawValue: §StyloAttribute.overlineColor): fallthrough
        case NSAttributedString.Key(rawValue: §StyloAttribute.strikethroughColor): fallthrough
        case NSAttributedString.Key.backgroundColor:
            
            let value = value as? PlateformColorType
            let _value = other as? PlateformColorType
            
            assert(value != nil)
            assert(_value != nil)
            if let value = value, let _value = _value, value != _value {
                
                return false
            }
            
        case NSAttributedString.Key.underlineStyle: fallthrough
        case NSAttributedString.Key.strikethroughStyle: fallthrough
        case NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle):
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("value: %@", log: Log.Common.all, type: .info, %%value)
            #endif
            let value = value as? Int
            let _value = other as? Int
            
            assert(value != nil)
            assert(_value != nil)
            
            if let value = value, let _value = _value, value != _value {
                return false
            }
            
        case NSAttributedString.Key.font:
            
            let value = value as? PlateformFontType
            let _value = other as? PlateformFontType
            
            assert(value != nil)
            assert(_value != nil)
            if let value = value, let _value = _value, value != _value {
                
                return false
            }
            
        case StyloAttribute.headingTagBefore.key: fallthrough
        case StyloAttribute.headingTagAfter.key:
            
            let compiledValue = value as? NSNumber
            let expectedValue = other as? NSNumber
            
            // these values should always be defined
            assert(compiledValue != nil)
            assert(expectedValue != nil)
            if let compiledValue = compiledValue, let expectedValue = expectedValue, compiledValue != expectedValue {
                
                return false
            }
        
        case NSAttributedString.Key.paragraphStyle:
            // we don't care about paragraph style
            break
            
        default:
            assert(false)
            return false
        }
        return true
    }
    
}
