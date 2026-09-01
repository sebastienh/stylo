//
//  MarkdownTestContext.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-12-31.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
@testable import WriterCommon
import XCTest
import Markdown
import Web
import Common
import os
import Igloo

struct MarkdownRendererContext: RendererContext {
    
    var attributedString: NSAttributedString {
        return self.markdownStyleStore.attributesStore.attributedString
    }
    
    var focusString: NSAttributedString {
        
        return self.markdownStyleStore.focusAttributesString!.attributedString
    }
    
    var document: Document {
        
        return self.markdownDocumentStore.document.value!
    }
    
    var string: String
    let dispatcher: MarkdownDocumentDispatcher
    let markdownDocumentStore: MarkdownDocumentStore
    var markdownStyleStore: MarkdownStyleStore
    
    mutating func applyChange(range: NSRange, insertedString: String, visibleRange: NSRange?) {
        
        var string = self.string
        guard let stringIndexRange = range.stringIndexRange(inString: string) else {
            assertionFailure("Error: stringIndexRange is nil")
            return
        }
        
        string.replaceSubrange(stringIndexRange, with: insertedString)
        self.string = string
        
        let changeLength = insertedString.utf16.count - range.length
        
        // insert a character after the strong tag
        let change = SourceStringChangeDescription(range: range, stringReplacement: insertedString, changeLength: changeLength, targetString: string)
        
        let sourceStringChangedAction = EditableStoreAction.sourceStringChanged(description: change).syncAction
        let result = dispatcher.sync(store: markdownDocumentStore, action: sourceStringChangedAction)
            
        let visibleTopElements: ContiguousArray<Element>? = {
            if let visibleRange = visibleRange {
                return topElements(inRange: visibleRange)
            }
            else {
                return nil
            }
        }()
        
        guard let documentStoreActionResult = result as? DocumentStoreActionResult else {
            
            let errorString = "Invalid action result expecting DocumentStoreActionResult received: \(String(describing: result))."
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("%@", log: Log.WriterCommon.all, type: .error, %%errorString)
            #endif
            return
        }
        
        let lastCompiledDocument = documentStoreActionResult.lastCompiledDocument!
        
        if documentStoreActionResult.containsCompleteUpdate {
            
            let styleAssemblyStore = MarkdownStyleStore(string: string, focusMode: markdownStyleStore.focusMode.value, resourceComputedStyle: markdownStyleStore.resourceComputedStyle)
            
            // apply the style
            dispatcher.sync(store: styleAssemblyStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: visibleTopElements, document: lastCompiledDocument, isFirstResponder: true, selectedRange: nil).syncAction)
//                if let focusedRange = focusedRange {
//                    let topElements: ContiguousArray<Element> = ContiguousArray<Element>(lastCompiledDocument.styleRoots)
//                    dispatcher.sync(store: styleAssemblyStore, action: StylableStoreAction.flash(topElements: topElements, range: focusedRange).syncAction)
//                }
            self.markdownStyleStore = styleAssemblyStore
        }
        else {
            
            let applyStringChangeAction = StylableStoreAction.applySourceStringChange(change: change, documentResults: documentStoreActionResult.updateDocumentResults!, visibleTopElements: visibleTopElements, document: lastCompiledDocument, isFirstResponder: true).syncAction
            dispatcher.sync(store: markdownStyleStore, action: applyStringChangeAction)
        }
    }
    
    func topElements(inRange range: NSRange) -> ContiguousArray<Element>? {
        
        let actionResult: ActionResult = dispatcher.sync(store: markdownDocumentStore, action: DocumentStoreAction.topElementsAroundRange(range: range).syncAction)!
        
        let documentStoreActionResult: DocumentStoreActionResult = actionResult as! DocumentStoreActionResult
        
        return documentStoreActionResult.topElementsAroundRange!
    }
    
    func applyFlash(in flashRange: NSRange) -> StylableActionResult? {
        
        let topElements = self.topElements(inRange: flashRange)!
        
        let applyFocusAction = StylableStoreAction.flash(topElements: topElements, range: flashRange, document: self.document)
        let result = dispatcher.sync(store: markdownStyleStore, action: applyFocusAction.syncAction)
        let stylableResult = result as? StylableActionResult
        return stylableResult
    }
    
    func removeFocus() {
        
        dispatcher.sync(store: markdownStyleStore, action: StylableStoreAction.clearFocusedAttributes(focusMode: FocusMode.disabled).syncAction)
    }
    
    func setFocusMode(focusMode: FocusMode) {
        
        dispatcher.sync(store: markdownStyleStore, action: StylableStoreAction.changeFocusMode(focusMode: focusMode).syncAction)
    }
    
    func highlight(with selectorString: String) {
        
        dispatcher.sync(store: markdownStyleStore, action: StylableStoreAction.updateSelectorHighlightString(string: selectorString).syncAction)
        
        XCTAssert(markdownStyleStore.highlightSelectors != nil)
        
        dispatcher.sync(store: markdownStyleStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: self.document, isFirstResponder: false, selectedRange: nil).syncAction)
    }
    
    func clearHighlight() {
        
        dispatcher.sync(store: markdownStyleStore, action: StylableStoreAction.clearSelectorHighlightString.syncAction)
        
        dispatcher.sync(store: markdownStyleStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: self.document, isFirstResponder: true, selectedRange: nil).syncAction)
    }
    
    @discardableResult
    func applySelectionChange(selectionRange: NSRange, visibleRange: NSRange) -> ContiguousArray<Element>? {
        
        let actionResult: ActionResult = dispatcher.sync(store: markdownDocumentStore, action: DocumentStoreAction.topElementsAroundRange(range: visibleRange).syncAction)!
        
        let documentStoreActionResult: DocumentStoreActionResult = actionResult as! DocumentStoreActionResult
        
        let visibleTopElements: ContiguousArray<Element> = documentStoreActionResult.topElementsAroundRange!
        
        let result = dispatcher.sync(store: markdownStyleStore, action: StylableStoreAction.changeSelection(selectionRange: selectionRange, visibleTopElements: visibleTopElements, document: self.document) .syncAction)
        let stylableResult = result as? StylableActionResult
        return stylableResult?.renderedTopElements
    }
    
    func scroll(focusMode: FocusMode) {
        
        dispatcher.sync(store: markdownStyleStore, action: StylableStoreAction.clearFocusedAttributes(focusMode: focusMode).syncAction)
        
    }
}
