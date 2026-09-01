////
////  StringSliceTests.swift
////  Common
////
////  Created by Sébastien Hamel on 2016-09-07.
////  Copyright © 2016 NM. All rights reserved.
////
//
//import XCTest
//
//class StringSliceTests: XCTestCase {
//
//    override func setUp() {
//        
//        super.setUp()
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//
//    func testBasic() {
//        
//        let string = "0123456789"
//        
//        let slice = string.sliceToSlice(1, end: 2)
//        
//        XCTAssert(slice.string == "1")
//    }
//
//    func testAddingSegmentToASlice() {
//        
//        let string = "0123456789"
//        
//        var firstSlice = string.sliceToSlice(2,end: 3)
//        firstSlice.addSegment(5, end: 6)
//        firstSlice.addSegment(7, end: 8)
//        
//        debugPrint("Sliced string: \"\(firstSlice.string)\"")
//    }
//    
//    func testAddingSegmentToASliceWithASliceOverItFail() {
//        
//        let string = "0123456789"
//        
//        var firstSlice = string.sliceToSlice(2,end: 3)
//        firstSlice.addSegment(5, end: 6)
//        firstSlice.addSegment(7, end: 8)
//        
//        debugPrint("Sliced string: \"\(firstSlice.string)\"")
//        
//        if let _ = firstSlice.slice(2,end: 5) {
//            
//            XCTAssert(false, "Should not have received any slice")
//        }
//        else {
//        
//            XCTAssert(true)
//        }
//    }
//    
//    func testAddingSegmentToASliceLength() {
//        
//        let string = "0123456789"
//        
//        var firstSlice = string.sliceToSlice(2,end: 3)
//        firstSlice.addSegment(5, end: 6)
//        firstSlice.addSegment(7, end: 8)
//        
//        
//        XCTAssert(firstSlice.length == 3, "Should have received 3 but received \(firstSlice.length)")
//    }
//    
//    func testAddingSegmentToASliceWithASliceOverIt() {
//        
//        let string = "0123456789"
//        
//        var firstSlice = string.sliceToSlice(2,end: 3)!
//        firstSlice.addSegment(5, end: 6)
//        firstSlice.addSegment(7, end: 8)
//        
//        
//        XCTAssert(firstSlice.length == 3, "Should have received 3")
//        XCTAssert(firstSlice.string == "257", "Expected \"257\" but received \"\(firstSlice.string)\"")
//        
//        if let secondSlice = firstSlice.sliceToSlice(2,end:3) {
//            
//            XCTAssert(secondSlice.string == "7", "Expected \"7\" but received \"\(secondSlice.string)\"")
//        }
//        else {
//            
//            XCTAssert(false, "Should have received a string.")
//        }
//    }
//    
//    func testExtractStringsFromSliceOfSliceOfStringFirstPart() {
//        
//        let string = "This a totally crazy test that I'm doing"
//        
//        var firstSlice = string.sliceToSlice(5,end: 6)!
//        firstSlice.addSegment(7, end: 14)
//        firstSlice.addSegment(15, end: 16)
//        firstSlice.addSegment(17, end: 19)
//        firstSlice.addSegment(21, end: 25)
//        firstSlice.addSegment(26, end: 30)
//        
//        let secondSlice = firstSlice.slice(2,end: 5)!
//        
//        XCTAssert(firstSlice.string == "atotallycaztestthat",
//                  "Expected \"atotallycaztestthat\" but received \"\(firstSlice.string)\"")
//        XCTAssert(secondSlice.string == "ota",
//                  "Expected \"ota\" but received \"\(secondSlice.string)\"")
//    }
//    
//    func testExtractStringsFromSliceOfSliceOfStringSecondPart() {
//        
//        let string = "This a totally crazy test that I'm doing"
//        
//        var firstSlice = string.sliceToSlice(5,end: 6)!
//        firstSlice.addSegment(7, end: 14)
//        firstSlice.addSegment(15, end: 16)
//        firstSlice.addSegment(17, end: 19)
//        firstSlice.addSegment(21, end: 25)
//        firstSlice.addSegment(26, end: 30)
//        
//        let secondSlice = firstSlice.slice(7, end: 9)!
//        
//        XCTAssert(firstSlice.string == "atotallycaztestthat",
//                  "Expected \"atotallycaztestthat\" but received \"\(firstSlice.string)\"")
//        XCTAssert(secondSlice.string == "yc",
//                  "Expected \"yc\" but received \"\(secondSlice.string)\"")
//    }
//    
//    func testExtractStringsFromSliceOfSliceOfStringThirdPart() {
//        
//        let string = "This a totally crazy test that I'm doing"
//        
//        var firstSlice = string.sliceToSlice(5,end: 6)!
//        firstSlice.addSegment(7, end: 14)
//        firstSlice.addSegment(15, end: 16)
//        firstSlice.addSegment(17, end: 19)
//        firstSlice.addSegment(21, end: 25)
//        firstSlice.addSegment(26, end: 30)
//        
//        let secondSlice = firstSlice.slice(10, end: 17)!
//        
//        XCTAssert(firstSlice.string == "atotallycaztestthat",
//                  "Expected \"atotallycaztestthat\" but received \"\(firstSlice.string)\"")
//        XCTAssert(secondSlice.string == "ztestth",
//                  "Expected \"ztestth\" but received \"\(secondSlice.string)\"")
//    }
//    
//    func testExtractStringsFromSliceOfSliceOfString() {
//        
//        let string = "This a totally crazy test that I'm doing"
//        
//        var firstSlice = string.sliceToSlice(5,end: 6)!
//        firstSlice.addSegment(7, end: 14)
//        firstSlice.addSegment(15, end: 16)
//        firstSlice.addSegment(17, end: 19)
//        firstSlice.addSegment(21, end: 25)
//        firstSlice.addSegment(26, end: 30)
//        
//        var secondSlice = firstSlice.sliceToSlice(2,end: 5)!
//        secondSlice.addSegment(7, end: 9)
//        secondSlice.addSegment(10, end: 17)
//        
//        XCTAssert(firstSlice.string == "atotallycaztestthat",
//                  "Expected \"atotallycaztestthat\" but received \"\(firstSlice.string)\"")
//        XCTAssert(secondSlice.string == "otaycztestth",
//                  "Expected \"otay cztestth\" but received \"\(secondSlice.string)\"")
//        
//    }
//    
//    
//    func testCharAt() {
//        
//        let string = "This a totally crazy test that I'm doing"
//        
//        var firstSlice = string.sliceToSlice(5,end: 6)!
//        firstSlice.addSegment(7, end: 14)
//        firstSlice.addSegment(15, end: 16)
//        firstSlice.addSegment(17, end: 19)
//        firstSlice.addSegment(21, end: 25)
//        firstSlice.addSegment(26, end: 30)
//        
//        XCTAssert(firstSlice.string == "atotallycaztestthat",
//                  "Expected \"atotallycaztestthat\" but received \"\(firstSlice.string)\"")
//        XCTAssert(firstSlice.length == 19, "Expected 19, received \(firstSlice.length)" )
//        XCTAssert(firstSlice.charAt(0) == §UnicodeLetter.a)
//        XCTAssert(firstSlice.charAt(1) == §UnicodeLetter.t)
//        XCTAssert(firstSlice.charAt(2) == §UnicodeLetter.o)
//        XCTAssert(firstSlice.charAt(3) == §UnicodeLetter.t)
//        XCTAssert(firstSlice.charAt(4) == §UnicodeLetter.a)
//        XCTAssert(firstSlice.charAt(5) == §UnicodeLetter.l)
//        XCTAssert(firstSlice.charAt(6) == §UnicodeLetter.l)
//        XCTAssert(firstSlice.charAt(7) == §UnicodeLetter.y)
//        XCTAssert(firstSlice.charAt(8) == §UnicodeLetter.c)
//        XCTAssert(firstSlice.charAt(9) == §UnicodeLetter.a)
//        XCTAssert(firstSlice.charAt(10) == §UnicodeLetter.z)
//        XCTAssert(firstSlice.charAt(11) == §UnicodeLetter.t)
//        XCTAssert(firstSlice.charAt(12) == §UnicodeLetter.e)
//        XCTAssert(firstSlice.charAt(13) == §UnicodeLetter.s)
//        XCTAssert(firstSlice.charAt(14) == §UnicodeLetter.t)
//        XCTAssert(firstSlice.charAt(15) == §UnicodeLetter.t)
//        XCTAssert(firstSlice.charAt(16) == §UnicodeLetter.h)
//        XCTAssert(firstSlice.charAt(17) == §UnicodeLetter.a)
//        XCTAssert(firstSlice.charAt(18) == §UnicodeLetter.t)
//        
//        var secondSlice = firstSlice.sliceToSlice(2,end: 5)!
//        secondSlice.addSegment(7, end: 9)
//        secondSlice.addSegment(10, end: 17)
//        
//        XCTAssert(secondSlice.length == 12, "Expected 12, received \(secondSlice.length)" )
//        XCTAssert(secondSlice.string == "otaycztestth",
//                  "Expected \"otay cztestth\" but received \"\(secondSlice.string)\"")
//        
//        XCTAssert(secondSlice.charAt(0) == §UnicodeLetter.o)
//        XCTAssert(secondSlice.charAt(1) == §UnicodeLetter.t)
//        XCTAssert(secondSlice.charAt(2) == §UnicodeLetter.a)
//        XCTAssert(secondSlice.charAt(3) == §UnicodeLetter.y)
//        XCTAssert(secondSlice.charAt(4) == §UnicodeLetter.c)
//        XCTAssert(secondSlice.charAt(5) == §UnicodeLetter.z)
//        XCTAssert(secondSlice.charAt(6) == §UnicodeLetter.t)
//        XCTAssert(secondSlice.charAt(7) == §UnicodeLetter.e)
//        XCTAssert(secondSlice.charAt(8) == §UnicodeLetter.s)
//        XCTAssert(secondSlice.charAt(9) == §UnicodeLetter.t)
//        XCTAssert(secondSlice.charAt(10) == §UnicodeLetter.t)
//        XCTAssert(secondSlice.charAt(11) == §UnicodeLetter.h)
//        
//        
//        
////        let address = unsafeAddressOf(secondSlice.charAt(0)!)
//        
//    }
//    
//}
