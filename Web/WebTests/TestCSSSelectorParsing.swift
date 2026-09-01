//
//  TestCSSSelectorParsing.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-05.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestCSSSelectorParsing: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDescendantSelector() {
        
        let cssString = String(
            "   body > p {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)

        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {
                
                debugPrint("styleRule: \(styleRule.cssText)")
                
                XCTAssert(styleRule.selectorList != nil, "selectorList is nil")
                if let selectorList = styleRule.selectorList {
                    
                    XCTAssert(!selectorList.isEmpty, "Selector list is empty")
                    XCTAssert(selectorList.count == 1, "Should have two compound selector")
                    XCTAssert(!(selectorList[0] is InvalidComplexSelector))
                    
                    let complexSelector = selectorList[0]!
                    
                    XCTAssert(complexSelector.compoundSelectorList.count == 2)
                    XCTAssert(complexSelector.combinatorList.count == 1)
                    
                    let compoundSelector = complexSelector.compoundSelectorList[0]
                    let firstSimpleSelector = compoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(firstSimpleSelector is TypeSelector)
                    if let typeSelector = firstSimpleSelector as? TypeSelector {
                        
                        let elementName = typeSelector.elementName
                            
                        XCTAssert(elementName.ident != nil)
                        if let ident = elementName.ident {
                            
                            XCTAssert(ident.identString == "body")
                            
                        }
                    }
                    
                    // combinator
                    let combinatorSelector = complexSelector.combinatorList[0]
                    XCTAssert(combinatorSelector.combinatorType == .GreaterThanSign)
                    
                    let secondCompoundSelector = complexSelector.compoundSelectorList[1]
                    let simpleSelector = secondCompoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(simpleSelector is TypeSelector)
                    if let typeSelector = simpleSelector as? TypeSelector {
                        
                        let elementName = typeSelector.elementName
                        
                        XCTAssert(elementName.ident != nil)
                        if let ident = elementName.ident {
                            
                            XCTAssert(ident.identString == "p")
                        }
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
    
    func testComplexSelectorCombinatorSiblingAndClass() {
        
        let cssString = String(
            "   body>p {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)

        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {

                debugPrint("styleRule: \(styleRule.cssText)")
                
                XCTAssert(styleRule.selectorList != nil, "selectorList is nil")
                if let selectorList = styleRule.selectorList {
                    
                    XCTAssert(!selectorList.isEmpty, "Selector list is empty")
                    XCTAssert(selectorList.count == 1, "Should have two compound selector")
                    XCTAssert(!(selectorList[0] is InvalidComplexSelector))
                    
                    let complexSelector = selectorList[0]!
                    
                    XCTAssert(complexSelector.compoundSelectorList.count == 2)
                    XCTAssert(complexSelector.combinatorList.count == 1)
                    
                    let compoundSelector = complexSelector.compoundSelectorList[0]
                    let firstSimpleSelector = compoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(firstSimpleSelector is TypeSelector)
                    if let typeSelector = firstSimpleSelector as? TypeSelector {
                        
                        let elementName = typeSelector.elementName
                        
                        XCTAssert(elementName.ident != nil)
                        if let ident = elementName.ident {
                            
                            XCTAssert(ident.identString == "body")
                            
                        }
                    }
                    
                    // combinator
                    let combinatorSelector = complexSelector.combinatorList[0]
                    XCTAssert(combinatorSelector.combinatorType == .GreaterThanSign)
                    
                    let secondCompoundSelector = complexSelector.compoundSelectorList[1]
                    let simpleSelector = secondCompoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(simpleSelector is TypeSelector)
                    if let typeSelector = simpleSelector as? TypeSelector {
                        
                        let elementName = typeSelector.elementName
                        
                        XCTAssert(elementName.ident != nil)
                        if let ident = elementName.ident {
                            
                            XCTAssert(ident.identString == "p")
                        }
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

    func testWrongNextSiblingSelector() {
        
        let cssString = String(
            "   + p, h1 {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {
                
                debugPrint("styleRule: \(styleRule.cssText)")
                
                // FIXME: needs to finish this test
                //                    XCTAssert(parserReport.messageHandler.numberOfErrorMessages() == 0, "Expected 0 error messages.")
                
                XCTAssert(styleRule.selectorList != nil, "selectorList is nil")
                if let selectorList = styleRule.selectorList {
                    
                    XCTAssert(!selectorList.isEmpty, "Selector list is empty")
                    XCTAssert(selectorList.count == 2, "Should have two compound selector")
                    
                    XCTAssert(selectorList[0] is InvalidComplexSelector)
                    XCTAssert(selectorList[1] is ComplexSelector)
                    
                    let complexSelector = selectorList[1]!
                    let compoundSelector = complexSelector.compoundSelectorList[0]
                    let firstSimpleSelector = compoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(firstSimpleSelector is TypeSelector)
                    if let typeSelector = firstSimpleSelector as? TypeSelector {
                        
                        let elementName = typeSelector.elementName
                        
                        XCTAssert(elementName.ident != nil)
                        if let ident = elementName.ident {
                            
                            XCTAssert(ident.identString == "h1")
                            
                        }
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
    
    func testBasicDescendantSelectorWithClassSelector() {
        
        let cssString = String(
            "p .test {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {
                
                debugPrint("styleRule: \(styleRule.cssText)")
                
                XCTAssert(styleRule.selectorList != nil, "selectorList is nil")
                if let selectorList = styleRule.selectorList {
                    
                    XCTAssert(!selectorList.isEmpty, "Selector list is empty")
                    XCTAssert(selectorList.count == 1, "Should have two compound selector")
                    XCTAssert(!(selectorList[0] is InvalidComplexSelector))
                    
                    let complexSelector = selectorList[0]!
                    
                    XCTAssert(complexSelector.compoundSelectorList.count == 2)
                    XCTAssert(complexSelector.combinatorList.count == 1)
                    
                    let compoundSelector = complexSelector.compoundSelectorList[0]
                    let firstSimpleSelector = compoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(firstSimpleSelector is TypeSelector)
                    if let typeSelector = firstSimpleSelector as? TypeSelector {
                        
                        let elementName = typeSelector.elementName
                        
                        XCTAssert(elementName.ident != nil)
                        if let ident = elementName.ident {
                            
                            XCTAssert(ident.identString == "p")
                            
                        }
                    }
                    
                    // combinator
                    let combinatorSelector = complexSelector.combinatorList[0]
                    XCTAssert(combinatorSelector.combinatorType == .Whitespace)
                    
                    // class selector
                    let secondCompoundSelector = complexSelector.compoundSelectorList[1]
                    let simpleSelector = secondCompoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(simpleSelector is ClassSelector)
                    if let classSelector = simpleSelector as? ClassSelector {
                        
                        XCTAssert(classSelector.className == "test")
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
    
    
    
    func testSimpleSelectorSequence() {
        
        let cssString = String(
            "[nw-message-id].error {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {
                
                debugPrint("styleRule: \(styleRule.cssText)")
                
                // FIXME: needs to finish this test
                //                    XCTAssert(parserReport.messageHandler.numberOfErrorMessages() == 0, "Expected 0 error messages.")
                
                XCTAssert(styleRule.selectorList != nil, "selectorList is nil")
                if let selectorList = styleRule.selectorList {
                    
                    XCTAssert(!selectorList.isEmpty, "Selector list is empty")
                    XCTAssert(selectorList.count == 1, "Should have two compound selector")
                    XCTAssert(!(selectorList[0] is InvalidComplexSelector))
                    
                    let complexSelector = selectorList[0]
                    let compoundSelector = complexSelector!.compoundSelectorList[0]
                    let firstSimpleSelector = compoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(firstSimpleSelector is AttribSelector)
                    if let attribSelector = firstSimpleSelector as? AttribSelector {
                        
                        XCTAssert(attribSelector.attribName != nil)
                        if let attribName = attribSelector.attribName {
                            
                            XCTAssert(attribName.ident != nil)
                            if let ident = attribName.ident {
                                
                                XCTAssert(ident.identString == "nw-message-id")
                                
                            }
                        }
                        
                        XCTAssert(attribSelector.attribFlags == nil)
                        XCTAssert(attribSelector.attribValue == nil)
                        XCTAssert(attribSelector.attribMatch == nil)
                        XCTAssert(attribSelector.rightSquareBraquetToken != nil)
                    }
                    
                    let secondSimpleSelector = compoundSelector.simpleSelectorSequence[1]
                    
                    XCTAssert(secondSimpleSelector is ClassSelector)
                    if let classSelector = secondSimpleSelector as? ClassSelector {
                        
                        XCTAssert(classSelector.className == "error")
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
    
    
    func testErrorSimpleSelectorSequence1() {
        
        let cssString = String(
            "[nw-message-id]error {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {
                
                debugPrint("styleRule: \(styleRule.cssText)")
                
                // FIXME: needs to finish this test
                //                    XCTAssert(parserReport.messageHandler.numberOfErrorMessages() == 0, "Expected 0 error messages.")
                
                XCTAssert(styleRule.selectorList != nil, "selectorList is nil")
                if let selectorList = styleRule.selectorList {
                    
                    XCTAssert(!selectorList.isEmpty, "Selector list is empty")
                    XCTAssert(selectorList.count == 1, "Should have two compound selector")
                    XCTAssert(selectorList[0] is InvalidComplexSelector)
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
    
    
    func testPseudoElementParsing() {
        
        let cssString = String(
            "   body::first-letter {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {
                
                debugPrint("styleRule: \(styleRule.cssText)")
                
                XCTAssert(styleRule.selectorList != nil, "selectorList is nil")
                if let selectorList = styleRule.selectorList {
                    
                    XCTAssert(!selectorList.isEmpty, "Selector list is empty")
                    XCTAssert(selectorList.count == 1, "Should have two compound selector")
                    XCTAssert(!(selectorList[0] is InvalidComplexSelector))
                    
                    let complexSelector = selectorList[0]!
                    
                    XCTAssert(complexSelector.compoundSelectorList.count == 1)
                    XCTAssert(complexSelector.combinatorList.count == 0)
                    
                    let compoundSelector = complexSelector.compoundSelectorList[0]
                    let firstSimpleSelector = compoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(firstSimpleSelector is TypeSelector)
                    if let typeSelector = firstSimpleSelector as? TypeSelector {
                        
                        let elementName = typeSelector.elementName
                        
                        XCTAssert(elementName.ident != nil)
                        if let ident = elementName.ident {
                            
                            XCTAssert(ident.identString == "body")
                            
                        }
                    }
                    
                    // pseudo-element selector
                    let secondSimpleSelector = compoundSelector.simpleSelectorSequence[1]
                    
                    XCTAssert(secondSimpleSelector is PseudoElementSelector)
                    if let pseudoElementSelector = secondSimpleSelector as? PseudoElementSelector {
                        
                        let ident = pseudoElementSelector.ident
                        XCTAssert(ident.identString == "first-letter")
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
    
    func testPseudoClassParsing() {
        
        let cssString = String(
            "   body:first-letter {                    " +
                "       background-color:#CCC;      " +
            "   }                               ")
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        if let rule = cssStyleSheet.cssRules.item(0) {
            
            if let styleRule = rule as? CSSStyleRule {
                
                debugPrint("styleRule: \(styleRule.cssText)")
                
                XCTAssert(styleRule.selectorList != nil, "selectorList is nil")
                if let selectorList = styleRule.selectorList {
                    
                    XCTAssert(!selectorList.isEmpty, "Selector list is empty")
                    XCTAssert(selectorList.count == 1, "Should have two compound selector")
                    XCTAssert(!(selectorList[0] is InvalidComplexSelector))
                    
                    let complexSelector = selectorList[0]!
                    
                    XCTAssert(complexSelector.compoundSelectorList.count == 1)
                    XCTAssert(complexSelector.combinatorList.count == 0)
                    
                    let compoundSelector = complexSelector.compoundSelectorList[0]
                    let firstSimpleSelector = compoundSelector.simpleSelectorSequence[0]
                    
                    XCTAssert(firstSimpleSelector is TypeSelector)
                    if let typeSelector = firstSimpleSelector as? TypeSelector {
                        
                        let elementName = typeSelector.elementName
                        
                        XCTAssert(elementName.ident != nil)
                        if let ident = elementName.ident {
                            
                            XCTAssert(ident.identString == "body")
                            
                        }
                    }
                    
                    // pseudo-element selector
                    let secondSimpleSelector = compoundSelector.simpleSelectorSequence[1]
                    
                    XCTAssert(secondSimpleSelector is IdentPseudoClass)
                    if let pseudoClassSelector = secondSimpleSelector as? IdentPseudoClass {
                        
                        let ident = pseudoClassSelector.ident
                        XCTAssert(ident.identString == "first-letter")
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
    
}
