//
//  SourceStringChangedMarkdownDocumentStoreLoseReferenceTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-05-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class SourceStringChangedMarkdownDocumentStoreLoseReferenceTests: SourceStringChangedMarkdownTests {

    override func setUp() {
        
        filename = "lose-reference-source.md"
        super.setUp()
    }

    func testLoseReference() {
        
        executeTest(affectedRange: NSMakeRange(304, 0), replacementString: " ")
    }

}
