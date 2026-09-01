//
//  TwoTablesTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2018-12-19.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest

class TwoTablesTests: MarkdownTokensTests {
    
    override func setUp() {
        
        filename = "two-tables.md"
        super.setUp()
    }
    
    func testChangeAtIndex5() {
        
        let change = StringChange(affectedRange: NSMakeRange(5, 1), replacementString: "")
        XCTAssert(executeTests(stringChanges: [change]))
    }
}
