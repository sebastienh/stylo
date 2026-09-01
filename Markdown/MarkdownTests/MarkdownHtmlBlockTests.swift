//
//  MarkdownHtmlTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-30.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownHtmlBlockTests: MarkdownBasicTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// RESULT: PASS
    func testBasicHtmlBlock() {
    
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-html-block.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("</div>\n*foo*")
        
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
