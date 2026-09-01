//
//  DoubleTimeTests.swift
//  Common
//
//  Created by Sebastien Hamel on 2019-12-16.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import Common

class DoubleTimeTests: XCTestCase {

    func testTimeString() {
        
        // 2 hours 24 minutes 35 seconds 34 milliseconds
        
        // 2 hours
        var milliseconds: Double = 7200
        
        // 24 minutes
        milliseconds += 1440
        
        // 35 seconds
        milliseconds += 35
        
        // 34 milliseconds
        milliseconds += 0.34
        
        let string = milliseconds.hoursMinutesSecondsMilliseconds
        let expected = "02:24:35"
        
        XCTAssert(string == expected, "Expected: \(expected), received: \(string)")
    }


}
