//
//  SourceStringChangeDescription.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-10-06.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import os

public struct SourceStringChangeDescription: CustomDebugStringConvertible {
    
    public enum ChangeType {
        
        case pureAddition
        case pureRemoval
        case pureReplace
        case replaceAddition
        case replaceRemoval
        case unchanged

        public var isAddition: Bool {
            
            return self == .pureAddition || self == .replaceAddition
        }
        
        public var isRemoval: Bool {
            
            return self == .pureRemoval || self == .replaceRemoval
        }
        
        static func from(changeDescription: SourceStringChangeDescription) -> ChangeType {
            
            switch changeDescription.changeLength {
            case 0:
                
                if changeDescription.utf16SubsequenceReplacement.count == 0 {
                    return .unchanged
                }
                else {
                    return .pureReplace
                }
                
            case let x where x > 0:
                
                if changeDescription.range.length == 0 {
                    assert(changeDescription.utf16SubsequenceReplacement.count > 0)
                    return .pureAddition
                }
                else {
                    assert(changeDescription.utf16SubsequenceReplacement.count > 0)
                    return .replaceAddition
                }
                
            default:
                
                if changeDescription.range.length > 0 && changeDescription.utf16SubsequenceReplacement.count == 0 {
                    return .pureRemoval
                }
                else {
                    assert(changeDescription.utf16SubsequenceReplacement.count > 0)
                    return .replaceRemoval
                }
            }
        }
    }
    
    /// The affected range in the original string
    public let range: NSRange
    
    /// The range at which we are at the end of the edit
    public let endRange: NSRange
    
    /// The string that has been put in the place of the
    /// string in the "range" affected by this StringChange.
    public let utf16SubsequenceReplacement: String.UTF16View.SubSequence
    
    public let stringReplacement: String?
    
    /// changeLength from changeInLength from the NSTextStorage notification
    public let changeLength: Int
    
    /// The string after the change is executed, basically
    /// it is the result of the application of this change
    public let targetString: String
    
    public var changeRange: NSRange? {
        
        switch self.changeType {
        case .pureAddition: fallthrough
        case .pureRemoval: fallthrough
        case .pureReplace: fallthrough
        case .replaceAddition: fallthrough
        case .replaceRemoval:
            return self.range
        case .unchanged:
            return nil
        }
    }
    
    public var isNonEmptyReplace: Bool {
        
        let changeType = self.changeType
        
        switch changeType {
            
        case .replaceAddition: fallthrough
        case .replaceRemoval:
            return !self.utf16SubsequenceReplacement.isEmpty
        default:
            return false
        }
    }
    
    /// Method that returns the change, if the change spans multiple line
    /// we return nil
    public var lineContainingChange: String? {
        
        func line(to endIndex: Int) -> String? {
            
            let utf16String = targetString.string.utf16
            var startIndex = endIndex - 1
            
            if startIndex >= 0 {
                
                var utf16Index = String.Index(utf16Offset: startIndex, in: targetString.string)
                var char: UTF16Char? = utf16String[utf16Index]
                
                while let _char = char {
                    
                    if _char != §UnicodeCharacter.lineFeed {
                    
                        startIndex -= 1
                        if startIndex >= 0 {
                            utf16Index = String.Index(utf16Offset: startIndex, in: targetString.string)
                            char = utf16String[utf16Index]
                        }
                        else {
                            startIndex = 0
                            char = nil
                        }
                    }
                    else {
                        startIndex += 1
                        break
                    }
                }
                
                let lineRange = NSMakeRange(startIndex, endIndex - startIndex)
                
                if !lineRange.isEmpty {
                    
                    return targetString.substringWithUTF16Range(lineRange)
                }
            }
            return nil
        }
        
        func line(from startIndex: Int) -> String? {
            
            let utf16String = targetString.string.utf16
            var index = startIndex
            
            if index < utf16String.length {
                
                var utf16Index = String.Index(utf16Offset: index, in: targetString.string)
                var char: UTF16Char? = utf16String[utf16Index]
                
                while let _char = char, _char != §UnicodeCharacter.lineFeed {
                    
                    index += 1
                    if index < utf16String.length {
                        utf16Index = String.Index(utf16Offset: index, in: targetString.string)
                        char = utf16String[utf16Index]
                    }
                    else {
                        char = nil
                    }
                }
                
                let lineRange = NSMakeRange(startIndex, index - startIndex)
                return targetString.substringWithUTF16Range(lineRange)
            }
            return nil
        }
        
        if range.isEmpty {
        
            if self.stringReplacement == "\n" {
                
                // in this case, we simply start from the next character
                // until we see a line feed character or the end of the text
                let startIndex = range.location + 1
                return line(from: startIndex)
            }
            else {
                
                let startIndex = range.location
                if let debut = line(to: startIndex) {
                    
                    if let end = line(from: startIndex) {
                        return debut + end
                    }
                    else {
                        return debut
                    }
                }
                else {
                    return line(from: startIndex)
                }
            }
        }
        return nil
    }
    
    public var changeType: ChangeType {

        return ChangeType.from(changeDescription: self)
    }
    
    public var addedRange: NSRange? {
        
        if utf16SubsequenceReplacement.count > 0 {
            return NSMakeRange(range.location, utf16SubsequenceReplacement.count)
        }
        return nil
    }
    
    public var isOnlyAddedWhitespaces: Bool {
        
        if changeType == .pureAddition || changeType == .replaceAddition {
            if utf16SubsequenceReplacement.filter({ (char) -> Bool in
                return char != §UnicodeCharacter.whitespace && char != §UnicodeCharacter.characterTabulation && charactersAreNewLine(char, secondCharacter: nil) == nil
            }).isEmpty {
                return true
            }
        }
        return false
    }
    
    public var characterAfterChangeIsANewline: Bool {
        
        // affected range the original string
        let nextUtf16Index = range.upperBound + changeLength
        return targetString.string.startWithNewLine(atPosition: nextUtf16Index) != nil
    }
    
    public var emptyLineAfterChange: Bool {
        
        let string = targetString.string
        let utf16Count = string.utf16.count
        var nextUtf16Index = range.upperBound + changeLength
        
        while nextUtf16Index < utf16Count && string.startWithNewLine(atPosition: nextUtf16Index) == nil {
            if let character = string.charAt(nextUtf16Index) {
                if character != §UnicodeCharacter.whitespace {
                    return false
                }
            }
            else {
                return true
            }
            nextUtf16Index += 1
        }
        return true
    }
    
    public var debugDescription: String {
        
        return "changeType: \(changeType), range: \(NSStringFromRange(range)), changeLength: \(changeLength), stringReplacement: \(String(describing: self.stringReplacement))."
    }
    
    public init(sourceString: String, range: NSRange, insertedString: String) {
        
        let changeLength = insertedString.utf16.count - range.length
        
        var targetString = sourceString
        targetString.update(range: range, withString: insertedString)
        
        // insert a character after the strong tag
        self.init(range: range, stringReplacement: insertedString, changeLength: changeLength, targetString: targetString)
    }
    
    public init?(range: NSRange, stringReplacement: String.UTF16View.SubSequence, changeLength: Int, targetStringUrl: URL) {
        
        do {
        
            let targetString = try String(contentsOf: targetStringUrl)
            self.init(range: range, stringReplacement: stringReplacement, changeLength: changeLength, targetString: targetString)
        }
        catch let error {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error while building SourceStringChangeDescription: %@", log: Log.Common.all, type: .error, %%error)
            #endif
            return nil
        }
    }

    public init(range: NSRange, stringReplacement: String?, changeLength: Int, targetString: String) {
        
        if let stringReplacement = stringReplacement {
        
            self.init(range: range, stringReplacement: stringReplacement.utf16[stringReplacement.utf16.startIndex..<stringReplacement.utf16.endIndex], changeLength: changeLength, targetString: targetString)
        }
        else {
            
            let string = targetString.string as NSString
            
            // it is a recompilation SourceStringChangeDescription
            assert(changeLength == 0)
            let stringReplacement = string.substring(with: range)
            
            self.init(range: range, stringReplacement: stringReplacement.utf16[stringReplacement.utf16.startIndex..<stringReplacement.utf16.endIndex], changeLength: changeLength, targetString: targetString)
        }
    }
    
    public init(range: NSRange, stringReplacement: String?, changeLength: Int, targetString: NSMutableAttributedString) {
        
        self.init(range: range, stringReplacement: stringReplacement, changeLength: changeLength, targetString: targetString.string)
    }
    
    public init(range: NSRange, stringReplacement: String.UTF16View.SubSequence, changeLength: Int, targetString: String) {
        
        self.range = range
        self.endRange = NSMakeRange(range.location+changeLength+range.length, 0)
        self.utf16SubsequenceReplacement = stringReplacement
        self.changeLength = changeLength
        self.targetString = targetString
        self.stringReplacement = String(self.utf16SubsequenceReplacement)
    }
    
    public init(attributedString: NSMutableAttributedString, originalAttributedString: NSMutableAttributedString?) {
    
        if let originalAttributedString = originalAttributedString {
        
            self.range = NSMakeRange(0, originalAttributedString.length)
            self.changeLength = attributedString.length - originalAttributedString.length
        }
        else {
            
            self.range = NSMakeRange(0, attributedString.length)
            self.changeLength = attributedString.length
        }
        self.utf16SubsequenceReplacement = attributedString.string.utf16[attributedString.string.utf16.startIndex..<attributedString.string.utf16.endIndex]
        self.targetString = attributedString.string
        self.stringReplacement = String(self.utf16SubsequenceReplacement)
        self.endRange = NSMakeRange(range.location+changeLength, 0)
    }
    
    public init(string: String, originalString: String?) {
    
        if let originalString = originalString {
        
            self.range = NSMakeRange(0, originalString.utf16.count)
            self.changeLength = string.utf16.count - originalString.utf16.count
        }
        else {
            
            self.range = NSMakeRange(0, string.utf16.count)
            self.changeLength = string.utf16.count
        }
        self.utf16SubsequenceReplacement = string.utf16[string.utf16.startIndex..<string.utf16.endIndex]
        self.targetString = string
        self.stringReplacement = String(self.utf16SubsequenceReplacement)
        self.endRange = NSMakeRange(range.location+changeLength, 0)
    }
    
    public func same(with stringReplacement: String.UTF16View.SubSequence, targetString: String) -> SourceStringChangeDescription {
        
        
        return SourceStringChangeDescription(range: self.range, stringReplacement: stringReplacement, changeLength: self.changeLength, targetString: targetString)
    }
    
    public func changeReplacementContains(character: Character) -> Bool {
        
        return self.stringReplacement?.contains(character) ?? false
    }
    
}

extension SourceStringChangeDescription: Equatable {
    
    public static func ==(lhs: SourceStringChangeDescription, rhs: SourceStringChangeDescription) -> Bool {
        
        if lhs.range != rhs.range {
            return false
        }
        
        if lhs.stringReplacement != rhs.stringReplacement {
            return false
        }
        
        if lhs.changeLength != rhs.changeLength {
            return false
        }
        
        if lhs.targetString != rhs.targetString {
            return false
        }
        
        if lhs.changeType != rhs.changeType {
            return false
        }
        return true
    }
}
