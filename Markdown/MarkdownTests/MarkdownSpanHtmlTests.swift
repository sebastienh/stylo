//
//  MarkdownSpanTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-18.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownSpanHtmlTests: MarkdownSpecTestsBase {

    func test1() {
        let parseResult = parseToHTML("[Span]{.class}\n")
        XCTAssert("<p><span class=\"class\">Span</span></p>\n" == parseResult)
    }

    func test2() {
        let parseResult = parseToHTML("[[Span]{.class}\n")
        XCTAssert("<p>[<span class=\"class\">Span</span></p>\n" == parseResult)
    }
    
    func test3() {
        let parseResult = parseToHTML("[[Span]{.class key=value}\n")
        
        // the order received might difer from one run to the other
        let expectedResult1 = "<p>[<span key=\"value\" class=\"class\">Span</span></p>\n"
        let expectedResult2 = "<p>[<span class=\"class\" key=\"value\">Span</span></p>\n"
        XCTAssert(parseResult == expectedResult1 || parseResult == expectedResult2)
    }
    
    
}
