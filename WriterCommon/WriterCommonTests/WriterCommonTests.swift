//
//  WriterCommonTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2015-08-29.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Cocoa
import XCTest
import Web
import Markdown
import Common
import PromiseKit
import Igloo
@testable import WriterCommon

class WriterCommonTests: XCTestCase {
    
    let testFileString = "#  test Shitty test Shitty testShitty tes\n"
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func loadMarkdownDocumentStore(filename: String, store: MarkdownDocumentStore, dispatcher: StyloDocumentDispatcher) -> MarkdownDocumentStore? {
        
        if let url = WriterCommonTests.urlOfFile(named: filename) {
            let loadAction = EditableStoreActionsFactory.loadStringAction(url: url)
            dispatcher.sync(store: store, action: loadAction)
        }
        return store
    }
    
    func loadStyle(filename: String, dispatcher: StyloDocumentDispatcher) -> Promise<CSSStyle> {
        
        fatalError()
//
//        return Promise<CSSStyle> { fulfill, reject in
//        
//            let stylesheetDocumentStore = StylesheetDocumentStore(origin: .author)
//            let styleAssemblyStore = StyleStore()
//
//            if let url = urlOfFile(named: filename) {
//
//                let loadStylesheetAction = StylesheetDocumentAction.loadStylesheet(url: url)
//
//                firstly {
//                    dispatcher.dispatch(store: stylesheetDocumentStore, action: loadStylesheetAction)
//                }.then {
//                    let stylesheet = stylesheetDocumentStore.stylesheet.value!
//                    let addStylesheetAction = StyleAction.addAuthorStylesheets(stylesheets: [stylesheet], loaded: true)
//                    return dispatcher.dispatch(store: styleAssemblyStore, action: addStylesheetAction)
//                }.then {
//                    let style = styleAssemblyStore.style.value!
//                    fulfill(style)
//                }.catch { error in
//                    let error = NWError.unableToLoadFile(file: filename)
//                    debugPrint("Error: \(error)")
//                    reject(error)
//                }
//            }
//            else {
//                let error = NWError.unableToLoadFile(file: filename)
//                debugPrint("Error: \(error)")
//                reject(error)
//            }
//        }
    }
    
    
    static func urlOfFile(named name: String) -> URL? {
        
        let unitTestBundle = Bundle(for: WriterCommonTests.self)
        
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
    
    func getElement(in document: Document, tagName: String, classes: [String]? = nil, attributes: [String: String]? = nil) -> Element? {
        let elements = document.getElementsByTagName(tagName, inclusive: true)
        
        for node in elements {
            
            let element = node as! Element
            var lookedForElement = true
            
            if let classes = classes {
                
                for _class in classes {
                
                    if !element.hasClassAttribute(_class) {
                        lookedForElement = false
                    }
                }
            }
            
            if let attributes = attributes {
                
                for (attributeName, attributeValue) in attributes {
                    
                    if element.hasAttribute(attributeName) {
                        
                        let value = element.getAttribute(attributeName)
                        
                        if value != attributeValue {
                            
                            lookedForElement = false
                        }
                    }
                    else {
                        lookedForElement = false
                    }
                }
            }
            if lookedForElement {
                return element
            }
        }
        return nil
    }
    
    func serializeCssDom(cssDomDocument: CSSDOMDocument) -> String {
        
        let domParsing = HTMLSerializer.createDefault(rangesEnabled: true)
        
        var string = domParsing.serializeHTMLFragment(cssDomDocument)
        
        return string
        
        //                let htmlSerializer = HTMLSerializer.shared
        //                let serializedDocumentString = htmlSerializer.serializeHTMLFragment(documentFragment, withRanges: true)
        //                print("Document fragment: \(serializedDocumentString)")
    }
    
    
    static func createStyle(fromUa usStylesheetName: String, authors: [String]) -> CSSStyle {
        
        let userAgentStylesheet = loadStylesheet(named: usStylesheetName, origin: .userAgent)
        var authorStylesheets: [CSSStyleSheet] = []
        for author in authors {
            
            let authorStylesheet = loadStylesheet(named: author, origin: .author)
            authorStylesheets.append(authorStylesheet)
        }
        
        return CSSStyle(id: "css-source-style", userAgentStyleSheet: userAgentStylesheet, authorStyleSheets: authorStylesheets)
    }

    static func createStyle(authorStylesheetString: String) -> CSSStyle {
        
        let authorStylesheet = loadStylesheet(stylesheetString: authorStylesheetString, origin: .author)
        
        let style = CSSStyle(id: "css-source-style", userAgentStyleSheet: nil, authorStyleSheets: [authorStylesheet])
        
        return style
    }

    static func loadStylesheet(named name: String, origin: CSSOrigin) -> CSSStyleSheet {
        
        let url = WriterCommonTests.urlOfFile(named: name)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return CSSOMModule.shared.parseStyleSheet(stylesheetString as NSString, origin: origin, computePropertyValues: true)!
    }

    static func loadStylesheet(stylesheetString: String, origin: CSSOrigin) -> CSSStyleSheet {
        
        return CSSOMModule.shared.parseStyleSheet(stylesheetString as NSString, origin: origin, computePropertyValues: true)!
    }


    static func validateColors(in compiledAttributes: NSAttributedString, colors: (index: Int, color: NSColor)...) {
        
        for (index, color) in colors {
        
            let validationResult = WriterCommonTests.validateColor(in: compiledAttributes, at: index, expected: color)
            
            switch validationResult {
            case .error(let receivedColor):
                XCTAssert(false, "Expected: \(color), received: \(receivedColor) at index: \(index)")
            case .success:
                break
            }
        }
    }

    static func validateColor(in compiledAttributes: NSAttributedString, index: Int, color: NSColor, failedClosure: (NSColor, NSColor, Int) -> ()) {
        
        let validationResult = WriterCommonTests.validateColor(in: compiledAttributes, at: index, expected: color)
        
        switch validationResult {
        case .error(let receivedColor):
            failedClosure(color, receivedColor, index)
        case .success:
            break
        }
    }

    static func validateColor(in markdownContext: MarkdownRendererContext, index: Int, color: NSColor, failedClosure: (NSColor, NSColor, Int) -> ()) {
        
        let validationResult = WriterCommonTests.validateColor(in: markdownContext.attributedString, at: index, expected: color)
        
        switch validationResult {
        case .error(let receivedColor):
            failedClosure(color, receivedColor, index)
        case .success:
            break
        }
    }

    static func validateColor(in rendererContext: RendererContext, index: Int, color: NSColor, failedClosure: (NSColor, NSColor, Int) -> ()) {
        
        let validationResult = WriterCommonTests.validateColor(in: rendererContext.attributedString, at: index, expected: color)
        
        switch validationResult {
        case .error(let receivedColor):
            failedClosure(color, receivedColor, index)
        case .success:
            break
        }
    }

    static func validateColor(in attributedString: NSAttributedString, at location: Int, expected: NSColor) -> Result {
        
        // # 1
        let attributes1 = attributedString.attributes(at: location, effectiveRange: nil)
        let compiledColor1 = attributes1[.foregroundColor] as! NSColor
        
        if expected == compiledColor1 {
            return .success
        }
        return .error(color: compiledColor1)
    }

    static func validateColor(in attributedString: NSAttributedString, over locations: [Int], expected: NSColor) -> Result {
        
        for location in locations {
            
            let result = WriterCommonTests.validateColor(in: attributedString, at: location, expected: expected)
                
            switch result {
                
            case .error(let color):
                return .error(color: color)
            default:
                break
            }
        }
        return .success
    }
    
    static func compileMarkdown(fromSourceString loadedString: String, in store: MarkdownDocumentStore, dispatcher: MarkdownDocumentDispatcher, with style: CSSStyle) -> MarkdownStyleStore? {
    
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

    static func compileStylesheet(fromSourceString loadedString: String, in store: StylesheetDocumentStore, dispatcher: StylesheetDocumentDispatcher, with style: CSSStyle) -> StylesheetStyleStore? {
        
        let description = SourceStringChangeDescription(string: loadedString, originalString: nil)
        dispatcher.sync(store: store, action: EditableStoreAction.setString(string: loadedString).syncAction)
        let result = dispatcher.sync(store: store, action: DocumentStoreAction.compileInitialDocument(description: description).syncAction)
        
        guard let stylesheetDocumentResult = result as? StylesheetDocumentResult else {
            XCTAssert(false, "result is not StylesheetDocumentResult")
            return nil
        }
        
        XCTAssert(stylesheetDocumentResult.stylesheet != nil)
        XCTAssert(store.stylesheet.value != nil)
        
        let document = store.document.value!
        
        let resourcComputedStyle = ResourceComputedStyle(styleDefinition: style)
        let styleAssemblyStore = StylesheetStyleStore(string: loadedString, focusMode: .disabled, resourceComputedStyle: resourcComputedStyle)
        
        // apply the style
        dispatcher.sync(store: styleAssemblyStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: document, isFirstResponder: true, selectedRange: nil).syncAction)
        return styleAssemblyStore
    }
    
}
