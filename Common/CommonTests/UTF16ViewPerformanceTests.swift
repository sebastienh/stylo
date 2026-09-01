//
//  UTF16ViewPerformanceTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-09-10.
//  Copyright © 2016 NM. All rights reserved.
//

import XCTest
@testable import Common

class UTF16ViewPerformanceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSliceToStringView() {
        
        let stringToSlice = "// Put teardown code here. This method is called after the invocation of each test method in the class."
        
        
        self.measure {
            
            for _ in 0..<100000 {
                
                let slice1: String = stringToSlice.slice(3, end: 12)!
                let slice2: String = stringToSlice.slice(26, end: 30)!
                let slice3: String = stringToSlice.slice(32, end: 36)!
                
//                let concat = slice1 + slice2 + slice3
//                
//                _ = concat.length
            }
        }
    }
//    
//    func testSliceToStringSlice() {
//        
//        let stringToSlice = "// Put teardown code here. This method is called after the invocation of each test method in the class."
//        
//        
//        self.measure {
//            
//            for _ in 0..<100000 {
//                
//                var slice: StringSlice = stringToSlice.sliceToSlice(3, end: 12)
//                slice.addSegment((26,30))
//                slice.addSegment((32,36))
//                
////                let string = slice.string
////                
////                _ = string.length
//            }
//        }
//    }
    
    
    func testWithCFString() {
        
        
        let hello: CFString = "// Put teardown code here. This method is called after the invocation of each test method in the class." as CFString
        
        self.measure {
            
            for _ in 0..<100000 {
        
                let slice1 = CFStringCreateWithSubstring(kCFAllocatorSystemDefault, hello, CFRange(location: 3, length: 12 - 3))
                CFStringCreateMutableCopy(kCFAllocatorDefault, 0, slice1)
                let slice2 = CFStringCreateWithSubstring(kCFAllocatorSystemDefault, hello, CFRange(location: 26, length: 30 - 26))
                CFStringCreateMutableCopy(kCFAllocatorDefault, 0, slice2)
                let slice3 = CFStringCreateWithSubstring(kCFAllocatorSystemDefault, hello, CFRange(location: 32, length: 36 - 32))
                CFStringCreateMutableCopy(kCFAllocatorDefault, 0, slice3)
            }
        }
    }
    
}
