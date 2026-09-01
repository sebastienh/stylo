//
//  String+Utilities.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-10-26.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import NaturalLanguage
import os

public extension String {
    
    var substringWithoutFileExtension: String {
        
        let startIndex = self.startIndex
        var index = self.endIndex
        index = self.index(before: index)
        
        while index != startIndex {
            
            if self[index] == Character(".") {
                break
            }
            
            index = self.index(before: index)
        }
        return String(self[startIndex..<index])
    }
    
    var stringReplacingDashsWithDots: String {
        
        return self.replacingOccurrences(of: "-", with: ".")
    }
    
    func capitalizingFirstLetter() -> String {
        
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        
        self = self.capitalizingFirstLetter()
    }
    
    /// Returns the sentences around the specified range.
    func sentencesRange(aroundRange range: NSRange) -> NSRange? {
        
        // Initialize the tagger
        let tagger = NLTagger(tagSchemes: [.tokenType])
        let completeRange = self.startIndex..<self.endIndex
        var startIndex: Int?
        var endIndex: Int?
        
        tagger.string = self
        tagger.enumerateTags(in: completeRange, unit: .sentence, scheme: .tokenType) { (tag, _sentenceRange) -> Bool in
            if let _ = tag {
                
                let start = _sentenceRange.lowerBound.utf16Offset(in: self)
                let end = _sentenceRange.upperBound.utf16Offset(in: self)

                if start <= range.location && end > range.lowerBound {
                    startIndex = start
                }
                
                if endIndex == nil && startIndex != nil && range.upperBound <= end {
                    endIndex = end
                }
                
                if startIndex != nil, endIndex != nil {
                    return false
                }
  
                return true
            }
            return true
        }
        
        if var startIndex = startIndex, var endIndex = endIndex {
            
            self.trimEndingNewLine(fromStartIndex: &startIndex, endIndex: &endIndex)
            self.trimLeftSquareBraquets(fromStartIndex: &startIndex, endIndex: &endIndex)
            self.extendsLastSpace(fromStartIndex: &startIndex, endIndex: &endIndex)
            return NSMakeRange(startIndex, endIndex-startIndex)
        }
    
        return nil
    }
    
    private func extendsLastSpace(fromStartIndex startIndex: inout Int, endIndex: inout Int) {
    
        if endIndex < self.utf16.count-1 && charAt(endIndex) == §UnicodeCharacter.whitespace {
            endIndex = endIndex+1
        }
    }
        
    private func trimEndingNewLine(fromStartIndex startIndex: inout Int, endIndex: inout Int) {
        
        if endIndex >= 1 && self.charAt(endIndex-1) == §UnicodeCharacter.lineFeed {
            endIndex = endIndex-1
        }
    }
    
    private func trimLeftSquareBraquets(fromStartIndex startIndex: inout Int, endIndex: inout Int) {
        
        if startIndex >= 1 && self.charAt(startIndex-1) == §UnicodeCharacter.leftSquareBracket {
            startIndex = startIndex-1
        }
        
        if endIndex >= 1 && self.charAt(endIndex-1) == §UnicodeCharacter.leftSquareBracket {
            endIndex = endIndex-1
        }
    }
    
    var indexedCharacters: OrderedDictionary<Int, String> {
        
        var result = OrderedDictionary<Int, String>()
        
        for (index, char) in self.utf16.enumerated() {
            
            result.append((key: index, value: String(utf16CodeUnits: [char], count: 1 )))
        }
        return result
    }
    
    func printCharactersIndexes() {
        
        let indexedCharacters = self.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \"\(arg.value)\"\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
    }
    
    mutating func update(withSourceStringChangeDescription sourceStringChangeDescription: SourceStringChangeDescription) {
        
        guard let stringReplacement = sourceStringChangeDescription.stringReplacement else {
            assertionFailure("Error: stringReplacement is nil")
            return
        }
        
        self.update(range: sourceStringChangeDescription.range, withString: stringReplacement)
    }
    
    mutating func update(range: NSRange, withString string: String) {
        
        assert(range.upperBound <= self.string.utf16.count)
        
        let utf16Start: String.UTF16View.Index = self.string.utf16.index(self.string.utf16.startIndex, offsetBy: range.lowerBound);
        let utf16End: String.UTF16View.Index = self.string.utf16.index(self.string.utf16.startIndex, offsetBy: range.upperBound)
        
        guard let start = utf16Start.samePosition(in: self.string) else {
            assertionFailure("Error: start is nil")
            return
        }
        
        guard let end = utf16End.samePosition(in: self.string) else {
            assertionFailure("Error: end is nil")
            return
        }
        
        self.replaceSubrange(start..<end, with: string)
    }
    
    func substringWithoutNamedFileExtension(_ name: String) -> String {
        
        if self.endsWith(".\(name)") {
            
            return self.slice(0, end: -(1+name.count))!
        }
        return self
    }
    
    /// Function that returns the first different characters
    /// between this string and another string.
    func firstDifferentCharacterIndex(from other: String) -> String.Index? {
    
        var index = self.startIndex
        let otherEndIndex = other.endIndex
        let selfEndIndex = self.endIndex
        
        while index != selfEndIndex {
            
            if index != otherEndIndex {
            
                if self[index] != other[index] {
                    return index
                }
                index = self.index(after: index)
            }
            else {
                return index
            }
        }
        
        // if there is still characters
        if index == selfEndIndex && index != otherEndIndex {
            
            return selfEndIndex
        }
        return nil
    }
    
    var firstLine: String {
        
        var i = 0
        
        // skip all whitespaces
        while i < length {
            
            let c = charAt(i)!
            if isPossibleNewLineStartCodePoint(c) {
                if startWithNewLine(atPosition: i) != nil {
                    break
                }
            }
            i += 1
        }
        return self.slice(0, end: i)!
    }
    
    func equalsIgnoreCase(_ otherString: String) -> Bool {
        
        return self.lowercased() == otherString.lowercased()
    }
    
    func beginsWith(_ str: String) -> Bool {
        
        if let range = self.range(of: str) {
            
            return range.lowerBound == self.startIndex
        }
        
        return false
    }
    
    func endsWith(_ str: String) -> Bool {
        
        if let range = self.range(of: str, options:NSString.CompareOptions.backwards) {
            
            return range.upperBound == self.endIndex
        }
        
        return false
    }

    func startingNumberUntilDot() -> String {
        
        var numberString = ""
        
        for character in self.utf16 {
            
            if UnicodeDigit.isUnicodeDigit(character) {
                
                if let scalar = UnicodeScalar(character) {
                    
                    let digit = String(describing: scalar)
                    numberString += digit + numberString
                }
            }
            else if character == ".".utf16.first! {
                break
            }
        }
        return numberString
    }
    
    func endingNumber() -> String {
        
        var numberString = ""
        
        for character in self.utf16.reversed() {
            
            if UnicodeDigit.isUnicodeDigit(character) {

                if let scalar = UnicodeScalar(character) {
                    
                    let digit = String(describing: scalar)
                    numberString += digit + numberString
                }
            }
        }
        return numberString
    }
    
    func extendsWithLastSpaces(_ range: NSRange) -> NSRange {
    
        let count = self.utf16.count
        
        var upperBound = range.upperBound
        
        while upperBound < count-1 {
            if self.charAt(upperBound) == §UnicodeCharacter.whitespace {
                upperBound += 1
            }
            else {
                break
            }
        }
        return NSMakeRange(range.location, upperBound-range.location)
    }
    
    func rangesByTrimmingSpaces(in range: NSRange) -> [NSRange] {
        
        var ranges = [NSRange]()
        var index = range.location
        let maxPosition = index + range.length
        var currentRange = NSMakeRange(0, 0)
        
        while index < range.location + range.length {
            
            if isWhitespace(fromPosition: index) {
                
                // we are at the start of the string
                // so we skip all whitespaces
                if ranges.isEmpty && index == range.location {
                    
                    // skip all the whitespaces
                    let nbrOfSpaces = skipAllWhitespaces(fromPosition: index, maxPosition: maxPosition)
                    
                    // update the index
                    index += nbrOfSpaces
                    
                    currentRange.location = index
                }
                else {
                    
                    // close the current range
                    currentRange.length = index - currentRange.location
                    ranges.append(currentRange)
                    
                    // skip all the whitespaces
                    let nbrOfSpaces = skipAllWhitespaces(fromPosition: index, maxPosition: maxPosition)
                    
                    // update the index
                    index += nbrOfSpaces
                    
                    // start a new range
                    currentRange = NSMakeRange(index, 0)
                }
            }
            else {
                
                index += 1
            }
        }
        
        // close the last range
        if currentRange.location != maxPosition {
            
            currentRange.length = index - currentRange.location
            ranges.append(currentRange)
        }
        
        return ranges
    }
        
    
}
