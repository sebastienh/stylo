//
//  TestSelectorSpecificity.swift
//  Web
//
//  Created by Sebastien hamel on 2018-11-06.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest
@testable import Web

class TestSelectorSpecificity: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        
        let cssString = String(
            "   body {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 0
            expected.C = 1
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    
    

    func test2() {
        
        let cssString = String(
            "   body::first-letter {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 0
            expected.C = 2
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    func test3() {
        
        let cssString = String(
            "   body p::first-letter {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 0
            expected.C = 3
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // body#home div#featured p.text
    func test4() {
        
        let cssString = String(
            "   body#home div#featured p.text {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 2
            expected.B = 1
            expected.C = 3
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    func test5() {
        
        let cssString = String(
            "   li::first-line {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 0
            expected.C = 2
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // ul ol+li
    func test6() {
        
        let cssString = String(
            "   ul ol+li {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 0
            expected.C = 3
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // h1 + *[rel=up]
    func test7() {
        
        let cssString = String(
            "   h1 + *[rel=up] {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 1
            expected.C = 1
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // ul ol li.first
    func test8() {
        
        let cssString = String(
            "   ul ol li.first {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 1
            expected.C = 3
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // li.last.featured
    func test9() {
        
        let cssString = String(
            "   li.last.featured {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 2
            expected.C = 1
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // div p.big-text
    func test10() {
        
        let cssString = String(
            "   div p.big-text{                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 1
            expected.C = 2
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // #author-name
    func test11() {
        
        let cssString = String(
            "   #author-name {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 1
            expected.B = 0
            expected.C = 0
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // body #blog-list .post p
    func test12() {
        
        let cssString = String(
            "   body #blog-list .post p {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 1
            expected.B = 1
            expected.C = 2
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // body.class::tag
    func test13() {
        
        let cssString = String(
            "   body.class::tag {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 1
            expected.C = 2
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    // body::tag:focus
    func test14() {
        
        let cssString = String(
            "   body::tag:focus {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        if let selectorSpecificity = self.specificity(from: cssString) {
            
            let expected = SelectorSpecificity()
            expected.A = 0
            expected.B = 1
            expected.C = 2
            
            XCTAssert(selectorSpecificity == expected, "received \(selectorSpecificity), expected: \(expected)")
        }
        else {
            XCTAssert(false, "selectorSpecificity is nil.")
        }
    }
    
    private func specificity(from cssString: String) -> SelectorSpecificity? {
    
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            if let styleRule = rule as? CSSStyleRule {
                
                return styleRule.selectorList?.selectorArray.first?.selectorSpecificity
            }
            else {
                XCTAssert(false, "Should have been a style rule object type.")
            }
        }
        else {
            XCTAssert(false, "Should have a arule at index 0!")
        }
        return nil
    }
    
    
}
