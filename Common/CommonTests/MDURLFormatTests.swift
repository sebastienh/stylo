//
//  MDURLFormatTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-12.
//  Copyright © 2016 NM. All rights reserved.
//

import XCTest
@testable import Common

class MDURLFormatTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test(url: String, dict: [String: String]) {
        
        let toFormat = MDURL(json: dict)
        
        XCTAssert(url == toFormat.format(), "URL: \(url) \nnot formatted as expected: \n\(url) \n\nbut as: \n\n\(toFormat.format())\n\n")
    }
    
    func testFormat1() {
        func test88() {
            
            test(url: "http://nodeca.github.io/pica/demo/", dict: [
                "proto" : "http:",
                "hostname" : "nodeca.github.io",
                "pathname" : "/pica/demo/",
                "slashes" : "true"
                ])
        }
    }


}
