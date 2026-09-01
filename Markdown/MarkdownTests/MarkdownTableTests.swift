//
//  MarkdownTableTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-04-22.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownTableTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicTable() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-table.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        // | Option | Description |
        // | ------ | ----------- |
        // | data   | path to dat |
        
        let tokens = md.parse("| Option | Description |\n| ------ | ----------- |\n| data   | path to dat |")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    func testTableWithoutHeader() {
        
        let content = try! String(contentsOf: urlOfFile(named: "table-without-header.md")! as URL, encoding: String.Encoding.utf8)
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "table-without-header-result.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse(content)
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
    }
    
    
}
