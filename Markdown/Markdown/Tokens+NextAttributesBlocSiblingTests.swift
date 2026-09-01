//
//  Tokens+NextAttributesBlocSiblingTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-13.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class TokensTests: XCTestCase {


    func testNextAttributesBlocSibling() {
        
        let md = MarkdownParser()
        let tokens = md.parse("One _wit_ [ssss](www.estt.com) dddd {.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        
        // em_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(1) == nil)
        // link_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(5) == nil)
        
        print(tokens.toString())
    }
    
    func testNextAttributesBlocSibling2() {
        
        let md = MarkdownParser()
        let tokens = md.parse("One _wit_ [ssss](www.estt.com) {.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        
        // em_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(1) == nil)
        // link_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(5) != nil)
        
        print(tokens.toString())
    }
    func testNextAttributesBlocSibling3() {
        
        let md = MarkdownParser()
        let tokens = md.parse("One _wit_ [ssss](www.estt.com) \n{.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        
        // em_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(1) == nil)
        // link_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(5) != nil)
        
        print(tokens.toString())
    }
    
    func testNextAttributesBlocSibling4() {
        
        let md = MarkdownParser()
        let tokens = md.parse("One _wit_ `test` \n{.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        
        // em_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(1) == nil)
        // link_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(5) != nil)
        
        print(tokens.toString())
    }
    
    func testNextAttributesBlocSibling5() {
        
        let md = MarkdownParser()
        let tokens = md.parse("One _wit_ **test** \n{.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        
        // em_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(1) == nil)
        // link_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(5) != nil)
        
        print(tokens.toString())
    }
    
    func testNextAttributesBlocSibling6() {
        
        let md = MarkdownParser()
        let tokens = md.parse("One _wit_ _test_ \n{.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        
        // em_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(1) == nil)
        // link_open
        XCTAssert(inlineTokens.nextAttributesBlocSibling(5) != nil)
        
        print(tokens.toString())
    }
}
