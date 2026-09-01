//
//  MultipleReferencesWithSameLabelTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2018-12-19.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest

class MultipleReferencesWithSameLabelTests: MarkdownTokensTests {
    
    override func setUp() {
        
        filename = "multiple-references-with-same-label.md"
        super.setUp()
    }
    
    func testChangeAtIndex53() {
        
        let change = StringChange(affectedRange: NSMakeRange(53, 1), replacementString: "")
        XCTAssert(executeTests(stringChanges: [change]), "")
    }
    
    func testChangeAtIndex168() {
        
        let change = StringChange(affectedRange: NSMakeRange(168, 1), replacementString: "")
        XCTAssert(executeTests(stringChanges: [change]), "")
    }
}
