//
//  TestURLLoader.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-04-01.
//  Copyright (c) 2015 NM. All rights reserved.
//

import XCTest

class TestURLLoader: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func testFileURLLoader() {
//
//        let readyExpectation = expectationWithDescription("ready")
//        
//        var error = NSError(
//        
//        let bundle = NSBundle(path: "/Users/sebastienhamel/Documents/textually.net/development/WriterWP/Common/CommonTests")
//        
//        if let bundle = bundle {
//        
//            let path = bundle.pathForResource("test", ofType: "css")
//        
//            let urlLoader = URLLoader.shared
//        
//            var content: String?
//            
//            urlLoader.loadStringContentFromURL(path!, localError: &error, externalCompletionHandler: {
//                
//                string, error in
//                
//                if let string = string {
//                    
//                    content = string
//                }
//                // And fulfill the expectation...
//                readyExpectation.fulfill()
//            })
//
//        
//            waitForExpectationsWithTimeout(5, handler: { error in
//                
//                if let content = content {
//
//                    XCTAssert( content == "test css file.", "wrong content")
//                    
//                    println("Content value is : \(content)")
//                }
//                else {
//                     XCTAssert(false, "content is nil.")
//                }
//            })
//        }
//        else {
//            
//            XCTAssert(false, "bundle is nil.")
//        }
//    }
//
//    func testWebURLLoader() {
//        
//        let readyExpectation = expectationWithDescription("ready")
//        
//        var error = NSError()
//        
//        var content: String?
//        
//        let urlLoader = URLLoader.shared
//            
//        urlLoader.loadStringContentFromURL("http://www.google.com", localError: &error, externalCompletionHandler: { string, error in
//            
//            if let string = string {
//                
//                content = string
//            }
//            
//            // And fulfill the expectation...
//            readyExpectation.fulfill()
//        })
//        
//        waitForExpectationsWithTimeout(5, handler: { error in
//            
//            XCTAssert(content != nil, "content is nil.")
//            
//            println("Content value is : \(content)")
//            
//        })
//
//    }
//    
//    func testFailHttpsWebURLLoader() {
//        
//        let readyExpectation = expectationWithDescription("ready")
//        
//        var error = NSError()
//        
//        var content: String?
//        
//        let urlLoader = URLLoader.shared
//        
//        urlLoader.loadStringContentFromURL("https://www.google.com", localError: &error, externalCompletionHandler: {
//            
//            string, error in
//            
////            if let string = string {
////                
////                XCTAssert(false, "content is not expected.")
////            }
//            
//            if let error = error {
//                
//                XCTAssert(error.domain == NSStyloErrorDomain, "should be stylo error domain")
//            }
//            
//            // And fulfill the expectation...
//            readyExpectation.fulfill()
//        })
//        
//        waitForExpectationsWithTimeout(5, handler: { error in
//            
//            
//            
//        })
//        
//    }
//
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
