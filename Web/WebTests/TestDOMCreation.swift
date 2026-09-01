//
//  TestCSSDOMCreation.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-14.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestDOMCreation: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testCreateElement() {
        
        var exception = Exception()
        
        let document = Document()
        
        let firstElement = Element(document: document, localName: "test1")
        
        if let parentNode = firstElement.parentNode {
        
            XCTAssert(false, "firstElement parentNode should be nil.")
            
        }
    }
    
    func testAppendChild() {
        
        var exception = Exception()
        
        let document = Document()
        
        let firstElement = Element(document: document, localName: "test1")
        
        let secondElement = Element(document: document, localName: "test2")
        
        firstElement.appendChild(secondElement, exception: &exception)
        
        XCTAssert(!exception.isError(), "Expecting empty exception.")

        // first child test
        if let firstChild = firstElement.firstChild {
            
            XCTAssert(firstChild == secondElement, "firstchild should equal secondElement")
        }
        else {
            
            XCTAssert(false, "firstElement should have a first child.")
        }
        
        // last child test
        if let lastChild = firstElement.lastChild {
            
            XCTAssert(lastChild == secondElement, "lastChild should equal secondElement")
        }
        else {
            
            XCTAssert(false, "firstElement should have a last child.")
        }
    }
    
    func testChildList() {
        
        var exception = Exception()
        
        let document = Document()
        
        let firstElement = Element(document: document, localName: "test1")
        
        let secondElement = Element(document: document, localName: "test2")
        
        firstElement.appendChild(secondElement, exception: &exception)
        
        let thirdElement = Element(document: document, localName: "test3")
        
        secondElement.appendChild(thirdElement, exception: &exception)
        
        XCTAssert(!exception.isError(), "Expecting empty exception.")
        
        // first child test
        if let firstChild = firstElement.firstChild {
            
            XCTAssert(firstChild == secondElement, "firstchild should equal secondElement")
        }
        else {
            
            XCTAssert(false, "firstElement should have a first child.")
        }
        
        // last child test
        if let lastChild = firstElement.lastChild {
            
            XCTAssert(lastChild == secondElement, "lastChild should equal secondElement")
        }
        else {
            
            XCTAssert(false, "firstElement should have a last child.")
        }
        
        if let childList = firstElement.childNodes {
            
            XCTAssert(childList.length == 1, "child list must be of length 1")
            
        }
        
        
    }
    
    
    
    
    

}
