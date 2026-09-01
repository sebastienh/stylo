//
//  NSTextStorageRangeAndReplacementStringTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-06-11.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
@testable import Common

class NSTextStorageRangeAndReplacementStringTests: XCTestCase, NSTextStorageDelegate {

    var closure: ((NSTextStorageEditActions, NSRange, Int) -> Void)?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    public func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {

        XCTAssert(closure != nil)
        if editedMask.contains(NSTextStorageEditActions.editedCharacters) {
            self.closure!(editedMask, editedRange, delta)
        }
    }
    
//    case pureAddition
    func testPureAddition() {
        
        executeTest(source: "test", affectedRange: NSMakeRange(4, 0), replacemenString: "2", changeType: .pureAddition)
    }
    
    func testPureAddition2() {
        
        executeTest(source: "test ", affectedRange: NSMakeRange(5, 0), replacemenString: "{", changeType: .pureAddition)
    }
    
    func testPureAddition3() {
        
        executeTest(source: "test {", affectedRange: NSMakeRange(6, 0), replacemenString: "\n", changeType: .pureAddition)
    }
    
    func testPureAddition4() {
        
        executeTest(source: "test {\n", affectedRange: NSMakeRange(7, 0), replacemenString: "\n", changeType: .pureAddition)
    }
    
    func testPureAddition5() {
        
        executeTest(source: "test \n\n", affectedRange: NSMakeRange(5, 0), replacemenString: "{", changeType: .pureAddition)
    }
    
    //    case pureRemoval
    func testPureRemoval() {
        
        executeTest(source: "test", affectedRange: NSMakeRange(3, 1), replacemenString: "", changeType: .pureRemoval)
    }
    
    //    case replaceRemoval
    func testReplaceRemoval() {
        
        executeTest(source: "test", affectedRange: NSMakeRange(0, 4), replacemenString: "tes", changeType: .replaceRemoval)
    }
    
    //    case pureReplace
    func testPureReplace() {
        
        executeTest(source: "test", affectedRange: NSMakeRange(0, 4), replacemenString: "1234", changeType: .pureReplace)
    }
    
    //    case unchanged
    func testUnchanged() {
        
        executeTest(source: "test", affectedRange: NSMakeRange(4, 0), replacemenString: "", changeType: .unchanged)
    }
    
    
    //    case replaceAddition
    func testReplaceAddition() {
        
        executeTest(source: "test", affectedRange: NSMakeRange(0, 4), replacemenString: "test1", changeType: .replaceAddition)
    }

    private func executeTest(source: String, affectedRange: NSRange, replacemenString: String, changeType: SourceStringChangeDescription.ChangeType) {
        
        let textStorage = NSTextStorage(string: source)
        let changeLength = replacemenString.utf16.count - affectedRange.length
            
        self.closure = { (editedMask: NSTextStorageEditActions, editedRange: NSRange, delta: Int) -> Void in
            
            let rangeString = textStorage.getRangeAndReplacementSubstring()
            
            XCTAssert(rangeString != nil)
            if let rangeString = rangeString {
                
                let sourceStringChangeDescription = SourceStringChangeDescription(range: rangeString.range, stringReplacement: rangeString.replacementSubstring, changeLength: delta, targetString: textStorage.string)
                
                XCTAssert(sourceStringChangeDescription.range == affectedRange)
                XCTAssert(sourceStringChangeDescription.targetString == textStorage.string)
                XCTAssert(sourceStringChangeDescription.changeLength == changeLength)
                XCTAssert(sourceStringChangeDescription.range.upperBound <= source.utf16.count)
                XCTAssert(sourceStringChangeDescription.stringReplacement == String(replacemenString.utf16[replacemenString.utf16.startIndex..<replacemenString.utf16.endIndex]))
                XCTAssert(sourceStringChangeDescription.changeType == changeType)
            }
        }
        
        textStorage.delegate = self
        let replacementString = NSAttributedString(string: replacemenString)
        textStorage.beginEditing()
        textStorage.replaceCharacters(in: affectedRange, with: replacementString)
        textStorage.endEditing()
        
    }

}
