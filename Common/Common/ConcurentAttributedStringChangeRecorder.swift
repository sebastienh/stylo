//
//  AttributedStringChangeRecorder.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-06-23.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import os

public final class ConcurentAttributedStringChangeRecorder: AttributesRecorder, DocumentAttributesContainer {
    
    public var completeRange: NSRange {
        return lock.withReadLock {
            return NSMakeRange(0, self._attributedString.length)
        }
    }
    
    public func setDocumentFont(fromAttributes attrs: [NSAttributedString.Key : Any]) {
        
        let font = attrs[NSAttributedString.Key.font] as? PlateformFontType
        
        assert(font != nil)
        if let font = font {
        
            assert(documentAttributes != nil)
            self.documentAttributes?.font = font
        }
    }
    
    public var spaceIncompatibleAttributes: [NSAttributedString.Key] = [
        NSAttributedString.Key.backgroundColor
    ]
    
    public var attributedString: NSMutableAttributedString {
        return lock.withReadLock {
            return _attributedString.mutableCopy() as! NSMutableAttributedString
        }
    }
    
    public var allAttributes: [([NSAttributedString.Key: Any], NSRange)] {
        return lock.withReadLock {
            return self._attributedString.attributes(in: NSMakeRange(0, self._attributedString.length))
        }
    }
    
    public var length: Int {
        return lock.withReadLock {
            return _length
        }
    }
    
    public var documentAttributes: DocumentAttributes? {
        get {
            return lock.withReadLock {
                return _documentAttributes
            }
        }
        set {
            lock.withWriteLock {
                self._documentAttributes = newValue
            }
        }
    }
    
    public var string: String {
        return lock.withReadLock {
            return _string
        }
    }
    
    private(set) var _attributedString: NSMutableAttributedString
    
    private var _documentAttributes: DocumentAttributes?
    
    private var _string: String
    
    private let lock: ReadWriteLock
    
    private var _length: Int {
        assert(_string.utf16.count == _attributedString.length)
        return _attributedString.length
    }
    
    public convenience init(string: String, visibleRange: NSRange? = nil) {
        
        self.init(string: NSAttributedString(string: string), visibleRange: visibleRange)
    }
    
    public init(string: NSAttributedString, visibleRange: NSRange? = nil) {
        
        self._string = string.string
        self._attributedString = string.mutableCopy() as! NSMutableAttributedString
        self.lock = ReadWriteLock()
    }
    
    private init(attributedString: NSAttributedString) {
        
        self._string = attributedString.string
        self._attributedString = attributedString.mutableCopy() as! NSMutableAttributedString
        self.lock = ReadWriteLock()
    }
    
    public func attributedSubstring(from range: NSRange) -> NSAttributedString {
        return lock.withReadLock {
            return self._attributedString.attributedSubstring(from: range)
        }
    }
    
    public func attributes(in range: NSRange) -> [([NSAttributedString.Key: Any], NSRange)] {
        return lock.withReadLock {
            return self._attributedString.attributes(in: range)
        }
    }
    
    public func lineRange(for range: NSRange) -> NSRange {
        return lock.withReadLock {
            return self._attributedString.mutableString.lineRange(for: range)
        }
    }
    
    public func setGlobalAttributes(_ attrs: [NSAttributedString.Key : Any]) {
        
        lock.writeLock()
        defer {lock.unlock()}

        self._attributedString = NSMutableAttributedString(string: self._attributedString.string, attributes: attrs)
        let font = attrs[NSAttributedString.Key.font] as? PlateformFontType

        assert(font != nil)
        if let font = font {

            assert(self._documentAttributes != nil)
            self._documentAttributes?.font = font
        }
    }
    
    public func spacesRange(after index: Int) -> NSRange? {
        
        return lock.withReadLock {
            
            // early exit when index is beyond lenght
            if index >= self.length {
                return nil
            }
            
            // early exit when first character is not a space
            if self._string.charAt(index) != 0x0020 {
                return nil
            }

            let space = Character(" ")
            let spacesSubstring = self._string.prefix(while: { $0 == space })
            let value = NSMakeRange(index, spacesSubstring.count)
            return value
        }
    }
    
    public func update(with sourceStringChangeDescription: SourceStringChangeDescription) {
        
        lock.withWriteLock {
        
            let stringReplacement = sourceStringChangeDescription.stringReplacement
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("stringReplacement: %@", log: Log.Common.all, type: .debug, String(describing: stringReplacement))
            os_log("self.string.utf16.count: %d", log: Log.Common.all, type: .debug, self.string.utf16.count)
            os_log("sourceStringChangeDescription.range.upperBound: %d", log: Log.Common.all, type: .debug, sourceStringChangeDescription.range.upperBound)
            os_log("actual string: %@", log: Log.Common.all, type: .debug, %%self.string)
            #endif
            
            assert(sourceStringChangeDescription.range.upperBound <= self._string.utf16.count)
            
            let utf16Start: String.UTF16View.Index = self._string.utf16.index(self._string.utf16.startIndex, offsetBy: sourceStringChangeDescription.range.lowerBound);
            let utf16End: String.UTF16View.Index = self._string.utf16.index(self._string.utf16.startIndex, offsetBy: sourceStringChangeDescription.range.upperBound)
            
            let start: String.Index? = utf16Start.samePosition(in: self._string)
            let end: String.Index? = utf16End.samePosition(in: self._string)
            
            assert(stringReplacement != nil)
            assert(start != nil)
            assert(end != nil)
            if let stringReplacement = stringReplacement, let start = start, let end = end {
                
                // the range in the SourceStringChangeDescription describe a utf16 range

                self._string.replaceSubrange(start..<end, with: stringReplacement)
                self._attributedString.replaceCharacters(in: sourceStringChangeDescription.range, with: stringReplacement)

                // for a temporary style we don't have a font value
                if let font = self._documentAttributes?.font {
                    let affectedRange = NSMakeRange(sourceStringChangeDescription.range.location, stringReplacement.utf16.count)
                    self._attributedString.setAttributes([.font: font], range: affectedRange)
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                
                let attributesRecorderString = self._attributedString.string
                let changedString = sourceStringChangeDescription.sourceString.string
                
                os_log("ChangedString: \n\"%@\"", log: Log.Common.all, type: .error, changedString)
                if attributesRecorderString != changedString {
                    
                    os_log("attributesRecorderString: \n\"%@\" is different from...", log: Log.Common.all, type: .error, attributesRecorderString)
                    os_log("...is different from changedString: \n\"%@\"", log: Log.Common.all, type: .error, changedString)
                    assert(false, "strings not in sync")
                }
                else {
                    os_log("attributesRecorderString: \n\"%@\" is same as changedString: \n\"%@\"", log: Log.Common.all, type: .info, attributesRecorderString, changedString)
                }
                #endif
            }
            else {
                assert(false)
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("stringReplacement replacement was nil.", log: Log.Common.all, type: .error)
                #endif
                
                // the SourceStringChangeDescription should contain the source attributed string changed
                // so we can just use it.
                self._string = sourceStringChangeDescription.targetString
                self._attributedString = sourceStringChangeDescription.targetString.mutableCopy() as! NSMutableAttributedString
            }
            
            if let addedRange = sourceStringChangeDescription.addedRange {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("setting nil attributes on range %@", log: Log.Common.all, type: .error, %%addedRange)
                #endif
                self._attributedString.setAttributes(nil, range: addedRange)
            }
        }
    }

    public func resetPermanentAttributes() {
        
        lock.writeLock()
        self._attributedString.setAttributes(nil, range: NSRange(0..<self._attributedString.length))
        lock.unlock()
    }
    
    public func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        
        lock.writeLock()
        assert(_isValidRange(range))
        if let attrs = attrs, range.length > 0 && self._attributedString.length > 0 {

            if range.location >= 0 && range.upperBound <= self._attributedString.length {

                self._attributedString.setAttributes(attrs, range: range)
            }
            else {

                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Setting attributes on invalid range %@, on string length %2", log: Log.Common.all, type: .error, %%range, self._attributedString.length)
                #endif
            }
        }
        lock.unlock()
    }
    
    public func addAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange) {

        lock.writeLock()
        assert(_isValidRange(range))
        if range.location >= 0 && range.upperBound <= self._attributedString.length {

            self._attributedString.addAttribute(name, value: value, range: range)
        }
        else {

            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Adding attribute on invalid range %@, on string length %2", log: Log.Common.all, type: .error, %%range, self._attributedString.length)
            #endif
        }
        lock.unlock()
    }
    
    public func addAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        
        lock.writeLock()
        assert(_isValidRange(range))
        if let attrs = attrs, range.length > 0 && self._attributedString.length > 0 {
        
            
            if range.location >= 0 && range.upperBound <= self._attributedString.length {
            
                self._attributedString.addAttributes(attrs, range: range)
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Adding attributes on invalid range %@, on string length %2", log: Log.Common.all, type: .error, %%range, self._attributedString.length)
                #endif
            }
        }
        lock.unlock()
    }
    
    public func removeAttribute(_ name: NSAttributedString.Key, range: NSRange) {
        
        lock.writeLock()
        assert(_isValidRange(range))
        if range.location >= 0 && range.upperBound <= self._attributedString.length {
            
            self._attributedString.removeAttribute(name, range: range)
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Removing attributes on invalid range %@, on string length %2", log: Log.Common.all, type: .error, %%range, self._attributedString.length)
            #endif
        }
        lock.unlock()
    }
    
    public func attribute(_ attr: NSAttributedString.Key, at location: Int, effectiveRange: NSRangePointer?) -> Any? {

        return lock.withReadLock {
            return _attribute(attr, at: location, effectiveRange: effectiveRange)
        }
    }
    
    public func _attribute(_ attr: NSAttributedString.Key, at location: Int, effectiveRange: NSRangePointer?) -> Any? {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self._attributedString.length: %d", log: Log.Common.all, type: .debug, self._attributedString.length)
        os_log("requested location: %d", log: Log.Common.all, type: .debug, location)
        #endif
        // if length is zero location can be equal to length
        assert(location >= 0 && location <= self._attributedString.length)
        if location != self._attributedString.length {
            return _attributedString.attribute(attr, at: location, effectiveRange: effectiveRange)
        }
        return [:]
    }
    
    public func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
     
        return lock.withReadLock {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("self._attributedString.length: %d", log: Log.Common.all, type: .debug, self._attributedString.length)
            os_log("requested location: %d", log: Log.Common.all, type: .debug, location)
            #endif
            // if length is zero location can be equal to length
            assert(location >= 0 && location <= self._attributedString.length)
            if location != self._attributedString.length {
                return _attributedString.attributes(at: location, effectiveRange: range)
            }
            return [:]
        }
    }
    
    public func debugPrintAttributesString(in range: NSRange? = nil) -> String {
        
        return lock.withReadLock {
            var _string = ""
            let _range: NSRange = range ?? NSMakeRange(0, _attributedString.length)
            
            _attributedString.enumerateAttribute(NSAttributedString.Key(rawValue: "AttributesStatus"), in: _range) {
                _value, __range, stop in
                if let _value = _value as? AttributesStatusValue {
                    _string += "AttriutesStatus value in range: \(NSStringFromRange(__range)): \(_value)\n"
                }
            }
            return _string
        }
    }
    
    public func hasDifferentAttributes(in range: NSRange, from attributes: [NSAttributedString.Key : Any], excludedAttributes: [NSAttributedString.Key]? = nil) -> Bool {
     
        return lock.withReadLock {
            return _attributedString.hasDifferentAttributes(in: range, from: attributes, excludedAttributes: excludedAttributes)
        }
    }
    
    public func hasSameAttributes(in range: NSRange, from attributes: [NSAttributedString.Key : Any], excludedAttributes: [NSAttributedString.Key]? = nil) -> Bool {
        
        return lock.withReadLock {
            return _attributedString.hasSameAttributes(in: range, from: attributes, excludedAttributes: excludedAttributes)
        }
    }
    
    public func differentAttributesRanges(in range: NSRange, from attributes: [NSAttributedString.Key : Any]) -> [NSRange] {
     
        return lock.withReadLock {
            return _attributedString.differentAttributesRanges(in: range, from: attributes)
        }
    }
    
    public func differentPermanentAttributesRanges(in range: NSRange, from attributes: [NSAttributedString.Key: Any]) -> [NSRange] {
        
        return lock.withReadLock {
            return _attributedString.differentPermanentAttributesRanges(in: range, from: attributes)
        }
    }
    
    public func containsAttribute(_ key: NSAttributedString.Key, in range: NSRange) -> Bool {
        
        return lock.withReadLock {
            return _attributedString.containsAttribute(key, in: range)
        }
    }
    
   public func substring(from range: NSRange) -> String? {
        
        return lock.withReadLock {
            assert(range.length >= 0)
            return self._string.substringWithUTF16Range(range)
        }
    }
    
    public var debugAttributesString: String {
        
        return lock.withReadLock {
            var debugAttributesString = ""
            self._attributedString.enumerateAttributes(in: NSMakeRange(0, _attributedString.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributes, range, stop) in
                
                debugAttributesString += "attributes: \(attributes) in range: \(range)"
            }
            return debugAttributesString
        }
    }
    
    public func isValidRange(_ range: NSRange) -> Bool {
        
        return lock.withReadLock {
            return _isValidRange(range)
        }
    }
    
    private func _isValidRange(_ range: NSRange) -> Bool {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self.length: %d", log: Log.Common.all, type: .debug, self.length)
        os_log("range.location: %d", log: Log.Common.all, type: .debug, range.location)
        #endif
        
        let length = self._length
        
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
        
        return lock.withReadLock {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Requesting spaces count from index: %d", log: Log.Common.stylableString, type: .info, index)
            #endif
            
            // early exit when index is beyond lenght
            if index >= self._length {
                return nil
            }
            
            if self._string.charAt(index) != 0x0020 {
                return nil
            }
            
            var index = index + 1
            var numberOfSpaces = 1
            
            while self._string.charAt(index) == 0x0020 {
                numberOfSpaces += 1
                index += 1
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Returning %d spaces count with end index: %d.", log: Log.Common.stylableString, type: .info, numberOfSpaces, index)
            #endif
            return numberOfSpaces
        }
    }
    
    public func spacesCount(before index: Int) -> Int? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Requesting spaces count before index: %d", log: Log.Common.stylableString, type: .info, index)
        #endif
        
        return lock.withReadLock {
        
            // early exit when index is 0 or below..
            assert(index >= 0)
            if index <= 0 {
                return nil
            }
            
            var index = index-1
            
            if self._string.charAt(index) != 0x0020 {
                return nil
            }
            
            var numberOfSpaces = 1
            index -= 1
            
            while self._string.charAt(index) == 0x0020 {
                numberOfSpaces += 1
                index -= 1
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Returning %d spaces count with start index: %d.", log: Log.Common.stylableString, type: .info, numberOfSpaces, index)
            #endif
            return numberOfSpaces
        }
    }
    
    public func differentAttributeRanges(in range: NSRange, from otherValue: Any, for attribute: NSAttributedString.Key) -> [NSRange]? {
                
        return lock.withReadLock {
        
            if range.isEmpty {
                return nil
            }
            
            var effectiveRange: NSRange = NSMakeRange(0, 0)
            var location = range.location
            var ranges = [NSRange]()
            
            while location < range.upperBound {
            
                if let currentValue = self._attribute(attribute, at: location, effectiveRange: &effectiveRange) {
                
                    if !self.attributeValuesEquals(key: attribute, value: currentValue, other: otherValue) {
                        
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

//
