//
//  String+UtilitiesTests.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-07-28.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import Common

class String_UtilitiesTests: XCTestCase {


    func testSentenceRange() throws {
        
        var testString = "\n"
        testString += "\n"
        testString += "\n"
        testString += "This is a sentence. This is another one."

        let sentenceRange = testString.sentencesRange(aroundRange: NSMakeRange(3, 0))
        let expectedRange = NSMakeRange(3, 20)
        
        XCTAssert(sentenceRange == expectedRange, "Expected: \(expectedRange), received: \(sentenceRange)")
    }

    func testSentenceRange2() throws {
        
        var testString = "\n"
        testString += "\n"
        testString += "\n"
        testString += "This is a sentence. This is another one."
        testString += "\n"
        testString += "Test.\n"
        
        let sentenceRange = testString.sentencesRange(aroundRange: NSMakeRange(3, 23))
        let expectedRange = NSMakeRange(3, 40)
        
        XCTAssert(sentenceRange == expectedRange, "Expected: \(expectedRange), received: \(sentenceRange)")
    }
    
    func testSentenceRange3() throws {
        
        var testString = "\n"
        testString += "\n"
        testString += "\n"
        testString += "ghjfdkgdgfdhjfdkgdfghjdfkgfldghfdjgkd"
        testString += "\n"
        testString += "Test.\n"
        
        let sentenceRange = testString.sentencesRange(aroundRange: NSMakeRange(4, 0))
        let expectedRange = NSMakeRange(3, 37)
        
        XCTAssert(sentenceRange == expectedRange, "Expected: \(expectedRange), received: \(sentenceRange)")
    }
    
    func testSentenceRange4() throws {
        
        var testString = "\n"
        testString += "\n"
        testString += "\n"
        testString += "Thjfdkgdgfdhjfdkgdfghjdfkgfldghfdjgkd. Dsdsadsdasdas"
        testString += "\n"
        testString += "Test.\n"
        
        let sentenceRange = testString.sentencesRange(aroundRange: NSMakeRange(4, 0))
        let expectedRange = NSMakeRange(3, 39)
        
        XCTAssert(sentenceRange == expectedRange, "Expected: \(expectedRange), received: \(sentenceRange)")
    }
    
    /// // See the `Nodio Help` under `Help` -> `Nodio Help` in section `3. Focus`  for more information.
    /// A dot followed by a capital letter
    /// FAILED: see stylo #1130
    func testSentenceRange5() {
        
        var testString = "\n"
        testString += "\n"
        testString += "\n"
        testString += "Se `N` in `3. F` f."
        testString += "\n"
        testString += "Test.\n"
        
        let sentenceRange = testString.sentencesRange(aroundRange: NSMakeRange(5, 0))
        let expectedRange = NSMakeRange(3, 19)
        
        XCTAssert(sentenceRange == expectedRange, "Expected: \(expectedRange), received: \(sentenceRange)")
    }
    
    func testUpdateAtEnd() throws {
        
        var string = "test"
        let update = "addition"
        let range = NSMakeRange(4,0)
        
        string.update(range: range, withString: update)
     
        XCTAssert(string == "testaddition", "Expected: testaddition, received: \(string)")
    }
    
    func testUpdateAtStart() throws {
        
        var string = "test"
        let update = "addition"
        let range = NSMakeRange(0,0)
        
        string.update(range: range, withString: update)
        XCTAssert(string == "additiontest", "Expected: additiontest, received: \(string)")
    }
    
    func testUpdateReplace() throws {
        
        var string = "test"
        let update = "addition"
        let range = NSMakeRange(0,4)
        
        string.update(range: range, withString: update)
        XCTAssert(string == "addition", "Expected: addition, received: \(string)")
    }
    
}
