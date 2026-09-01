//
//  StringCoreStringTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-10-11.
//  Copyright © 2016 NM. All rights reserved.
//

import XCTest

class StringCoreStringTests: XCTestCase {

    let coreStringTests = CoreStringTests<String>()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsEmpty() {
        coreStringTests.testIsEmpty()
    }
    
    /// var string: String { get }
    func testStringVariable() {
        coreStringTests.testStringVariable()
    }
    
    /// func startWithNewLine(atPosition position: Int) -> Int?
    func testStartWithNewLineNo() {
        coreStringTests.testStartWithNewLineNo()
    }
    
    /// func extractStringFromSegment(_ segment: (start: Int, end: Int)) -> String?
    func testExtractStringFromSegment() {
        coreStringTests.testExtractStringFromSegment()
    }
    
    /// func hasPrefixFromPositionCaseSensitive(_ prefix: String, fromPosition position: Int) -> Bool
    func testHasPrefixFromPositionCaseSensitive() {
        coreStringTests.testHasPrefixFromPositionCaseSensitive()
    }
    
    /// func hasPrefix(_ prefix: String) -> Bool
    func testHasPrefix() {
        coreStringTests.testHasPrefix()
    }
    
    /// func slice(_ start: Int, end: Int?) -> Self?
    func testSlice() {
        coreStringTests.testSlice()
    }
    
    /// func lowercaseCharAt(_ pos: Int) -> UniChar?
    func testLowercaseCharAt() {
        coreStringTests.testLowercaseCharAt()
    }
    
    /// func indexOf(_ codeUnit: UTF16.CodeUnit) -> Int?
    func testIndexOf() {
        coreStringTests.testIndexOf()
    }
    
    /// func indexOf(_ string: String, fromIndex index: Int) -> Int?
    func testIndexOfFromIndex() {
        coreStringTests.testIndexOfFromIndex()
    }
    
    /// func isWhitespace(fromPosition position: Int) -> Bool
    func testIsWhitespace() {
        coreStringTests.testIsWhitespace()
    }
    
    /// func skipAllWhitespaces(fromPosition position: Int) -> Int
    func testSkipAllWhitespaces() {
        coreStringTests.testSkipAllWhitespaces()
    }
    
    /// func hasPrefixFromPositionCaseInsensitive(_ prefix: String, fromPosition position: Int) -> Bool
    func testHasPrefixFromPositionCaseInsensitive() {
        coreStringTests.testHasPrefixFromPositionCaseInsensitive()
    }
    
    /// func lastIndexOf(_ codeUnit: UTF16.CodeUnit, fromIndex index: Int?) -> Int?
    func testLastIndexOf() {
        coreStringTests.testLastIndexOf()
    }
    
    /// func endsWith(_ str: String) -> Bool
    func testEndsWith() {
        coreStringTests.testEndsWith()
    }
    
    /// func trimWhitespaces() -> Self
    func testTrimWhitespaces() {
        coreStringTests.testTrimWhitespaces()
    }
    
    /// static func fromCharCode(_ codeUnit: UTF16Char) -> Self
    func testFromCharCode() {
        coreStringTests.testFromCharCode()
    }
    
//    /// mutating func replaceOccurrences(of target: String, with replacement: String)
//    func testReplaceOccurrences() {
//        coreStringTests.testReplaceOccurrences()
//    }
    
    /// func replacingOccurrences(of target: String, with replacement: String) -> Self
    func testReplacingOccurrences() {
        coreStringTests.testReplacingOccurrences()
    }
    
    /// mutating func append(_ other: Self)
    func testAppend() {
        coreStringTests.testAppend()
    }
    
    /// func components(separatedBy: String) -> [Self]
    func testComponentsSeparatedBy() {
        coreStringTests.testComponentsSeparatedBy()
    }
    
    /// mutating func replaceAll(_ expression: NSRegularExpression, withTemplate template: String)
    func testReplaceAll() {
        coreStringTests.testReplaceAll()
    }
    
    /// static func +(lhs: Self, rhs: Self) -> Self
    func testPlus() {
        coreStringTests.testPlus()
    }
    
    /// static func +=(lhs: inout Self, rhs: Self)
    func testPlusEqual() {
        coreStringTests.testPlusEqual()
    }}
