//
//  TestLiveNodeList.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-30.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestLiveNodeList: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///         Document
    ///             |
    ///         firstElement
    ///             |
    ///         secondElement
    ///             |
    ///         thirdElement
    ///
    func testChildListDescendants() {
        
        var exception = Exception()
        
        let document = Document()
        
        let firstElement = Element(document: document, localName: "test1")
        document.appendChild(firstElement, exception: &exception)
        
        let secondElement = Element(document: document, localName: "test2")
        
        firstElement.appendChild(secondElement, exception: &exception)
        
        let thirdElement = Element(document: document, localName: "test3")
        
        secondElement.appendChild(thirdElement, exception: &exception)
        
        XCTAssert(!exception.isError(), "Expecting empty exception.")
        
        let descendants = document.descendants()
        
        XCTAssert(descendants.length == 3, "document should have three descendants.")
        
    }
    
    func testAllElementsInclusive() {
    
        var exception = Exception()
        
        let document = Document()
        
        let firstElement = Element(document: document, localName: "test1")
        document.appendChild(firstElement, exception: &exception)
        
        let secondElement = Element(document: document, localName: "test2")
        
        firstElement.appendChild(secondElement, exception: &exception)
        
        let thirdElement = Element(document: document, localName: "test3")
        
        secondElement.appendChild(thirdElement, exception: &exception)
        
        let filter = AllElementNodeFilter()
        
        let collection = HTMLCollection(root: firstElement, filter: filter, inclusive: true)
        
        XCTAssert(collection.length == 3, "document should have three elements.")
    }

    func testAllElementsNoRepeat() {
        
        let cssString =
            "   body {                                          " +
                "       font-family: arial, times, serif;           " +
                "   }                                               " +
                "   p {                                             " +
                "       font-family: arial, times, serif;                       " +
        "   }                                               "
        
        let cssDomModule = CSSDOMModule.shared

        
        if let cssDomDocument = cssDomModule.domFromCSSString(cssString as NSString, origin: .author) {
            
            let length = cssDomDocument.length
            
            // the document should contain the documenttype
            // and the stylesheet
            let expectedLength = 2
            
            XCTAssert(length == expectedLength, "CSSDOMDocument lenght is not \(expectedLength) but \(length).")
            
            let descendants = cssDomDocument.descendants()
            
            XCTAssert(descendants.length == 76, "should have 54 descendants")
            
            var elementsSet = Set<Element>()
            for descendant in descendants {
                
                if let element = descendant as? Element {
                    elementsSet.insert(element)
                }
            }
            
            let collection = HTMLCollection(root: cssDomDocument.styleSheet, filter: AllElementNodeFilter(), inclusive: true)
            
            let collectionLength = collection.length
            let elementsSetCount = elementsSet.count
            
            XCTAssert(collectionLength == elementsSetCount)
        }
        else {
            XCTAssert(false, "CSSDOMDocument is nil.")
        }
    }
    
    
    func testAllElementsNoRepeat2(){
        
        let cssString = """
        /*
         stylo - source - all errors - light
         
         source css file for handling a single error highlighting
         in light mode.
         */
        
        @namespace "http://www.w3.org/Style/CSS/";
        
        css-style-sheet {
            font-family: Menlo;
            font-size: 10pt;
            color: #999 !important;
            background-color: rgb(42,41,40) !important;
        }
        
        [nw-message-id].error {
            color: rgba(255, 0, 0, 0.4);
        }
        
        [nw-message-id].warning {
            color: rgba(255,255,153, 0.6) !important;
        }
        
        /* the later will select only the error to highlight */
        
        /***********
         
         Important Note: This rule should always be the last rule
         
         ***********/
        [nw-message-id=""].warning {
            color: yellow !important;
        }
        
        [nw-message-id=""].error {
            color: red !important;
        }
        """
        
        let cssDomModule = CSSDOMModule.shared
        
        
        if let cssDomDocument = cssDomModule.domFromCSSString(cssString as NSString, origin: .author) {
            
            let length = cssDomDocument.length
            
            // the document should contain the documenttype
            // and the stylesheet
            let expectedLength = 2
            
            XCTAssert(length == expectedLength, "CSSDOMDocument lenght is not \(expectedLength) but \(length).")
            
            let descendants = cssDomDocument.descendants()

            var elementsSet = Set<Element>()
            for descendant in descendants {
                
                if let element = descendant as? Element {
                    elementsSet.insert(element)
                }
            }
            
            let collection = HTMLCollection(root: cssDomDocument.styleSheet, filter: AllElementNodeFilter(), inclusive: true)
            
            let collectionLength = collection.length
            let elementsSetCount = elementsSet.count
            
            XCTAssert(collectionLength == elementsSetCount, "expected: \(elementsSetCount) got: \(collectionLength)")
        }
        else {
            XCTAssert(false, "CSSDOMDocument is nil.")
        }
        
    }

}
