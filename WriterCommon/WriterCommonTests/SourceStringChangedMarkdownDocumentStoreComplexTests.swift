//
//  SourceStringChangedMarkdownDocumentStoreComplexTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-07-21.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo
import Markdown
@testable import WriterCommon

class SourceStringChangedMarkdownDocumentStoreComplexTests: SourceStringChangedMarkdownTests {
    
    override func setUp() {
        
        filename = "complex.md"
        super.setUp()
    }
    
    func testSourceStringChangedPureAddition() {
        
        // DEBUG in textStorage(_:willProcessEditing:range:changeInLength:): sourceStringChangeDescription: changeType: pureAddition, range: {268, 0}, changeLength: 1, stringReplacement: Optional("s").
        
        executeTest(affectedRange: NSMakeRange(268, 0), replacementString: "s")
    }
    
    func testSourceStringChangedPureAddition2() {
        
        // DEBUG in textStorage(_:willProcessEditing:range:changeInLength:): sourceStringChangeDescription: changeType: pureAddition, range: {257, 0}, changeLength: 7, stringReplacement: Optional("3333333").
        
        executeTest(affectedRange: NSMakeRange(257, 0), replacementString: "3333333")
    }
    
}
