//
//  Utils.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-23.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

////////////////////////////////////////////////////////////////////////////////

let REGEXP_ESCAPE_RE = "([\\.\\?\\*\\+\\^\\$\\[\\]\\(\\)\\{\\}\\|\\-\\\\])"
fileprivate let escapeRegex = regex(REGEXP_ESCAPE_RE)


func escapeRE(_ str: String) -> String {
    
    var localString = str
    
    localString.replaceAll(escapeRegex, withTemplate: "\\\\$1")
    
    return localString
}


////////////////////////////////////////////////////////////////////////////////

func escapeHtml(_ str: String, preserveEntities: Bool = true) -> String {
    
    var localString = str
    
//    let ampRegex = preserveEntities ? regex("[&](?![#](x[a-f0-9]{1,8}|[0-9]{1,8});|[a-z][a-z0-9]{1,31};)", options: .CaseInsensitive) : regex("[&]")
    
    localString = localString.replacingOccurrences(of: "&", with: "&amp;", options: .literal)
    localString = localString.replacingOccurrences(of: "<", with: "&lt;", options: .literal)
    localString = localString.replacingOccurrences(of: ">", with: "&gt;", options: .literal)
    localString = localString.replacingOccurrences(of: "\"", with: "&quot;", options: .literal)

    return localString
}

////////////////////////////////////////////////////////////////////////////////


let UNESCAPE_MD_RE  = "\\\\([!\"#\\$%&'\\(\\)\\*\\+, - \\.\\/:;<=>\\?@\\[ \\]\\^_`\\{\\|\\}~])" // \\
//                      \\ ([! "#  $%&'  (  )  *  +,\-   . \/:;<=>  ?@  [\\\]  ^_`  {  |  }~]


let ENTITY_RE       = "&(?:#x[a-f0-9]{1,8}|#[0-9]{1,8}|[a-z][a-z0-9]{1,31});"  //"&([a-z#][a-z0-9]{1,31});";
fileprivate let unescapedRegex = regex(UNESCAPE_MD_RE)

func unescapeMd(_ str: String) -> String {
    
    var localString = str
    
    if !localString.contains("\\") {
        
        return localString
    }

    localString.replaceAll(unescapedRegex, subrange: localString.startIndex..<localString.endIndex, withTemplate: "$1")
    
    return localString
}

//fileprivate let entityRegex = regex(ENTITY_RE)
//
//func unescapeAll(_ str: String) -> String {
//    
//    var localString = str
//    
//    let unescapedRegex = try! NSRegularExpression(pattern: UNESCAPE_MD_RE, options: NSRegularExpression.Options.caseInsensitive)
//    localString.replaceAll(unescapedRegex, withTemplate: "$1")
//    
//    // update range
//    let matches = entityRegex.matches(in: localString, options: [], range: NSMakeRange(0, localString.characters.count))
//
//    // begin with the last match
//    for match in matches.reversed() {
//        
//        let startIndex = localString.characters.index(localString.startIndex, offsetBy: match.range.location)
//        let endIndex = localString.index(startIndex, offsetBy: match.range.length)
//        
//        let replacementRange = Range<String.Index>(startIndex..<endIndex)
//        
//        // Errors are just ignored.
//        if let entityString = decodeHTML(localString.substring(with: replacementRange)) {
//        
//            localString.replaceSubrange(replacementRange, with: entityString)
//        }
//        else {
//            
//            localString.replaceSubrange(replacementRange, with: "�")
//        }
//    }
//    
//    return localString
//}
//
///// Decode the HTML character entity to the corresponding
///// Unicode character, return `nil` for invalid input.
/////     decode("&#64;")    --> "@"
/////     decode("&#x20ac;") --> "€"
/////     decode("&lt;")     --> "<"
/////     decode("&foo;")    --> nil
//func decodeHTML(_ entity: String) -> String? {
//    
//    // Convert the number in the string to the corresponding
//    // Unicode character, e.g.
//    //    decodeNumeric("64", 10)   --> "@"
//    //    decodeNumeric("20ac", 16) --> "€"
//    func decodeNumeric(_ string : String?, base : Int32) -> String? {
//        
//        // stop when there no number
//        if string == nil {
//            
//            return nil
//        }
//        
//        // stop when there no number 
//        if string!.hasPrefix(";") {
//            
//            return nil
//        }
//        
//        let characterNumberValue = UInt32(strtoul(string!.string, nil, base))
//        
//        if characterNumberValue > 0x10FFFF || characterNumberValue == 0 {
//            
//            return "�"
//        }
//        
//        return String(describing: UnicodeScalar(characterNumberValue)!)
//    }
//    
//    if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
//        
//        return decodeNumeric(entity.slice(3, end: -1), base: 16)
//    }
//    else if entity.hasPrefix("&#") {
//        
//        return decodeNumeric(entity.slice(2, end: -1), base: 10)
//    }
//    else {
//        
//        return CharacterEntities[entity.string]
//    }
//}


func isValidEntityCode(_ c: UTF16.CodeUnit) -> Bool {
    
    /*eslint no-bitwise:0*/
    // broken sequence
    if c >= 0xD800 && c <= 0xDFFF {

        return false
    }
    
    // never used
    if c >= 0xFDD0 && c <= 0xFDEF {
        
        return false
    }
    
    if (c & 0xFFFF) == 0xFFFF || (c & 0xFFFF) == 0xFFFE {
        
        return false
    }
    
    // control codes
    if c >= 0x00 && c <= 0x08 {
        
        return false
    }
    
    if c == 0x0B {
        
        return false
    }
    
    if c >= 0x0E && c <= 0x1F {
        
        return false
    }
    
    if c >= 0x7F && c <= 0x9F {
        
        return false
    }
    
    return true
}




////////////////////////////////////////////////////////////////////////////////

/// In this method we return the length when we know the lenght, meaning 
/// that the new line character by itself is a new line and we don't further
/// processing.
/// In my case I don't consider the character 0x2424 as a new line in itself 
/// as stated in this [wiki article](https://en.wikipedia.org/wiki/Newline)
/// The Unicode characters U+2424 (SYMBOL FOR NEWLINE, ␤), U+23CE (RETURN SYMBOL, ⏎), 
/// U+240D (SYMBOL FOR CARRIAGE RETURN, ␍) and U+240A (SYMBOL FOR LINE FEED, ␊) are 
/// intended for presenting a user-visible character to the reader of the document, 
/// and are thus most often not recognized themselves as a newline.
func isPossibleNewLineStartCodePoint(_ code: UTF16.CodeUnit) -> Bool {
    
    // LF:    Line Feed ('\n'), U+000A
    // Note: we can't return the length since it could be:
    // LF+CR: Acorn BBC and RISC OS spooled text output.
    if code == 0x0A {
        
        return true
    }
    // CR:    Carriage Return ('\r'), U+000D
    // Note: could be '\r\n' express in two so we don't 
    // know its length right away.
    // CommonMark also consider those cases :
    // \r[\n\u0085]
    // CR+LF: CR (U+000D) followed by LF (U+000A)
    if code == 0x0D {
        
        return true
    }
    
    // '\r\n', 0x0D0A
    if code == 0x0D0A{
        
        return true
    }
    
    // RS, 0x1E
    if code == 0x1E {
        
        return true
    }
    
    // NEL:   Next Line, U+0085
    if code == 0x0085 {
        
        return true
    }
    // LS:    Line Separator, U+2028
    if code == 0x2028 {
        
        return true
    }
    // VT:    Vertical Tab, U+000B
    if code == 0x000B {
        
        return true
    }
    
    // FF:    Form Feed, U+000C
    if code == 0x000C {
        
        return true
    }
   
    // PS:    Paragraph Separator, U+2029
    if code == 0x2029 {
        
        return true
    }
    
    return false 
}

// Zs (unicode class) || [\t\f\v\r\n]
func isWhiteSpace(_ code: UTF16.CodeUnit) -> Bool {
    
    if code >= 0x2000 && code <= 0x200A {
        
        return true
    }
    
    switch (code) {
        
    case 0x09:
        // \t
        return true
    case 0x0A:
        
        // \n
        return true
        
    case 0x0B:
        
        // \v
        return true
        
    case 0x0C:
        
        // \f
        return true
        
    case 0x0D:
        
        // \r
        return true
        
    case 0x0085:
        
        // \u0085  (newline, space, invisible
        return true
        
    case 0x2028:
        
        // \u2028  (newline, space, invisible)
        return true
        
    case 0x20:
        
        return true
        
    case 0xA0:
        
        return true
        
    case 0x1680:
        
        return true
        
    case 0x202F:
        
        return true
        
    case 0x205F:
        
        return true
        
    case 0x3000:
        
        return true
        
    default:
        
        return false
    }
}

/// Currently without astral characters support.
func isPunctChar(_ ch: UTF16Char) -> Bool {
    
    return CharacterSet.punctuationCharacters.contains(UnicodeScalar(ch)!)
}

/// Markdown ASCII punctuation characters.
///
/// !, ", #, $, %, &, ', (, ), *, +, ,, -, ., /, :, ;, <, =, >, ?, @, [, \, ], ^, _, `, {, |, }, or ~
/// http://spec.commonmark.org/0.15/#ascii-punctuation-character
///
/// Don't confuse with unicode punctuation !!! It lacks some chars in ascii range.
///
func isMdAsciiPunct(_ ch: UTF16.CodeUnit) -> Bool {
    
    switch (ch) {
    case 0x21: return true // !
    case 0x22: return true // "
    case 0x23: return true // #
    case 0x24: return true // $
    case 0x25: return true // %
    case 0x26: return true // &
    case 0x27: return true // '
    case 0x28: return true // ( 
    case 0x29: return true // ) 
    case 0x2A: return true // * 
    case 0x2B: return true // + 
    case 0x2C: return true // , 
    case 0x2D: return true // - 
    case 0x2E: return true // . 
    case 0x2F: return true // / 
    case 0x3A: return true // : 
    case 0x3B: return true // ; 
    case 0x3C: return true // < 
    case 0x3D: return true // = 
    case 0x3E: return true // > 
    case 0x3F: return true // ? 
    case 0x40: return true // @ 
    case 0x5B: return true // [ 
    case 0x5C: return true // \ 
    case 0x5D: return true // ] 
    case 0x5E: return true // ^ 
    case 0x5F: return true // _ 
    case 0x60: return true // ` 
    case 0x7B: return true // { 
    case 0x7C: return true // | 
    case 0x7D: return true // } 
    case 0x7E: return true // ~
    default:
        return false;
    }
}

///
/// Hepler to unify [reference labels].
///
func normalizeReference(_ str: String) -> String {
    
    // use .toUpperCase() instead of .toLowerCase()
    // here to avoid a conflict with Object.prototype
    // members (most notably, `__proto__`)
    // Note: Us we use lowercase since we don't 
    // have the possibility of such conflicts
    var localString = str.lowercased().trimWhitespaces()
    localString.replaceAll(regex("\\s+"), withTemplate: " ")
    return localString.trimWhitespaces()
}

func rangesOfStringsInString(_ string: String, strings: Array<String>) -> [CountableRange<Int>]? {
    
    var result = [CountableRange<Int>]()
    
    // First test whether the string appears at all
    var occurence: (start: Int, end: Int)? = occurenceOfSearchedStringsInString(string, strings: strings)
    
    if occurence != nil {
        // continue to look for the other ranges
        while occurence != nil {
            
            result.append(occurence!.start..<occurence!.end)
            occurence = occurenceOfSearchedStringsInString(string, strings: strings, fromPosition: occurence!.end)
        }
        return result
    }
    return nil
}

func occurenceOfSearchedStringsInString(_ string: String, strings: [String], fromPosition position: Int = 0) ->(start: Int, end: Int)? {
    
    var i = position
    var startIndex: Int?
    var endIndex: Int?
    
    func startRecording(_ index: Int, length: Int) {
        startIndex = index
        endIndex = index + length
    }
    
    func isRecording() -> Bool {
        if startIndex != nil && endIndex != nil {
            return true
        }
        return false
    }
    
    func clearRecordingInfo() {
        startIndex = nil
        endIndex = nil
    }
    
    func incrementEndIndex(by value: Int) {
        endIndex! += value
    }
    
    while i < string.length {
        
        if let prefixLength = stringHasOneOfPrefixes(string, strings: strings, fromPosition: i) {
            
            if isRecording() {
                incrementEndIndex(by: prefixLength)
                i += prefixLength
            }
            else {
                startRecording(i, length: prefixLength)
                i += 1
            }
        }
        else {
            
            if isRecording() {
                // return the result 
                let result = (start: startIndex!, end: endIndex!)
                clearRecordingInfo()
                return result
            }
            i += 1
        }
    }
    
    return nil
}

func stringHasOneOfPrefixes(_ string: String, strings: [String], fromPosition position: Int = 0) -> Int? {
    
    for prefix in strings {
        
        if string.hasPrefixFromPositionCaseSensitive(prefix, fromPosition: position) {
            
            return prefix.length
        }
    }
    
    return nil
}

