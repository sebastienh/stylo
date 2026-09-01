//
//  StylesheetDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-06-08.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Igloo
@testable import WriterCommon
import Common
import os

struct CssContext {
    
    let dispatcher: Dispatcher
    
    let document: Document
    
    let style: CSSStyle
    
    let loadedString: String
    
    let stylesheetDocumentStore: StylesheetDocumentStore
    
    var string: String {
        
        return stylesheetDocumentStore.sourceString.value!
    }
    
    mutating func applyChange(range: NSRange, insertedString: String) {
        
        // insert a character after the strong tag
        let change = SourceStringChangeDescription(sourceString: self.string, range: range, insertedString: insertedString)
        
        let sourceStringChangedAction = EditableStoreAction.sourceStringChanged(description: change).syncAction
        dispatcher.sync(store: stylesheetDocumentStore, action: sourceStringChangedAction)
    }
        
}

class StylesheetDocumentStoreTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func createDispatcher() -> StylesheetDocumentDispatcher {
        
        let stylesheetDocumentState = StylesheetDocumentState()
        
        return StylesheetDocumentDispatcher(state: stylesheetDocumentState)
    }
    
    func createStylesheetDocumentStore(origin: CSSOrigin) -> StylesheetDocumentStore {
        
        return StylesheetDocumentStore(origin: origin, appearances: [.dark, .light], alwaysAllowPartialCompilation: true)
    }
    
    func loadStylesheetDocumentStore(filename: String, store: StylesheetDocumentStore, dispatcher: Dispatcher) {
        
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
    
    func loadStylesheet(named name: String, origin: CSSOrigin) -> CSSStyleSheet {
        
        let url = urlOfFile(named: name)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return CSSOMModule.shared.parseStyleSheet(stylesheetString as NSString, origin: origin, computePropertyValues: true)!
    }

    func loadStylesheet(stylesheetString: String, origin: CSSOrigin) -> CSSStyleSheet {
        
        return CSSOMModule.shared.parseStyleSheet(stylesheetString as NSString, origin: origin, computePropertyValues: true)!
    }
    
    func createBasicStyle() -> CSSStyle {
    
        let userAgentStylesheet = loadStylesheet(named: "css-ua.css", origin: .userAgent)
        let singleErrorStylesheet = loadStylesheet(named: "source-author.css", origin: .user)
    
        return CSSStyle(id: "single-error-style", userAgentStyleSheet: userAgentStylesheet, userStyleSheet: singleErrorStylesheet)
    }
    
    func createStyle(fromUa uaStylesheetName: String?, authors: [String]) -> CSSStyle {
        
        let userAgentStylesheet: CSSStyleSheet? = {
            if let uaStylesheetName = uaStylesheetName {
                return loadStylesheet(named: uaStylesheetName, origin: .userAgent)
            }
            return nil
        }()
            
        var authorStylesheets: [CSSStyleSheet] = []
        for author in authors {
            
            let authorStylesheet = loadStylesheet(named: author, origin: .author)
            authorStylesheets.append(authorStylesheet)
        }
        
        return CSSStyle(id: "style", userAgentStyleSheet: userAgentStylesheet, authorStyleSheets: authorStylesheets)
    }
    
    func prepareCssContext(fromFileWithName filename: String, uaStylesheet: String, authorStylesheets: [String]) -> CssContext? {
        
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
                
                return prepareCssContext(fromString: loadedString!, uaStylesheet: uaStylesheet, authorStylesheets: authorStylesheets)
            }
        }
        return nil
    }
    
    func prepareCssContext(fromString string: String, uaStylesheet: String?, authorStylesheets: [String]) -> CssContext? {
        
        let dispatcher = createDispatcher()
        let stylesheetDocumentStore = createStylesheetDocumentStore(origin: .userAgent)
        dispatcher.register(store: stylesheetDocumentStore)
        
        let style = createStyle(fromUa: uaStylesheet, authors: authorStylesheets)

        // compile first stylesheet
        let createStylesheetAction = StylesheetDocumentAction.createInitialStylesheet(source: string).syncAction
        let result = dispatcher.sync(store: stylesheetDocumentStore, action: createStylesheetAction)
        
        XCTAssert(result != nil)
        if let result = result {
            
            XCTAssert(result is StylesheetDocumentResult)
            if let stylesheetDocumentResult = result as? StylesheetDocumentResult {
                
                let stylesheet = stylesheetDocumentResult.stylesheet
                XCTAssert(stylesheet != nil)
                
                let document = stylesheetDocumentStore.document.value!
                return CssContext(dispatcher: dispatcher, document: document, style: style, loadedString: string, stylesheetDocumentStore: stylesheetDocumentStore)
            }
        }
            
        return nil
    }
    
    func validateSame(stylesheetSource: String, changeRange: NSRange, insertedString: String, expectedStylesheetString: String) -> Bool {
        
        guard var context: CssContext = self.prepareCssContext(fromString: stylesheetSource, uaStylesheet: nil, authorStylesheets: []) else {
            XCTAssert(false)
            return false
        }

        guard let context2: CssContext = self.prepareCssContext(fromString: expectedStylesheetString, uaStylesheet: nil, authorStylesheets: []) else {
            XCTAssert(false)
            return false
        }
        
        context.applyChange(range: changeRange, insertedString: insertedString)
        
        let modifiedStylesheet = context.stylesheetDocumentStore.stylesheet.value!
        let expectedStylesheet = context2.stylesheetDocumentStore.stylesheet.value!
        
        if !modifiedStylesheet.equals(to: expectedStylesheet, comparePositions: true) {
            
            print("modifiedStylesheet: \n\(modifiedStylesheet.descriptionWithPositions)")
            print("expectedStylesheet: \n\(expectedStylesheet.descriptionWithPositions)")
            XCTAssert(false)
        }
        
        let firstDocument = context.stylesheetDocumentStore.document.value!
        let secondDocument = context2.stylesheetDocumentStore.document.value!
        
        
        if !firstDocument.equals(to: secondDocument, comparePositions: true) {
        
            print("compiled document: \(HTMLSerializer.createDefault(rangesEnabled: true).serializeHTMLFragment(firstDocument))")

            let string = HTMLSerializer.createDefault(rangesEnabled: true).serializeHTMLFragment(secondDocument)
            print("expected document: \(string)")
            return false
        }
        return true
    }
    
}
