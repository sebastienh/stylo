//
//  MarkdownTextTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Markdown

class MarkdownTextTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///
    /// "~~"
    ///
    /// RESULT: PASS
    ///
    func testPreStrikethrough() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "pre-strikethrough.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("~~")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    ///
    /// "~"
    ///
    /// RESULT: TBD
    ///
    func testPreStrikethrough2() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "pre-strikethrough2.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("~")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
}
