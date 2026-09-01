//
//  NSRangeAdditionsRealtivePositionTest.swift
//  CommonTests
//
//  Created by Sébastien Hamel on 2018-05-30.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest
@testable import Common

class NSRangeAdditionsRealtivePositionTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //case same
    func testBasicRelativePositionSame() {
        
        let enclosingRange = NSMakeRange(0, 10)
        let range = NSMakeRange(0, 10)
        
        let relativePosition = enclosingRange.relativePosition(from: range)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .same, "Expected .same received: \(relativePosition!)")
    }
    
    //case before
    func testBasicRelativePositionBefore1() {
        
        let range1 = NSMakeRange(0, 5)
        let range2 = NSMakeRange(5, 10)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .before)
    }
    
    func testBasicRelativePositionBefore2() {
        
        let range1 = NSMakeRange(0, 3)
        let range2 = NSMakeRange(5, 10)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .before)
    }
    
    //case contains
    func testBasicRelativePositionContains() {
        
        let enclosingRange = NSMakeRange(0, 10)
        let range = NSMakeRange(3, 1)
        
        let relativePosition = enclosingRange.relativePosition(from: range)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .contains)
    }

    //case after
    func testBasicRelativePositionAfter() {
        
        let range1 = NSMakeRange(10, 3)
        let range2 = NSMakeRange(5, 5)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .after, "Expected .after received: \(relativePosition!)")
    }
    
    func testBasicRelativePositionAfter2() {
        
        let range1 = NSMakeRange(13, 3)
        let range2 = NSMakeRange(5, 5)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .after, "Expected .after received: \(relativePosition!)")
    }
    
    func testBasicRelativePositionAfter3() {
        
        let range1 = NSMakeRange(1, 9)
        let range2 = NSMakeRange(1, 0)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .after, "Expected .after received: \(relativePosition!)")
    }
    
    //case inside
    func testBasicRelativePositionInside() {
        
        let range1 = NSMakeRange(5, 1)
        let range2 = NSMakeRange(5, 5)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .inside, "Expected .inside received: \(relativePosition!)")
    }
    
    func testBasicRelativePositionInside2() {
        
        let range1 = NSMakeRange(6, 1)
        let range2 = NSMakeRange(5, 5)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .inside, "Expected .inside received: \(relativePosition!)")
    }
    
    func testBasicRelativePositionInside3() {
        
        let range1 = NSMakeRange(9, 1)
        let range2 = NSMakeRange(5, 5)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .inside, "Expected .inside received: \(relativePosition!)")
    }
    
    //case partiallyBefore
    func testBasicRelativePartiallyBefore() {
        
        let range1 = NSMakeRange(1, 2)
        let range2 = NSMakeRange(2, 5)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .partiallyBefore, "Expected .partiallyBefore received: \(relativePosition!)")
    }
    
    //case partiallyAfter
    func testBasicRelativePartiallyAfter() {
        
        let range1 = NSMakeRange(4, 4)
        let range2 = NSMakeRange(2, 5)
        
        let relativePosition = range1.relativePosition(from: range2)
        
        XCTAssert(relativePosition != nil)
        XCTAssert(relativePosition! == .partiallyAfter, "Expected .partiallyAfter received: \(relativePosition!)")
    }
}
