//
//  TestFontStyleDomParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest

class TestFontStyleDomParsing: TestCSSDOM {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testArrayFontFamilyParsingWithQuotes() {
        
        XCTAssert(true, "Should be implemented when implementing the property.")
//        
//        let cssString =
//        "   body {                          " +
//            "       font-style : normal ;         " +
//        "   }                               ";
//        
//         
//        
//        let sourceString = SourceString(contentString: cssString)
//        
//        let fontStyleElement = domFromCSSProperty(sourceString, document: CSSDOMDocument(), propertyName: "font-style" )
//        
//        if let fontStyleElement = fontStyleElement {
//            
//            if let childList = fontStyleElement.childNodes {
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
