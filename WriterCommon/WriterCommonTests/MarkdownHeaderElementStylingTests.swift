//
//  MarkdownHeaderElementStylingTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon

class MarkdownHeaderElementStylingTests: MarkdownListsElementStylingTests {

    func testHeader1ContentStyling() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "headers.md", styleFilename: "basic-style.css")
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 2, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 1, green: 0, blue: 0, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }

    func testHeader1TagContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 0, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader1UnderTagContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 54, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader2ContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 8, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 1, green: 0, blue: 0, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader2TagContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 5, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader2UnderTagContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 47, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader3ContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 15, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 1, green: 0, blue: 0, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader3TagContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 11, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader4ContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 23, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 1, green: 0, blue: 0, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader4TagContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 18, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader5ContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 32, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 1, green: 0, blue: 0, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader5TagContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 26, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    
    func testHeader6ContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 42, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 1, green: 0, blue: 0, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
    
    func testHeader6TagContentStyling() {
        
        let url = urlOfFile(named: "headers.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "basic-style.css")
        
        let styleAssemblyStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)!
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = styleAssemblyStore.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 35, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }
}
