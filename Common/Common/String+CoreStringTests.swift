//
//  String+CoreStringTests.swift
//  Common
//
//  Created by Sebastien hamel on 2019-05-08.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class String_CoreStringTests: XCTestCase {

    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testBasicSlice() {
        
        let string = "123456789"
        let slice = string.slice(1, end: 2)
        XCTAssert(slice == "2")
    }

    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testCompleteSlice() {
        
        let string = "123456789"
        let slice = string.slice(0, end: 9)
        XCTAssert(slice == "123456789")
    }

    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testCompleteSlice2() {
        
        let string = "www.textually.net"
        let slice = string.slice(0, end: 17)
        XCTAssert(slice == "www.textually.net")
    }
    
    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testSliceAtEndOfString() {
        
        let string = "www.textually.net"
        let slice = string.slice(17)
        XCTAssert(slice == nil)
    }
    
    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testBasicSliceOver() {
        
        let string = "123456789"
        let slice = string.slice(1, end: 12)
        XCTAssert(slice == nil)
    }
    
    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testBasicSliceNegativeEnd() {
        
        let string = "123456789"
        let slice = string.slice(1, end: -2)
        XCTAssert(slice == "234567")
    }
    
    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testBasicSliceNegativeStart() {
        
        let string = "123456789"
        let slice = string.slice(-11)
        XCTAssert(slice == nil)
    }
    
    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testBasicSliceOverflowStart() {
        
        let string = "123456789"
        let slice = string.slice(14)
        XCTAssert(slice == nil)
    }
    
    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testBasicSliceNegativEnd2() {
        
        let string = "123456789"
        let slice = string.slice(0, end: -1)
        XCTAssert(slice == "12345678")
    }
    
    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testBasicSliceEndOverflow() {
        
        let string = "123456789"
        let slice = string.slice(0, end: 14)
        XCTAssert(slice == nil)
    }
    
    // func slice(_ start: Int, end: Int? = nil) -> String?
    func testBasicSliceEndOverflow2() {
        
        let string = "123456789"
        let slice = string.slice(0, end: -14)
        XCTAssert(slice == nil)
    }
}
