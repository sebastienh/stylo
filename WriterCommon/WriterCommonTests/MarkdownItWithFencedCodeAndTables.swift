//
//  MarkdownItWithFencedCodeAndTables.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-10-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import XCTest

class MarkdownItWithFencedCodeAndTables: MarkdownTokensTests {
    
    override func setUp() {
        
        filename = "markdown-it-with-fenced-code-block-and-tables.md"
        super.setUp()
    }

    func testChangeAtIndex16() {
        
        // cutTokensEnd range    NSRange    location=173, length=21
        let change = StringChange(affectedRange: NSMakeRange(16, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
    func testChangeAtIndex170() {
        
        // cutTokensEnd range    NSRange    location=173, length=21
        let change = StringChange(affectedRange: NSMakeRange(170, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
    func testChangeAtIndex171() {
        
        // cutTokensEnd range    NSRange    location=173, length=21
        let change = StringChange(affectedRange: NSMakeRange(171, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
    func testChangeAtIndex1849() {
        
        // cutTokensEnd range    NSRange    location=173, length=21
        let change = StringChange(affectedRange: NSMakeRange(1849, 0), replacementString: " ")
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
//    
//    func testAddThreeBackticksEverywhere() {
//        
//        var globalResult = true
//        
//        for i in 0...sourceString!.count {
//            
//            setUp()
//            let change = StringChange(affectedRange: NSMakeRange(i, 0), replacementString: "```")
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
    
//    func testPerformance1() {
//        
//        // This is an example of a performance test case.
//        self.measure() {
//            
//            var globalResult = true
//            
//            for i in 0...sourceString!.count/10 {
//                
//                setUp()
//                let change = StringChange(affectedRange: NSMakeRange(i, 0), replacementString: " ")
//                let result = executeTests(stringChanges: [change])
//                
//                if !result {
//                    
//                    debugPrint("Failed at index: \(i)")
//                }
//                
//                globalResult = globalResult && result
//            }
//            
//            XCTAssert(globalResult)
//        }
//    }
    
}
