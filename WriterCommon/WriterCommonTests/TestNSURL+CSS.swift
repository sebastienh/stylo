//
//  TestNSURL+CSS.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-02.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon

class TestNSURL_CSS: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTitleFromURL() {
        
        let urlString = "/test/de/dest/filename.css"
        
        let url = URL(fileURLWithPath: urlString)
        
        let filename = url.extendedTitle()
        
        XCTAssert(filename == "filename", "Expected: filename received: \(filename)")
    }
    
    func testTitleLightFromURL() {
        
        let urlString = "/test/de/dest/filename.light.css"
        
        let url = URL(fileURLWithPath: urlString)
        
        let filename = url.extendedTitle()
        
        XCTAssert(filename == "filename", "Expected: filename received: \(filename)")
    }

    func testTitleDarkFromURL() {
        
        let urlString = "/test/de/dest/filename.dark.css"
        
        let url = URL(fileURLWithPath: urlString)
        
        let filename = url.extendedTitle()
        
        XCTAssert(filename == "filename", "Expected: filename received: \(filename)")
    }

}
