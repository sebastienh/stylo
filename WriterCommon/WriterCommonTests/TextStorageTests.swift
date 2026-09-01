//
//  TextStorageTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-04-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Cocoa
@testable import WriterCommon

class TextStorageTests: XCTestCase {

    func testTrim() {
        
        let storage = NSTextStorage(string: " test ")
        let trimmedRange = storage.trim(range: NSMakeRange(0, 6))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
        
            XCTAssert(trimmedRange.location == 1)
            XCTAssert(trimmedRange.length == 4)
        }
    }

    func testTrimEmptyRange() {
        
        let storage = NSTextStorage(string: " test ")
        let trimmedRange = storage.trim(range: NSMakeRange(0, 0))
        XCTAssert(trimmedRange == nil)
    }

    func testTrimBeforeRange() {
        
        let storage = NSTextStorage(string: " test ")
        let trimmedRange = storage.trim(range: NSMakeRange(-2, 2))
        XCTAssert(trimmedRange == nil)
    }
    
    func testTrimEmptyString() {
        
        let storage = NSTextStorage(string: "      ")
        let trimmedRange = storage.trim(range: NSMakeRange(0, 6))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 6)
            XCTAssert(trimmedRange.length == 0)
        }
    }
    
    func testTrimEmptyString2() {
        
        let storage = NSTextStorage(string: "      ")
        let trimmedRange = storage.trim(range: NSMakeRange(2, 0))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 2)
            XCTAssert(trimmedRange.length == 0)
        }
    }
    
    func testTrimEmptyString3() {
        
        let storage = NSTextStorage(string: "      ")
        let trimmedRange = storage.trim(range: NSMakeRange(2, 1))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 3)
            XCTAssert(trimmedRange.length == 0)
        }
    }
    
    func testTrimString4() {
        
        let storage = NSTextStorage(string: "      d")
        let trimmedRange = storage.trim(range: NSMakeRange(2, 1))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 3)
            XCTAssert(trimmedRange.length == 0)
        }
    }
    
    
    func testTrimString5() {
        
        let storage = NSTextStorage(string: "ddddddd")
        let trimmedRange = storage.trim(range: NSMakeRange(2, 1))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 2)
            XCTAssert(trimmedRange.length == 1)
        }
    }
    
    func testTrimString6() {
        
        let storage = NSTextStorage(string: "d ddddd")
        let trimmedRange = storage.trim(range: NSMakeRange(2, 1))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 2)
            XCTAssert(trimmedRange.length == 1)
        }
    }
    
    func testTrimString7() {
        
        let storage = NSTextStorage(string: "d d ddd")
        let trimmedRange = storage.trim(range: NSMakeRange(2, 1))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 2)
            XCTAssert(trimmedRange.length == 1)
        }
    }
    
    func testTrimString8() {
        
        let storage = NSTextStorage(string: "d   ddd")
        let trimmedRange = storage.trim(range: NSMakeRange(2, 1))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 3)
            XCTAssert(trimmedRange.length == 0)
        }
    }
    
    func testTrimString9() {
        
        let storage = NSTextStorage(string: "d ddd")
        let trimmedRange = storage.trim(range: NSMakeRange(1, 2))

        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 2)
            XCTAssert(trimmedRange.length == 1)
        }
    }
    
    func testTrimString10() {
        
        let storage = NSTextStorage(string: "d ddd")
        let trimmedRange = storage.trim(range: NSMakeRange(0, 2))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 0)
            XCTAssert(trimmedRange.length == 1)
        }
    }
    
    func testTrimString11() {
        
        let storage = NSTextStorage(string: "d d d")
        let trimmedRange = storage.trim(range: NSMakeRange(1, 3))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 2)
            XCTAssert(trimmedRange.length == 1)
        }
    }
    
    func testTrimString12() {
        
        let storage = NSTextStorage(string: "d d  ")
        let trimmedRange = storage.trim(range: NSMakeRange(1, 3))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 2)
            XCTAssert(trimmedRange.length == 1)
        }
    }
    
    func testTrimString13() {
        
        let storage = NSTextStorage(string: "  d  ")
        let trimmedRange = storage.trim(range: NSMakeRange(1, 3))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 2)
            XCTAssert(trimmedRange.length == 1)
        }
    }
    
    func testTrimString14() {
        
        let storage = NSTextStorage(string: "     ")
        let trimmedRange = storage.trim(range: NSMakeRange(0, 1))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 1)
            XCTAssert(trimmedRange.length == 0)
        }
    }
    
    func testTrimString15() {
        
        let storage = NSTextStorage(string: "     ")
        let trimmedRange = storage.trim(range: NSMakeRange(4, 1))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 5)
            XCTAssert(trimmedRange.length == 0)
        }
    }
    
    func testTrimString16() {
        
        let storage = NSTextStorage(string: "     ")
        let trimmedRange = storage.trim(range: NSMakeRange(5, 1))
        XCTAssert(trimmedRange == nil)
    }
    
    func testTrimString17() {
        
        let storage = NSTextStorage(string: "     ")
        let char = storage.mutableString.charAt(7)
        XCTAssert(char == nil)
    }
    
    func testTrimString18() {
        
        let storage = NSTextStorage(string: "     ")
        let char = storage.mutableString.charAt(-1)
        XCTAssert(char == nil)
    }
    
    func testTrimString19() {
        
        let storage = NSTextStorage(string: "     ")
        let trimmedRange = storage.trim(range: NSMakeRange(5, 0))
        XCTAssert(trimmedRange == nil)
    }
    
    func testTrimString20() {
        
        let storage = NSTextStorage(string: "     ")
        let trimmedRange = storage.trim(range: NSMakeRange(0, 0))
        XCTAssert(trimmedRange == nil)
    }
    
    func testTrimString21() {
        
        let storage = NSTextStorage(string: "  c")
        let trimmedRange = storage.trim(range: NSMakeRange(0, 3))

        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 2)
            XCTAssert(trimmedRange.length == 1)
        }
    }
    
    func testTrimInSpaces() {
        
        let storage = NSTextStorage(string: " test   ")
        let trimmedRange = storage.trim(range: NSMakeRange(6, 1))
        
        XCTAssert(trimmedRange != nil)
        if let trimmedRange = trimmedRange {
            
            XCTAssert(trimmedRange.location == 7)
            XCTAssert(trimmedRange.length == 0)
        }
    }
}
