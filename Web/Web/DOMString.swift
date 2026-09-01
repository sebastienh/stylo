//
//  DOMString.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-17.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

public typealias DOMString = String

public extension String {
    
    
    /// String length, should be in UTF-16 
//    var length: Int {
//        return self.characters.count
//    }

    /// self.capitalizedString shorthand
    var capitalized: String {
        return capitalized
    }
    
    ///
    /// Returns the substring in the given range
    ///
    /// - parameter range:
    /// - returns: Substring in range
    subscript (range: Range<Int>) -> String? {
        
        if range.lowerBound < 0 || range.upperBound > self.length {
            return nil
        }
        
        let range = self.utf16.index(self.utf16.startIndex, offsetBy: range.lowerBound)..<self.utf16.index(self.utf16.startIndex, offsetBy: range.upperBound)
        
        return String(self.utf16[range])
    }
    
//    subscript (range: Range<Int>) -> String? {
//
//        if range.startIndex < 0 || range.endIndex > self.length {
//            return nil
//        }
//        
//        let subStart = advance(self.startIndex, range.startIndex, self.endIndex)
//        let subEnd = advance(subStart, range.endIndex - range.startIndex, self.endIndex)
//        return self.substringWithRange(Range(start: subStart, end: subEnd))
//    }
    
    func substring(_ from: Int) -> String? {
        let end = self.count
        return self[from..<end]
    }
    
    func substring(_ from: Int, length: Int) -> String? {
        let end = from + length
        return self[from..<end]
    }
    
    /**
    Returns an array of strings, each of which is a substring of self formed by splitting it on separator.
    
    - parameter separator: Character used to split the string
    - returns: Array of substrings
    */
    func explode (_ separator: Character) -> [String] {
        
        return self.split(whereSeparator: { $0 == separator}).map { String($0) }
    }
    
    /**
    Inserts a substring at the given index in self.
    
    - parameter index: Where the new string is inserted
    - parameter string: String to insert
    - returns: String formed from self inserting string at index
    */
    func insert (_ index: Int, _ string: String) -> String {
        //  Edge cases, prepend and append
        if index > length {
            return self + string
        } else if index < 0 {
            return string + self
        }
        
        return self[0..<index]! + string + self[index..<length]!
    }
    
    mutating func removeSubstring(_ deleteOffset: Int, count: Int) {
        
        let startIndex = self.startIndex
        
        let startDeleteIndex = self.index(startIndex, offsetBy: deleteOffset)
        let endDeleteIndex = self.index(startDeleteIndex, offsetBy: count)
        
        removeSubrange(startDeleteIndex..<endDeleteIndex)
    }
    
    /**
    Strips whitespaces from the beginning of self.
    
    - returns: Stripped string
    */
    func ltrimmed () -> String {
        return ltrimmed(CharacterSet.whitespacesAndNewlines)
    }
    
    /**
    Strips the specified characters from the beginning of self.
    
    - returns: Stripped string
    */
    func ltrimmed (_ set: CharacterSet) -> String {
        if let range = rangeOfCharacter(from: set.inverted) {
            return String(self[range.lowerBound..<endIndex])
        }
        
        return ""
    }
    
    /**
    Strips whitespaces from the end of self.
    
    - returns: Stripped string
    */
    func rtrimmed () -> String {
        return rtrimmed(CharacterSet.whitespacesAndNewlines)
    }
    
    /**
    Strips the specified characters from the end of self.
    
    - returns: Stripped string
    */
    func rtrimmed (_ set: CharacterSet) -> String {
        if let range = rangeOfCharacter(from: set.inverted, options: NSString.CompareOptions.backwards) {
            return String(self[startIndex..<range.upperBound])
        }
        
        return ""
    }
    
    /**
    Strips whitespaces from both the beginning and the end of self.
    
    - returns: Stripped string
    */
    func trimmed () -> String {
        return (self as NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /**
    Parses a string containing a non-negative integer value into an optional UInt if the string is a well formed number.
    
    - returns: A UInt parsed from the string or nil if it cannot be parsed.
    */
    func toUInt() -> UInt? {
        if let val = Int(self.trimmed()) {
            if val < 0 {
                return nil
            }
            return UInt(val)
        }
        
        return nil
    }
    
    
    /**
    Parses a string containing a boolean value (true or false) into an optional Bool if the string is a well formed.
    
    - returns: A Bool parsed from the string or nil if it cannot be parsed as a boolean.
    */
    func toBool() -> Bool? {
        let text = self.trimmed().lowercased()
        if text == "true" || text == "false" || text == "yes" || text == "no" {
            return (text as NSString).boolValue
        }
        
        return nil
    }
    
    /**
    Parses a string containing a date into an optional NSDate if the string is a well formed.
    The default format is yyyy-MM-dd, but can be overriden.
    
    - returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
    */
    func toDate(_ format : String? = "yyyy-MM-dd") -> Date? {
        let text = self.trimmed().lowercased()
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone.current
        if let fmt = format {
            dateFmt.dateFormat = fmt
        }
        return dateFmt.date(from: text)
    }
    
    /**
    Parses a string containing a date and time into an optional NSDate if the string is a well formed.
    The default format is yyyy-MM-dd hh-mm-ss, but can be overriden.
    
    - returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
    */
    func toDateTime(_ format : String? = "yyyy-MM-dd hh-mm-ss") -> Date? {
        return toDate(format)
    }
    
}

