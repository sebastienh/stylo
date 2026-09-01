//
//  ConcurentRendererTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-09-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Web
import Common
import os

class ConcurentRendererTests: MarkdownDocumentStoreTests {
    
    struct MarkdownTestContext {
        
        var string: String
        let dispatcher: MarkdownDocumentDispatcher
        let markdownDocumentStore: MarkdownDocumentStore
        
        
    }
    
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFastAndSlowSameAttributesOrder1() throws {
        
        let stylesheetsName: [String] = [
            "highlight-common.css",
            "highlight-colors-selectors.css",
            "highlight-source-dark.css"
        ]
        
        let markdownString: String = "\n\n# header\n\n"
        
        let context = self.createInitialContext(markdownString: markdownString)
        
        let style = self.createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilenames: stylesheetsName)
        
        let document = context.markdownDocumentStore.document.value as! HtmlDocument
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let styleAssemblyStore = MarkdownStyleStore(string: context.string, focusMode: .disabled, resourceComputedStyle: resourceComputedStyle)
        
        let filterContext = FilterContext()
        
        styleAssemblyStore.resourceComputedStyle.computeElementsStyles(document: document, filterContext: filterContext)
        
        let stylableString = AttributedStringChangeRecorder(string: context.string)
        let renderingContext = RenderingContext(contentString: stylableString, renderingType: .complete, filterContext: filterContext)
        let domRenderer = MarkdownRenderer(resourceComputedStyle: styleAssemblyStore.resourceComputedStyle, renderingContext: renderingContext, document: document)
        
        
        let elements = document.body.children.elements
        
        let processingResult = domRenderer.process(elements: elements, deletedNodes: nil)
        
        //        print("processingResult: \(processingResult)")
        
        let concurentStylableString = AttributedStringChangeRecorder(string: context.string)
        let concurentRenderingContext = RenderingContext(contentString: concurentStylableString, renderingType: .complete, filterContext: filterContext)
        let concurentDomRenderer = MarkdownConcurentRenderer(resourceComputedStyle: styleAssemblyStore.resourceComputedStyle, renderingContext: concurentRenderingContext, document: document)
        
        let concurentProcessingResult = concurentDomRenderer.process(elements: elements, deletedNodes: nil)
        
        XCTAssert(concurentStylableString.attributedString.isEqual(to: stylableString.attributedString))
        
        XCTAssert(processingResult.attributes[.delete]?.count == 1)
        XCTAssert(concurentProcessingResult.attributes[.delete]?.count == 1, "Expected 1, received: \(String(describing: concurentProcessingResult.attributes[.delete]?.count))")
        
        let deteteValue = processingResult.attributes[.delete]?.first?.attributes[StyloAttribute.headingTagBefore.key] as! Bool
        
        XCTAssert(deteteValue == true)
        
        let concurentDeleteValue = concurentProcessingResult.attributes[.delete]?.first?.attributes[StyloAttribute.headingTagBefore.key] as! Bool
        
        XCTAssert(concurentDeleteValue == true)
        
        
        if processingResult != concurentProcessingResult {
            RenderingProcessingResult.displayDifference(lhs: processingResult, rhs: concurentProcessingResult)
            XCTAssert(false)
        }
        else {
            XCTAssert(true)
        }
    }
    
    
    func testFastAndSlowSameAttributesOrder2() throws {
        
        let stylesheetsName: [String] = [
            "highlight-common.css",
            "highlight-colors-selectors.css",
            "highlight-source-dark.css"
        ]
        
        let markdownString: String = "\n\n# header **test**\n\n"
        
        let context = self.createInitialContext(markdownString: markdownString)
        
        let style = self.createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilenames: stylesheetsName)
        
        let document = context.markdownDocumentStore.document.value as! HtmlDocument
        let resourcComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let styleAssemblyStore = MarkdownStyleStore(string: context.string, focusMode: .disabled, resourceComputedStyle: resourcComputedStyle)
        
        let filterContext = FilterContext()
        
        styleAssemblyStore.resourceComputedStyle.computeElementsStyles(document: document, filterContext: filterContext)
        
        let stylableString = AttributedStringChangeRecorder(string: context.string)
        let renderingContext = RenderingContext(contentString: stylableString, renderingType: .complete, filterContext: filterContext)
        let domRenderer = MarkdownRenderer(resourceComputedStyle: styleAssemblyStore.resourceComputedStyle, renderingContext: renderingContext, document: document)
        
        
        let elements = document.body.children.elements
        
        let processingResult = domRenderer.process(elements: elements, deletedNodes: nil)
        
        //        print("processingResult: \(processingResult)")
        
        let concurentStylableString = AttributedStringChangeRecorder(string: context.string)
        let concurentRenderingContext = RenderingContext(contentString: concurentStylableString, renderingType: .complete, filterContext: filterContext)
        let concurentDomRenderer = MarkdownConcurentRenderer(resourceComputedStyle: styleAssemblyStore.resourceComputedStyle, renderingContext: concurentRenderingContext, document: document)
        
        let concurentProcessingResult = concurentDomRenderer.process(elements: elements, deletedNodes: nil)
        
        XCTAssert(concurentStylableString.attributedString.isEqual(to: stylableString.attributedString))
        
        
        XCTAssert(processingResult.attributes[.delete]?.count == 1)
        XCTAssert(concurentProcessingResult.attributes[.delete]?.count == 1, "Expected 1, received: \(String(describing: concurentProcessingResult.attributes[.delete]?.count))")
        
        let deteteValue = processingResult.attributes[.delete]?.first?.attributes[StyloAttribute.headingTagBefore.key] as! Bool
        
        XCTAssert(deteteValue == true)
        
        let concurentDeleteValue = concurentProcessingResult.attributes[.delete]?.first?.attributes[StyloAttribute.headingTagBefore.key] as! Bool
        
        XCTAssert(concurentDeleteValue == true)
        
        
        if processingResult != concurentProcessingResult {
            RenderingProcessingResult.displayDifference(lhs: processingResult, rhs: concurentProcessingResult)
            XCTAssert(false)
        }
        else {
            XCTAssert(true)
        }
    }
    
    // ERROR: THIS TEST CAN NOT PASS BECAUSE WE REMOVED THREAD SAFETY TO AttributesRecorded.
//    func testFastAndSlowSameAttributesOrder3() throws {
//        
//        let stylesheetsName: [String] = [
//            "highlight-common.css",
//            "highlight-colors-selectors.css",
//            "highlight-source-dark.css"
//        ]
//        
//        let context = self.createInitialContext(markdownFilename: "highlight-md-test-1.md")
//        
//        let style = self.createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilenames: stylesheetsName)
//        
//        let document = context.markdownDocumentStore.document.value as! HtmlDocument
//        
//        let styleAssemblyStore = MarkdownStyleStore(string: context.string, styleValue: style, document: document, focusMode: .disabled)
//        
//        let filterContext = FilterContext()
//        
//        styleAssemblyStore.resourceComputedStyle.computeElementsStyles(filterContext: filterContext)
//        
//        let stylableString = AttributedStringChangeRecorder(string: context.string)
//        let renderingContext = RenderingContext(contentString: stylableString, renderingType: .complete, filterContext: filterContext)
//        let domRenderer = MarkdownRenderer(resourceComputedStyle: styleAssemblyStore.resourceComputedStyle, renderingContext: renderingContext, document: document)
//        
//        
//        let elements = document.body.children.elements
//        
//        let processingResult = domRenderer.process(elements: elements, deletedNodes: nil)
//        
//        //        print("processingResult: \(processingResult)")
//        
//        let concurentStylableString = AttributedStringChangeRecorder(string: context.string)
//        let concurentRenderingContext = RenderingContext(contentString: concurentStylableString, renderingType: .complete, filterContext: filterContext)
//        let concurentDomRenderer = MarkdownConcurentRenderer(resourceComputedStyle: styleAssemblyStore.resourceComputedStyle, renderingContext: concurentRenderingContext, document: document)
//        
//        let concurentProcessingResult = concurentDomRenderer.process(elements: elements, deletedNodes: nil)
//        
//        XCTAssert(concurentStylableString.attributedString.isEqual(to: stylableString.attributedString))
//        
//        if processingResult != concurentProcessingResult {
//            RenderingProcessingResult.displayDifference(lhs: processingResult, rhs: concurentProcessingResult)
//            XCTAssert(false)
//        }
//        else {
//            XCTAssert(true)
//        }
//    }
    
    
    func createInitialContext(markdownFilename: String) -> MarkdownTestContext {
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        
        
        let url = urlOfFile(named: markdownFilename)!
        let markdownString = contentOfFile(at: url)
        
        compileMarkdown(fromSourceString: markdownString, in: markdownDocumentStore, dispatcher: dispatcher)
        
        return MarkdownTestContext(string: markdownString, dispatcher: dispatcher, markdownDocumentStore: markdownDocumentStore)
    }
    
    func createInitialContext(markdownString: String) -> MarkdownTestContext {
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        compileMarkdown(fromSourceString: markdownString, in: markdownDocumentStore, dispatcher: dispatcher)
        
        return MarkdownTestContext(string: markdownString, dispatcher: dispatcher, markdownDocumentStore: markdownDocumentStore)
    }
    
    private func applyAttributes(using document: Document, and resourceComputedStyle: ResourceComputedStyle, to string: String, stringChange: SourceStringChangeDescription?) -> NSAttributedString {
        
        let stylableString = AttributedStringChangeRecorder(string: string)
        
        let renderingContext = RenderingContext(contentString: stylableString, renderingType: .edit, filterContext: FilterContext())
        let domRenderer = MarkdownRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: document as! HtmlDocument)
        domRenderer.process(document)
        
        return stylableString.attributedString
    }
    
    private func compileMarkdown(fromSourceString loadedString: String, in store: MarkdownDocumentStore, dispatcher: MarkdownDocumentDispatcher)  {
        
        let description = SourceStringChangeDescription(string: loadedString, originalString: nil)
        dispatcher.sync(store: store, action: EditableStoreAction.setString(string: loadedString).syncAction)
        let result = dispatcher.sync(store: store, action: DocumentStoreAction.compileInitialDocument(description: description).syncAction)
        
        guard let documentStoreActionResult = result as? DocumentStoreActionResult else {
            XCTAssert(false, "result is not DocumentStoreActionResult")
            return
        }
        
        guard let lastCompiledDocument = documentStoreActionResult.lastCompiledDocument else {
            XCTAssert(false, "lastCompiledDocument is nil")
            return
        }
        
        XCTAssert(store.markdownTokens != nil)
    }
}
