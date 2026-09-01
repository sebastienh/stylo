//
//  AttributedStringChangeRecorder.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-06-23.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import os

public final class AttributedStringChangeRecorder: AttributesRecorder, DocumentAttributesContainer {
    
    public var spaceIncompatibleAttributes: [NSAttributedString.Key] = [
        NSAttributedString.Key.backgroundColor
    ]
    
    public var attributedString: NSMutableAttributedString {
        return _attributedString
    }
    
    private var _attributedString: NSMutableAttributedString
    
    @objc dynamic public var documentAttributes: DocumentAttributes?
    
    public var string: String {
        return _string
    }
    
    private var _string: String
    
    public var allAttributes: [([NSAttributedString.Key: Any], NSRange)] {
        return self._attributedString.attributes(in: NSMakeRange(0, self._attributedString.length))
    }
    
    public var length: Int {
        return _length
    }
    
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
    }
    
    private init(attributedString: NSAttributedString) {
        
        self._string = attributedString.string
        self._attributedString = attributedString.mutableCopy() as! NSMutableAttributedString
    }
    
    public func attributes(in range: NSRange) -> [([NSAttributedString.Key: Any], NSRange)] {
        return self._attributedString.attributes(in: range)
    }
    
    public func lineRange(for range: NSRange) -> NSRange {
        return self._attributedString.mutableString.lineRange(for: range)
    }
    
    public func setGlobalAttributes(_ attrs: [NSAttributedString.Key : Any]) {
            
        assert(_string.utf16.count == _attributedString.length)
        self._attributedString.setAttributes(attrs, range: NSMakeRange(0, _attributedString.length))
        self.setDocumentFont(fromAttributes: attrs)
    }

    public func setDocumentFont(fromAttributes attrs: [NSAttributedString.Key : Any]) {
            
        let font = attrs[NSAttributedString.Key.font] as? PlateformFontType
        
        assert(font != nil)
        if let font = font {
        
            assert(documentAttributes != nil)
            self.documentAttributes?.font = font
        }
    }
    
    public func spacesRange(after index: Int) -> NSRange? {
        
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
        return NSMakeRange(index, spacesSubstring.count)
    }
    
    public func update(with sourceStringChangeDescription: SourceStringChangeDescription) {
            
        let stringReplacement = sourceStringChangeDescription.stringReplacement
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("stringReplacement: %@", log: Log.Common.all, type: .debug, describing: stringReplacement)
        os_log("self.string.utf16.count: %d", log: Log.Common.all, type: .debug, self.string.utf16.count)
        os_log("sourceStringChangeDescription.range.upperBound: %d", log: Log.Common.all, type: .debug, sourceStringChangeDescription.range.upperBound)
        os_log("actual string: %@", log: Log.Common.all, type: .debug, %%self.string)
        #endif
        
        assert(sourceStringChangeDescription.range.upperBound <= self._string.utf16.count)
        
        let utf16Start: String.UTF16View.Index = self._string.utf16.index(self._string.utf16.startIndex, offsetBy: sourceStringChangeDescription.range.lowerBound);
        let utf16End: String.UTF16View.Index = self.string.utf16.index(self.string.utf16.startIndex, offsetBy: sourceStringChangeDescription.range.upperBound)
        
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
            if let font = self.documentAttributes?.font {
                let affectedRange = NSMakeRange(sourceStringChangeDescription.range.location, stringReplacement.utf16.count)
                self._attributedString.setAttributes([.font: font], range: affectedRange)
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            
            let attributesRecorderString = self._attributedString.string
            let changedString = sourceStringChangeDescription.targetString.string
            
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
            self._string = sourceStringChangeDescription.targetString.string
            self._attributedString = sourceStringChangeDescription.targetString.mutableCopy() as! NSMutableAttributedString
        }
        
        if let addedRange = sourceStringChangeDescription.addedRange {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("setting nil attributes on range %@", log: Log.Common.all, type: .error, %%addedRange)
            #endif
            self._attributedString.setAttributes(nil, range: addedRange)
        }
    }

    public func resetPermanentAttributes() {
        
        _attributedString.setAttributes(nil, range: NSRange(0..<_attributedString.length))
    }
    
    public func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
            
        if let attrs = attrs, range.length > 0 && self._attributedString.length > 0 {
            
            assert(isValidRange(range))
            if range.location >= 0 && range.upperBound <= self._attributedString.length {
                _attributedString.setAttributes(attrs, range: range)
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Setting attributes on invalid range %@, on string length %2", log: Log.Common.all, type: .error, %%range, self._attributedString.length)
                #endif
            }
        }
    }
    
    public func addAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange) {
        
        assert(isValidRange(range))
        if range.location >= 0 && range.upperBound <= self._attributedString.length {
            
            _attributedString.addAttribute(name, value: value, range: range)
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Adding attribute on invalid range %@, on string length %2", log: Log.Common.all, type: .error, %%range, self._attributedString.length)
            #endif
        }
    }
    
    public func addAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        
        assert(isValidRange(range))
        if let attrs = attrs, range.length > 0 && self._attributedString.length > 0 {
        
            
            if range.location >= 0 && range.upperBound <= self._attributedString.length {
            
                _attributedString.addAttributes(attrs, range: range)
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Adding attributes on invalid range %@, on string length %2", log: Log.Common.all, type: .error, %%range, self._attributedString.length)
                #endif
            }
        }
    }
    
    public func removeAttribute(_ name: NSAttributedString.Key, range: NSRange) {
        
        assert(isValidRange(range))
        if range.location >= 0 && range.upperBound <= self._attributedString.length {
            
            _attributedString.removeAttribute(name, range: range)
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Removing attributes on invalid range %@, on string length %2", log: Log.Common.all, type: .error, %%range, self._attributedString.length)
            #endif
        }
    }
    
    public func attribute(_ attr: NSAttributedString.Key, at location: Int, effectiveRange: NSRangePointer?) -> Any? {
        
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
    
    public func copy() -> AttributedStringChangeRecorder {
        
        return AttributedStringChangeRecorder(attributedString: self._attributedString)
    }
    
    
    public func debugPrintAttributesString(in range: NSRange? = nil) -> String {
        
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
    
    public func hasDifferentAttributes(in range: NSRange, from attributes: [NSAttributedString.Key : Any], excludedAttributes: [NSAttributedString.Key]? = nil) -> Bool {
     
        return _attributedString.hasDifferentAttributes(in: range, from: attributes, excludedAttributes: excludedAttributes)
    }
    
    public func hasSameAttributes(in range: NSRange, from attributes: [NSAttributedString.Key : Any], excludedAttributes: [NSAttributedString.Key]? = nil) -> Bool {
            
        return _attributedString.hasSameAttributes(in: range, from: attributes, excludedAttributes: excludedAttributes)
    }
    
    public func differentAttributesRanges(in range: NSRange, from attributes: [NSAttributedString.Key : Any]) -> [NSRange] {
     
        return _attributedString.differentAttributesRanges(in: range, from: attributes)
    }
    
    public func differentPermanentAttributesRanges(in range: NSRange, from attributes: [NSAttributedString.Key: Any]) -> [NSRange] {
        
        return _attributedString.differentPermanentAttributesRanges(in: range, from: attributes)
    }
    
    public func containsAttribute(_ key: NSAttributedString.Key, in range: NSRange) -> Bool {
        
        return _attributedString.containsAttribute(key, in: range)
    }
    
}

