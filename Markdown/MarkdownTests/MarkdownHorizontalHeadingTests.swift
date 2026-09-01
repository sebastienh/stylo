//
//  MarkdownHorizontalHeadingTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownHorizontalHeadingTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///
    /// Titre Level 1
    /// =============
    ///
    /// Titre Level 2
    /// -------------
    ///
    /// RESULT: PASS
    ///
    func testHorizontalHeadings() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "horizontal-headings.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("Titre Level 1\n=============\n\nTitre Level 2\n-------------")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString, "expectedString: \(expectedString), \nreceivedString: \(tokenString)")
        
        print(tokens.toString())
    }

}
