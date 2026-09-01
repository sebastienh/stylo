//
//  String+CoreString.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-09-07.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension String: CoreString {

    ///
    public var inlineBufferEnabled: Bool {
        
        get {
            return false
        }
        set {
            // nothing to do
        }
    }
    
    public init(string: String) {
        
        self.init(string)
    }
    
    public var string: String {
        
        return self
    }
    
    mutating public func replaceAll(_ expression: NSRegularExpression, withTemplate template: String) {
        
        replaceAll(expression, options: [], subrange: startIndex..<endIndex, withTemplate: template)
    }
    
    public func replacingOccurrences(of target: String, with replacement: String) -> String {
        
        return (self as NSString).replacingOccurrences(of: target, with: replacement, range: NSMakeRange(0, length))
    }
    
    public func charAt(_ index: Int, isEqualTo char: UTF16.CodeUnit) -> Bool {
        
        if let charAtIndex = charAt(index), charAtIndex == char {
            
            return true
        }
        return false
    }
    
    public func charAt(_ integerIndex: Int) -> UTF16.CodeUnit? {
        
        if integerIndex < 0 {
            return nil
        }
        
        let index = String.UTF16View.Index(utf16Offset: integerIndex, in: self)
        
        if index < utf16.endIndex{
            return utf16[index]
        }
        
        return nil
    }
    
    public var length: Int {
        
        return utf16.count
    }

    public func isGraveAccent(at index: Int) -> Bool {
        
        return string.charAt(index) == §UnicodeCharacter.graveAccent
    }
    
    /// Method that return the substring based on the String.Index unit, the Character.
    /// The end index is the up-to index (not including)
    public func slice(_ start: Int, end: Int? = nil) -> String? {
        
        let utf16Length = self.utf16.count
        var localEnd: Int = end ?? utf16Length
        let localStart = start < 0 ? length + start : start
        
        if localStart < 0 || localStart >= utf16Length {
            return nil
        }
        
        if let _end = end {
            
            if start == _end {
                return ""
            }
            if _end < 0 {
                localEnd = utf16Length + _end
            }
        }
        let utf16View = self.utf16
        
        let _startIndex = utf16View.index(utf16View.startIndex, offsetBy: localStart)
        
        if localEnd == utf16View.count {
            
            return String(utf16View[_startIndex..<utf16View.endIndex])
        }
        else {
            
            let substringLenght = localEnd - localStart
            
            if substringLenght >= 0 && substringLenght <= utf16Length {
                
                let _endIndex = utf16View.index(_startIndex, offsetBy: substringLenght)
                return String(utf16View[_startIndex..<_endIndex])
            }
        }
        return nil
    }
    
    public func extractStringFromSegment(_ segment: (start: Int, end: Int)) -> String? {
        
        let utf16View = self.utf16
        
        let startIndex = utf16View.index(utf16View.startIndex, offsetBy: segment.start)
        
        if segment.end == utf16View.count {
            return String(utf16View[startIndex..<utf16View.endIndex])
        }
        else {
            let endIndex = utf16View.index(utf16View.startIndex, offsetBy: segment.end - segment.start)
            return String(utf16View[startIndex..<endIndex])
        }
    }
    
    public func trimWhitespaces() -> String {
        //Returns "Let's trim the whitespace"
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public func trimOneLeadingAndTrailingSpace() -> String {
        
        let string = trimOneLeadingSpace(self)
        return trimOneTrailingSpace(string)
    }
    
    private func trimOneLeadingSpace(_ string: String) -> String {
        
        if let char = string.charAt(0), isSpace(char) {
            
            let startIndex = String.Index(utf16Offset: 1, in: string)
            return String(string.utf16[startIndex..<string.utf16.endIndex])!
        }
        return string
    }
    
    private func trimOneTrailingSpace(_ string: String) -> String {
        
        if let char = string.charAt(string.length - 1), isSpace(char) {
            
            let endIndex = String.Index(utf16Offset: string.length - 1, in: string)
            return String(string.utf16[string.utf16.startIndex..<endIndex])!
        }
        return string
    }
}

fileprivate let UNESCAPE_MD_RE  = "\\\\([!\"#\\$%&'\\(\\)\\*\\+, - \\.\\/:;<=>\\?@\\[ \\]\\^_`\\{\\|\\}~])" // \\
fileprivate let ENTITY_RE       = "&(?:#x[a-f0-9]{1,8}|#[0-9]{1,8}|[a-z][a-z0-9]{1,31});"  //"&([a-z#][a-z0-9]

fileprivate let entityRegex = regex(ENTITY_RE)

extension String: HtmlString {
    
    public typealias OperatingStringType = String
    
    mutating public func unescapeAll() -> String {
        
        if !self.contains("\\") && !self.contains("&") {
            
            return self 
        }
        
        let unescapedRegex = try! NSRegularExpression(pattern: UNESCAPE_MD_RE, options: NSRegularExpression.Options.caseInsensitive)
        replaceAll(unescapedRegex, subrange: startIndex..<endIndex, withTemplate: "$1")
        
        // update range
        let matches = entityRegex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        
        // begin with the last match
        for match in matches.reversed() {
            
            let startIndex = self.index(self.startIndex, offsetBy: match.range.location)
            let endIndex = index(startIndex, offsetBy: match.range.length)
            
            let replacementRange = startIndex..<endIndex
            
            // Errors are just ignored.
            if let entityString = self.substring(with: replacementRange).decodeHTML() {
                replaceSubrange(replacementRange, with: entityString)
            }
            else {
                replaceSubrange(replacementRange, with: "�")
            }
        }
        
        return self
    }

    /// Decode the HTML character entity to the corresponding
    /// Unicode character, return `nil` for invalid input.
    ///     decode("&#64;")    --> "@"
    ///     decode("&#x20ac;") --> "€"
    ///     decode("&lt;")     --> "<"
    ///     decode("&foo;")    --> nil
    public func decodeHTML() -> String? {
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : String?, base : Int32) -> String? {
            
            // stop when there no number
            if string == nil {
                
                return nil
            }
            
            // stop when there no number
            if string!.hasPrefix(";") {
                
                return nil
            }
            
            let characterNumberValue = UInt32(strtoul(string!.string, nil, base))
            
            if characterNumberValue > 0x10FFFF || characterNumberValue == 0 {
                
                return "�"
            }
            
            return String(describing: UnicodeScalar(characterNumberValue)!)
        }
        
        if hasPrefix("&#x") || hasPrefix("&#X"){
            
            return decodeNumeric(slice(3, end: -1), base: 16)
        }
        else if hasPrefix("&#") {
            
            return decodeNumeric(slice(2, end: -1), base: 10)
        }
        else {
            
            return CharacterEntities[self]
        }
    }    
}
