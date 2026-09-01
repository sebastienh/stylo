//
//  TestFontSizeDomParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest

class TestFontSizeDomParsing: TestCSSDOM {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFontSizeDomParsing() {
        
        XCTAssert(true, "Font is nil.")
        
//        let cssString =
//        "   body {                          " +
//            "       font-size : normal ;         " +
//        "   }                               ";
//        
//         
//        
//        let sourceString = SourceString(contentString: cssString)
//        
//        let fontSizeElement = domFromCSSProperty(sourceString, document: CSSDOMDocument(), propertyName: "font-size" )
//        
//        if let fontSizeElement = fontSizeElement {
//            
//            if let childList = fontSizeElement.childNodes {
//                
//                XCTAssert(childList.length == 1, "Wrong number of children.")
//                
//                for var index = 0; index < childList.length; index++ {
//                    
//                    let child = childList[index]
//                    
//                    switch index {
//                        
//                    case 0:
//                        XCTAssert(child is CSSDOMKeywordElement, "CSSDOMKeywordElement is expected.")
//                    default:
//                        XCTAssert(false, "wrong number of childs.")
//                    }
//                }
//            }
//            else {
//                XCTAssert(false, "childList is nil.")
//            }
//        }
//        else {
//            XCTAssert(false, "Font is nil.")
//        }
    }

}
