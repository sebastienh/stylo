//
//  MarkdownStrikethroughTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Markdown

class MarkdownStrikethroughTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///
    /// ~~strikethrough~~"
    ///
    /// RESULT: PASS
    ///
    func testStrikethrough() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "strikethrough.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("~~strikethrough~~")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// ~~strike~~
    ///
    /// RESULT: PASS
    ///
    func testBasicStrikethrough() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-strikethrough.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("~~strike~~")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

}
