//
//  MarkdownItWithoutFencedCodeAndTables.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-09-27.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownItWithoutFencedCodeAndTables: MarkdownTokensTests {

    override func setUp() {
        
        filename = "markdown-it-without-fenced-code-block-and-tables.md"
        super.setUp()
    }

    func testChangeAtIndex0() {
        
        let change = StringChange(affectedRange: NSMakeRange(0, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
    func testChangeAtIndex99() {
        
        let change = StringChange(affectedRange: NSMakeRange(99, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
    func testChangeAtIndex150() {
        
        // cutTokensEnd range    NSRange    location=173, length=21    
        let change = StringChange(affectedRange: NSMakeRange(150, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
    func testChangeAtIndex261() {
        
        let change = StringChange(affectedRange: NSMakeRange(261, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
    func testChangeAtIndex136() {
        
        let change = StringChange(affectedRange: NSMakeRange(136, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
    func testChangeAtIndex1399() {
        
        let change = StringChange(affectedRange: NSMakeRange(1399, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
    func testChangeAtIndex1539() {
        
        let change = StringChange(affectedRange: NSMakeRange(1539, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
//    func testAddSingleSpaceEverywhere() {
//        
//        var globalResult = true
//        
//        for i in 0...sourceString!.count {
//            
//            setUp()
//            let change = StringChange(affectedRange: NSMakeRange(i, 0), replacementString: " ")
//            let result = executeTests(stringChanges: [change])
//            
//            if !result {
//                
//                debugPrint("Failed at index: \(i)")
//            }
//            
//            globalResult = globalResult && result
//        }
//        
//        XCTAssert(globalResult)
//    }

}
