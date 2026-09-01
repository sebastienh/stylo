//
//  MarkdownBlockquoteTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownBlockquoteTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///
    /// > block line 1
    /// > block line 2
    /// > block line 3
    /// 
    /// Paragraph following
    ///
    /// RESULT: PASS
    ///
    func testBasicBlockquote() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "blockquote.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("> block line 1\n> block line 2\n> block line 3\n\nParagraph following")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString, "expectedString: \(expectedString), \nreceivedString: \(tokenString)")
        
        print(tokens.toString())
    }

    ///
    /// > block line 1
    /// > block line 2
    /// > block line 3
    ///        dddddd
    ///
    ///
    /// RESULT: PASS
    ///
    func testBasicBlockquote2() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "blockquote-2.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("> block line 1\n> block line 2\n> block line 3\n        dddddd")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString, "expectedString: \(expectedString), \nreceivedString: \(tokenString)")
        
        print(tokens.toString())
    }
    
    
    ///
    /// RESULT: PASS
    ///
    func testReceiveTokensBlockquoteHeading() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "blockquote+paragraph+heading+carriage-return.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("> # first\r\n> ## second")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        print(tokenString)
        
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        print(expectedString)
        
        XCTAssert(tokenString == expectedString)
    }
    
}
