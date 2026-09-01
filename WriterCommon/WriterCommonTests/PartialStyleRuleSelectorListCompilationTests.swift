//
//  PartialStyleRuleSelectorListCompilationTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2021-01-06.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Common

class PartialStyleRuleSelectorListCompilationTests: StylesheetDocumentStoreTests {
    
    func testEditSelectorsListOnyEditedSelectors1() throws {
        
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
        
        let onlyEditedSelectors = stylesheet.onlyEditedSelectors(ruleIndex: 0, description: description)
        
        XCTAssert(!onlyEditedSelectors, "Error")
    }

    func testEditSelectorsListOnyEditedSelectors2() throws {
        
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
        
        let description = SourceStringChangeDescription(range: NSMakeRange(3, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusively inside: \(rulesAdjacency)")
        
        let onlyEditedSelectors = stylesheet.onlyEditedSelectors(ruleIndex: 0, description: description)
        
        XCTAssert(onlyEditedSelectors, "Error")
    }
    
    func testEditSelectorsListOnyEditedSelectors3() throws {
        
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
        
        let description = SourceStringChangeDescription(range: NSMakeRange(4, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusively inside: \(rulesAdjacency)")
        
        let onlyEditedSelectors = stylesheet.onlyEditedSelectors(ruleIndex: 0, description: description)
        
        XCTAssert(onlyEditedSelectors, "Error")
    }
    
    func testEditSelectorsListOnyEditedSelectors4() throws {
        
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
        
        let description = SourceStringChangeDescription(range: NSMakeRange(5, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusively inside: \(rulesAdjacency)")
        
        let onlyEditedSelectors = stylesheet.onlyEditedSelectors(ruleIndex: 0, description: description)
        
        XCTAssert(onlyEditedSelectors, "Error")
    }
    
    func testEditSelectorsListOnyEditedSelectors5() throws {
        
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
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 0), stringReplacement: "e", changeLength: 1, targetString: string)
        
        guard let rulesAdjacency = stylesheet.rulesAdjacency(description.range) else {
            XCTAssert(false, "Error: rulesAdjacency is nil")
            return
        }
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusively inside: \(rulesAdjacency)")
        
        let onlyEditedSelectors = stylesheet.onlyEditedSelectors(ruleIndex: 0, description: description)
        
        XCTAssert(onlyEditedSelectors, "Error")
    }
    
    func testEditSelectorsListOnyEditedSelectors6() throws {
        
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
        
        XCTAssert(rulesAdjacency == .exclusivelyInside(index: 0), "Not exclusively inside: \(rulesAdjacency)")
        
        let onlyEditedSelectors = stylesheet.onlyEditedSelectors(ruleIndex: 0, description: description)
        
        XCTAssert(!onlyEditedSelectors, "Error")
    }
}
