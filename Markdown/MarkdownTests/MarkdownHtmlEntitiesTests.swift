//
//  MarkdownHtmlEntitiesTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-19.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownHtmlEntitiesTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// In this test we don't follow markdown-it since markdown-it does not
    /// create an entity token, so for this test we take our output.
    ///
    /// RESULT: PASS
    func testEntityCodeEm() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "entity+code+em.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("The killer *feature &amp;* of `markdown-it` is &amp; very")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
        
        
    }
    // Note: if this test fail it's probably because we deceided to implement smartquote feature.
    // FIXME: change this test when smartquote is implemented.
    func testEntity() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "entity.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        md.options.markdownOut = false
        
        let tokens = md.parse("C'est l'&eacute;t&#233;!")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        print(tokenString)
        
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        print(expectedString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
    }
    
    func testAmpHtmlEntity() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "amp-html-entity.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("&amp;")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    func testAmpNumberHtmlEntity() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "amp-number-html-entity.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("&#38;")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    func testEntityPattern() {
        
        executeTestWithString("&#X22; &#XD06; &#xcab;", andFile: "entity-pattern.json")
    }
    
    func testEntityPattern2() {
        
        executeTestWithString("&#98765432;", andFile: "entity-pattern-2.json")
    }
    
    func testEntityPattern3() {
        
        executeTestWithString("&#0;", andFile: "entity-pattern-3.json")
    }
    
}
