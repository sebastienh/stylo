//
//  StringSet+AdditionsTests.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-01-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest

class StringSet_AdditionsTests: XCTestCase {

    func testSetEditOperations1() {
        
        let origin = Set(["1","2","3"])
        let other = Set(["1","2","3"])
        
        let operations = origin.setEditOperations(to: other)
        XCTAssert(operations == nil)
    }
    
    func testSetEditOperations2() {
        
        var origin = Set(["1","2","3"])
        let other = Set(["1","2","4"])
        
        guard let operations = origin.setEditOperations(to: other) else {
            XCTAssert(false, "operations should not be nil")
            return 
        }
        
        XCTAssert(operations.count == 2)
        XCTAssert(operations.contains(.add(value: "4")))
        XCTAssert(operations.contains(.delete(value: "3")))
        
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }

    func testSetEditOperations3() {
        
        var origin = Set<String>([])
        let other = Set(["1","2","4"])
        
        guard let operations = origin.setEditOperations(to: other) else {
            XCTAssert(false, "operations should not be nil")
            return
        }
        
        XCTAssert(operations.count == 3)
        XCTAssert(operations.contains(.add(value: "1")))
        XCTAssert(operations.contains(.add(value: "2")))
        XCTAssert(operations.contains(.add(value: "4")))
        
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testSetEditOperations4() {
        
        var origin = Set(["1","2","4"])
        let other = Set<String>([])
        
        guard let operations = origin.setEditOperations(to: other) else {
            XCTAssert(false, "operations should not be nil")
            return
        }
        
        XCTAssert(operations.count == 3)
        XCTAssert(operations.contains(.delete(value: "1")))
        XCTAssert(operations.contains(.delete(value: "2")))
        XCTAssert(operations.contains(.delete(value: "4")))
        
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
}
