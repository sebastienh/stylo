//
//  StylesheetCompilationTests.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-13.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest
@testable import Web

class StylesheetCompilationTests: CssTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    public func testUnterminatedRuleCompilation1() {
        
        let styleSheet = parseStylesheet(named: "unterminated-rule-1.css")
        XCTAssert(styleSheet.styleRulesCount == 1, "Expected: 1, received: \(styleSheet.styleRulesCount)")
    }

    public func testUnterminatedRuleCompilation2() {
        
        let styleSheet = parseStylesheet(named: "unterminated-rule-2.css")
        XCTAssert(styleSheet.styleRulesCount == 1, "Expected: 1, received: \(styleSheet.styleRulesCount)")
    }
    
    public func testUnterminatedRuleCompilation3() {
        
        let styleSheet = parseStylesheet(named: "unterminated-rule-3.css")
        XCTAssert(styleSheet.styleRulesCount == 1, "Expected: 1, received: \(styleSheet.styleRulesCount)")
    }
    
    public func testTerminatedRuleCompilation1() {
        
        let styleSheet = parseStylesheet(named: "terminated-rule-1.css")
        XCTAssert(styleSheet.styleRulesCount == 2, "Expected: 2, received: \(styleSheet.styleRulesCount)")
    }
}
