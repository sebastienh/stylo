//
//  SourceStringChangedMarkdownDocumentStoreBlockquotesTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-07-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo
import Markdown
@testable import WriterCommon

class SourceStringChangedMarkdownDocumentStoreBlockquotesTests: SourceStringChangedMarkdownTests {

    override func setUp() {
        
        filename = "blockquotes.md"
        super.setUp()
    }

    func testSourceStringChangedPureAddition() {
        
        executeTest(affectedRange: NSMakeRange(61, 0), replacementString: " ")
    }
}
