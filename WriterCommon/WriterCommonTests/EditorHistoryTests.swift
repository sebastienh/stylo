//
//  EditorHistoryTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2018-12-02.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Markdown
import Common
import Web
@testable import WriterCommon

fileprivate extension EditRange {
    
    var range: NSRange {
        
        return NSMakeRange(Int(self.location), Int(self.length))
    }
}

fileprivate extension EditHistory {
    
    var stringChanges: [StringChange] {
        
        var stringChanges = [StringChange]()
        
        for edit in self.edits {
            
            stringChanges.append(StringChange(affectedRange: edit.range.range, replacementString: edit.replacementString))
        }
        return stringChanges
    }
}

class EditorHistoryTests: MarkdownDocumentStoreTests {

    func testBasic() {
        
        XCTAssert(executeTest(sourceFilename: "basic.history"), "failed basic.history test!")
    }

    func testLoseReference() {
        
        XCTAssert(executeTest(sourceFilename: "lose-reference-short.history"), "failed basic.history test!")
    }
    
    func testChangingParagraphAttributesWithFollowingSiblingClassSelector() {
        
        XCTAssert(executeTest(sourceFilename: "change-p-attributes-with-following-sibling-selector.history"), "failed basic.history test!")
    }

    func testChangingAttributesBlocParagraph() {
        
        XCTAssert(executeTest(sourceFilename: "edit-with-attributes-blocs.history"), "failed basic.history test!")
    }

    func testWrongTokenMove() {
        
        XCTAssert(executeTest(sourceFilename: "wrong-token-move.history"), "failed basic.history test!")
    }
    
    func executeTest(sourceFilename: String) -> Bool {
        
        let url = urlOfFile(named: sourceFilename)
        
        let utf8String = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        let editHistory = try! EditHistory(jsonString: utf8String)
        
        var stringChanges = editHistory.stringChanges
        
        let firstStringChange = stringChanges.removeFirst()
        
        let sourceString = firstStringChange.replacementString
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = MarkdownDocumentStore(identifier: UUID().uuidString, name: "test-store", parentId: "")
        dispatcher.register(store: markdownDocumentStore)
        let style = createBasicStyle()
        
        compileMarkdownTokens(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)
        
        var result = true
        
        var markdownString = sourceString
        
        for (index, stringChange) in stringChanges.enumerated() {
            
            print("testing change \(index+1) of \(stringChanges.count)")
            
            let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
            
            let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: markdownString, range: stringChange.affectedRange, replacementString: stringChange.replacementString)
            
            let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, targetString: destination)
            
            result = result && compare(change: change, fromSourceString: markdownString, to: destination, dispatcher: dispatcher, markdownDocumentStore: markdownDocumentStore)
            
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
    
    private func compare(change: SourceStringChangeDescription, fromSourceString sourceString: String, to destinationString: String, dispatcher: MarkdownDocumentDispatcher, markdownDocumentStore: MarkdownDocumentStore) -> Bool {
        
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
        
        let expectedMardownTokens = compileExpectedMarkdownTokens(source: destinationString)
        let compilationResultMarkdownTokens = markdownDocumentStore.markdownTokens
        
        XCTAssert(compilationResultMarkdownTokens != nil, "compilationResultMarkdownTokens is nil")
        if let compilationResultMarkdownTokens = compilationResultMarkdownTokens {
            
            //            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            //            os_log("expectedMardownTokens: %@", log: Log.WriterCommon.all, type: .debug, %%expectedMardownTokens.toString())
            //            os_log("compilationResultMarkdownTokens: %@)", log: Log.WriterCommon.all, type: .debug, %%compilationResultMarkdownTokens.toString())
            //            #endif
            //
            
//                        print("=======================================================")
//                        print("=======================================================")
//                        print("=======================================================")
//                        print("Expected: \(expectedMardownTokens.toString(includePosition: true))")
//                        print("=======================================================")
//                        print("=======================================================")
//                        print("=======================================================")
//
//
//                        print("=======================================================")
//                        print("=======================================================")
//                        print("=======================================================")
//                        print("Received: \(compilationResultMarkdownTokens.toString(includePosition: true))")
//                        print("=======================================================")
//                        print("=======================================================")
//                        print("=======================================================")
//
            
            //////////////////////////////////////////////////////////////////
            /////////// make sure both Tokens are equals ////////////////
            //////////////////////////////////////////////////////////////////
            return expectedMardownTokens.equals(to: compilationResultMarkdownTokens, comparePositions: true, compareChildren: true)
        }
        
        return false
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
    
    private func compileMarkdown(from url: URL, in store: MarkdownDocumentStore, dispatcher: MarkdownDocumentDispatcher, with style: CSSStyle) -> MarkdownStyleStore? {
        
        let loadAction = EditableStoreActionsFactory.loadStringAction(url: url)
        let result = dispatcher.sync(store: store, action: loadAction)
        
        XCTAssert(result is StylableActionResult)
        
        if let editableActionResult = result as? EditableActionResult {
            
            let loadedString = editableActionResult.loadedString
            XCTAssert(loadedString != nil)
            XCTAssert(loadedString! == contentOfFile(at: url))
            
            return compileMarkdown(fromSourceString: loadedString!, in: store, dispatcher: dispatcher, with: style)
        }
        return nil 
    }

}
