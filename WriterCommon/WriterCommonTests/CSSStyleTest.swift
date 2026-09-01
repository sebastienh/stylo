//
//  CSSStyleTest.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2017-11-26.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Web

class CSSStyleTest: WriterCommonCssTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStyleCopy() {
        
        let userAgentStylesheet = loadStylesheet(named: "css-ua.css", origin: .userAgent)
        let singleErrorStylesheet = loadStylesheet(named: "single-error.css", origin: .user)

        let style = CSSStyle(id: "single-error-style", userAgentStyleSheet: userAgentStylesheet, userStyleSheet: singleErrorStylesheet)
        
        let styleCopy = style.clone()
    
        XCTAssert(style.equals(to: styleCopy), "styles are not equal")
    }

}






















