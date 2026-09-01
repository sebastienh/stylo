//
//  CoreStringTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-10-09.
//  Copyright © 2016 NM. All rights reserved.
//

import XCTest
import Common

/// All
class CoreStringTests<S: CoreString> {
    
    init() {}
    
    /// MARK: var isEmpty: Bool { get }
    func testIsEmpty() {
        let s = S(string: "")
        XCTAssert(s.isEmpty)
    }

    /// var string: String { get }
    func testStringVariable() {
        
        let string = S(string: "test")
        XCTAssert(string.string == "test")
    }
    
    /// func startWithNewLine(atPosition position: Int) -> Int?
    func testStartWithNewLineNo() {
        
        var s = S(string: "test\n4\r\n")
        s.inlineBufferEnabled = true
        
        // use newLineTestString
        XCTAssert(s.startWithNewLine(atPosition: 0) == nil)
        
        let newLine = s.startWithNewLine(atPosition: 4)!
        XCTAssert(newLine == 1, "new line is \(newLine)")
        
        let newLine2 = s.startWithNewLine(atPosition: 6)!
        XCTAssert(newLine2 == 2)
    }
    
    /// func extractStringFromSegment(_ segment: (start: Int, end: Int)) -> String?
    func testExtractStringFromSegment() {
        // TODO
    }
    
    /// func hasPrefixFromPositionCaseSensitive(_ prefix: String, fromPosition position: Int) -> Bool
    func testHasPrefixFromPositionCaseSensitive() {
        
        var s = S(string: "test\n4\r\n")
        s.inlineBufferEnabled = true
        XCTAssert(s.hasPrefixFromPositionCaseSensitive("Te") == false)
        XCTAssert(s.hasPrefixFromPositionCaseSensitive("te") == true)
        XCTAssert(s.hasPrefixFromPositionCaseSensitive("test\n") == true)
    }
    
    /// func hasPrefix(_ prefix: String) -> Bool
    func testHasPrefix() {
        
        var s = S(string: "test\n4\r\n")
        s.inlineBufferEnabled = true
        XCTAssert(s.hasPrefixFromPositionCaseSensitive("Te") == false)
        XCTAssert(s.hasPrefixFromPositionCaseSensitive("te") == true)
        XCTAssert(s.hasPrefixFromPositionCaseSensitive("test\n") == true)
    }

    /// func slice(_ start: Int, end: Int?) -> Self?
    func testSlice() {
        
        let s = S(string: "test\n4\r\n")
        let slice = s.slice(1, end: 3)!
        XCTAssert(slice == "es")
    }
    
    /// func lowercaseCharAt(_ pos: Int) -> UniChar?
    func testLowercaseCharAt() {
        
        var s = S(string: "TEST\n4\r\n")
        s.inlineBufferEnabled = true
        let char = s.lowercaseCharAt(0)
        XCTAssert(char == §"t")
    }
    
    /// func indexOf(_ codeUnit: UTF16.CodeUnit) -> Int?
    func testIndexOf() {
        
        var s = S(string: "TEST\n4\r\n")
        s.inlineBufferEnabled = true
        
        let index = s.indexOf(§"t")
        XCTAssert(index == nil)
        
        let index2 = s.indexOf(§"T")
        XCTAssert(index2! == 0)
    }
    
    
    /// func indexOf(_ string: String, fromIndex index: Int) -> Int?
    func testIndexOfFromIndex() {
        
        var s = S(string: "TEST\n4\r\n")
        s.inlineBufferEnabled = true
        
        let index = s.indexOf("t", fromIndex: 1)
        XCTAssert(index == nil)
        
        let index2 = s.indexOf("T", fromIndex: 1)
        XCTAssert(index2 == 3, "Received \(index2)")
    }
    
    /// func isWhitespace(fromPosition position: Int) -> Bool
    func testIsWhitespace() {
        
        var s = S(string: "TEST\n4\r\n")
        s.inlineBufferEnabled = true
        
        XCTAssert(s.isWhitespace(fromPosition: 0) == false)
        XCTAssert(s.isWhitespace(fromPosition: 4) == true)
        XCTAssert(s.isWhitespace(fromPosition: 6) == true)
        XCTAssert(s.isWhitespace(fromPosition: 7) == true)
    }
    
    /// func skipAllWhitespaces(fromPosition position: Int) -> Int
    func testSkipAllWhitespaces() {
        
        var s = S(string: "    TEST\n4\r\n")
        s.inlineBufferEnabled = true
        
        XCTAssert(s.skipAllWhitespaces(fromPosition: 0) == 4, "received \(s.skipAllWhitespaces(fromPosition: 0))")
    }
    
    /// func hasPrefixFromPositionCaseInsensitive(_ prefix: String, fromPosition position: Int) -> Bool
    func testHasPrefixFromPositionCaseInsensitive() {
        
        var s = S(string: "test\n4\r\n")
        s.inlineBufferEnabled = true
        XCTAssert(s.hasPrefixFromPositionCaseInsensitive("Te") == true)
        XCTAssert(s.hasPrefixFromPositionCaseInsensitive("te") == true)
        XCTAssert(s.hasPrefixFromPositionCaseInsensitive("test\n") == true)
    }
    
    /// func lastIndexOf(_ codeUnit: UTF16.CodeUnit, fromIndex index: Int?) -> Int?
    func testLastIndexOf() {
        
        var s = S(string: "test\n4\r\n")
        s.inlineBufferEnabled = true
        
        let lastIndex = s.lastIndexOf(§"t", fromIndex: s.length - 1)
        XCTAssert(lastIndex == 3, "received \(lastIndex)")
        
        let lastIndex2 = s.lastIndexOf(§"t")
        XCTAssert(lastIndex2 == 3, "received \(lastIndex2)")
    }
    
    /// func endsWith(_ str: String) -> Bool
    func testEndsWith() {
        
        var s = S(string: "tes35523")
        s.inlineBufferEnabled = true
        
        XCTAssert(s.endsWith("5523") == true )
        XCTAssert(s.endsWith("553") == false )
    }
    
    /// func trimWhitespaces() -> Self
    func testTrimWhitespaces() {
        
        var s = S(string: " \ntes35523   \n   ")
        s.inlineBufferEnabled = true
        
        XCTAssert(s.trimWhitespaces() == "tes35523")
    }
    
    /// static func fromCharCode(_ codeUnit: UTF16Char) -> Self
    func testFromCharCode() {
        
        XCTAssert(S.fromCharCode(0x48) == S(string: "H"))
    }
    
//    /// mutating func replaceOccurrences(of target: String, with replacement: String)
//    func testReplaceOccurrences() {
//        
//        var s = S(string: "replaceOCreplaceOCreplaceOCreplaceOCreplaceOCreplaceOCreplaceOCreplace")
//        s.inlineBufferEnabled = true
//        
//        s.replaceOccurrences(of: "OC", with: "Here")
//        
//        XCTAssert(s == "replaceHerereplaceHerereplaceHerereplaceHerereplaceHerereplaceHerereplaceHerereplace", "received \(s)")
//    }
    
    
    /// func replacingOccurrences(of target: String, with replacement: String) -> Self
    func testReplacingOccurrences() {
        
        var s = S(string: "replaceOCreplaceOCreplaceOCreplaceOCreplaceOCreplaceOCreplaceOCreplace")
        s.inlineBufferEnabled = true
        
        let s2 = s.replacingOccurrences(of: "OC", with: "Here")
            
        XCTAssert(s == "replaceOCreplaceOCreplaceOCreplaceOCreplaceOCreplaceOCreplaceOCreplace")
        XCTAssert(s2 == "replaceHerereplaceHerereplaceHerereplaceHerereplaceHerereplaceHerereplaceHerereplace", "received \(s2)")
    }
    
    /// mutating func append(_ other: Self)
    func testAppend() {
        
        var s = S(string: "12345")
        
        s.append(S(string: "Here"))
        XCTAssert(s == "12345Here")
    }
    
    /// func components(separatedBy: String) -> [Self]
    func testComponentsSeparatedBy() {
        
        let s = S(string: "1,2,3,4,5")
        var result = ["1","2","3","4","5"]
        
        let strings = s.components(separatedBy: ",")
        
        for i in 0..<5 {
        
            XCTAssert(strings[i] == result[i])
        }
    }
    
    /// mutating func replaceAll(_ expression: NSRegularExpression, withTemplate template: String)
    func testReplaceAll() {

        var s = S(string: "replace             replace                \n\r  replace")
        s.inlineBufferEnabled = true
        
        s.replaceAll(regex("\\s+"), withTemplate: " ")
        s.replaceAll(regex(" "), withTemplate: "&nbsp;")
        
        XCTAssert(s == "replace&nbsp;replace&nbsp;replace", "error received \(s)")
    }
    
    /// static func +(lhs: Self, rhs: Self) -> Self
    func testPlus() {
        
        let s1 = S(string: "replace")
        let s2 = S(string: "replace")
        
        let s3 = s1 + s2
        
        XCTAssert(s3 == "replacereplace")
    }
    
    /// static func +=(lhs: inout Self, rhs: Self)
    func testPlusEqual() {
        
        var s1 = S(string: "replace")
        let s2 = S(string: "replace")
        
        s1 += s2
        
        XCTAssert(s1 == "replacereplace")
        XCTAssert(s2 == "replace")
    }
    
}
