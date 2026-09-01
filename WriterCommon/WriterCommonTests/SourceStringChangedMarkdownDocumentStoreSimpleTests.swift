//
//  SourceStringChangedMarkdownDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-07-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo
import Markdown
@testable import WriterCommon

class SourceStringChangedMarkdownDocumentStoreTests: SourceStringChangedMarkdownTests {
    
    override func setUp() {
        
        filename = "simple.md"
        super.setUp()
    }
    
    func testSourceStringChangedPureAdditionStart() {
        
        executeTest(affectedRange: NSMakeRange(0, 0), replacementString: "# Title Level One\n\n")
    }
    
    func testSourceStringChangedPureAdditionMiddle() {
        
        executeTest(affectedRange: NSMakeRange(24, 0), replacementString: "# Title Level One\n\n")
    }
}
