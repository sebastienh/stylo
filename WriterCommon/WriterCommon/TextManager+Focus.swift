//
//  TextManager+Focus.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-07-29.
//  Copyright © 2020 Textually Inc. All rights reserved.
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

extension TextManager {
    
    func subscribeToFocusMode() {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: documentManager is nil")
            return
        }
        
        documentManager.focusMode.subscribe({ [weak self](focusMode) in
            self?.handleFocusModeChange(focusMode)
        }, observer: self)
    }
    
    func subscribeToFocusedEditorId() {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: documentManager is nil")
            return
        }
        
        documentManager.lastFocusedEditorChangeEvent.subscribe({ [weak self](focusedEditorId) in
           self?.handleFocusedEditorIdChange(focusedEditorId)
       }, observer: self)
    }
    
    private func handleFocusedEditorIdChange(_ changeEvent: FocusedEditorChangeEvent?) {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: documentManager is nil")
            return
        }
        
        guard documentManager.focusMode.value != .disabled else {
            return
        }
        
        let visibleRanges = self.visibleRanges
        
        for (editorId, _) in self.editorManagers.values {
            
            guard let _visibleRange = visibleRanges[editorId] else {
                assertionFailure("Error: _visibleRange is nil")
                continue
            }
            
            guard let visibleRange = _visibleRange else {
                assertionFailure("Error: visibleRange is nil")
                continue
            }
            
            if let changeEvent = changeEvent, changeEvent.editorId == editorId {
            
                switch changeEvent.reason {
                case .edit:
                    // we should remember that we are not in the serialCompilation
                    // queue so the document may changed. This is the reason why we
                    // should not handle FocusedEditorChangeEvents here. Moreover, the focus
                    // is already handled at compilation time.
                    break
                case .moveCursor: fallthrough
                    
                case .mouseDown:
                    self.handleSelectionChange(forEditorWithId: editorId, visibleRange: visibleRange)
                }
            }
            else {
                self.handleSelectionChange(forEditorWithId: editorId, visibleRange: visibleRange)
            }
        }
    }
    
    private func handleFocusModeChange(_ focusMode: FocusMode) {
        
        self.applyFocusMode(focusMode)
    }
    
    public func clearFocusAttributes(forEditorWithId editorId: EditorId) {
        
        guard let editorManager = self.editorManagers.values[editorId] else {
            // editorManager can be nil at startup
            return
        }
        
        editorManager.clearFocusAttributes()
    }
    
    public func handleSelectionChange(forEditorWithId editorId: EditorId, visibleRange: NSRange) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleSelectionChange(forEditorWithId: %@)", log: Log.WriterCommon.all, type: .info, %%editorId)
        #endif
        
        updateFocusAttributes(forEditorWithId: editorId, inVisibleRange: visibleRange)
    }
    
    /// Method that allows to change the focus mode.
    public func applyFocusMode(_ focusMode: FocusMode) {
        for (editorId, _) in self.editorManagers.values {
            self.applyFocusMode(focusMode, toEditorWithId: editorId)
        }
        
        #if DEBUG
        if focusMode != .disabled {
            for (_, editorManager) in self.editorManagers.values {
                assert(editorManager.styledStoreManager.styledStore.focusMode.value != nil)
            }
        }
        #endif
    }
    
    func unsubscribeFromFocusMode() {
        
        self.documentManager?.focusMode.unsubscribe(observer: self)
    }
    
    func unsubscribeFromClearFocusRequest() {
        
        self.documentManager?.clearFocusRequest.unsubscribe(observer: self)
    }
    
    func unsubscribeFromFocusedEditorId() {
        
        self.documentManager?.lastFocusedEditorChangeEvent.unsubscribe(observer: self)
    }
    
    /// This method set the focus mode but does not apply it.
    func setFocusMode(_ focusMode: FocusMode, toEditorWithId editorId: EditorId) {
        
        guard let editorManager = self.editorManagers.values[editorId] else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        editorManager.changeFocusMode(focusMode)
    }
    
    /// This method set the focus mode and applies it
    /// if it is not disabled.
    private func applyFocusMode(_ focusMode: FocusMode, toEditorWithId editorId: EditorId) {
        
        guard let editorManager = self.editorManagers.values[editorId] else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        guard let visibleRange = editorManager.visibleRange else {
            assertionFailure("Error: visibleRange is nil")
            return
        }
        
        editorManager.changeFocusMode(focusMode)
        if focusMode != .disabled {
            self.updateFocusAttributes(forEditorWithId: editorId, inVisibleRange: visibleRange)
        }
        else {
            editorManager.clearFocusAttributes()
        }
    }
    
    private func updateFocusAttributes(forEditorWithId editorId: EditorId, inVisibleRange visibleRange: NSRange) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateFocusAttributes(forEditorWithId: %@)", log: Log.WriterCommon.all, type: .info, %%editorId)
        #endif
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: documentManager is nil")
            return
        }
        
        guard documentManager.focusMode.value != .disabled else {
            self.clearFocusAttributes(forEditorWithId: editorId)
            return
        }
        
        guard let editorManager = self.editorManagers.values[editorId] else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        guard let topElements = self.topElements(around: visibleRange) else {
            assertionFailure("Error: topElements is nil")
            return
        }
        
        guard let document = self.document.value else {
            assertionFailure("Error: document is nil")
            return
        }
        
        let topElementsRange = self.range(fromTopElement: topElements)
        let refocusedRange = topElementsRange ?? visibleRange
        
        editorManager.updateFocusAttributes(forVisibleTopElements: topElements, document: document, originStringAction: StringAction.refocus(range: refocusedRange))
    }
    
    private func updateFocusAttributesAsync(forEditorWithId editorId: EditorId) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateFocusAttributes(forEditorWithId: %@)", log: Log.WriterCommon.all, type: .info, %%editorId)
        #endif
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: documentManager is nil")
            return
        }
        
        guard documentManager.focusMode.value != .disabled else {
            self.clearFocusAttributes(forEditorWithId: editorId)
            return
        }
        
        guard let document = self.document.value else {
            assertionFailure("Error: document is nil")
            return
        }
        
        guard let editorManager = self.editorManagers.values[editorId] else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        firstly {
            return editorManager.visibleRangeAsync
        }.then { visibleRange -> Void in
            
            guard let visibleRange = visibleRange else {
                assertionFailure("Error: visibleRange is nil")
                return
            }
            
            guard let topElements = self.topElements(around: visibleRange) else {
                assertionFailure("Error: topElements is nil")
                return
            }
            
            let topElementsRange = self.range(fromTopElement: topElements)
            let refocusedRange = topElementsRange ?? visibleRange
            
            editorManager.updateFocusAttributes(forVisibleTopElements: topElements, document: document, originStringAction: StringAction.refocus(range: refocusedRange))
        }
    }
    
    private func range(fromTopElement topElements: ContiguousArray<Element>) -> NSRange? {
        
        guard let firstElement = topElements.first else {
            return nil
        }
        
        guard let firstElementRange = firstElement.range else {
            assertionFailure("Error: firstElementRange is nil")
            return nil
        }
        
        var range = firstElementRange
        
        for topElement in topElements {
            
            guard let elementRange = topElement.range else {
                assertionFailure("Error: elementRange is nil")
                continue
            }
            
            range.formUnion(elementRange)
        }
        
        return range
    }
    
    
    private func topElements(around range: NSRange) -> ContiguousArray<Element>? {
        
        guard let actionResult: ActionResult = dispatcher.sync(store: markdownDocumentStore, action: DocumentStoreAction.topElementsAroundRange(range: range).syncAction) else {
            assertionFailure("Error: actionResult is nil")
            return nil
        }
        
        guard let documentStoreActionResult: DocumentStoreActionResult = actionResult as? DocumentStoreActionResult else {
            assertionFailure("Error: actionResult is not DocumentStoreActionResult")
            return nil
        }
        
        return documentStoreActionResult.topElementsAroundRange
    }
    
    func handleScroll(forEditorWithId editorId: EditorId) {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: documentManager is nil")
            return
        }
        
        guard documentManager.focusMode.value != .disabled else {
            return
        }
        
        clearFocusAttributes(forEditorWithId: editorId)
    }
    
}
