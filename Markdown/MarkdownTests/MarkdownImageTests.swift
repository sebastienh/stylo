//
//  MarkdownImageTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-04-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownImageTests: MarkdownBasicTests {

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
    func testBasicImage() {
        
        executeTestWithString("![Minion](https://octodex.github.com/images/minion.png)", andFile: "basic-image.json")
    }

    ///
    /// RSSULT: PASS
    ///
    func testImageWithParagraph() {
        
        executeTestWithString("![foo] \n[]\n\n[foo]: /url \"title\"", andFile: "image-with-paragraph.json")
    }
}
