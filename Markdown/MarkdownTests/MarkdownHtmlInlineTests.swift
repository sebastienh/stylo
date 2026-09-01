//
//  MarkdownHtmlInlineTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-31.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownHtmlInlineTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// RESULT: PASS
    func testBasicHtmlInline4() {
        
        executeTestWithString("<a foo=\"bar\" bam = 'baz <em>\"</em>'\n_boolean zoop:33=zoop:33 />", andFile: "basic-html-inline-4.json")
    }
    
    /// RESULT: PASS
    func testBasicHtmlInline3() {
        
        executeTestWithString("<a  /><b2\ndata=\"foo\" >", andFile: "basic-html-inline-3.json")
    }
    
    /// RESULT: PASS
    func testBasicHtmlInline2() {
        
        executeTestWithString("<a/><b2/>", andFile: "basic-html-inline-2.json")
    }
    
    /// RESULT: PASS
    func testBasicHtmlInline() {
        
        executeTestWithString("<del>*foo*</del>", andFile: "basic-html-inline.json")
    }

}
