//
//  TestString+URLUtils.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-04-02.
//  Copyright (c) 2015 NM. All rights reserved.
//

import XCTest

class TestString_URLUtils: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func testConstructFileURL() {
//        
//        let path = String("/Users/sebastienhamel/Documents/textually.net")
//        
//        if let url = path.contructURL() {
//            
//            if let scheme = url.scheme {
//                
//                if let firstPathComponent = URLFirstPathComponent(rawValue: scheme.constructFirstPathComponent()) {
//                
//                    XCTAssert(firstPathComponent == URLFirstPathComponent.FILE, "expecting file url firstPathComponent")
//                }
//                else {
//                    XCTAssert(false, "firstPathComponent is nil")
//                }
//            }
//            else {
//                XCTAssert(false, "scheme is nil")
//            }
//        }
//        else {
//            XCTAssert(false, "url is nil")
//        }
//    }
//
//    func testConstructHttpURL() {
//        
//        let path = String("http:///textually.net")
//        
//        if let url = path.contructURL() {
//            
//            if let scheme = url.scheme {
//                
//                if let firstPathComponent = URLFirstPathComponent(rawValue: scheme.constructFirstPathComponent()) {
//                    
//                    XCTAssert(firstPathComponent == URLFirstPathComponent.HTTP, "expecting http url firstPathComponent")
//                }
//                else {
//                    XCTAssert(false, "firstPathComponent is nil")
//                }
//            }
//            else {
//                XCTAssert(false, "scheme is nil")
//            }
//        }
//        else {
//            XCTAssert(false, "url is nil")
//        }
//    }

}
