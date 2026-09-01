//
//  MDURLDecodeTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-11.
//  Copyright © 2016 NM. All rights reserved.
//

import XCTest

class MDURLDecodeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testShouldDecodePercentXX() {
    
        let decodedString = "x%20xx%20%2520".decode()
        
        XCTAssert(decodedString == "x xx %20")
    }
    
    func testShouldNotDecodeInvalidSequences() {
    
        XCTAssert("%2g%z1%%".decode() == "%2g%z1%%")
    }
    
    func testShouldNotDecodeReservedSet1() {
        
        XCTAssert("%20%25%20".decode("%") ==  " %25 ")
    }
    
    func testShouldNotDecodeReservedSet2() {
    
        XCTAssert("%20%25%20".decode(" ") ==  "%20%%20")
    }
    
    func testShouldNotDecodeReservedSet3() {
    
        XCTAssert("%20%25%20".decode(" %") == "%20%25%20")
    }

}
