//
//  MarkdownSpanTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-18.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownSpanTests: MarkdownBasicTests {


    func testBasicSpan() {
        executeTestWithString("[span text]{.attr}", andFile: "basic-span.json")
    }

    func testBasicSpanWithLineFeed() {
        executeTestWithString("[span \ntext]{.attr}", andFile: "basic-span-with-linefeed.json")
    }
    
    func testBasicSpanWithLineFeedAndSpace() {
        executeTestWithString("[span \ntext]     {.attr}", andFile: "basic-span-with-linefeed-and-spaces.json")
    }
    
    func testWrongFirstSpanWithLineFeedAndSpace() {
        executeTestWithString("[span[ \ntext]     {.attr}", andFile: "wrong-first-span-with-linefeed-and-space.json")
    }
    
    func testInlineSpanWithLineFeedInsideBlockquote() {
        executeTestWithString("> [span \n> text]     {.attr}", andFile: "inline-span-with-linefeed-inside-blockquote.json")
    }
    
    func testWrongInlineSpanInsideBlockquote() {
        executeTestWithString("> [span \n> text]     {.attr", andFile: "wrong-inline-span-with-linefeed-inside-blockquote.json")
    }
}
