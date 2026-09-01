//
//  OtherMarkdownTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2018-11-27.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest

class OtherMarkdownTests: MarkdownSpecTestsBase {
    
    func test1() {
        let parseResult = parseToHTML("<h1 id=\"tttt\">title</h1>")
        XCTAssert("<h1 id=\"tttt\">title</h1>" == parseResult)
    }

    func test2() {
        let parseResult = parseToHTML("\n<h1 id=\"tttt\">title</h1>")
        XCTAssert("<h1 id=\"tttt\">title</h1>" == parseResult, "Reeived: \(parseResult)")
    }
    //
    
    func test3() {
        let parseResult = parseToHTML("<h3 id=\"about-stylo\">Stylo</h3>")
        XCTAssert("<h3 id=\"about-stylo\">Stylo</h3>" == parseResult)
    }
    
    func test4() {
        let expected = "<blockquote>\n<p>l'Être</p>\n</blockquote>\n"
        let parseResult = parseToHTML("> l'Être")
        XCTAssert(expected == parseResult, "Expected: \n\"\(expected)\", received: \n\"\(parseResult)\"")
    }
    
    func test5() {
        let expected = "<blockquote>\n<p>[l'Être</p>\n</blockquote>\n"
        let parseResult = parseToHTML("> [l'Être")
        XCTAssert(expected == parseResult, "Expected: \n\"\(expected)\", received: \n\"\(parseResult)\"")
    }
    
}
