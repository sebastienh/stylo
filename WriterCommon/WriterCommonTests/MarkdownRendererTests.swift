//
//  RendererTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-07-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest

@testable import WriterCommon
import Markdown
import Web
import Common
import os
import Igloo

class MarkdownRendererTests: MarkdownStylingDocumentStoreTests {
    
    func createInitialContext(markdownString: String, styleString: String) -> MarkdownRendererContext {
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(authorStylesheetString: styleString)
        
        let markdownStyleStore = compileMarkdown(fromSourceString: markdownString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        return MarkdownRendererContext(string: markdownString, dispatcher: dispatcher, markdownDocumentStore: markdownDocumentStore, markdownStyleStore: markdownStyleStore)
    }

    func createInitialContext(markdownFilename: String, stylesheetsName: [String]) -> MarkdownRendererContext {
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = self.createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilenames: stylesheetsName)
        
        let url = urlOfFile(named: markdownFilename)!
        let markdownString = contentOfFile(at: url)
        
        let markdownStyleStore = compileMarkdown(fromSourceString: markdownString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        return MarkdownRendererContext(string: markdownString, dispatcher: dispatcher, markdownDocumentStore: markdownDocumentStore, markdownStyleStore: markdownStyleStore)
    }
    
    
    func createDocumentContext(markdownFilename: String, stylesheetsName: [String]) -> MarkdownRendererContext {
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = self.createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilenames: stylesheetsName)
        
        let url = urlOfFile(named: markdownFilename)!
        let markdownString = contentOfFile(at: url)
        
        let markdownStyleStore = compileMarkdown(fromSourceString: markdownString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        return MarkdownRendererContext(string: markdownString, dispatcher: dispatcher, markdownDocumentStore: markdownDocumentStore, markdownStyleStore: markdownStyleStore)
        
    }
    
    
    func applyFocus(inRange range: NSRange, context: MarkdownRendererContext) -> NSAttributedString {
        
        fatalError()
        
    }
    

    func validateFocusColor(in markdownContext: MarkdownRendererContext, range: NSRange, color: NSColor, failedClosure: (NSColor, NSColor, Int) -> ()) {
        for i in range.location..<range.upperBound {
            if let char = markdownContext.attributedString.string.charAt(i), !UnicodeWhitespace.isUnicodeWhitespace(char) {
                validateFocusColor(in: markdownContext, index: i, color: color, failedClosure: failedClosure)
            }
        }
    }
    
    func validateFocusColor(in markdownContext: MarkdownRendererContext, index: Int, color: NSColor, failedClosure: (NSColor, NSColor, Int) -> ()) {
        
        let validationResult = WriterCommonTests.validateColor(in: markdownContext.focusString, at: index, expected: color)
        
        switch validationResult {
        case .error(let receivedColor):
            failedClosure(color, receivedColor, index)
        case .success:
            break
        }
    }
    
}
