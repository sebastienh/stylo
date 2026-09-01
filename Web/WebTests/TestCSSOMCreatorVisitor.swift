//
//  TestCSSOMCreatorVisitor.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-04.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestCSSOMCreatorVisitor: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRuleIsStyleRule() {
        
        let cssString = " body { font-family: arial; } "
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        XCTAssert(cssStyleSheet.cssRules.length == 1, "Should have only one rule!")
            
        if let rule = cssStyleSheet.cssRules.item(0) {
                
            XCTAssert(rule.type == CSSRuleType.style_rule, "Should have been a style rule")
                
        }
        else {
                
            XCTAssert(false, "Should have a arule at index 0!")
        }
    }
    
    
    func testSimpleDeclarationNotImportant() {
        
        let cssString = " body { font-family: arial; } "
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
            
        XCTAssert(cssStyleSheet.cssRules.length == 1, "Should have only one rule!")
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            XCTAssert(rule.type == CSSRuleType.style_rule, "Should have been a style rule")
            
            if let styleRule = rule as? CSSStyleRule {
                
                XCTAssert(styleRule.selectorText == "body", "Wrong selector, expected \"body\" received : \(styleRule.selectorText)")
                
                if let style = styleRule.style {
                    
                    let fontFamilyValue = style.getPropertySringValue("font-family")
                    
                    XCTAssert(fontFamilyValue == " arial", "Expected \"arial\" font-family value received \(String(describing: fontFamilyValue)).")
                }
            }
            else {
                XCTAssert(false, "Should have been a style rule object type.")
            }
        }
        else {
            
            XCTAssert(false, "Should have a arule at index 0!")
        }
        
    }
    
    func testSimpleDeclarationImportant() {
        
        let cssString = " body { font-family: arial !important ; } "
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
            
        XCTAssert(cssStyleSheet.cssRules.length == 1, "Should have only one rule!")
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            XCTAssert(rule.type == CSSRuleType.style_rule, "Should have been a style rule")
            
            if let styleRule = rule as? CSSStyleRule {
                
                XCTAssert(styleRule.selectorText == "body", "Wrong selector, expected \"body\" received : \(styleRule.selectorText)")
                
                if let style = styleRule.style {
                    
                    let fontFamilyValue = style.getPropertySringValue("font-family")
                    let expected: String? = " arial "
                    
                    XCTAssert(fontFamilyValue == expected, "Expected \" arial \" font-family value receive \(String(describing: fontFamilyValue)).")
                }
            }
            else {
                XCTAssert(false, "Should have been a style rule object type.")
            }
        }
        else {
            
            XCTAssert(false, "Should have a arule at index 0!")
        }
        
    }
    
    func testComplexDeclaration() {
        
        let cssString = String(
            "   h1 {                            " +
            "       background-color:#CCC;      " +
            "       border: 1px solid;          " +
            "       color:#39F;                 " +
            "       text-align: center;         " +
            "   }                               " +
            "   table {                         " +
            "       background-color: #F60;     " +
            "       border: 1px solid #39F;     " +
            "       width: 100%;                " +
            "   }                               " +
            "   td {                            " +
            "       border: 0px;                " +
            "       text-align: center;         " +
            "   }                               " +
            "   p {                             " +
            "       color:#09F;                 " +
            "       text-indent: 20px;          " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
            
        XCTAssert(cssStyleSheet.cssRules.length == 4, "Should have four rules!")
        
        
        //            "   h1 {                            " +
        //            "       background-color:#CCC;      " +
        //            "       border: 1px solid;          " +
        //            "       color:#39F;                 " +
        //            "       text-align: center;         " +
        //            "   }
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            XCTAssert(rule.type == CSSRuleType.style_rule, "Should have been a style rule")
            
            if let styleRule = rule as? CSSStyleRule {
                
                XCTAssert(styleRule.selectorText == "h1", "Wrong selector, expected \"h1\" received : \(styleRule.selectorText)")
                
                if let style = styleRule.style {
                    
                    // Validate background-color
                    if let backgroundColorValue = style.getPropertySringValue("background-color") {
                        
                        XCTAssert(backgroundColorValue == "#CCC", "Expected \"#CCC\" font-family value.")
                    }
                    else {
                        XCTAssert(false, "Expected a value for background-color.")
                    }
                    
                    if let borderValue = style.getCSSPropertyValueContainer("border") {
                        
                        
                        XCTAssert(false, "Should not have received value for border since it is not supported.")
                    }
                    
                    if let colorValue = style.getPropertySringValue("color") {
                        
                        XCTAssert(colorValue == "#39F", "Expected \"#39F\" font-family value.")
                    }
                    
                    if let textAlignValue = style.getPropertySringValue("text-align") {
                        
                        XCTAssert(textAlignValue == " center", "Expected \" center\" text-align value.")
                    }
                }
            }
            else {
                XCTAssert(false, "Should have been a style rule object type.")
            }
        }
        else {
            
            XCTAssert(false, "Should have a arule at index 0!")
        }
    }
    
    func testComplexComplexeSelectorCombinatorDescendant() {
        
        let cssString = String(
            "   h1,body>p {                    " +
            "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
            
        XCTAssert(cssStyleSheet.cssRules.length == 1, "Should have one rule!")
        
        
//            "   h1,body>p {                    " +
//                "       background-color:#CCC;      " +
//            "   }                               ")
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            XCTAssert(rule.type == CSSRuleType.style_rule, "Should have been a style rule")
            
            if let styleRule = rule as? CSSStyleRule {
                
                XCTAssert(styleRule.selectorText == "h1, body>p", "Wrong selector, expected \"h1,body>p\" received : \(styleRule.selectorText)")
                
                if let style = styleRule.style {
                    
                    if let backgroundColorValue = style.getPropertySringValue("background-color") {
                        XCTAssert(backgroundColorValue == "#CCC", "Expected \"#CCC\" font-family value.")
                    }
                    else {
                        XCTAssert(false, "Expected a value for background-color.")
                    }
                 }
            }
            else {
                XCTAssert(false, "Should have been a style rule object type.")
            }
            
        }
            
        else {
            
            XCTAssert(false, "Should have a arule at index 0!")
        }
        
    }

    func testComplexComplexeSelectorCombinatorSibling() {
        
        let cssString = String(
            "   h1,body+p {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        XCTAssert(cssStyleSheet.cssRules.length == 1, "Should have one rule!")
        
        
        //            "   h1,body>p {                    " +
        //                "       background-color:#CCC;      " +
        //            "   }                               ")
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            XCTAssert(rule.type == CSSRuleType.style_rule, "Should have been a style rule")
            
            if let styleRule = rule as? CSSStyleRule {
                
                XCTAssert(styleRule.selectorText == "h1, body+p", "Wrong selector, expected \"h1,body+p\" received : \(styleRule.selectorText)")
                
                if let style = styleRule.style {
                    
                    if let backgroundColorValue = style.getPropertySringValue("background-color") {
                        XCTAssert(backgroundColorValue == "#CCC", "Expected \"#CCC\" font-family value.")
                    }
                    else {
                        XCTAssert(false, "Expected a value for background-color.")
                    }
                }
            }
            else {
                XCTAssert(false, "Should have been a style rule object type.")
            }
            
        }
            
        else {
            
            XCTAssert(false, "Should have a arule at index 0!")
        }
        
    }

    func testComplexComplexeSelectorCombinatorSiblingAndClass() {
        
        let cssString = String(
            "   .className,body+p {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)

        if let rule = cssStyleSheet.cssRules.item(0) {

            if let styleRule = rule as? CSSStyleRule {
                
                XCTAssert(styleRule.selectorText == ".className, body+p", "Wrong selector, expected \".className,body+p\" received : \(styleRule.selectorText)")
                
                if let style = styleRule.style {
                    
                    if let backgroundColorValue = style.getPropertySringValue("background-color") {
                        XCTAssert(backgroundColorValue == "#CCC", "Expected \"#CCC\" font-family value.")
                    }
                    else {
                        XCTAssert(false, "Expected a value for background-color.")
                    }
                }
            }
            else {
                XCTAssert(false, "Should have been a style rule object type.")
            }
            
        }
            
        else {
            
            XCTAssert(false, "Should have a arule at index 0!")
        }
        
    }

    func testComplexComplexeSelectorCombinatorSiblingAndId() {
        
        let cssString = String(
            "   #id,body+p {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
            
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {
                
                XCTAssert(styleRule.selectorText == "#id, body+p", "Wrong selector, expected \"#id,body+p\" received : \(styleRule.selectorText)")
                
                if let style = styleRule.style {
                    
                    if let backgroundColorValue = style.getPropertySringValue("background-color") {
                        XCTAssert(backgroundColorValue == "#CCC", "Expected \"#CCC\" font-family value.")
                    }
                    else {
                        XCTAssert(false, "Expected a value for background-color.")
                    }
                }
            }
            else {
                XCTAssert(false, "Should have been a style rule object type.")
            }
        }
        else {
            XCTAssert(false, "Should have a arule at index 0!")
        }
    }

    func testPseudoSelector() {
        
        let cssString = String(
            "   body::tag {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as! NSString)
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)

        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {
                
                XCTAssert(styleRule.selectorText == "body::tag", "Wrong selector, expected \"body::tag\" received : \(styleRule.selectorText)")
                
            }
        }
    }
    
    
//    func testPseudoClass() {
//        
//        let cssString = String(
//            "   body:matches(:hover, :focus)  {                    " +
//                "       background-color:#CCC;      " +
//            "   }                               ")
//        
//         
//        
//        let reader = CSSReader(string: cssString)
//        
//        let parser = CSParser(reader: reader)
//        
//        let styleSheet = parser.parseStyleSheet()
//        
//        let cssOmCreatorVisitor = CSSOMCreatorVisitor()
//        
//        if let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet, href: "") {
//            
//            
//            if let rule = cssStyleSheet.cssRules.item(0) {
//                
//                if let styleRule = rule as? CSSStyleRule {
//                    
//                    XCTAssert(styleRule.selectorText == "body::matches(:hover, :focus) ", "Wrong selector, expected \"body::tag\" received : \(styleRule.selectorText)")
//                    
//                }
//            }
//            
//        }
//    }
    
    
    func testPerformanceSimpleCSS() {
        // This is an example of a performance test case.
        self.measure() {

            let cssString = " body { font-family: arial !important; } "
            
            let reader = CSSReader(sourceString: cssString as NSString)
            
            let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
            
            let styleSheet = parser.parseStyleSheet()
            
            let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
            
            let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        }
    }

}
