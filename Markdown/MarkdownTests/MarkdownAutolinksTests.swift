//
//  MarkdownAutolinksTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-19.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownAutolinksTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicAutolink() {
        
        executeTestWithString("<http://foo.bar.baz>", andFile: "basic-autolink.json")
    }

    func testQueryAutolink() {
        
        executeTestWithString("<http://foo.bar.baz/test?q=hello&id=22&boolean>", andFile: "query-autolink.json")
    }
    
    func testEmailAutolink() {
        
        executeTestWithString("<sebastien.hamel@gmail.com>", andFile: "email-autolink.json")
    }
    
    func testAutolinkFoo() {
        
        executeTestWithString("<foo@bar.example.com>", andFile: "autolink-foo.json")
    }
    
    func testLocalhostAutolink () {
     
        executeTestWithString("<localhost:5001/foo>", andFile: "localhost-foo.json")
        
        
    }
}
