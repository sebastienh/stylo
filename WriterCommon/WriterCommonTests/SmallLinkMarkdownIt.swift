//
//  SmallLinkMarkdownIt.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-10-04.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest

class SmallLinkMarkdownIt: MarkdownTokensTests {

    override func setUp() {
        
        filename = "small-link-markdown-it.md"
        super.setUp()
    }

    func testChangeAtIndex0() {
        
        let change = StringChange(affectedRange: NSMakeRange(0, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }

}
