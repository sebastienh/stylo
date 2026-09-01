//
//  MardownListTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-04-18.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MardownListTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //
    //    - Marker character change forces new list start:
    //       * Ac tristique libero volutpat at
    //       + Facilisis in pretium nisl aliquet
    //       - Nulla volutpat aliquam velit
    ///
    /// RESULT: PASS
    ///
    func testMarkedList() {
    
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "marked-list.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("- Marker character change forces new list start:\n   * Ac tristique libero volutpat at\n   + Facilisis in pretium nisl aliquet\n   - Nulla volutpat aliquam velit")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// RESULT: PASS
    ///
    func testOrderedStart() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-ordered-list.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("1. first item\n2. second item ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    ///
    /// RESULT: PASS
    ///
    func testUnorderedStart() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-unordered-list.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("+ First line\n+ Second line")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// RESULT: PASS
    ///
    func testBasicListOffset() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-list-offset.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("57. foo\n1. bar")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// RESULT: PASS
    ///
    func testComplicatedList() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "complicated-list.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("## Lists\n" +
            "\n" +
            "Unordered\n" +
            "\n" +
            "+ Create a list by starting a line\n" +
            "+ Sub-lists are made by indenting 2 spaces:\n" +
            "  - Marker character change forces new list start:\n" +
            "    * Ac tristique libero volutpat at\n" +
            "    + Facilisis in pretium nisl aliquet\n" +
            "    - Nulla volutpat aliquam velit\n" +
            "+ Very easy!\n" +
            "\n" +
            "Ordered\n" +
            "\n" +
            "1. Lorem ipsum dolor sit amet\n" +
            "2. Consectetur adipiscing elit\n" +
            "3. Integer molestie lorem at massa\n" +
            "\n" +
            "\n" +
            "1. You can use sequential numbers...\n" +
            "1. ...or keep all the numbers as\n" +
            "\n" +
            "Start numbering with offset:\n" +
            "\n" +
            "57. foo\n" +
            "1. bar")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    func testSpaceEndedListParsing() {
        
        let string = try! String(contentsOf: urlOfFile(named: "list.md")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse(string)
        
        debugPrint(tokens)
    }
    
}
