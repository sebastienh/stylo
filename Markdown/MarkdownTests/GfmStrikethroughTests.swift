//
//  GfmStrikethroughTests.swift

//  Created by Sébastien Hamel on 2016-04-18.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest

class GfmStrikethroughTests : MarkdownSpecTestsBase {
    
    func test1() {
        let parseResult = parseToHTML("~~Strikeout~~\n")
        XCTAssert("<p><s>Strikeout</s></p>\n" == parseResult)
    }
    
    func test2() {
        let parseResult = parseToHTML("x ~~~~foo~~ bar~~\n")
        XCTAssert("<p>x <s><s>foo</s> bar</s></p>\n" == parseResult)
    }
    
    func test3() {
        let parseResult = parseToHTML("x ~~foo ~~bar~~~~\n")
        XCTAssert("<p>x <s>foo <s>bar</s></s></p>\n" == parseResult)
    }
    
    func test4() {
        let parseResult = parseToHTML("x ~~~~foo~~~~\n")
        XCTAssert("<p>x <s><s>foo</s></s></p>\n" == parseResult)
    }
    
    func test5() {
        let parseResult = parseToHTML("x ~~a ~~foo~~~~~~~~~~~bar~~ b~~\n\nx ~~a ~~foo~~~~~~~~~~~~bar~~ b~~\n")
        XCTAssert("<p>x <s>a <s>foo</s></s>~~~<s><s>bar</s> b</s></p>\n<p>x <s>a <s>foo</s></s>~~~~<s><s>bar</s> b</s></p>\n" == parseResult)
    }
    
    func test6() {
        let parseResult = parseToHTML("**~~test**~~\n\n~~**test~~**\n")
        XCTAssert("<p><strong>~~test</strong>~~</p>\n<p><s>**test</s>**</p>\n" == parseResult)
    }
    
    func test7() {
        let parseResult = parseToHTML("[~~link]()~~\n\n~~[link~~]()\n")
        XCTAssert("<p><a href=\"\">~~link</a>~~</p>\n<p>~~<a href=\"\">link~~</a></p>\n" == parseResult)
    }
    
    func test8() {
        let parseResult = parseToHTML("~~`code~~`\n\n`~~code`~~\n")
        XCTAssert("<p>~~<code>code~~</code></p>\n<p><code>~~code</code>~~</p>\n" == parseResult)
    }
    
    func test9() {
        let parseResult = parseToHTML("~~foo ~~bar~~ baz~~\n\n~~f **o ~~o b~~ a** r~~\n")
        XCTAssert("<p><s>foo <s>bar</s> baz</s></p>\n<p><s>f <strong>o <s>o b</s> a</strong> r</s></p>\n" == parseResult)
    }
    
    func test10() {
        let parseResult = parseToHTML("foo ~~ bar ~~ baz\n")
        XCTAssert("<p>foo ~~ bar ~~ baz</p>\n" == parseResult)
    }
    
    func test11() {
        let parseResult = parseToHTML("~~test\n~~\n\n~~\ntest~~\n\n~~\ntest\n~~\n")
        XCTAssert("<p>~~test\n~~</p>\n<p>~~\ntest~~</p>\n<p>~~\ntest\n~~</p>\n" == parseResult)
    }
    
    
    // From CommonMark test suite, replacing `**` with our marker:
    func test12() {
        let expected = "<p>a~~&quot;foo&quot;~~</p>\n"
        let parseResult = parseToHTML("a~~\"foo\"~~\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected), received: \n\(parseResult)")
    }
    
    
}
