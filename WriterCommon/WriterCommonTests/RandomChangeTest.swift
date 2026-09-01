//
//  RandomChangeTest.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-05-12.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
import Web
import Markdown
import os
@testable import WriterCommon

class RandomChangeTest: XCTestCase {

    var sourceString: String!
    
    var nextChangeType: SourceStringChangeDescription.ChangeType? {
        
        let changeType = Int.random(in: 0..<6)
        switch changeType {
        case 0:
            return .pureAddition
        case 1:
            return .pureRemoval
        case 2:
            return .pureReplace
        case 3:
            return .replaceAddition
        case 4:
            return .replaceRemoval
        case 5:
            return .unchanged
        default:
            return nil
        }
    }
    
    var nextStringChange: StringChange? {
        
        if let changeType = nextChangeType {
            
            switch changeType {
                
            case .pureAddition:
                
                let changeLenght = Int.random(in: 1..<10)
                let replacemenntStringSourceIndex = Int.random(in: 0..<sourceString.count - changeLenght)
                let replacementString = sourceString.substring(replacemenntStringSourceIndex, length: changeLenght)!
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, 0), replacementString: replacementString)
                
            case .pureRemoval:
                
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                let insertionLenght = Int.random(in: 1..<10)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, insertionLenght), replacementString: "")
                
            case .pureReplace:
                
                let changeLenght = Int.random(in: 2..<10)
                let replacemenntStringSourceIndex = Int.random(in: 0..<sourceString.count - changeLenght)
                let replacementString = sourceString.substring(replacemenntStringSourceIndex, length: changeLenght)!
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, changeLenght), replacementString: replacementString)
                
            case .replaceAddition:
                
                let changeLenght = Int.random(in: 2..<10)
                let replacemenntStringSourceIndex = Int.random(in: 0..<sourceString.count - changeLenght)
                let replacementString = sourceString.substring(replacemenntStringSourceIndex, length: changeLenght)!
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                let insertionLenght = Int.random(in: 1..<changeLenght)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, insertionLenght), replacementString: replacementString)
                
            case .replaceRemoval:
                
                let changeLenght = Int.random(in: 2..<10)
                let replacemenntStringSourceIndex = Int.random(in: 0..<sourceString.count - changeLenght)
                let replacementString = sourceString.substring(replacemenntStringSourceIndex, length: changeLenght)!
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                let insertionLenght = Int.random(in: changeLenght..<changeLenght+10)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, insertionLenght), replacementString: replacementString)
                
            case .unchanged:
                
                return nil
            }
        }
        return nil
    }
    
    func testChange(stringChange: StringChange) -> Bool {
        
        let dispatcher = createDispatcher()
        
        let markdownDocumentStore = MarkdownDocumentStore(identifier: UUID().uuidString, name: "test-store", parentId: "")
        dispatcher.register(store: markdownDocumentStore)
        let style = createBasicStyle()
        compileMarkdownTokens(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)
        
        let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
        
        if let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: sourceString, range: stringChange.affectedRange, replacementString: stringChange.replacementString) {
            
            let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, targetString: destination)
            
            return compare(change: change, fromSourceString: sourceString, to: destination, markdownDocumentStore: markdownDocumentStore, dispatcher: dispatcher)
        }
        return true
    }
    
    
    
    private func replacementAndDestinationSubtring(fromSourceString stylesheetString: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String)? {
        
        var _stylesheetString = stylesheetString
        
        let startRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.lowerBound)
        let endRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.upperBound)
        if _stylesheetString.startIndex <= startRangeIndex && endRangeIndex <= _stylesheetString.endIndex {
            _stylesheetString.replaceSubrange(startRangeIndex..<endRangeIndex, with: replacementString)
            return (replacementString.utf16[replacementString.utf16.startIndex..<replacementString.utf16.endIndex], _stylesheetString)
        }
        return nil
    }
    
    func compare(change: SourceStringChangeDescription, fromSourceString sourceString: String, to destinationString: String, markdownDocumentStore: MarkdownDocumentStore, dispatcher: MarkdownDocumentDispatcher) -> Bool {
        
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
        dispatcher.sync(store: markdownDocumentStore, action: sourceStringChangedAction)
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetCommonMarkPresets().options!)
        let expectedMardownTokens = md.parse(destinationString)
        
        let compilationResultMarkdownTokens = markdownDocumentStore.markdownTokens
        
        XCTAssert(compilationResultMarkdownTokens != nil, "compilationResultMarkdownTokens is nil")
        if let compilationResultMarkdownTokens = compilationResultMarkdownTokens {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("expectedMardownTokens: %@", log: Log.WriterCommon.all, type: .debug, %%expectedMardownTokens.toString())
            os_log("compilationResultMarkdownTokens: %@)", log: Log.WriterCommon.all, type: .debug, %%compilationResultMarkdownTokens.toString())
            #endif
            
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
            let compilationResultMarkdownDom = markdownDocumentStore.document.value
            
            XCTAssert(compilationResultMarkdownDom != nil, "compilationResultMarkdownDom is nil")
            if let compilationResultMarkdownDom = compilationResultMarkdownDom {
                
                let expectedDocument = createMarkdownDom(from: expectedMardownTokens)
                
                if !expectedDocument.equals(to: compilationResultMarkdownDom, comparePositions: true) {
                    
                    let serializer = HTMLSerializer.createPreview(rangesEnabled: true)
                    
                    
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
    
    func createDispatcher() -> MarkdownDocumentDispatcher {
        
        return MarkdownDocumentDispatcher(state: MarkdownDocumentState())
    }
    
    func createBasicStyle() -> CSSStyle {
        
        let userAgentStylesheet = loadStylesheet(named: "markdown-ua.css", origin: .userAgent)
        let singleErrorStylesheet = loadStylesheet(named: "markdown-source-author.css", origin: .user)
        
        let style = CSSStyle(id: "single-error-style", userAgentStyleSheet: userAgentStylesheet, userStyleSheet: singleErrorStylesheet)
        
        return style
    }
    
    func compileMarkdownTokens(fromSourceString loadedString: String, in store: MarkdownDocumentStore, dispatcher: MarkdownDocumentDispatcher, with style: CSSStyle) {
        
        let description = SourceStringChangeDescription(string: loadedString, originalString: nil)
        dispatcher.sync(store: store, action: TextDocumentAction.compileMarkdownTokens(string: loadedString).syncAction)
        dispatcher.sync(store: store, action: DocumentStoreAction.compileInitialDocument(description: description).syncAction)
        
        XCTAssert(store.markdownTokens != nil)
        XCTAssert(store.document.value != nil)
    }
    
    func loadStylesheet(named name: String, origin: CSSOrigin) -> CSSStyleSheet {
        
        let url = urlOfFile(named: name)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return CSSOMModule.shared.parseStyleSheet(stylesheetString as NSString, origin: origin, computePropertyValues: true)!
    }
    
    private func createMarkdownDom(from markdownTokens: Tokens) -> HtmlDocument {
        
        // Create the HtmlDocument that will be th head of all created elements
        let markdownDomRenderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        return markdownDomRenderer.render(markdownTokens)
    }
}
