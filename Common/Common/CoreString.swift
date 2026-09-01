//
//  CoreString.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-09-07.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public protocol CoreString: RandomlyAccessibleCharacters, Hashable, ExpressibleByStringLiteral {
    
    /// Mark: Default implementation not provided
    var string: String { get }
    
    init()
    
    init(string: String)
    
    /// Mark: Default implementation provided
    var isEmpty: Bool { get }
    
    ///
    var inlineBufferEnabled: Bool { get set }
    
    func startWithNewLine(atPosition position: Int) -> Int?
    
    func isGraveAccent(at index: Int) -> Bool
    
    func charAt(_ index: Int, isEqualTo char: UTF16.CodeUnit) -> Bool
    
    /// should remove the conditional here asserts will do all
    /// the needed validations.
    func extractStringFromSegment(_ segment: (start: Int, end: Int)) -> String?
    
    func hasPrefixFromPositionCaseSensitive(_ prefix: String, fromPosition position: Int) -> Bool
    
    func hasPrefix(_ prefix: String) -> Bool
    
    /// FIXME: for performance we should transform this method to 
    /// func slice(_ start: UInt, end: UInt) -> Self
    /// all validations should be done by the caller and negative value 
    /// must not be allowed.
    func slice(_ start: Int, end: Int?) -> Self?
    
    func lowercaseCharAt(_ pos: Int) -> UniChar?
    
    func indexOf(_ codeUnit: UTF16.CodeUnit) -> Int?
    
    func indexOf(_ string: String, fromIndex index: Int) -> Int?
    
    func firstNonWitespaceBeforeIsAccent(fromPosition position: Int) -> Bool
    
    func onlyWhitespacesUntilStartOfLine(fromPosition position: Int) -> Bool
    
    func isWhitespace(fromPosition position: Int) -> Bool
    
    func skipWhitespaces(fromPosition position: Int) -> Int
    
    func skipAllWhitespaces(fromPosition position: Int, maxPosition: Int?) -> Int
    
    func hasPrefixFromPositionCaseInsensitive(_ prefix: String, fromPosition position: Int) -> Bool
    
    /// Starting from the end point passed as fromIndex parameter this 
    /// function will traverse backward the string returning the first index 
    /// of the codeUnit parameter.
    func lastIndexOf(_ codeUnit: UTF16.CodeUnit, fromIndex index: Int?) -> Int?
    
    func endsWith(_ str: String) -> Bool
    
    mutating func trimWhitespaces() -> Self
    
    static func fromCharCode(_ codeUnit: UTF16Char) -> Self
    
    func replacingOccurrences(of target: String, with replacement: String) -> Self
    
    mutating func append(_ other: Self)
    
    func components(separatedBy: String) -> [Self]
    
    mutating func replaceAll(_ expression: NSRegularExpression, withTemplate template: String)
    
    func numberOfSpacesOrNewlines(before index: Int) -> Int
    
    func numberOfSpacesOrNewlines(from index: Int) -> Int
    
    func numberOfSingleWhitepacesBeforeNewLineOrStart(before index: Int) -> Int
    
    static func +(lhs: Self, rhs: Self) -> Self
    
    static func +=(lhs: inout Self, rhs: Self)
}

extension CoreString {
    
    public var isEmpty: Bool {
    
        return length == 0
    }
    
    /// Returns the length of the new line at position
    /// parameter, if it founds one, otherwise returns nil.
    ///
    /// Note: This method consider a UTF16 string.
    public func startWithNewLine(atPosition position: Int) -> Int? {
        
        let firstChar = charAt(position)
        
        if position + 1 < length {
            return charactersAreNewLine(firstChar, secondCharacter: charAt(position + 1) )
        }
        else {
            return charactersAreNewLine(firstChar, secondCharacter: nil)
        }
    }
    
    public func hasPrefixFromPositionCaseSensitive(_ prefix: String, fromPosition position: Int = 0) -> Bool {
        
        let count = min(length, prefix.length)
        
        if count < prefix.length {
            return false
        }
        
        var i = position
        var prefixIndex = 0
        
        while prefixIndex < prefix.length {
            if !charAt(i, isEqualTo: prefix.charAt(prefixIndex)!) {
                return false
            }
            prefixIndex += 1
            i += 1
        }
        
        return true
    }
    
    public func hasPrefix(_ prefix: String) -> Bool {
        
        return hasPrefixFromPositionCaseSensitive(prefix)
    }
    
    public func lowercaseCharAt(_ pos: Int) -> UniChar? {
        
        if let character = charAt(pos) {
            return UnicodeLetter.convertLowercaseIfNeeded(character)
        }
        return nil
    }
    
    public func indexOf(_ codeUnit: UTF16.CodeUnit) -> Int? {
        
        var i = 0
        while i < length {
            if charAt(i, isEqualTo: codeUnit) {
                return i
            }
            i += 1
        }
        return nil
    }
    
    public func indexOf(_ string: String, fromIndex index: Int = 0) -> Int? {
        
        var i = index.integerValue
        while i < length {
            if hasPrefixFromPositionCaseSensitive(string, fromPosition: i) {
                return i
            }
            i += 1
        }
        return nil
    }
    
    
    public func skipWhitespaces(fromPosition position: Int) -> Int {
        
        var i = position
        
        // skip all whitespaces
        while i < length {
            
            let c = charAt(i)!
            
            if isSpace(c) {
                i += 1
            }
            else {
                break
            }
        }
        return i - position
    }
    
    public func firstNonWitespaceBeforeIsAccent(fromPosition position: Int) -> Bool {
    
        for i in stride(from: position, through: 0, by: -1) {
            
            guard let c = charAt(i) else {
                // if for any reason the character is nil
                // it must be that we reached the start of the line
                return false
            }
            
            if c == §UnicodeCharacter.graveAccent {
                return true
            }
            
            if isPossibleNewLineStartCodePoint(c) {
                return false
            }
            else if !isSpace(c) {
                return false
            }
        }
        return true
    }
    
    public func onlyWhitespacesUntilStartOfLine(fromPosition position: Int) -> Bool {
        
        for i in stride(from: position, through: 0, by: -1) {
            
            guard let c = charAt(i) else {
                // if for any reason the character is nil
                // it must be that we reached the start of the line
                return true
            }
            
            if isPossibleNewLineStartCodePoint(c) {
                return true
            }
            else if !isSpace(c) {
                return false
            }
        }
        return true
    }
    
    /// Return the number of whitespaces skiped
    public func skipAllWhitespaces(fromPosition position: Int, maxPosition: Int? = nil) -> Int {
        
        var i = position
        var max = length
        if let maxPosition = maxPosition {
            
            max = maxPosition
        }
        
        // skip all whitespaces
        while i < max {
            
            let c = charAt(i)!
            
            if isPossibleNewLineStartCodePoint(c) {
                
                if let newLineLength = startWithNewLine(atPosition: i) {
                    i += newLineLength
                }
                else {
                    i += 1
                }
            }
            else if isSpace(c) {
                i += 1
            }
            else {
                break
            }
        }
        
        return i - position
    }
    
    public func isWhitespace(fromPosition position: Int) -> Bool {
        
        let i = position
        
        if let c = charAt(i) {
            return isPossibleNewLineStartCodePoint(c) || isSpace(c)
        }
        
        return false
    }
    
    public func hasPrefixFromPositionCaseInsensitive(_ prefix: String, fromPosition position: Int = 0) -> Bool {
        
        let lowercasePrefix = prefix.lowercased()
        let count = min(length, prefix.length)
        
        if count < prefix.length {
            return false
        }
        
        var i = position
        var prefixIndex = 0
        
        while prefixIndex < prefix.length {
            
            let c = lowercasePrefix.charAt(prefixIndex)!

            if let char = lowercaseCharAt(i) , char != c {
                return false
            }
            prefixIndex += 1
            i += 1
        }
        
        return true
    }
    
    public func extractStringFromSegment(_ segment: (start: Int, end: Int)) -> String? {
        
        return string.extractStringFromSegment((segment.start, segment.end))
    }

    public func lastIndexOf(_ codeUnit: UTF16.CodeUnit, fromIndex index: Int? = nil) -> Int? {

        if length != 0 {
            
            var i = length - 1
            
            if let index = index {
                assert(index < length)
                i = index
            }
            
            while i >= 0 {
                
                let c = charAt(i)!
                
                if c == codeUnit {
                    return i
                }
                i -= 1
            }
        }
        return nil
    }
    
    public func endsWith(_ str: String) -> Bool {
        
        if length < str.length {
            return false
        }

        var i = str.length - 1
        
        for suffixIndex in str.length - 1...0 {

            let c = str.charAt(suffixIndex)
            if let char = charAt(i), char != c {
                return false
            }
            i -= 1
        }
        
        return true
    }

    public func numberOfSingleWhitepacesBeforeNewLineOrStart(before index: Int) -> Int {
        
        var result = 0
        var index = index-1
        
        while index >= 0 {
            
            let secondChar = self.charAt(index)!
            var firstChar: UTF16.CodeUnit? = nil
            
            if index - 1 >= 0 {
                firstChar = string.charAt(index - 1)
            }
            
            // both characters need to constitute a new line. The case where only the second character
            // is a new line is considered next in the "else if".
            if let newLineLength = charactersAreNewLine(firstChar, secondCharacter: secondChar), newLineLength == 2 {
                break
            }
            else if charactersAreNewLine(secondChar, secondCharacter: nil) != nil {
                break
            }
            else if secondChar == 0x20 {
                index -= 1
                result += 1
            }
            else {
                break
            }
        }
        
        return result
    }
    
    public func numberOfSpacesOrNewlines(before index: Int) -> Int {
        
        var result = 0
        var index = length-1
        
        while index >= 0 {
            
            let secondChar = self.charAt(index)!
            var firstChar: UTF16.CodeUnit? = nil
            
            if index - 1 >= 0 {
                firstChar = string.charAt(index - 1)
            }
            
            // both characters need to constitute a new line. The case where only the second character
            // is a new line is considered next in the "else if".
            if let newLineLength = charactersAreNewLine(firstChar, secondCharacter: secondChar), newLineLength == 2 {
                
                result += newLineLength
            }
            else if charactersAreNewLine(secondChar, secondCharacter: nil) != nil {
                
                index -= 1
                result += 1
            }
            else if isSpace(secondChar) {
                
                index -= 1
                result += 1
            }
            else {
                break
            }
        }
        
        return result
    }
    
    public func numberOfSpacesOrNewlines(from index: Int) -> Int {
        
        var index = index
        var result = 0
        
        while index < self.length {
            
            let firstChar = string.charAt(index)!
            let secondChar = string.charAt(index + 1)
            
            if let newLineLength = charactersAreNewLine(firstChar, secondCharacter: secondChar) {
                
                result += newLineLength
                index += newLineLength
            }
            else if isSpace(firstChar) {
                
                result += 1
                index += 1
            }
            else {
                break
            }
        }
        return result
    }
    
    public static func ==(lhs: Self, rhs: String) -> Bool {
        
        return lhs.string == rhs
    }
}

