//
//  MarkdownHeadingTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-14.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownHeadingTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    ///
    /// #
    ///
    /// RESULT: PASS
    ///
    func testBasicHeadingLevelOne() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-heading-level-one.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("# ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString, "expectedString: \(expectedString), \nreceivedString: \(tokenString)")
        
        print(tokens.toString())
    }
    
    ///
    /// ##
    ///
    /// RESULT: PASS
    ///
    func testBasicHeadingLevelTwo() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-heading-level-two.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("## ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString, "expectedString: \(expectedString), \nreceivedString: \(tokenString)")
        
        print(tokens.toString())
    }
    
    ///
    /// ###
    ///
    /// RESULT: PASS
    ///
    func testBasicHeadingLevelThree() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-heading-level-three.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("### ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// ####
    ///
    /// RESULT: PASS
    ///
    func testBasicHeadingLevelFour() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-heading-level-four.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("#### ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// #####
    ///
    /// RESULT: PASS
    ///
    func testBasicHeadingLevelFive() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-heading-level-five.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("##### ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// ######
    ///
    /// RESULT: PASS
    ///
    func testBasicHeadingLevelSix() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-heading-level-six.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("###### ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

}
