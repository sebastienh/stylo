//
//  ViewOffsetsTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-12-17.
//  Copyright © 2017 NM. All rights reserved.
//

import XCTest
@testable import Common

class ViewOffsetsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testBasicViewOffsets() {
//   
//        var viewOffsets = ViewOffsets(viewHeight: 2761.5, scrollingGranularity: 60, sectionLength: 5, endOffset: <#CGFloat#>)
//        let origin: CGFloat = 1962.0
//        
//        XCTAssert(viewOffsets.baseOffsets.count == 46)
//        
//        // 30 = 2043.3614732142858
//        
//        let (offset, indexes) = viewOffsets.offset(at: origin)
//        
//        XCTAssert(offset == nil)
//        XCTAssert(indexes != nil)
//        XCTAssert(indexes!.count == 5)
//        XCTAssert(indexes![0] == 30)
//        XCTAssert(indexes![1] == 31)
//        XCTAssert(indexes![2] == 32)
//        XCTAssert(indexes![3] == 33)
//        XCTAssert(indexes![4] == 34)
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
