//
//  PartialStyleRuleStyleDeclarationCompilationTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2021-01-06.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Common

class PartialStyleRuleStyleDeclarationCompilationTests: StylesheetDocumentStoreTests {

    func testEditStyleRule1() throws {
        
        guard let context: CssContext = self.prepareCssContext(fromFileWithName: "common-colors.css", uaStylesheet: "css-ua-2.css", authorStylesheets: ["common-source.css", "source-dark.css"]) else {
            XCTAssert(false)
            return
        }
        
        let store = context.stylesheetDocumentStore
        
        // get the style rules range associated with the changeIndex
        // Note: the range is excluding the last index.
        
        guard let stylesheet = store.stylesheet.value else {
            XCTAssert(false, "stylesheet is nil")
            return
        }
        
        guard let string = store.sourceString.value else {
            XCTAssert(false, "string is nil")
            return
        }
        
        let description = SourceStringChangeDescription(range: NSMakeRange(2, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .start, "Not at start: \(rulesAdjacency)")
        
        let onlyEditedDeclarations = stylesheet.onlyEditedDeclarations(ruleIndex: 0, description: description)
        
        XCTAssert(!onlyEditedDeclarations, "Error")
    }

    func testEditStyleRule2() throws {
        
        guard let context: CssContext = self.prepareCssContext(fromFileWithName: "common-colors.css", uaStylesheet: "css-ua-2.css", authorStylesheets: ["common-source.css", "source-dark.css"]) else {
            XCTAssert(false)
            return
        }
        
        let store = context.stylesheetDocumentStore
        
        // get the style rules range associated with the changeIndex
        // Note: the range is excluding the last index.
        
        guard let stylesheet = store.stylesheet.value else {
            XCTAssert(false, "stylesheet is nil")
            return
        }
        
        guard let string = store.sourceString.value else {
            XCTAssert(false, "string is nil")
            return
        }
        
        let description = SourceStringChangeDescription(range: NSMakeRange(7, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusivelyInside: \(rulesAdjacency)")
        
        let onlyEditedDeclarations = stylesheet.onlyEditedDeclarations(ruleIndex: 0, description: description)
        
        XCTAssert(!onlyEditedDeclarations, "Error")
    }
    
    
    func testEditStyleRule3() throws {
        
        guard let context: CssContext = self.prepareCssContext(fromFileWithName: "common-colors.css", uaStylesheet: "css-ua-2.css", authorStylesheets: ["common-source.css", "source-dark.css"]) else {
            XCTAssert(false)
            return
        }
        
        let store = context.stylesheetDocumentStore
        
        // get the style rules range associated with the changeIndex
        // Note: the range is excluding the last index.
        
        guard let stylesheet = store.stylesheet.value else {
            XCTAssert(false, "stylesheet is nil")
            return
        }
        
        guard let string = store.sourceString.value else {
            XCTAssert(false, "string is nil")
            return
        }
        
        let description = SourceStringChangeDescription(range: NSMakeRange(8, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusivelyInside: \(rulesAdjacency)")
        
        let onlyEditedDeclarations = stylesheet.onlyEditedDeclarations(ruleIndex: 0, description: description)
        
        XCTAssert(!onlyEditedDeclarations, "Error")
    }
    
    // insert after opening curly brace
    func testEditStyleRule4() throws {
        
        guard let context: CssContext = self.prepareCssContext(fromFileWithName: "common-colors.css", uaStylesheet: "css-ua-2.css", authorStylesheets: ["common-source.css", "source-dark.css"]) else {
            XCTAssert(false)
            return
        }
        
        let store = context.stylesheetDocumentStore
        
        // get the style rules range associated with the changeIndex
        // Note: the range is excluding the last index.
        
        guard let stylesheet = store.stylesheet.value else {
            XCTAssert(false, "stylesheet is nil")
            return
        }
        
        guard let string = store.sourceString.value else {
            XCTAssert(false, "string is nil")
            return
        }
        
        let description = SourceStringChangeDescription(range: NSMakeRange(9, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusivelyInside: \(rulesAdjacency)")
        
        let onlyEditedDeclarations = stylesheet.onlyEditedDeclarations(ruleIndex: 0, description: description)
        
        XCTAssert(onlyEditedDeclarations, "Error")
    }
    
    // insert inside styles rules
    func testEditStyleRule5() throws {
        
        guard let context: CssContext = self.prepareCssContext(fromFileWithName: "common-colors.css", uaStylesheet: "css-ua-2.css", authorStylesheets: ["common-source.css", "source-dark.css"]) else {
            XCTAssert(false)
            return
        }
        
        let store = context.stylesheetDocumentStore
        
        // get the style rules range associated with the changeIndex
        // Note: the range is excluding the last index.
        
        guard let stylesheet = store.stylesheet.value else {
            XCTAssert(false, "stylesheet is nil")
            return
        }
        
        guard let string = store.sourceString.value else {
            XCTAssert(false, "string is nil")
            return
        }
        
        let description = SourceStringChangeDescription(range: NSMakeRange(50, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusivelyInside: \(rulesAdjacency)")
        
        let onlyEditedDeclarations = stylesheet.onlyEditedDeclarations(ruleIndex: 0, description: description)
        
        XCTAssert(onlyEditedDeclarations, "Error")
    }
    
    // insert before last curly brace
    func testEditStyleRule6() throws {
        
        guard let context: CssContext = self.prepareCssContext(fromFileWithName: "test-9.css", uaStylesheet: "css-ua-2.css", authorStylesheets: ["common-source.css", "source-dark.css"]) else {
            XCTAssert(false)
            return
        }
        
        let store = context.stylesheetDocumentStore
        
        // get the style rules range associated with the changeIndex
        // Note: the range is excluding the last index.
        
        guard let stylesheet = store.stylesheet.value else {
            XCTAssert(false, "stylesheet is nil")
            return
        }
        
        guard let string = store.sourceString.value else {
            XCTAssert(false, "string is nil")
            return
        }
        
        let description = SourceStringChangeDescription(range: NSMakeRange(24, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusivelyInside: \(rulesAdjacency)")
        
        let onlyEditedDeclarations = stylesheet.onlyEditedDeclarations(ruleIndex: 0, description: description)
        
        XCTAssert(onlyEditedDeclarations, "Error")
    }
    
    // insert after last curly brace
    func testEditStyleRule7() throws {
        
        guard let context: CssContext = self.prepareCssContext(fromFileWithName: "test-9.css", uaStylesheet: "css-ua-2.css", authorStylesheets: ["common-source.css", "source-dark.css"]) else {
            XCTAssert(false)
            return
        }
        
        let store = context.stylesheetDocumentStore
        
        // get the style rules range associated with the changeIndex
        // Note: the range is excluding the last index.
        
        guard let stylesheet = store.stylesheet.value else {
            XCTAssert(false, "stylesheet is nil")
            return
        }
        
        guard let string = store.sourceString.value else {
            XCTAssert(false, "string is nil")
            return
        }
        
        let description = SourceStringChangeDescription(range: NSMakeRange(25, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .end, "Not end: \(rulesAdjacency)")
        
        let onlyEditedDeclarations = stylesheet.onlyEditedDeclarations(ruleIndex: 0, description: description)
        
        XCTAssert(!onlyEditedDeclarations, "Error")
    }
    
}


