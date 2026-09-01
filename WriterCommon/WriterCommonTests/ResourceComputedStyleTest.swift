//
//  ResourceComputedStyleTest.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-30.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Markdown
import Common
@testable import WriterCommon

class ResourceComputedStyleTest: WriterCommonCssTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUserStylesheetSpecificity() {
        
        
        
        
    }
    
//    
//    
//    func testCascading() {
//        
//        // create the document to test
//        let cssChangeRequest = compileCssSourceFile(from: "source.css")!
//        
//        let domDocument = cssChangeRequest.renderableDocument as! CSSDOMDocument?
//        XCTAssert(domDocument != nil)
//        
//        let dom = serializeCssDom(cssDomDocument: domDocument!)
//        
//        debugPrint(dom)
//        
//        // find the element with the error
//        
//        let element = getElement(in: domDocument!, tagName: "css-token", classes: ["number-token"], attributes: ["text-value": "1940"])
//        
//        // create the style 
//        let cssStyle = createStyle(from: ["source-author.css", "user.css"], with: "text-ua.css")
//        
//        // evaluate the style 
//        let resourceComputedStyle = computeElementsStyle(styleDefinition: cssStyle!, document: domDocument!)
//        
//
//        
//        
//        
//        for attribute in element!.attributeList {
//            
//            debugPrint("attribute: \(attribute.name), \(attribute.value)")
//        }
//        
//        XCTAssert(element!.hasAttribute("nw-message-id"))
//        
//        // test for element styles 
//        let elementResourceComputedStyle = resourceComputedStyle.elementStyleForElement(element!)
//        
////        validate(computedStyle: elementResourceComputedStyle, is: "{ }")
//        
//        
//        
////        need to create the test for the style
//        
//    }
    
}
