//
//  TestTextDecorationLineDOMParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest

class TestTextDecorationLineDOMParser: TestCSSDOM {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func testTextDecorationLineNoneParsing() {
//        
//        let cssString =
//        "   body {                          " +
//            "       text-decoration-line : none ;         " +
//        "   }                               ";
//        
//         
//        
//        let sourceString = SourceString(contentString: cssString)
//        
//        let fontElement = domFromCSSProperty(sourceString, document: CSSDOMDocument(), propertyName: "text-decoration-line" )
//        
//        if let fontElement = fontElement {
//            
//            if let childList = fontElement.childNodes {
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
//    }

}
