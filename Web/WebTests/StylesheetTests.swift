//
//  StylesheetTests.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-12-21.
//  Copyright © 2017 NM. All rights reserved.
//

import XCTest
@testable import Web

class StylesheetTests: CssTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCloneStylesheet() {
        
        let styleSheet = parseStylesheet(named: "test.css")
        let styleSheetClone: CSSStyleSheet = styleSheet.clone()
        XCTAssert(styleSheetClone.equals(to: styleSheet))
    }
    
    func testCloneStylesheet2() {
        
        let styleSheet = parseStylesheet(named: "clone-compound-selector.css")
        let styleSheetClone: CSSStyleSheet = styleSheet.clone()
        XCTAssert(styleSheetClone.equals(to: styleSheet))
    }
    
    func testSameStylesheetEquals1() {
        
        let stylesheet1 = parseStylesheet(named: "equals-1.css")
        let stylesheet2 = parseStylesheet(named: "equals-1.css")
        XCTAssert(stylesheet1.equals(to: stylesheet2))
    }
    
    func testSameStylesheetEquals2() {
        
        let stylesheet1 = parseStylesheet(named: "equals-2.css")
        let stylesheet2 = parseStylesheet(named: "equals-2.css")
        XCTAssert(stylesheet1.equals(to: stylesheet2))
    }
    
    func testDifferentStylesheetNotEquals1() {
        
        let stylesheet1 = parseStylesheet(named: "equals-1.css")
        let stylesheet2 = parseStylesheet(named: "equals-2.css")
        XCTAssert(!stylesheet1.equals(to: stylesheet2))
    }
    
    func testDifferentStylesheetNotEquals2() {
        
        let stylesheet1 = parseStylesheet(named: "equals-1.css")
        let stylesheet2 = parseStylesheet(named: "equals-1-changed-font-family-declaration-1.css")
        XCTAssert(!stylesheet1.equals(to: stylesheet2))
    }
    
    func testDifferentStylesheetNotEquals3() {
        
        let stylesheet1 = parseStylesheet(named: "equals-1.css")
        let stylesheet2 = parseStylesheet(named: "equals-1-changed-rgb-color-declaration-1.css")
        XCTAssert(!stylesheet1.equals(to: stylesheet2))
    }
    
    func testDifferentStylesheetNotEquals4() {
        
        let stylesheet1 = parseStylesheet(named: "equals-1.css")
        let stylesheet2 = parseStylesheet(named: "equals-1-changed-rgb-color-declaration-1.css")
        XCTAssert(!stylesheet1.equals(to: stylesheet2))
    }
    
    func testDifferentStylesheetNotEquals5() {
        
        let stylesheet1 = parseStylesheet(named: "equals-1.css")
        let stylesheet2 = parseStylesheet(named: "equals-1-changed-font-size-declaration-1.css")
        XCTAssert(!stylesheet1.equals(to: stylesheet2))
    }

    func testDifferentStylesheetNotEquals6() {
        
        let stylesheet1 = parseStylesheet(named: "equals-3.css")
        let stylesheet2 = parseStylesheet(named: "equals-3-with-html-block-rule.css")
        XCTAssert(!stylesheet1.equals(to: stylesheet2))
    }
    
}
