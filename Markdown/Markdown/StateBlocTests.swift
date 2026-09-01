//
//  StateBlocTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-04-29.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown
import Common

class StateBlocTests: XCTestCase {

    func testSkipChars() {
        
        let src = "::: : : : : :  : :"
        let md = MarkdownParser()
        md.src = src
        let env = StyloMarkdownEnv()
        let tokens = Tokens()
        let stateBloc = StateBlock(src: src, md: md, env: env, tokens: tokens)
        
        let pos = stateBloc.skipChars(0, codes: §UnicodeCharacter.colon, §UnicodeCharacter.whitespace)
        
        XCTAssert(pos == 18)
    }

    func testSkipChars2() {
        
        let src = "::::::::::       "
        let md = MarkdownParser()
        md.src = src
        let env = StyloMarkdownEnv()
        let tokens = Tokens()
        let stateBloc = StateBlock(src: src, md: md, env: env, tokens: tokens)
        
        let pos = stateBloc.skipChars(0, codes: §UnicodeCharacter.colon)
        
        XCTAssert(pos == 10)
    }
    
}
