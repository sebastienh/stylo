//
//  MarkdownLinkTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-23.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Common

class MarkdownLinkTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///
    /// RESULT: PASS
    ///
    func testBasicLinkWithoutTitle() {
        
        executeTestWithString("[link without title](http://nodeca.github.io/pica/demo/)", andFile: "basic-link-without-title.json")
    }
    
    ///
    /// RESULT: PASS
    ///
    func testBasicLink() {
        
        executeTestWithString("[link with title](http://nodeca.github.io/pica/demo/ \"title text!\")", andFile: "basic-link.json")
    }
    
    ///
    /// [link](/uri "title")
    ///
    /// RESULT: PASS
    ///
    func testBasicLink2() {
        
        executeTestWithString("[link](/uri \"title\")", andFile: "basic-link-2.json")
    }

    ///
    ///
    ///
    /// RESULT: PASS
    ///
    func testBasicLink3() {
        
        executeTestWithString("[foo] \n[]\n\n[foo]: /url \"title\"", andFile: "basic-link-3.json")
    }
    
    
    ///
    ///
    ///
    /// RESULT: PASS
    ///
    func testBasicLink4() {
        
        executeTestWithString("[Foo\n  bar]: /url\n\n[Baz][Foo bar]", andFile: "basic-link-4.json")
    }
    
    ///
    ///
    ///
    func testBasicLink5() {
        
        executeTestWithString("[link](</my uri>)", andFile: "basic-link-5.json")
    }
    
    ///
    /// RESULT: PASS
    ///
    func testTwoLinks() {
        
        executeTestWithString("[link](www.test.com)[link](www.test.com)", andFile: "two-links.json")
    }
    
}
