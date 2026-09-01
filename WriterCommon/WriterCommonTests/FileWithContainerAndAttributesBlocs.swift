//
//  FileWithContainerAndAttributesBlocs.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-05-12.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class FileWithContainerAndAttributesBlocs: RandomChangeTest {

    override func setUp() {
        
        super.setUp()
        
        let url = urlOfFile(named: "file-with-container-and-attributes-bloc.md")
        self.sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
    }
    
    // { affectedRange: {6530, 2}, replacementString: ->ck on th<-}"
    func testError1() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(6530, 2), replacementString: "ck on th")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // { affectedRange: {90954, 4}, replacementString: ->\n\nAn <-}"
    func testError2() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(90954, 4), replacementString: "\n\nAn ")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // { affectedRange: {37203, 6}, replacementString: ->e><c<-}"
    func testError3() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(37203, 6), replacementString: "e><c")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // { affectedRange: {22147, 3}, replacementString: -><-}"
    func testError4() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(22147, 3), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
//    func testRandomChanges() {
//
//        var failedChanges = [StringChange]()
//        var passed: Int = 0
//
//
//        while failedChanges.count < 100 {
//
//            autoreleasepool {
//
//                if let stringChange = nextStringChange {
//
//                    debugPrint("\(passed) -> testing: \(stringChange)")
//
//                    if !testChange(stringChange: stringChange) {
//
//                        debugPrint("failure")
//                        failedChanges.append(stringChange)
//                    }
//                    else {
//
//                        passed += 1
//                        debugPrint("success")
//                    }
//                }
//            }
//        }
//
//        debugPrint("number of passed: \(passed)")
//
//        debugPrint("Failed changes: ")
//        for failedChange in failedChanges {
//
//            debugPrint("failed change: \(failedChange)")
//        }
//        XCTAssert(failedChanges.isEmpty, "Failed changed: \(failedChanges)")
//    }
    
}
