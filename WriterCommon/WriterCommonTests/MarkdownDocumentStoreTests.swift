//
//  MarkdownDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-07-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Igloo
import Markdown
import Common
import os
@testable import WriterCommon

class MarkdownDocumentStoreTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func createDispatcher() -> MarkdownDocumentDispatcher {
        
        return MarkdownDocumentDispatcher(state: MarkdownDocumentState())
    }
    
    func createMarkdownDocumentStore() -> MarkdownDocumentStore {
        
        return MarkdownDocumentStore(identifier: UUID().uuidString, name: "test-store", parentId: "")
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
    
    func urlOfFile(named name: String) -> URL? {
        
        let unitTestBundle = Bundle(for: type(of: self))
        
        let resourcesDirectoryURL = unitTestBundle.resourceURL!
        
        let fileManager = FileManager.default
        
        let resourcesDirectoryURLs: [URL] = (try! fileManager.contentsOfDirectory(at: resourcesDirectoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants))
        
        for url in resourcesDirectoryURLs {
            
            let last = url.lastPathComponent
            if last == name {
                return url
            }
        }
        return nil
    }
    
    func loadMarkdownTokens(named name: String) -> Tokens {
        
        let url = urlOfFile(named: name)
        let markdownString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return loadMarkdownTokens(markdownString: markdownString)
    }
    
    func loadMarkdownTokens(markdownString: String) -> Tokens {
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetCommonMarkPresets().options!)
        return md.parse(markdownString)
    }
    
    func createStyle(uaStylesheetFilename: String, authorStylesheetFilename: String) -> CSSStyle {
        
        let userAgentStylesheet = loadStylesheet(named: uaStylesheetFilename, origin: .userAgent)
        let authorStylesheet = loadStylesheet(named: authorStylesheetFilename, origin: .author)
        
        let style = CSSStyle(id: "markdown-source-style", userAgentStyleSheet: userAgentStylesheet, authorStyleSheets: [authorStylesheet])
        
        return style
    }

    func createStyle(uaStylesheetFilename: String, authorStylesheetFilenames: [String]) -> CSSStyle {
        
        let userAgentStylesheet = loadStylesheet(named: uaStylesheetFilename, origin: .userAgent)
        
        var authorStyleSheets: [CSSStyleSheet] = []
        
        for authorStylesheetFilename in authorStylesheetFilenames {
        
            let authorStylesheet = loadStylesheet(named: authorStylesheetFilename, origin: .author)
            authorStyleSheets.append(authorStylesheet)
        
        }
        let style = CSSStyle(id: "markdown-source-style", userAgentStyleSheet: userAgentStylesheet, authorStyleSheets: authorStyleSheets)
        return style
    }
    
    func createStyle(authorStylesheetString: String) -> CSSStyle {
        
        let authorStylesheet = loadStylesheet(stylesheetString: authorStylesheetString, origin: .author)
        
        let style = CSSStyle(id: "markdown-source-style", userAgentStyleSheet: nil, authorStyleSheets: [authorStylesheet])
        
        return style
    }
    
    func createBasicStyle() -> CSSStyle {
        
        let userAgentStylesheet = loadStylesheet(named: "markdown-ua.css", origin: .userAgent)
        let singleErrorStylesheet = loadStylesheet(named: "markdown-source-author.css", origin: .user)
        
        let style = CSSStyle(id: "single-error-style", userAgentStyleSheet: userAgentStylesheet, userStyleSheet: singleErrorStylesheet)
        
        return style
    }
    
    func loadStylesheet(named name: String, origin: CSSOrigin) -> CSSStyleSheet {
        
        let url = urlOfFile(named: name)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return CSSOMModule.shared.parseStyleSheet(stylesheetString as NSString, origin: origin, computePropertyValues: true)!
    }
    
    func loadStylesheet(stylesheetString: String, origin: CSSOrigin) -> CSSStyleSheet {
        
        return CSSOMModule.shared.parseStyleSheet(stylesheetString as NSString, origin: origin, computePropertyValues: true)!
    }
    
    func compileMarkdownTokens(fromSourceString loadedString: String, in store: MarkdownDocumentStore, dispatcher: MarkdownDocumentDispatcher, with style: CSSStyle) {
        
        let description = SourceStringChangeDescription(string: loadedString, originalString: nil)
        dispatcher.sync(store: store, action: TextDocumentAction.compileMarkdownTokens(string: loadedString).syncAction)
        dispatcher.sync(store: store, action: DocumentStoreAction.compileInitialDocument(description: description).syncAction)
        
        XCTAssert(store.markdownTokens != nil)
        XCTAssert(store.document.value != nil)
    }
    
    func compileMarkdown(fromSourceString loadedString: String, in store: MarkdownDocumentStore, dispatcher: MarkdownDocumentDispatcher, with style: CSSStyle) -> MarkdownStyleStore? {
        
        let description = SourceStringChangeDescription(string: loadedString, originalString: nil)
        dispatcher.sync(store: store, action: EditableStoreAction.setString(string: loadedString).syncAction)
        let result = dispatcher.sync(store: store, action: DocumentStoreAction.compileInitialDocument(description: description).syncAction)
        
        guard let documentStoreActionResult = result as? DocumentStoreActionResult else {
            XCTAssert(false, "result is not DocumentStoreActionResult")
            return nil
        }
        
        guard let lastCompiledDocument = documentStoreActionResult.lastCompiledDocument else {
            XCTAssert(false, "lastCompiledDocument is nil")
            return nil
        }
        
        XCTAssert(store.markdownTokens != nil)
        
        let resourcComputedStyle = ResourceComputedStyle(styleDefinition: style)
        let styleAssemblyStore = MarkdownStyleStore(string: loadedString, focusMode: .disabled, resourceComputedStyle: resourcComputedStyle)
        
        // apply the style
        dispatcher.sync(store: styleAssemblyStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: lastCompiledDocument, isFirstResponder: true, selectedRange: nil).syncAction)
        dispatcher.sync(store: styleAssemblyStore, action: StylableStoreAction.precomputeFadeStyles(document: lastCompiledDocument).syncAction)
        return styleAssemblyStore
    }
    
    func areSameAttributes(expectedAttributes: NSAttributedString, with compiledAttributes: NSAttributedString) -> Bool {
        
        XCTAssert(compiledAttributes.length == expectedAttributes.length)
        
        if !expectedAttributes.isEqual(to: compiledAttributes) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Expected string attributes...", log: Log.WriterCommon.all, type: .debug)
            #endif
            expectedAttributes.enumerateAttributes(in: NSMakeRange(0, expectedAttributes.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributes, range, stop) in
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .debug, %%attributes, %%range)
                #endif
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Received string attributes...", log: Log.WriterCommon.all, type: .debug)
            #endif
            compiledAttributes.enumerateAttributes(in: NSMakeRange(0, compiledAttributes.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributes, range, stop) in
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .debug, %%attributes, %%range )
                #endif
            }
            
            let differentAttributes = expectedAttributes.differentAttributesRanges(from: compiledAttributes, in: [NSMakeRange(0, expectedAttributes.length)])
            
            for (attributes, range) in differentAttributes {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("different attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .debug, %%attributes, %%range)
                os_log("string affected in expected: %@", log: Log.WriterCommon.all, type: .debug, %%expectedAttributes.attributedSubstring(from: range))
                os_log("string affected in compiled: %@", log: Log.WriterCommon.all, type: .debug, %%compiledAttributes.attributedSubstring(from: range))
                os_log("expected attributes: %@", log: Log.WriterCommon.all, type: .debug, %%expectedAttributes.attributes(in: range))
                os_log("compiled attributes: %@", log: Log.WriterCommon.all, type: .debug, %%compiledAttributes.attributes(in: range))
                #endif
            }
            
            return false
        }
        
        return true
    }
}
