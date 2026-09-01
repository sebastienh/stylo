//
//  Collection+PositionnableTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-06-06.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest
@testable import Common

fileprivate struct Element: Positionnable {
    
    var sourceStringFragment: SourceStringFragment?
    
    init(sourceStringFragment: SourceStringFragment?) {
        
        self.sourceStringFragment = sourceStringFragment
    }
}

class Collection_PositionnableTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNonIncludingIndexBefore() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(0, 1))
        XCTAssert(index == -1)
    }
    
    func testNonIncludingIndexBefore2() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(1, 6))
        XCTAssert(index == -1)
    }
    
    func testNonIncludingIndexBefore3() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(5, 1))
        XCTAssert(index == -1)
    }
    
    func testNonIncludingIndexBefore4() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(13, 16))
        XCTAssert(index == -1)
    }
    
    func testNonIncludingIndexBefore5() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(14, 16))
        XCTAssert(index == 0)
    }
    
    func testNonIncludingIndexBefore6() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(15, 1))
        XCTAssert(index == 0)
    }
    
    ///
    /// 4, 10
    /// 16, 10
    /// 40, 10
    ///
    func testNonIncludingIndexBefore7() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(15, 5))
        XCTAssert(index == 0)
    }
    
    func testNonIncludingIndexBefore8() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(16, 50))
        XCTAssert(index == 0)
    }
    
    func testNonIncludingIndexBefore9() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(16, 1))
        XCTAssert(index == 0)
    }
    
    func testNonIncludingIndexBefore10() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(28, 1))
        XCTAssert(index == 1)
    }
    
    func testNonIncludingIndexBefore11() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(28, 40))
        XCTAssert(index == 1)
    }
    
    func testNonIncludingIndexBefore12() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(18, 60))
        XCTAssert(index == 0)
    }
    
    func testNonIncludingIndexBefore13() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(4, 10))
        XCTAssert(index == -1)
    }
    
    func testNonIncludingIndexBefore14() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(12, 1))
        XCTAssert(index == -1)
    }
    
    func testNonIncludingIndexBefore15() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(1, 1))
        XCTAssert(index == -1)
    }
    
    func testNonIncludingIndexBefore16() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(1, 7))
        XCTAssert(index == -1)
    }
    
    func testNonIncludingIndexBefore17() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(52, 7))
        XCTAssert(index == 2)
    }
    
    func testNonIncludingIndexBefore18() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(48, 7))
        XCTAssert(index == 1)
    }
    
    func testNonIncludingIndexBefore19() {
        
        let collection = buildBasicCollection()
        let index = collection.nonIncludingIndex(before: NSMakeRange(0, 4))
        XCTAssert(index == -1)
    }
    
    private func buildBasicCollection() -> [Element] {
        
        let element1 = Element(sourceStringFragment: SourceStringSegment(range: NSMakeRange(4, 10)))
        let element2 = Element(sourceStringFragment: SourceStringSegment(range: NSMakeRange(16, 10)))
        let element3 = Element(sourceStringFragment: SourceStringSegment(range: NSMakeRange(40, 10)))
        return [element1, element2, element3]
    }
    
}
