//
//  MarkdownTokensTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-09-20.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo
import Markdown
import os
@testable import WriterCommon

class MarkdownTokensTests: MarkdownDocumentStoreTests {

    var filename = ""
    
    var sourceString: String?
    
    var dispatcher: MarkdownDocumentDispatcher?
    
    var markdownDocumentStore: MarkdownDocumentStore?
    
    var style: CSSStyle?
    
    override func setUp() {
        
        super.setUp()
        
        let url = urlOfFile(named: filename)
        self.sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        self.dispatcher = createDispatcher()
        self.markdownDocumentStore = nil
        self.markdownDocumentStore = MarkdownDocumentStore(identifier: UUID().uuidString, name: "test-store", parentId: "")
        self.dispatcher!.register(store: markdownDocumentStore!)
        self.style = createBasicStyle()
        compileMarkdownTokens(fromSourceString: self.sourceString!, in: markdownDocumentStore!, dispatcher: dispatcher!, with: style!)
        
    }
    
    @discardableResult
    func executeTests(stringChanges: [StringChange]) -> Bool {
        
        return executeTest(sourceFilename: filename, stringChanges: stringChanges)
    }
    
    func executeTest(affectedRange: NSRange, replacementString: String) {
        
        let stringChange = StringChange(affectedRange: affectedRange, replacementString: replacementString)
        
        executeTest(sourceFilename: filename, stringChanges: [stringChange])
    }
    
    @discardableResult
    func executeTest(sourceFilename: String, stringChanges: [StringChange]) -> Bool {
        
        var result = true
        
        let url = urlOfFile(named: sourceFilename)
        var markdownString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        for stringChange in stringChanges {
            
            let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
            
            let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: markdownString, range: stringChange.affectedRange, replacementString: stringChange.replacementString)
            
            let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, targetString: destination)
            
            result = result && compare(change: change, fromSourceString: markdownString, to: destination)
            
            markdownString = destination
        }
        return result
    }
    
    func replacementAndDestinationSubtring(fromSourceFile sourceFilename: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String) {
        
        let url = urlOfFile(named: sourceFilename)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return replacementAndDestinationSubtring(fromSourceString: stylesheetString, range: range, replacementString: replacementString)
    }
    
    private func replacementAndDestinationSubtring(fromSourceString stylesheetString: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String) {
        
        var _stylesheetString = stylesheetString
        
        let startRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.lowerBound)
        let endRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.upperBound)
        _stylesheetString.replaceSubrange(startRangeIndex..<endRangeIndex, with: replacementString)
        return (replacementString.utf16[replacementString.utf16.startIndex..<replacementString.utf16.endIndex], _stylesheetString)
    }
    
    private func compare(change: SourceStringChangeDescription, fromSourceString sourceString: String, to destinationString: String) -> Bool {
        
//        if let markdownTokens = markdownDocumentStore?.markdownTokens {
//
//            print("=======================================================")
//            print("=======================================================")
//            print("=======================================================")
//            print("Before: \(markdownTokens.toString(includePosition: true))")
//            print("=======================================================")
//            print("=======================================================")
//            print("=======================================================")
//        }
        
        let sourceStringChangedAction = EditableStoreActionsFactory.sourceStringChangedActionSync(description: change)
        dispatcher!.sync(store: markdownDocumentStore!, action: sourceStringChangedAction)
        
        let expectedMardownTokens = compileExpectedMarkdownTokens(source: destinationString)
        let compilationResultMarkdownTokens = markdownDocumentStore!.markdownTokens
        
        XCTAssert(compilationResultMarkdownTokens != nil, "compilationResultMarkdownTokens is nil")
        if let compilationResultMarkdownTokens = compilationResultMarkdownTokens {
            
//            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//            os_log("expectedMardownTokens: %@", log: Log.WriterCommon.all, type: .debug, %%expectedMardownTokens.toString())
//            os_log("compilationResultMarkdownTokens: %@)", log: Log.WriterCommon.all, type: .debug, %%compilationResultMarkdownTokens.toString())
//            #endif
//
            
            //////////////////////////////////////////////////////////////////
            /////////// make sure both Tokens are equals ////////////////
            //////////////////////////////////////////////////////////////////
            if !expectedMardownTokens.equals(to: compilationResultMarkdownTokens, comparePositions: true, compareChildren: true) {
                
                print("=======================================================")
                print("=======================================================")
                print("=======================================================")
                print("Expected: \(expectedMardownTokens.toString(includePosition: true))")
                print("=======================================================")
                print("=======================================================")
                print("=======================================================")
    
    
                print("=======================================================")
                print("=======================================================")
                print("=======================================================")
                print("Received: \(compilationResultMarkdownTokens.toString(includePosition: true))")
                print("=======================================================")
                print("=======================================================")
                print("=======================================================")
                
                return false
            }
            
            // we continue and compare the generated HTML document
            let compilationResultMarkdownDom = markdownDocumentStore!.document.value
            
            XCTAssert(compilationResultMarkdownDom != nil, "compilationResultMarkdownDom is nil")
            if let compilationResultMarkdownDom = compilationResultMarkdownDom {
                
                let expectedDocument = createMarkdownDom(from: expectedMardownTokens)
            
                if !expectedDocument.equals(to: compilationResultMarkdownDom, comparePositions: true) {
                    
                    let serializer = HTMLSerializer.createPreview(rangesEnabled: false)
                    
                    
                    print("=======================================================")
                    print("=======================================================")
                    print("=======================================================")
                    print("Expected: \(serializer.serializeHTMLFragment(expectedDocument))")
                    print("=======================================================")
                    print("=======================================================")
                    print("=======================================================")
                    
                    
                    print("=======================================================")
                    print("=======================================================")
                    print("=======================================================")
                    print("Received: \(serializer.serializeHTMLFragment(compilationResultMarkdownDom))")
                    print("=======================================================")
                    print("=======================================================")
                    print("=======================================================")
                    
                    return false
                }
            }
        }
        
        return true
    }
    
    private func compileExpectedMarkdownTokens(source string: String) -> Tokens {
        
        return loadMarkdownTokens(markdownString: string)
    }
    
    private func createMarkdownDom(from markdownTokens: Tokens) -> HtmlDocument {
        
        // Create the HtmlDocument that will be th head of all created elements
        let markdownDomRenderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        return markdownDomRenderer.render(markdownTokens)
    }
    
    private func sourceStringChangeDescription(from range: NSRange, stringReplacement: String.UTF16View.SubSequence, changeLength: Int, destionationFileName: String) -> SourceStringChangeDescription? {
        
        let url = urlOfFile(named: destionationFileName)
        
        XCTAssert(url != nil)
        if let url = url {
            return SourceStringChangeDescription(range: range, stringReplacement: stringReplacement, changeLength: changeLength, targetStringUrl: url)
        }
        return nil
    }
    
    private func sourceStringChangeDescription(from range: NSRange, stringReplacement: String.UTF16View.SubSequence, changeLength: Int, destionationString: String) -> SourceStringChangeDescription? {
        
        return SourceStringChangeDescription(range: range, stringReplacement: stringReplacement, changeLength: changeLength, targetString: destionationString)
    }
    
    private func compileMarkdown(from url: URL, in store: MarkdownDocumentStore, dispatcher: MarkdownDocumentDispatcher, with style: CSSStyle) {
        
        let loadAction = EditableStoreActionsFactory.loadStringAction(url: url)
        let result = dispatcher.sync(store: store, action: loadAction)
        
        XCTAssert(result is StylableActionResult)
        
        if let editableActionResult = result as? EditableActionResult {
            
            let loadedString = editableActionResult.loadedString
            XCTAssert(loadedString != nil)
            XCTAssert(loadedString! == contentOfFile(at: url))
            
            compileMarkdown(fromSourceString: loadedString!, in: store, dispatcher: dispatcher, with: style)
        }
    }
}
