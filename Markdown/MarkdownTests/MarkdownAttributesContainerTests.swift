//
//  MarkdownAttributesContainerTests.swift

//  Created by Sébastien Hamel on 2016-04-18.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownAttributesContainerTests : MarkdownSpecTestsBase {
    
    
    // 0->::: class :::
    // 1->Some text.
    // 2->:::
    // 3->
    func test1() {
        let parseResult = parseToHTML("::: class :::\nSome text.\n:::\n")
        XCTAssert("<div class=\"class\"><p>Some text.</p>\n</div>" == parseResult)
    }
    
    func test2() {
        let parseResult = parseToHTML(":::: { key=value } :::::\n\n# level one\n\n::::")
        XCTAssert("<div key=\"value\"><h1>level one</h1>\n</div>" == parseResult)
    }
    
}
