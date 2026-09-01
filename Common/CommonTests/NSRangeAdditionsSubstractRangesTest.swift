//
//  NSRangeAdditionsSubstractRangesTest.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-05-20.
//  Copyright © 2017 NM. All rights reserved.
//

import XCTest

class NSRangeAdditionsSubstractRangesTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicSubstract() {
        
        // 0123456789
        // __________
        // ___
        //    _
        //     ______
        //
        let enclosingRange = NSMakeRange(0, 10)
        let substractedRange = NSMakeRange(3, 1)
        
        let ranges = enclosingRange.substractsRanges([substractedRange])
        
        XCTAssert(ranges.count == 2)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(0, 3)))
        XCTAssert(NSEqualRanges(ranges[1], NSMakeRange(4, 6)))
    }

    func testBasicSubstract2() {
        
        // 0123456789
        // __________
        // ___
        //    _
        //     ______
        //
        let enclosingRange = NSMakeRange(3, 2)
        let substractedRange1 = NSMakeRange(1, 1)
        let substractedRange2 = NSMakeRange(3, 1)
        
        let ranges = enclosingRange.substractsRanges([substractedRange1, substractedRange2])
        
        XCTAssert(ranges.count == 1)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(4, 1)))
    }
    
    func testBasicSubstractNotIntersectingRange1() {
        
        // 0123456789
        // __________
        // ___
        //    _
        //     ______
        //
        let enclosingRange = NSMakeRange(0, 10)
        let substractedRange1 = NSMakeRange(3, 1)
        let substractedRange2 = NSMakeRange(11, 1)
        
        let ranges = enclosingRange.substractsRanges([substractedRange1, substractedRange2])
        
        XCTAssert(ranges.count == 2)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(0, 3)))
        XCTAssert(NSEqualRanges(ranges[1], NSMakeRange(4, 6)))
    }
    
    func testBasicSubstractNotIntersectingRange2() {
        
        // 0123456789
        // __________
        //            _
        //
        // __________
        //
        let enclosingRange = NSMakeRange(0, 10)
        let substractedRange = NSMakeRange(11, 1)
        
        let ranges = enclosingRange.substractsRanges([substractedRange])
        
        XCTAssert(ranges.count == 1)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(0, 10)))
    }
    
    func testBasicSubstractIntersectingRange3() {
        
        // 0123456789
        // ____ ______
        //     |
        //
        // ____ ______
        //
        let enclosingRange = NSMakeRange(0, 10)
        let substractedRange1 = NSMakeRange(4, 0)
        
        let ranges = enclosingRange.substractsRanges([substractedRange1])
        
        XCTAssert(ranges.count == 2)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(0, 4)))
        XCTAssert(NSEqualRanges(ranges[1], NSMakeRange(4, 6)))
    }
    
    func testBasicSubstractIntersectingRange4() {
        
        // substract:    ____________**********************
        // element:      ____________-----------------------
        // result:       ____________                      -
        let enclosingRange = NSMakeRange(12, 23)
        let substractedRange = NSMakeRange(12, 22)
        
        let ranges = enclosingRange.substractsRanges([substractedRange])
        
        XCTAssert(ranges.count == 1)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(34, 1)), "Received: \(ranges[0])")
    }
    
    func testBasicSubstractNotIntersectingRange5() {
        
        // substract:    ____________**********************
        // element:      ____________-----------------------
        // result:       ____________                      -
        let enclosedRange = NSMakeRange(1654, 3)
        let substractedRange = NSMakeRange(1644, 13)
        
        let ranges = enclosedRange.substractsRanges([substractedRange])
        
        XCTAssert(ranges.count == 0)
    }
    
    func testBasicSubstractNotIntersectingRange6() {
        
        // substract:    ____________**********************
        // element:      ____________-----------------------
        // result:       ____________                      -
        let enclosedRange = NSMakeRange(1654, 3)
        let substractedRange = NSMakeRange(1644, 12)
        
        let ranges = enclosedRange.substractsRanges([substractedRange])
        
        XCTAssert(ranges.count == 1)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(1656, 1)), "Received: \(ranges[0])")
    }
    
}
