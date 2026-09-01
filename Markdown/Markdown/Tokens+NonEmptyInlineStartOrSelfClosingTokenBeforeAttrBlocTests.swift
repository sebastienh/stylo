//
//  Tokens+NonEmptyInlineStartOrSelfClosingTokenBeforeAttrBlocTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-14.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class Tokens_NonEmptyInlineStartOrSelfClosingTokenBeforeAttrBlocTests: XCTestCase {

    func testNonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc() {
        
        let md = MarkdownParser()
        let tokens = md.parse("[ssss](www.estt.com) dddd {.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        
        XCTAssert(inlineTokens.nonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc(4)?.type == .text)
        
//        print(tokens.toString())
    }

    func testNonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc2() {
        
        let md = MarkdownParser()
        let tokens = md.parse("[ssss](www.estt.com) {.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        
        let tokenBefore = inlineTokens.nonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc(4)
        
        XCTAssert(tokenBefore?.type == .linkOpen)
        
        print(tokens.toString())
    }
    
    func testNonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc3() {
        
        let md = MarkdownParser()
        let tokens = md.parse("[ssss](www.estt.com) \n{.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        
        let tokenBefore = inlineTokens.nonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc(4)
        XCTAssert(tokenBefore?.type == .linkOpen)
        
        print(tokens.toString())
    }
    
    func testNonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc4() {
        
        let md = MarkdownParser()
        let tokens = md.parse("test \n{.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        print(tokens.toString())
        
        let tokenBefore = inlineTokens.nonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc(2)
        XCTAssert(tokenBefore?.type == .text)
    }
    
    func testNonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc5() {
        
        let md = MarkdownParser()
        let tokens = md.parse("**test** \n{.red} wom  {.pik} ")
        let inlineTokens = tokens[1]!.children
        print(tokens.toString())
        
        let tokenBefore = inlineTokens.nonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc(6)
        XCTAssert(tokenBefore?.type == .strongOpen)
    }
}
