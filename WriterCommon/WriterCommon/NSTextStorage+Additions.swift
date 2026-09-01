//
//  NSTextStorage+Additions.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-06-23.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

extension NSTextStorage {
    
    public func isHeader(inLineContainingRange range: NSRange) -> Bool {
        
        let string: NSString = self.string as NSString
        let linesRange = string.lineRange(for: range)
        
        if let string = self.string.substringWithUTF16Range(linesRange) {
            
            let rangesOfLines = string.linesRanges()
            
            // If there is only one line selected, we simply switch on or off
            if rangesOfLines.count == 1 || rangesOfLines.count == 0 {
                if rangesOfLines.count == 1 {
                    let rangesOfLine = rangesOfLines.first!
                    if let _ = string.headingRange(from: rangesOfLine) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    public func moveCursorToEndOfHiddenHeaderTag(from location: Int, in textView: NSTextView) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("moveCursorToEndOfHiddenHeaderTag(from: %@, in: %@)", log: Log.WriterCommon.all, type: .info, %%location, %%textView)
        #endif
        
        let positionAtEndOfHiddenHeaderTag = self.positionAtEndOfHiddenHeaderTag(from: location, in: textView)
        let selectionRange = NSMakeRange(positionAtEndOfHiddenHeaderTag, 0)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("moveCursorToEndOfHiddenHeaderTag -> new selectionRange: %@", log: Log.WriterCommon.all, type: .info, %%location)
        #endif
        
        textView.setSelectedRange(selectionRange)
    }
    
    public func positionAtEndOfHiddenHeaderTag(from location: Int, in textView: NSTextView) -> Int {
        
        var longestEffectiveRange: NSRange = NSMakeRange(0, 0)
        attribute(StyloAttribute.headingTagBefore.key, at: location, longestEffectiveRange: &longestEffectiveRange, in: NSMakeRange(0, self.length))
        return longestEffectiveRange.upperBound
    }
    
    public func moveCursorBeforeHiddenHeaderTag(from location: Int, in textView: NSTextView) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("moveCursorBeforeHiddenHeaderTag(from: %@, in: %@)", log: Log.WriterCommon.all, type: .info, %%location, %%textView)
        #endif
        
        let positionBeforeHiddenHeaderTag = self.positionBeforeHiddenHeaderTag(from: location, in: textView)
        let selectionRange = NSMakeRange(positionBeforeHiddenHeaderTag, 0)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("moveCursorBeforeHiddenHeaderTag -> new selectionRange: %@", log: Log.WriterCommon.all, type: .info, %%location)
        #endif
        
        textView.setSelectedRange(selectionRange)
    }
    
    public func positionBeforeHiddenHeaderTag(from location: Int, in textView: NSTextView) -> Int {
        
        var longestEffectiveRange: NSRange = NSMakeRange(0, 0)
        attribute(StyloAttribute.headingTagBefore.key, at: location, longestEffectiveRange: &longestEffectiveRange, in: NSMakeRange(0, self.length))
        
        if longestEffectiveRange.location-1 >= 0 {
            return longestEffectiveRange.location-1
        }
        else {
            return longestEffectiveRange.location
        }
    }
    
    public func positionBeforeHiddenHeaderTag(fromLocationAfterTag location: Int, in textView: NSTextView) -> Int {
        
        guard location > 0 else {
            return location
        }
        
        var longestEffectiveRange: NSRange = NSMakeRange(0, 0)
        guard attribute(StyloAttribute.headingTagBefore.key, at: location-1, longestEffectiveRange: &longestEffectiveRange, in: NSMakeRange(0, self.length)) != nil else {
            assertionFailure("Error: no heading tag at location: \(location)")
            return location
        }
        
        if longestEffectiveRange.location-1 >= 0 {
            return longestEffectiveRange.location-1
        }
        else {
            return longestEffectiveRange.location
        }
    }
    
    public func isCursorInsideHeaderTag(at location: Int) -> Bool {
        
        if location == self.length {
            return false
        }
        
        let afterIsHeaderTag = attribute(StyloAttribute.headingTagBefore.key, at: location, longestEffectiveRange: nil, in: NSMakeRange(0, self.length)) != nil
        
        if location == 0 {
            return afterIsHeaderTag
        }
        
        let beforeIsHeaderTag = attribute(StyloAttribute.headingTagBefore.key, at: location-1, longestEffectiveRange: nil, in: NSMakeRange(0, self.length)) != nil
        
        return beforeIsHeaderTag && afterIsHeaderTag
    }
    
    public func isCursorAtHeaderTagEnd(at location: Int) -> Bool {
        
        if location == 0 {
            return false
        }
        
        let beforeIsHeaderTag = attribute(StyloAttribute.headingTagBefore.key, at: location-1, longestEffectiveRange: nil, in: NSMakeRange(0, self.length)) != nil
        
        if location == self.length {
            return beforeIsHeaderTag
        }
        
        let atIsHeaderTag = attribute(StyloAttribute.headingTagBefore.key, at: location, longestEffectiveRange: nil, in: NSMakeRange(0, self.length)) != nil
        
        return beforeIsHeaderTag && !atIsHeaderTag
    }
    
    public func headerTagValue(at location: Int) -> Int? {
        
        let attribute = self.attribute(StyloAttribute.headingTagBefore.key, at: location, longestEffectiveRange: nil, in: NSMakeRange(0, self.length))
        
        guard let number = attribute as? NSNumber else {
            assertionFailure("Error: headingTagBefore not NSNumber")
            return nil
        }
        
        return number.intValue
    }
    
    public func isWhitespace(at location: Int) -> Bool {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("isWhitespace(at: %@)", log: Log.WriterCommon.all, type: .debug, %%location)
        #endif
        
        guard location != self.length else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("isWhitespace -> false", log: Log.WriterCommon.all, type: .debug)
            #endif
            return false
        }
        
        guard let char = string.charAt(location) else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("isWhitespace -> false", log: Log.WriterCommon.all, type: .debug)
            #endif
            return false
        }
        
        if char == §UnicodeCharacter.whitespace || char == §UnicodeCharacter.characterTabulation {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("isWhitespaceOrNewLine -> true", log: Log.WriterCommon.all, type: .debug)
            #endif
            return true
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("isWhitespaceOrNewLine -> false", log: Log.WriterCommon.all, type: .debug)
        #endif
        return false
    }
    
    public func isNewLine(at location: Int) -> Bool {
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("isNewLine(at: %@)", log: Log.WriterCommon.all, type: .debug, %%location)
        #endif
        
        guard location != self.length else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("isNewLine -> false", log: Log.WriterCommon.all, type: .debug)
            #endif
            return false
        }
        
        guard let char = string.charAt(location) else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("isNewLine -> false", log: Log.WriterCommon.all, type: .debug)
            #endif
            return false
        }
        
        if char == §UnicodeCharacter.lineFeed {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("isNewLine -> true", log: Log.WriterCommon.all, type: .debug)
            #endif
            return true
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("isNewLine -> false", log: Log.WriterCommon.all, type: .debug)
        #endif
        return false
    }
    
    public func isWhitespaceOrNewLine(at location: Int) -> Bool {
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("isWhitespaceOrNewLine(at: %@)", log: Log.WriterCommon.all, type: .debug, %%location)
        #endif
    
        return self.isWhitespace(at: location) || self.isNewLine(at: location)
    }
        
    public func isHeaderTagStart(at location: Int) -> Bool {
        
        if location == self.length {
            return false
        }
        
        let atIsHeaderTag = attribute(StyloAttribute.headingTagBefore.key, at: location, longestEffectiveRange: nil, in: NSMakeRange(0, self.length)) != nil
        
        if location == 0 {
            return atIsHeaderTag
        }
        
        let beforeIsHeaderTag = attribute(StyloAttribute.headingTagBefore.key, at: location-1, longestEffectiveRange: nil, in: NSMakeRange(0, self.length)) != nil
        
        return !beforeIsHeaderTag && atIsHeaderTag
    }
    
    public var range: NSRange {
        
        return NSMakeRange(0, self.length)
    }
    
    public func trim(range: NSRange) -> NSRange? {
        
        // error cases
        if range.lowerBound >= self.length
            || range.upperBound > self.length
            || range.lowerBound < 0
            || range.upperBound <= 0 {
            
            return nil
        }
        
        if self.length == 0
            || range.isEmpty {
            
            return range
        }
        
        var totalNumberOfSpaces = 0
        let numberOfHeadSpaces = self.numberOfHeadSpaces(from: range.location, to: range.upperBound)
        totalNumberOfSpaces += numberOfHeadSpaces
        
        if totalNumberOfSpaces < range.length {
            let numberOfTailSpaces = self.numberOfTailSpaces(from: range.upperBound, to: range.lowerBound)
            totalNumberOfSpaces += numberOfTailSpaces
        }
        
        assert(totalNumberOfSpaces <= range.length)
        return  NSMakeRange(range.location + numberOfHeadSpaces, range.length - totalNumberOfSpaces)
    }
    
    // change the implementation of fixAttributes...
    @objc func emptyFixParagraphStyleAttribute(in: NSRange) {
        
        // nothing
    }
    
    private static let swizzleFixParagraphStyleAttributeImplementation: Void = {
        
        let textStorageClass: AnyClass! = object_getClass(NSTextStorage())
        let originalMethod = class_getInstanceMethod(textStorageClass, #selector(fixParagraphStyleAttribute(in:)))
        let swizzledMethod = class_getInstanceMethod(textStorageClass, #selector(emptyFixParagraphStyleAttribute(in:)))
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            // switch implementation..
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()
    
    public static func swizzleFixParagraphAttributes() {
        
        _ = self.swizzleFixParagraphStyleAttributeImplementation
    }
    
    public func isStartOfFencedCode(before index: Int) -> Bool {
        
        var index = index
        let string = self.mutableString
        var concecutiveGraveAccentsCount = 0
        var lastGraveAccentIndex = -1
        
        while let char = string.charAt(index) {
            
            if char == §UnicodeCharacter.graveAccent {
                concecutiveGraveAccentsCount += 1
                
                if concecutiveGraveAccentsCount > 3 {
                    return false
                }
                
                if lastGraveAccentIndex != index+1 {
                    return false
                }
                
                lastGraveAccentIndex = index
            }
            else if char == §UnicodeCharacter.lineFeed {
                if concecutiveGraveAccentsCount == 3 {
                    return true
                }
            }
            
            index -= 1
        }
        return false
    }
    
    public func isOnlySpacesInSameLine(from index: Int) -> (Bool, Int?) {
        
        var index = index
        var numberOfSpaces = 0
        let string = self.mutableString
        
        while let char = string.charAt(index) {
            
            if char == 0x0a {
                return (true, numberOfSpaces)
            }
            
            if char != 0x20 {
                return (false, nil)
            }
            
            numberOfSpaces += 1
            index += 1
        }
        return (true, numberOfSpaces)
    }
    
    
    public func isOnlySpacesInSameLine(to index: Int) -> (Bool, Int?) {
        
        var index = index
        var numberOfSpaces = 0
        let string = self.mutableString
        
        while let char = string.charAt(index) {
            
            if char == 0x0a {
                return (true, numberOfSpaces)
            }
            
            if char != 0x20 {
                return (false, nil)
            }
            
            numberOfSpaces += 1
            index -= 1
        }
        return (true, numberOfSpaces)
    }
    
    fileprivate func numberOfHeadSpaces(from start: Int, to end: Int) -> Int {
        
        var _numberOfHeadSpaces: Int = 0
        
        var _startPosition = start
        
        while let char = self.mutableString.charAt(_startPosition), _startPosition < end {
            
            if isSpace(char) {
                
                _startPosition += 1
                _numberOfHeadSpaces += 1
            }
            else {
                break
            }
        }
        
        return _numberOfHeadSpaces
    }
    
    fileprivate func numberOfTailSpaces(from end: Int, to start: Int) -> Int {
        
        var _numberOfTailSpaces: Int = 0
        
        var _endPosition = end - 1
        
        while let char = self.mutableString.charAt(_endPosition), _endPosition >= start {
            
            if isSpace(char) {
                
                _endPosition -= 1
                _numberOfTailSpaces += 1
            }
            else {
                break
            }
            
        }
        return _numberOfTailSpaces
    }
    
    /// This method allow any process to change the content of this StylableString.
    public func setStringContent(_ string: String) {
        
        beginEditing()
        self.replaceCharacters(in: NSRange(0..<self.length), with: string)
        endEditing()
    }
    
    public func spaceRanges(in range: NSRange) -> [NSRange] {
        
        var spaceRanges = [NSRange]()
        var lastSpaceIndex: Int?
        var currentStartIndex: Int?
        
        for i in range.lowerBound..<range.upperBound {
            
            if let char = self.mutableString.charAt(i), isWhiteSpace(char) {
                
                if currentStartIndex == nil {
                    currentStartIndex = i
                }
                lastSpaceIndex = i
            }
            else {
                
                if let _currentStartIndex = currentStartIndex {
                    
                    let range = NSMakeRange(_currentStartIndex, lastSpaceIndex! + 1 - _currentStartIndex)
                    spaceRanges.append(range)
                    currentStartIndex = nil
                    lastSpaceIndex = nil
                }
            }
        }
        return spaceRanges
    }
    
    func filterAttribute(with key: NSAttributedString.Key) {
        
        
    }
    
    func addTemporaryAttributesFromAttributedString(_ attributedString: NSAttributedString) {
        
        removeAllTemporaryAttributes()
        var index = 0
        
        while index < attributedString.length {
            
            var changedStringRange: NSRange = NSMakeRange(index, 1)
            let changedAttributes = attributedString.attributes(at: index, effectiveRange: &changedStringRange)
            self.addTemporaryAttributes(changedAttributes as [NSAttributedString.Key : AnyObject], forCharacterRange: changedStringRange)
            
            if changedStringRange.length > 0 {
                
                index += changedStringRange.length
            }
            else {
                
                index += 1
            }
        }
    }
    
    public func removeAllTemporaryAttributes() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("removeAllTemporaryAttributes()", log: Log.WriterCommon.all, type: .info)
        #endif
        
        assert(Thread.isMainThread)
        assert(self.layoutManagers.first != nil)
        
        let completeRange = NSMakeRange(0, self.string.utf16.count)
        for key in NSAttributedString.Key.temporaryAttributesKeys {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("removeTemporaryAttribute(%@, forCharacterRange: %@)", log: Log.WriterCommon.all, type: .info, %%key, %%completeRange)
            #endif
            
            self.layoutManagers.first?.removeTemporaryAttribute(key, forCharacterRange: completeRange)
        }
    }
    
    public func addTemporaryAttribute(_ attrName: NSAttributedString.Key, value: AnyObject, forCharacterRange charRange: NSRange) {
        
        assert(self.layoutManagers.first != nil)
        self.layoutManagers.first?.addTemporaryAttribute(attrName, value: value, forCharacterRange: charRange)
    }
    
    public func removeTemporaryAttribute(_ name: NSAttributedString.Key, range: NSRange) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("removeTemporaryAttribute(%@, forCharacterRange: %@)", log: Log.WriterCommon.all, type: .info, %%name, %%range)
        #endif
        
        assert(self.layoutManagers.first != nil)
        self.layoutManagers.first?.removeTemporaryAttribute(name, forCharacterRange: range)
    }
    
    public func setTemporaryAttributes(_ attributes: [NSAttributedString.Key: Any], range: NSRange) {
        assert(self.layoutManagers.first != nil)
        self.layoutManagers.first?.setTemporaryAttributes(attributes, forCharacterRange: range)
    }
    
    public func addTemporaryAttributes(_ attrs: [NSAttributedString.Key: Any], forCharacterRange charRange: NSRange) {
        
        assert(self.layoutManagers.first != nil)
        self.layoutManagers.first?.addTemporaryAttributes(attrs, forCharacterRange: charRange)
    }
    
    public func setAttributesSilently(_ attrs: [NSAttributedString.Key : AnyObject]?, range: NSRange) {
        
        self.setAttributes(attrs, range: range)
        
        for layoutManager in layoutManagers {
            
            // this will not trigger relayout
            assert(Thread.isMainThread)
            layoutManager.invalidateDisplay(forCharacterRange: range)
        }
    }
    
    func replaceAllAttributesSilentlyFromAttributedString(_ attributedString: NSAttributedString) {
        
        // changed string should have been updated to match the currentString
        assert(attributedString.length == self.length)
        
        // compute the where the attributes are different for all index and if it is
        // different set them silenlty in the destination string
        
        var index = 0
        
        while index < attributedString.length {
            
            var changedStringRange: NSRange = NSMakeRange(index, 1)
            let changedAttributes = attributedString.attributes(at: index, effectiveRange: &changedStringRange)
            self.setAttributesSilently(changedAttributes as [NSAttributedString.Key : AnyObject]?, range: changedStringRange)
            
            if changedStringRange.length > 0 {
                
                index += changedStringRange.length
            }
            else {
                
                index += 1
            }
        }
    }
    
    func getRangeAndReplacementSubstring() -> (range: NSRange, replacementSubstring: String.UTF16View.SubSequence)? {
        
        // changeInLength is positive when adding characters
        // and negative when removing.
        let changeInLength = self.changeInLength
        let editedRange = self.editedRange
        let range: NSRange
        let substring: String.UTF16View.SubSequence
        
        let lowerBoundUtf16Index = self.string.utf16.index(self.string.utf16.startIndex, offsetBy: editedRange.location, limitedBy: self.string.utf16.endIndex)
        
        assert(lowerBoundUtf16Index != nil)
        if let lowerBoundUtf16Index = lowerBoundUtf16Index {
            
            let upperBoundUtf16Index = self.string.utf16.index(lowerBoundUtf16Index, offsetBy: editedRange.length, limitedBy: self.string.utf16.endIndex)
            
            assert(upperBoundUtf16Index != nil)
            if let upperBoundUtf16Index = upperBoundUtf16Index {
                
                if changeInLength == 0 {
                    
                    range = editedRange
                    
                    // can be pureReplace or unchanged
                    // two cases:
                    // 1. "t" -> "o"
                    // 2. "t" -> "t"
                    // we can not know if the change is a pureReplace or unchanged
                    if editedRange.length == self.length {
                        substring = self.string.utf16[self.string.utf16.startIndex..<self.string.utf16.endIndex]
                    }
                    else if editedRange.length > 0 {
                        substring = self.string.utf16[lowerBoundUtf16Index..<upperBoundUtf16Index]
                    }
                    else {
                        substring = "".utf16["".utf16.startIndex..<"".utf16.endIndex]
                    }
                }
                else {
                    
                    let originalStringEditedRangeLength = editedRange.length - changeInLength
                    range = NSMakeRange(editedRange.location, originalStringEditedRangeLength)
                    substring = self.string.utf16[lowerBoundUtf16Index..<upperBoundUtf16Index]
                }
                
                return (range, substring)
            }
        }
        return nil
    }
    
    /// Compute the differences betweens the changedString and the currentString and returns
    /// the attributes dictionary to apply to currentString to make it identical to changedString.
    func computeAttributesDifferentRanges(_ changedString: NSAttributedString) -> [([NSAttributedString.Key: Any], NSRange)] {
        
        var changedAttributesRanges = [([NSAttributedString.Key: Any], NSRange)]()
        
        var index = 0
        
        while index < changedString.length {
            
            var changedStringRange: NSRange = NSMakeRange(index, 1)
            let changedAttributes = changedString.attributes(at: index, effectiveRange: &changedStringRange)
            var currentStringRange: NSRange = NSMakeRange(index, 1)
            let currentAttributes = self.attributes(at: index, effectiveRange: &currentStringRange)
            
            if !NSDictionary(dictionary: changedAttributes).isEqual(to: currentAttributes) || changedStringRange.length != currentStringRange.length {
                
                changedAttributesRanges.append((changedAttributes as [NSAttributedString.Key : Any], changedStringRange))
            }
            
            if changedStringRange.length > 0 {
                index += changedStringRange.length
            }
            else {
                index += 1
            }
        }
        return changedAttributesRanges
    }
    
    /// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/TextLayout/Tasks/StringHeight.html
    public func size(for width: CGFloat, height: CGFloat) -> NSSize {
        
        var answer: NSSize = NSZeroSize
        
        if self.length > 0 {
            
            // Checking for empty string is necessary since Layout Manager will give the nominal
            // height of one line if length is 0.  Our API specifies 0.0 for an empty string.
            let size: NSSize = NSMakeSize(width, height)
            let textContainer = NSTextContainer(size: size)
            let layoutManager: NSLayoutManager = NSLayoutManager()
            
            layoutManager.addTextContainer(textContainer)
            self.addLayoutManager(layoutManager)
            layoutManager.hyphenationFactor = 0.0
            
            // NSLayoutManager is lazy, so we need the following kludge to force layout:
            layoutManager.glyphRange(for: textContainer)
            
            answer = layoutManager.usedRect(for: textContainer).size
            let extraLineSize = layoutManager.extraLineFragmentUsedRect.size
            if extraLineSize.height > 0 {
                answer.height -= extraLineSize.height
            }
            self.removeLayoutManager(layoutManager)
        }
        return answer
    }
    
    func applyTemporaryAttributes(_ attributes: [([NSAttributedString.Key : Any], NSRange)]) -> NSRange {
        
        var updatedRange: NSRange = NSMakeRange(0, 0)
        
        for (attributes, range) in attributes {
            
            updatedRange.formUnion(range)
            
            #if DEBUG
            if range.location < 0 {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("range.location: %d", log: Log.WriterCommon.all, type: .debug, range.location)
                #endif
                assert(false, "range.location(\(range.location)) < 0")
            }
            if range.location + range.length > self.length {
                os_log("range.location + range.length: %d", log: Log.WriterCommon.all, type: .debug, range.location + range.length)
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("length: %d", log: Log.WriterCommon.all, type: .debug, self.length)
                #endif
                assert(false, "range.location(\(range.location)) + range.length(\(range.length)) > textStorage.length(\(self.length))")
            }
            #endif
            
            let temporaryAttributes = attributes.filter { (arg) -> Bool in
                return arg.key.isTemporary
            }
            
            // to go back to the old behavior we just
            // need to put back setAttributes ( before we were only setting attributes)
            self.addTemporaryAttributes(temporaryAttributes, forCharacterRange: range)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Added temporary attributes in range: %@", log: Log.WriterCommon.all, type: .info, %%NSStringFromRange(range))
            os_log("..attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%NSStringFromRange(range))
            #endif
        }
        return updatedRange
    }
    
    
    func applyTemporaryAttributes(_ attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]]) -> NSRange {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyTemporaryAttributes(attributes: %@)", log: Log.WriterCommon.all, type: .info, %%attributes)
        #endif
        
        var updatedRange: NSRange = NSMakeRange(0, 0)
        
        if let deletedAttributes = attributes[.delete] {
            
            for attributesRange in deletedAttributes {
                
                let attributes = attributesRange.attributes
                let range = attributesRange.range
                updatedRange.formUnion(range)
                
                #if DEBUG
                if range.location < 0 {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("range.location: %d", log: Log.WriterCommon.all, type: .debug, range.location)
                    #endif
                    assert(false)
                }
                if range.location + range.length > self.length {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("range.location + range.length: %d", log: Log.WriterCommon.all, type: .debug, range.location + range.length)
                    os_log("length: %d", log: Log.WriterCommon.all, type: .debug, textStorage.length)
                    #endif
                    assert(false)
                }
                #endif
                
                let temporaryAttributes = attributes.filter { (arg) -> Bool in
                    return arg.key.isTemporary
                }
                
                for (key, _) in temporaryAttributes {
                    self.removeTemporaryAttribute(key, range: range)
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Removed temporary attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%NSStringFromRange(range))
                #endif
            }
        }
        
        if let setAttributes = attributes[.set] {
            for attributesRange in setAttributes {
                
                let attributes = attributesRange.attributes
                let range = attributesRange.range
                updatedRange.formUnion(range)
                
                #if DEBUG
                if range.location < 0 {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("range.location: %d", log: Log.WriterCommon.all, type: .debug, range.location)
                    #endif
                    assert(false)
                }
                if range.location + range.length > self.length {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("range.location + range.length: %d", log: Log.WriterCommon.all, type: .debug, range.location + range.length)
                    os_log("length: %d", log: Log.WriterCommon.all, type: .debug, textStorage.length)
                    #endif
                    assert(false)
                }
                #endif
                
                let temporaryAttributes = attributes.filter { (arg) -> Bool in
                    return arg.key.isTemporary
                }
                
                self.setTemporaryAttributes(temporaryAttributes, range: range)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Applied temporary attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%NSStringFromRange(range))
                #endif
            }
        }
        
        if let addedAttributes = attributes[.add] {
            for attributesRange in addedAttributes {
                
                let attributes = attributesRange.attributes
                let range = attributesRange.range
                updatedRange.formUnion(range)
                
                #if DEBUG
                if range.location < 0 {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("range.location: %d", log: Log.WriterCommon.all, type: .debug, range.location)
                    #endif
                    assert(false, "range.location(\(range.location)) < 0")
                }
                if range.location + range.length > self.length {
                    os_log("range.location + range.length: %d", log: Log.WriterCommon.all, type: .debug, range.location + range.length)
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("length: %d", log: Log.WriterCommon.all, type: .debug, self.length)
                    #endif
                    assert(false, "range.location(\(range.location)) + range.length(\(range.length)) > textStorage.length(\(self.length))")
                }
                #endif
                
                let temporaryAttributes = attributes.filter { (arg) -> Bool in
                    return arg.key.isTemporary
                }
                
                // to go back to the old behavior we just
                // need to put back setAttributes ( before we were only setting attributes)
                self.addTemporaryAttributes(temporaryAttributes, forCharacterRange: range)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Added temporary attributes in range: %@", log: Log.WriterCommon.all, type: .info, %%NSStringFromRange(range))
                os_log("..attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%NSStringFromRange(range))
                #endif
            }
        }
        return updatedRange
    }
    
    func applyAttributes(_ attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]]) {
        
        if let deletedAttributes = attributes[.delete] {
            
            for attributesRange in deletedAttributes {
                
                let attributes = attributesRange.attributes
                let range = attributesRange.range
                
                #if DEBUG
                if range.location < 0 {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("range.location: %d", log: Log.WriterCommon.all, type: .debug, range.location)
                    #endif
                    assert(false)
                }
                if range.location + range.length > self.length {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("range.location + range.length: %d", log: Log.WriterCommon.all, type: .debug, range.location + range.length)
                    os_log("length: %d", log: Log.WriterCommon.all, type: .debug, textStorage.length)
                    #endif
                    assert(false)
                }
                #endif
                
                for (key, _) in attributes {
                    self.removeAttribute(key, range: range)
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Removed attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%NSStringFromRange(range))
                #endif
            }
        }
        
        if let setAttributes = attributes[.set] {
            for attributesRange in setAttributes {
                
                let attributes = attributesRange.attributes
                let range = attributesRange.range
                
                #if DEBUG
                if range.location < 0 {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("range.location: %d", log: Log.WriterCommon.all, type: .debug, range.location)
                    #endif
                    assert(false)
                }
                if range.location + range.length > self.length {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("range.location + range.length: %d", log: Log.WriterCommon.all, type: .debug, range.location + range.length)
                    os_log("length: %d", log: Log.WriterCommon.all, type: .debug, textStorage.length)
                    #endif
                    assert(false)
                }
                #endif
                //                    sourceStringAttributesRenderer?.updateTypingAttributes(from: attributes, in: range)
                self.setAttributes(attributes, range: range)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Applied attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%NSStringFromRange(range))
                #endif
            }
        }
        
        if let addedAttributes = attributes[.add] {
            for attributesRange in addedAttributes {
                
                let attributes = attributesRange.attributes
                let range = attributesRange.range
                
                #if DEBUG
                if range.location < 0 {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("range.location: %d", log: Log.WriterCommon.all, type: .debug, range.location)
                    #endif
                    assert(false, "range.location(\(range.location)) < 0")
                }
                if range.location + range.length > self.length {
                    os_log("range.location + range.length: %d", log: Log.WriterCommon.all, type: .debug, range.location + range.length)
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("length: %d", log: Log.WriterCommon.all, type: .debug, self.length)
                    #endif
                    assert(false, "range.location(\(range.location)) + range.length(\(range.length)) > textStorage.length(\(self.length))")
                }
                #endif
                //                    sourceStringAttributesRenderer?.updateTypingAttributes(from: attributes, in: range)
                
                // to go back to the old behavior we just
                // need to put back setAttributes ( before we were only setting attributes)
                self.addAttributes(attributes, range: range)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Added attributes in range: %@", log: Log.WriterCommon.all, type: .info, %%NSStringFromRange(range))
                os_log("..attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%NSStringFromRange(range))
                #endif
            }
        }
    }
    
}

