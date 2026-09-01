//
//  MDURLEncodeTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-11.
//  Copyright © 2016 NM. All rights reserved.
//

import XCTest

class MDURLEncodeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testShouldEncodePercent() {
        
        XCTAssert("%%%".encodeToHtml() == "%25%25%25")
    }
    
    func testShouldEncodeControlChars() {
        
        XCTAssert("\r\n".encodeToHtml() == "%0D%0A")
    }
    
    func testShouldNotEncodePartsOfAnUrl() {
    
        XCTAssert("?#".encodeToHtml() == "?#")
    }
    
    func testShouldNotEncodeSquareBraquetsAndCircumflexAccentCommonmarkTests() {
    
        XCTAssert("[]^".encodeToHtml() == "%5B%5D%5E")
    }
    
    func testShouldEncodeSpaces() {
    
        XCTAssert("my url".encodeToHtml() == "my%20url")
    }
    
    func testShouldEncodeUnicode() {
    
        XCTAssert("φου".encodeToHtml() == "%CF%86%CE%BF%CF%85")
    }
    
    func testShouldEncodePercentIfItDoesntStartAValidEscapeSeq() {
     
        let encodedString = "%FG".encodeToHtml()
        
        XCTAssert(encodedString == "%25FG")
    }
    
    func testShouldPreserveNonUtf8EncodedCharacters() {
    
        let encodedString = "%00%FF".encodeToHtml()
        
        XCTAssert(encodedString == "%00%FF")
    }
    
    func testShouldEncodeCharactersOnTheCacheBorders() {
        
        // protects against off-by-one in cache implementation
        XCTAssert("\u{00}\u{7F}\u{80}".encodeToHtml() == "%00%7F%C2%80")
    }

//    func testBadSurrogatesHigh1() {
//        
//        XCTAssert("\u{D800}foo".encode() == "%EF%BF%BDfoo")
//    }
//    
//    func testBadSurrogatesHigh2() {
//        
//        XCTAssert("foo\u{D800}".encode() == "foo%EF%BF%BD")
//    }
//
//    func testBadSurrogatesLow1() {
//        
//        XCTAssert("\u{DD00}foo".encode() == "%EF%BF%BDfoo")
//    }
//    
//    func testBadSurrogatesLow2() {
//        
//        XCTAssert("foo\u{DD00}".encode() == "foo%EF%BF%BD")
//    }
//
//    func testValidSurrogate() {
//        
//        XCTAssert("\u{D800}\u{DD00}".encode() == "%F0%90%84%80")
//    }



}
