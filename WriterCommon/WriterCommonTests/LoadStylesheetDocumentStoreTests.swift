//
//  LoadStylesheetDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-06-08.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Igloo
import Web
@testable import WriterCommon

class LoadStylesheetDocumentStoreTests: StylesheetDocumentStoreTests {

    func testSimpleLoadString() {
        
        let filename = "simple.css"
        
        let dispatcher = createDispatcher()
        let stylesheetDocumentStore = createStylesheetDocumentStore(origin: .userAgent)
        dispatcher.register(store: stylesheetDocumentStore)
        
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
            }
        }
    }

    func testLoadStylesheet() {
        
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
                
                let stylesheetStyleStore = StylesheetStyleStore(string: loadedString!, focusMode: .disabled, resourceComputedStyle: resourceComputedStyle)
                
                // apply the style
                let applyStyleAction = StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: document, isFirstResponder: true, selectedRange: NSMakeRange(0, 0))
                dispatcher.sync(store: stylesheetStyleStore, action: applyStyleAction.syncAction)
            }
        }
    }

}
