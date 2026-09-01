//
//  RangesByTrimmingWhitespacesTest.swift
//  Common
//
//  Created by Sebastien hamel on 2017-05-21.
//  Copyright © 2017 NM. All rights reserved.
//

import XCTest

class RangesByTrimmingWhitespacesTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicTrimming() {
        
        let string = "  234 678 "
        
        let ranges = string.rangesByTrimmingSpaces(in: NSMakeRange(0, 10))
        
        XCTAssert(ranges.count == 2)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(2, 3)))
        XCTAssert(NSEqualRanges(ranges[1], NSMakeRange(6, 3)))
    }

    func testBasicTrimming2() {
        
        let string = "0123456789"
        
        let ranges = string.rangesByTrimmingSpaces(in: NSMakeRange(0, 10))
        
        XCTAssert(ranges.count == 1)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(0, 10)))
    }
    
    func testBasicTrimming3() {
        
        let string = "012 456 89"
        
        let ranges = string.rangesByTrimmingSpaces(in: NSMakeRange(0, 10))
        
        XCTAssert(ranges.count == 3)
        XCTAssert(NSEqualRanges(ranges[0], NSMakeRange(0, 3)))
        XCTAssert(NSEqualRanges(ranges[1], NSMakeRange(4, 3)))
        XCTAssert(NSEqualRanges(ranges[2], NSMakeRange(8, 2)))
    }

}
