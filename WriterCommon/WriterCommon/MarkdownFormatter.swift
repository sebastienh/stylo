//
//  MarkdownFormatter.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-12-03.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Markdown
import Common
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

public enum Mark: String {
    
    case StrongEmphasis = "**"
    case Emphasis = "*"
    case Strikethrough = "~~"
    case Italic = "_"
    
    var length: Int {
        
        return self.rawValue.length
    }
    
    var character: UTF16Char {
        
        return self.rawValue.charAt(0)!
    }
}

public enum Heading: String {
    
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
    
    var level: Int {
        
        switch self {
            
        case .h1: return 1
        case .h2: return 2
        case .h3: return 3
        case .h4: return 4
        case .h5: return 5
        case .h6: return 6
        }
    }
}

public protocol MarkdownFormatter {
    
    func handleHeading(heading: Heading)
    
    func handleBlockQuote()
    
    func handleBulletedList()
    
    func handleNumberedList()
    
    func handleBold()
    
    func handleItalic()
    
    func handleStrikethrough()
    
    func handleLink()
}

extension String {
    
    func headingRange(from lineRange: NSRange? = nil) -> (NSRange, String)? {
        
        if let lineRange = lineRange {
            
            return MarkdownParser.headingTagRange(in: self, range: lineRange)
        }
        else {
            
            return MarkdownParser.headingTagRange(in: self, range: NSMakeRange(0, self.length))
        }
    }
    
    func linesRanges() -> [NSRange] {
        
        var _linesRanges = [NSRange]()
        var lowerBound = 0
        
        while lowerBound < self.length {
            
            let startRange = NSMakeRange(lowerBound, 0)
            let _lineRange = (self as NSString).lineRange(for: startRange)
            
            _linesRanges.append(_lineRange)
            lowerBound = _lineRange.upperBound
        }
        
        return _linesRanges
    }
    
    func lines(from ranges: [NSRange]) -> [String] {
        
        var _lines = [String]()
        for range in ranges {
            debugPrint("range: \(NSStringFromRange(range))")
            if let lineString = self.substringWithUTF16Range(range) {
                _lines.append(lineString)
            }
        }
        return _lines
    }
    
    @discardableResult
    fileprivate mutating func removeTag(in range: NSRange) -> Int {
        
        // we have a range but we should also remove all spaces
        // after the tag itself
        
        // we should leave the spaces added by the user there
        let rangeWithSpaces = NSMakeRange(range.location, range.length + 1)
        
        replaceCharacters(in: rangeWithSpaces, with: "")
        return rangeWithSpaces.length
    }
    
    fileprivate mutating func removeRanges(ranges: [NSRange]) {
        
        var lengthChange: Int = 0
        
        for range in ranges {
            
            let replacementRange = NSMakeRange(range.location + lengthChange, range.length)
            replaceCharacters(in: replacementRange, with: "")
            lengthChange -= replacementRange.length
        }
    }
    
    @discardableResult
    fileprivate mutating func insertHeading(level: Int, in range: NSRange? = nil) -> Int {
        
        let headingString = "########".slice(0, end: level)!
        return insert(string: "\(headingString) ", range: range)
    }
    
    @discardableResult
    fileprivate mutating func insertBullet(in range: NSRange? = nil) -> Int {
        
        let bullet = "- "
        return insert(string: bullet, range: range)
    }
    
    @discardableResult
    fileprivate mutating func insertNumberedBullet(number: Int, in range: NSRange? = nil) -> Int {
        
        let numberedBullet = "\(number). "
        return insert(string: numberedBullet, range: range)
    }
    
    @discardableResult
    fileprivate mutating func insertBlockQuote(in range: NSRange? = nil) -> Int {
        
        let quote = "> "
        return insert(string: quote, range: range)
    }
    
    private mutating func insert(string: String, range: NSRange? = nil) -> Int {
        
        if let range = range {
            
            replaceCharacters(in: range, with: string)
        }
        else {
            replaceCharacters(in: NSMakeRange(0, 0), with: string)
        }
        return string.length
    }
    
    private mutating func replaceCharacters(in range: NSRange, with string: String) {
        
        self = (self as NSString).replacingCharacters(in: range, with: string)
    }
}

extension MarkdownFormatter where Self: PlateformTextViewType & EditableView & ProjectSrollableEditor {
    
    public func handleBlockQuote() {
        
        let selectedRange = self.selectedRange()
        let linesRange = (self.textStorage!.string as NSString).lineRange(for: selectedRange)
        var replacementString = ""
        
        if let string = self.textStorage!.string.substringWithUTF16Range(linesRange) {
            
            let rangesOfLines = string.linesRanges()
            let lines = string.lines(from: rangesOfLines)
            
            if lines.isEmpty {
                replacementString.insertBlockQuote()
            }
            else {
                for var line in lines {
                    line.insertBlockQuote()
                    replacementString += line
                }
            }
            
            replaceTextStorageCharacters(in: linesRange, with: replacementString)
            let lengthDifference = replacementString.length - linesRange.length
            debugPrint("lengthDifference: \(lengthDifference)")
            let newSelectedRange = NSMakeRange(selectedRange.location + lengthDifference, selectedRange.length)
            self.setSelectedRange(newSelectedRange)
        }
    }
    
    public func handleBulletedList() {
        
        let selectedRange = self.selectedRange()
        let linesRange = (self.textStorage!.string as NSString).lineRange(for: selectedRange)
        var replacementString = ""
        
        if let string = self.textStorage!.string.substringWithUTF16Range(linesRange) {
            
            let rangesOfLines = string.linesRanges()
            let lines = string.lines(from: rangesOfLines)
            
            if lines.isEmpty {
                replacementString.insertBullet()
            }
            else {
                for var line in lines {
                    line.insertBullet()
                    replacementString += line
                }
            }
        
            replaceTextStorageCharacters(in: linesRange, with: replacementString)
            
            let lengthDifference = replacementString.length - linesRange.length
            debugPrint("lengthDifference: \(lengthDifference)")
            let newSelectedRange = NSMakeRange(selectedRange.location, selectedRange.length + lengthDifference)
            self.setSelectedRange(newSelectedRange)
        }
    }
    
    public func handleNumberedList() {
        
        let selectedRange = self.selectedRange()
        
        let linesRange = (self.textStorage!.string as NSString).lineRange(for: selectedRange)
        var replacementString = ""
        
        if let string = self.textStorage!.string.substringWithUTF16Range(linesRange) {
            
            let rangesOfLines = string.linesRanges()
            let lines = string.lines(from: rangesOfLines)
            
            if lines.isEmpty {
                replacementString.insertNumberedBullet(number: 1)
            }
            else {
                for var (index, line) in lines.enumerated() {
                    
                    line.insertNumberedBullet(number: index + 1)
                    replacementString += line
                }
            }
            replaceTextStorageCharacters(in: linesRange, with: replacementString)
            
            let lengthDifference = replacementString.length - linesRange.length
            let newSelectedRange = NSMakeRange(selectedRange.location, selectedRange.length + lengthDifference)
            self.setSelectedRange(newSelectedRange)
        }
    }
    
    public func handleLink() {
        
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("handleLink() missing implementation.", log: Log.WriterCommon.all, type: .error)
        #endif
    }
    
    ///
    /// Method to make a selection bold:
    ///
    /// Many cases (depending on selection)
    ///
    ///   1. Selection is not empty
    ///     - Make it bold
    ///         If there is strong bold inside it... Remove it
    ///   2. Selection is empty
    ///     - In the middle of a bold
    ///         Remove the existing bold
    ///     - At the start of a bold
    ///         Move the cursor at the end of the existing bold
    ///     - At the end of a bold
    ///         Remove the existing bold
    ///     - In the middle of a word
    public func handleBold() {
        
        handleSurroundingMark(mark: Mark.StrongEmphasis)
    }

    public func handleItalic() {
        
        handleSurroundingMark(mark: Mark.Italic)
    }
    
    public func handleStrikethrough() {
        
        handleSurroundingMark(mark: Mark.Strikethrough)
    }
    
    public func handleSurroundingMark(mark: Mark) {
        
        let selectedRange = self.selectedRange()

        // If selection is empty
        if selectedRange.isEmpty {
            
            if let surroundingMarkRange = self.surroundingMarkRange(string: string, index: selectedRange.location, mark: mark) {
                
                // remove the surrounding mark
                replaceTextStorageCharacters(in: surroundingMarkRange, with: "")
                return
            }
            else if let previousMarkRange = self.previousMarkRange(string: string, index: selectedRange.location, mark: mark) {

                // remove the previous mark
                replaceTextStorageCharacters(in: previousMarkRange, with: "")
                return
            }
            else if let followingMarkRange = self.followingMarkRange(string: string, index: selectedRange.location, mark: mark) {
                
                let newSelectedRange = NSMakeRange(followingMarkRange.upperBound, 0)
                self.setSelectedRange(newSelectedRange)
                return
            }
            else {
            
                // otherwise we simply insert the mark
                replaceTextStorageCharacters(in: selectedRange, with: mark.rawValue+mark.rawValue)
                let newSelectedRange = NSMakeRange(selectedRange.location + mark.rawValue.count, selectedRange.length)
                self.setSelectedRange(newSelectedRange)
                
            }
        }
        else {
            
            if var replacementString = string.substringWithUTF16Range(selectedRange) {
            
                // remove same marks inside
                if let _markInsideRanges = markInside(string: replacementString, range: NSMakeRange(0, replacementString.length), mark: mark) {
                    
                    replacementString.removeRanges(ranges: _markInsideRanges)
                }
            
                // surround with the mark
                replacementString = "\(mark.rawValue)\(replacementString)\(mark.rawValue)"
                replaceTextStorageCharacters(in: selectedRange, with: replacementString)
            }
        }
    }

    /// Method that returns the ranges containing the mark inside a range.
    fileprivate func markInside(string: String, range: NSRange, mark: Mark) -> [NSRange]? {
    
        var ranges = [NSRange]()
        var index = 0
        
        while index < string.length {
         
            if index + mark.rawValue.length <= string.length {
                
                if string.hasPrefixFromPositionCaseSensitive(mark.rawValue, fromPosition: index) {
                    
                    ranges.append(NSMakeRange(index, mark.rawValue.length))
                    index += mark.rawValue.length
                }
            }
            index += 1
        }
        
        if ranges.isEmpty {
            
            return  nil
        }
        return ranges
    }
    
    fileprivate func followingMarkRange(string: String, index: Int, mark: Mark) -> NSRange? {
    
        if mark.length == 1 {
            
            if let followingChar = string.charAt(index) {
                
                if followingChar == mark.character {
                    
                    return NSMakeRange(index, 1)
                }
            }
        }
        else if mark.length == 2 {
            
            if let followingChar = string.charAt(index) {
                
                if let followingFollowingChar = string.charAt(index + 1) {
                    
                    if followingChar == mark.character && followingFollowingChar == mark.character {
                        
                        return NSMakeRange(index, 2)
                    }
                }
            }
        }
        else if mark.length == 3 {
            
            if let followingChar = string.charAt(index) {
                
                if let followingFollowingChar = string.charAt(index + 1) {
                    
                    if let followingFollowingFollowingChar = string.charAt(index - 3) {
                        
                        if followingChar == mark.character && followingFollowingChar == mark.character && followingFollowingFollowingChar == mark.character {
                            
                            return NSMakeRange(index, 3)
                        }
                    }
                }
            }
        }
        return nil
    }
        
    fileprivate func previousMarkRange(string: String, index: Int, mark: Mark) -> NSRange? {
        
        if mark.length == 1 {
            
            if let previousChar = string.charAt(index - 1) {
             
                if previousChar == mark.character {
                    
                    return NSMakeRange(index - 1, 1)
                }
            }
        }
        else if mark.length == 2 {
            
            if let previousChar = string.charAt(index - 1) {
                
                if let previousPreviousChar = string.charAt(index - 2) {
            
                    if previousChar == mark.character && previousPreviousChar == mark.character {
                    
                        return NSMakeRange(index - 2, 2)
                    }
                }
            }
        }
        else if mark.length == 3 {
        
            if let previousChar = string.charAt(index - 1) {
                
                if let previousPreviousChar = string.charAt(index - 2) {
                    
                    if let previousPreviousPreviousChar = string.charAt(index - 3) {
                        
                        if previousChar == mark.character && previousPreviousChar == mark.character && previousPreviousPreviousChar == mark.character {
                            
                            return NSMakeRange(index - 3, 3)
                        }
                    }
                }
            }
        }
        return nil
    }
        
    fileprivate func surroundingMarkRange(string: String, index: Int, mark: Mark) -> NSRange? {
        
        if mark.length == 2 {
            
            if let previousChar = string.charAt(index - 1) {
                
                if let followingChar = string.charAt(index + 1) {
                    
                    if previousChar == mark.character && followingChar == mark.character {
                        
                        return NSMakeRange(index - 1, 2)
                    }
                }
            }
        }
        else if mark.length == 3 {
            
            if let previousChar = string.charAt(index - 1) {
                
                if let followingChar = string.charAt(index + 1) {
                    
                    if let previousPreviousChar = string.charAt(index - 2) {
                        
                        if previousChar == mark.character && followingChar == mark.character && previousPreviousChar == mark.character {
                            
                            return NSMakeRange(index - 2, 3)
                        }
                    }
                
                    if let followingFollowingChar = string.charAt(index + 2) {
                     
                        if previousChar == mark.character && followingChar == mark.character && followingFollowingChar == mark.character {
                            
                            return NSMakeRange(index - 1, 3)
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    public func handleHeading(heading: Heading) {
        
        let selectedRange = self.selectedRange()
        let string: NSString = self.textStorage!.string as NSString
        let linesRange = string.lineRange(for: selectedRange)
        var replacementString = ""
        
        if var string = self.textStorage?.string.substringWithUTF16Range(linesRange) {
            
            let rangesOfLines = string.linesRanges()
            
            // If there is only one line selected, we simply switch on or off
            if rangesOfLines.count == 1 || rangesOfLines.count == 0 {
                
                if rangesOfLines.count == 1 {
                    
                    let rangesOfLine = rangesOfLines.first!
                    if let (_headingRange, headingString) = string.headingRange(from: rangesOfLine) {
                        if headingString == §heading {
                            string.removeTag(in: _headingRange)
                        }
                        else {
                            string.removeTag(in: _headingRange)
                            string.insertHeading(level: heading.level, in: NSMakeRange(0, 0))
                        }
                    }
                    else {
                        string.insertHeading(level: heading.level, in: NSMakeRange(0, 0))
                    }
                }
                else {
                    
                    string.insertHeading(level: heading.level, in: NSMakeRange(0, 0))
                }
                replacementString.append(string)
            }
            else {
                
                let _lines = string.lines(from: rangesOfLines)
                
                for var line in _lines {
                    if let (_headingRange, headingString) = line.headingRange() {
                        let headingRange = NSMakeRange(_headingRange.location, _headingRange.length)
                        if headingString != §heading {
                            line.removeTag(in: headingRange)
                            line.insertHeading(level: heading.level, in: NSMakeRange(0, 0))
                        }
                    }
                    else {
                        line.insertHeading(level: heading.level, in: NSMakeRange(0, 0))
                    }
                    replacementString += line
                }
            }
            
            replaceTextStorageCharacters(in: linesRange, with: replacementString)
            let lengthDifference = replacementString.length - linesRange.length
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("lengthDifference: %d", log: Log.WriterCommon.all, type: .debug, lengthDifference)
            #endif
            let newSelectedRange = NSMakeRange(selectedRange.location + lengthDifference, selectedRange.length)
            self.setSelectedRange(newSelectedRange)
        }
    }
    
    private func replaceTextStorageCharacters(in range: NSRange, with replacementString: String) {
        
        assert(self.textStorage != nil)
        if let textStorage = self.textStorage {
        
            if self.shouldChangeText(in: range, replacementString: replacementString) {
            
                preventScrollingAndSaveBoundsIfNecessary(replacementString, replacementRange: range)
                
                textStorage.beginEditing()
                // removing the characters does not removes the attributes
                // stylo #506: Header does not disappear in front of "4$%" using the markdown shortcuts
                textStorage.removeAttribute(StyloAttribute.headingTagBefore.key, range: range)
                textStorage.replaceCharacters(in: range, with: replacementString)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                let attributes = textStorage.attributes(in: NSMakeRange(range.location, replacementString.length))
                os_log("left attributes: %@", log: Log.WriterCommon.all, type: .debug, %%attributes)
                #endif
                textStorage.endEditing()
                didChangeText()
            }
        }
    }
    
    private func trimLeadingAndTrailingLineFeed(_ range: NSRange, in string: NSString) -> NSRange {
    
        var trimmedRange = range
        
        if trimmedRange.length >= 1 {
            if string.character(at: trimmedRange.lowerBound) == §UnicodeCharacter.lineFeed {
                trimmedRange = NSMakeRange(trimmedRange.lowerBound+1, trimmedRange.length-1)
            }
        }
        if trimmedRange.length >= 1 {
            if string.character(at: trimmedRange.upperBound-1) == §UnicodeCharacter.lineFeed {
                trimmedRange = NSMakeRange(trimmedRange.lowerBound, trimmedRange.length-1)
            }
        }
        return trimmedRange
    }
    
}

