//
//  ApplyStyleStylesheetDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-06-08.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Igloo
@testable import WriterCommon

class ApplyStyleStylesheetDocumentStoreTests: StylesheetDocumentStoreTests {

    func testApplyStyle() {
        
        // load first
        let filename = "simple.css"
        
        let dispatcher = createDispatcher()
        let stylesheetDocumentStore = createStylesheetDocumentStore(origin: .userAgent)
        dispatcher.register(store: stylesheetDocumentStore)
        
        let style = createBasicStyle()
        let url = urlOfFile(named: filename)
        
        
        XCTAssert(url != nil)
        if let url = url {
            let loadAction = EditableStoreActionsFactory.loadStringAction(url: url)
            let result = dispatcher.sync(store: stylesheetDocumentStore, action: loadAction)
            
            XCTAssert(result is EditableActionResult)
            
            if let editableActionResult = result as? EditableActionResult {
                
                let loadedString = editableActionResult.loadedString
                XCTAssert(loadedString != nil)
                XCTAssert(loadedString! == contentOfFile(at: url))
                
                // compile first stylesheet
                let createStylesheetAction = StylesheetDocumentAction.createInitialStylesheet(source: loadedString!).syncAction
                let result = dispatcher.sync(store: stylesheetDocumentStore, action: createStylesheetAction)
                
                XCTAssert(result != nil)
                if let result = result {
                    
                    XCTAssert(result is StylesheetDocumentResult)
                    if let stylesheetDocumentResult = result as? StylesheetDocumentResult {
                        
                        let stylesheet = stylesheetDocumentResult.stylesheet
                        XCTAssert(stylesheet != nil)
                    }
                }
                
                let document = stylesheetDocumentStore.document.value!
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let stylesheetStyleStore = StylesheetStyleStore(string: loadedString!, focusMode: .disabled, resourceComputedStyle: resourceComputedStyle, highlightSelectors: nil)
                
                // apply the style
                dispatcher.sync(store: stylesheetStyleStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: document, isFirstResponder: true, selectedRange: NSMakeRange(0, 0)).syncAction)
            }
        }
    }

    func testCssStylingPerformance() {
        
        guard let context: CssContext = self.prepareCssContext(fromFileWithName: "common-colors.css", uaStylesheet: "css-ua-2.css", authorStylesheets: ["common-source.css", "source-dark.css"]) else {
            XCTAssert(false)
            return
        }
        
        self.measure {
            
            let resourceComputedStyle = ResourceComputedStyle(styleDefinition: context.style)
            
            let stylesheetStyleStore = StylesheetStyleStore(string: context.loadedString, focusMode: .disabled, resourceComputedStyle: resourceComputedStyle, highlightSelectors: nil)
            
            // apply the style
            context.dispatcher.sync(store: stylesheetStyleStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: context.document, isFirstResponder: true, selectedRange: NSMakeRange(0, 0)).syncAction)
        }
    }
    
}
