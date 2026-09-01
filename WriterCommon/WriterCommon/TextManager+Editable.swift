//
//  TextManager+Editable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-08.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import Igloo
import PromiseKit
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

extension TextManager: Editable {

    public typealias EditableStore = MarkdownDocumentStore
    
    public typealias StylableStore = MarkdownStyleStore
    
    public var editedLanguage: Language {
        return Language.Markdown
    }
    
    public var supportsAutocompletion: Bool {
        return false
    }
    
    public func executeCompilation(withChangeDescription changeDescription: SourceStringChangeDescription) {
        
        assert(Thread.isMainThread)
        self.pendingRequests.enqueue(changeDescription)
        
        assert(self.textDocument != nil)
        if let textDocument = self.textDocument, !textDocument.isBrowsingVersions {

            if syncCompilationNecessary(sourceStringChangeDescription: changeDescription) {
                compileSync(changeDescription: changeDescription)
            }
            else {
                compileAsync(changeDescription: changeDescription)
            }
        }
        else {
            compileSync(changeDescription: changeDescription)
        }
    }
    
    func compileSync(changeDescription: SourceStringChangeDescription) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("requested sync compilation", log: Log.WriterCommon.textStorage, type: .info)
        #endif
        let visibleRanges = self.visibleRanges
        let _stylableActionResults: [EditorId: StylableActionResult]? = compilationQueue.sync {
            return self.compileDocumentAndAttributes(changeDescription: changeDescription, visibleRanges: visibleRanges)
        }
        
        assert(_stylableActionResults != nil, "Error: stylableActionResults is nil")
        if let stylableActionResults = _stylableActionResults {
            self.updateAttributes(for: changeDescription, with: stylableActionResults)
        }
        
        compilationQueue.sync {
            self.documentManager?.restoreTemporaryDisabledFocusIfNecessary()
        }
    }
    
    func compileAsync(changeDescription: SourceStringChangeDescription) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("requested async compilation", log: Log.WriterCommon.textStorage, type: .info)
        #endif
        
        let visibleRanges = self.visibleRanges
        compilationQueue.async {
            
            guard let stylableActionResults = self.compileDocumentAndAttributes(changeDescription: changeDescription, visibleRanges: visibleRanges) else {
                assertionFailure("Error: stylableActionResults is nil")
                return
            }
            
            self.applyAsync(stylableActionResults: stylableActionResults, changeDescription: changeDescription)
            
            self.documentManager?.restoreTemporaryDisabledFocusIfNecessary()
        }
    }
    
    private func applyAsync(stylableActionResults: [EditorId: StylableActionResult], changeDescription: SourceStringChangeDescription) {
        
        if changeDescription.lineContainingChange?.contains("#") == true
            && self.undoManager?.isUndoing == false
            && self.undoManager?.isRedoing == false {
            // asyncOnMain: no rendering lag but pendingRequests are not removed in order
            DispatchQueue.asyncOnMain {
                self.updateAttributes(for: changeDescription, with: stylableActionResults)
            }
        }
        else {
            // main.async: rendering lag but pendingRequests are removed in order
            DispatchQueue.main.async {
                self.updateAttributes(for: changeDescription, with: stylableActionResults)
            }
        }
    }
    
    private func compileDocumentAndAttributes(changeDescription: SourceStringChangeDescription, visibleRanges: [EditorId: NSRange?]) -> [EditorId: StylableActionResult]? {
        
        do {
            
            guard let documentStoreActionResult = try self.compileDocument(from: changeDescription) else {
                assertionFailure("Error: documentStoreActionResult is nil")
                return nil
            }
            
            guard let stylableActionResults = try self.compileAttributes(using: documentStoreActionResult, change: changeDescription, visibleRanges: visibleRanges) else {
                assertionFailure("Error: stylableResults is nil")
                return nil
            }
            
            return stylableActionResults
        }
        catch let error {
            assertionFailure("Error: \(error)")
            return nil
        }
    }
    
    private func updateAttributes(for changeDescription: SourceStringChangeDescription, with stylableActionResults: [EditorId: StylableActionResult]) {
        
        guard let (change, pendingRequests) = self.extractPendingRequests(changeDescription) else {
            assertionFailure("Error: ")
            return
        }
        
        self.updateDifferentAttributesForAllRenderers(stylableActionResults, change: change, pendingRequests: pendingRequests)
        self.restartTokenAttributesUpdateTimer()
    }
    
    private func compileAttributes(using documentStoreActionResult: DocumentStoreActionResult, change: SourceStringChangeDescription, visibleRanges: [EditorId: NSRange?]) throws -> [EditorId: StylableActionResult]? {
    
        if documentStoreActionResult.containsCompleteUpdate {
            
            guard let lastCompiledDocument = documentStoreActionResult.lastCompiledDocument else {
                assertionFailure("Error: lastCompiledDocument is nil")
                return nil
            }
            
            return try self.compileCompleteAttributes(withDocument: lastCompiledDocument, withSourceStringChangeDescription: change, visibleRanges: visibleRanges)
        }
        else {
            
            return self.compilePartialAttributes(using: documentStoreActionResult, change: change, visibleRanges: visibleRanges)
        }
    }
    
    private func compileDocument(from changeDescription: SourceStringChangeDescription) throws -> DocumentStoreActionResult? {
        
        let action = EditableStoreAction.sourceStringChanged(description: changeDescription)
        let result = try dispatcher.online(store: self.markdownDocumentStore, action: action)
        
        guard let documentStoreActionResult = result as? DocumentStoreActionResult else {
            
            let errorString = "Invalid action result expecting DocumentStoreActionResult received: \(String(describing: result))."
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("%@", log: Log.WriterCommon.all, type: .error, %%errorString)
            #endif
            assertionFailure(errorString)
            return nil
        }
        
        return documentStoreActionResult
    }
    
    private func extractPendingRequests(_ expectedChange: SourceStringChangeDescription) -> (SourceStringChangeDescription, Queue<SourceStringChangeDescription>)? {
        
        // there could be pending requests that came after this one
        // but we are not a pending request anymore. So we should remove
        // the first request from the queue and it should be the same
        // as the changeDescription
        guard let change = self.pendingRequests.dequeue() else {
            assertionFailure("Error: pendingRequest is nil")
            return nil
        }
        
        assert(change == expectedChange)
        let pendingRequests = self.pendingRequests
        
        return (change, pendingRequests)
    }
    
    private func syncCompilationNecessary(sourceStringChangeDescription: SourceStringChangeDescription) -> Bool {
        
        guard !Constants.Configuration.ForceMarkdownSynchronousCompilation else {
            return true
        }
        
        guard let index = sourceStringChangeDescription.changeRange?.location else {
            assertionFailure("Error: index is nil")
            // by default we request synchronous compilation
            return true
        }
        
        // by default if the range is more than one we require synchronous
        // compilation, this will avoid bumping while pasting text.
        // see NW-1560
        if abs(sourceStringChangeDescription.changeLength) > 1 {
            return true
        }
        
        assert(abs(sourceStringChangeDescription.changeLength) <= 1)
        if sourceStringChangeDescription.changeType == .pureRemoval {
            return false
        }
        
        guard let stringReplacement = sourceStringChangeDescription.stringReplacement else {
            assertionFailure("Error: stringReplacement is nil")
            return true
        }
        
        // if we start inline code
        if stringReplacement == UnicodeCharacter.graveAccent.descriptionString() {
            return true
        }
        
        let string = sourceStringChangeDescription.targetString
        
        // if we end an inline code
        if index > 0 && string.firstNonWitespaceBeforeIsAccent(fromPosition: index-1) {
            return true
        }
        
        // if we are the first non-whitespace letter of a line
        // we need synchronous compilation
        if !sourceStringChangeDescription.isOnlyAddedWhitespaces && string.onlyWhitespacesUntilStartOfLine(fromPosition: index) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("requested sync compilation", log: Log.WriterCommon.textStorage, type: .info)
            #endif
            
            return true
        }
        
        let range = NSMakeRange(index, 0)
        
        let lineRange: NSRange = (string as NSString).lineRange(for: range)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("lineRange.location == index -> %@ == %@", log: Log.WriterCommon.textStorage, type: .info, %%lineRange.location, %%index)
        os_log("sourceStringChangeDescription.isOnlyAddedWhitespaces -> %@", log: Log.WriterCommon.textStorage, type: .info, %%sourceStringChangeDescription.isOnlyAddedWhitespaces)
        #endif
        
        // if we are in a header we need synchronous compilation
        if let line = string.substring(lineRange.location, length: lineRange.length) {
            for char in line.utf16 {
                if char == §UnicodeCharacter.numberSign || char == §UnicodeCharacter.graveAccent {
                    return true
                }
            }
            return false
        }
            
        // by default we request synchronous compilation
        return false
    }
}
