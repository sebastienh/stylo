//
//  UnicodeDigitTests.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-06-03.
//  Copyright (c) 2014 CM. All rights reserved.
//

import XCTest
import Common

class UnicodeDigitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIsUnicodeDigit() {
        
        assert(UnicodeDigit.isUnicodeDigit(0x0031), "")
    }

    func testIsUnicodeDigitErrorCase() {
        
        assert(!UnicodeDigit.isUnicodeDigit(0x0040), "")
    }
    
}
