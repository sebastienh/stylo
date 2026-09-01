//
//  CssRendererTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-12-31.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Web
import Common
import os
import Igloo

class CssRendererTests: RendererTests {
    
    
    func createDispatcher() -> StylesheetDocumentDispatcher {
        
        return StylesheetDocumentDispatcher(state: StylesheetDocumentState())
    }
    
    func createStylesheetDocumentStore() -> StylesheetDocumentStore {
        
        return StylesheetDocumentStore(origin: .author, appearances: [.dark, .light])
    }
    
    func loadMarkdownDocumentStore(filename: String, store: MarkdownDocumentStore, dispatcher: Dispatcher) {
        
        let url = urlOfFile(named: filename)
        
        XCTAssert(url != nil)
        if let url = url {
            let loadAction = EditableStoreActionsFactory.loadStringAction(url: url)
            dispatcher.sync(store: store, action: loadAction)
        }
    }
    
    func contentOfFile(at url: URL) -> String {
        
        return try! String(contentsOf: url)
    }
    
    func createInitialContext(cssString: String, styleString: String) -> CssRendererContext {
        
        let dispatcher = createDispatcher()
        let stylesheetDocumentStore = createStylesheetDocumentStore()
        dispatcher.register(store: stylesheetDocumentStore)
        
        let style = WriterCommonTests.createStyle(authorStylesheetString: styleString)
        
        let stylehseetStyleStore = WriterCommonTests.compileStylesheet(fromSourceString: cssString, in: stylesheetDocumentStore, dispatcher: dispatcher, with: style)!
        
        return CssRendererContext(string: cssString, dispatcher: dispatcher, stylesheetDocumentStore: stylesheetDocumentStore, stylesheetStyleStore: stylehseetStyleStore)
    }

    func createInitialContext(markdownFilename: String, stylesheetsName: [String]) -> CssRendererContext {
        
        let dispatcher = createDispatcher()
        let stylesheetDocumentStore = createStylesheetDocumentStore()
        dispatcher.register(store: stylesheetDocumentStore)
        
        let style = WriterCommonTests.createStyle(fromUa: "markdown-ua.css", authors: stylesheetsName)
        
        let url = urlOfFile(named: markdownFilename)!
        let markdownString = contentOfFile(at: url)
        
        let markdownStyleStore = WriterCommonTests.compileStylesheet(fromSourceString: markdownString, in: stylesheetDocumentStore, dispatcher: dispatcher, with: style)!
        
        return CssRendererContext(string: markdownString, dispatcher: dispatcher, stylesheetDocumentStore: stylesheetDocumentStore, stylesheetStyleStore: markdownStyleStore)
    }
    
    
    func createDocumentContext(markdownFilename: String, stylesheetsName: [String]) -> CssRendererContext {
        
        let dispatcher = createDispatcher()
        let stylesheetDocumentStore = createStylesheetDocumentStore()
        dispatcher.register(store: stylesheetDocumentStore)
        
        let style = WriterCommonTests.createStyle(fromUa: "markdown-ua.css", authors: stylesheetsName)
        
        let url = urlOfFile(named: markdownFilename)!
        let markdownString = contentOfFile(at: url)
        
        let markdownStyleStore = WriterCommonTests.compileStylesheet(fromSourceString: markdownString, in: stylesheetDocumentStore, dispatcher: dispatcher, with: style)!
        
        return CssRendererContext(string: markdownString, dispatcher: dispatcher, stylesheetDocumentStore: stylesheetDocumentStore, stylesheetStyleStore: markdownStyleStore)
    }
    
    func applyFocus(inRange range: NSRange, context: CssRendererContext) -> NSAttributedString {
        
        fatalError()
        
    }


}
