//
//  Editable+Edit.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-06-14.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

fileprivate enum HeadingRemovalType {
    
    case removedLeadingSpace
    case addingLeadingWhitespace
    case removedRemainingTrailingSpaceBeforeLineFeed
    case removedRemainingTrailingSpaceBeforeNonSpaceCharacter
    case removedLeadingNewline
    case removedRemainingTrailingSpaceAtEndOfFile
    case addingLeadingWhitespaceToCode(startLocation: Int)
}

extension Editable {

    public func doEdit(toChangeDescription currentChangeDescription: SourceStringChangeDescription, forEditorWithId editorId: EditorId, withUndoManager undoManager: StyloUndoManager?, updateAll: Bool) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("doEdit(toChangeDescription: %@, forEditorWithId: %@, withUndoManager: %@)", log: Log.WriterCommon.textStorage, type: .debug, %%previousChangeDescription, %%currentChangeDescription, %%editorId, %%undoManager)
        #endif
    
        undoManager?.registerUndo(EditorUndoCommand(sourceString: self.string, destinationChange: currentChangeDescription, editable: self as! AnyEditable, editorId: editorId))
        
        applyEdit(withChangeDescription: currentChangeDescription, forEditorWithId: editorId, undoManager: undoManager, updateAll: updateAll)
    }
    
    public func applyEdit(withChangeDescription changeDescription: SourceStringChangeDescription, forEditorWithId editorId: EditorId, undoManager: UndoManager?, updateAll: Bool) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyEdit(withChangeDescription: %@, forEditorWithId: %@", log: Log.WriterCommon.textStorage, type: .info, %%changeDescription, %%editorId)
        #endif
        
        guard let stringReplacement = changeDescription.stringReplacement else {
            assertionFailure("Error: replacementString is nil")
            return
        }
        
        updateRange(changeDescription.range, withString: stringReplacement, fromEditorWithId: editorId, updateAll: updateAll)
        updateAttributes(withChangeDescription: changeDescription)
        retoreCursorPositionIfNecessary(changeDescription: changeDescription, forEditorWithId: editorId, undoManager: undoManager)
    }
    
    private func retoreCursorPositionIfNecessary(changeDescription: SourceStringChangeDescription, forEditorWithId editorId: EditorId?, undoManager: UndoManager?) {
        
        if let editorId = editorId {
            
            if undoManager?.isUndoing == true || undoManager?.isRedoing == true {
                
                let endCursorPosition = changeDescription.range.lowerBound + changeDescription.utf16SubsequenceReplacement.count
                
                let renderer: SourceStringAttributesRenderer? = {
                   
                    if let editorManager = self.editorManagers.values[editorId] {
                        return editorManager.renderer
                    }
                    // if the text editor in which the edits where made is not
                    // shown anymore we return the first renderer.
                    return self.editorManagers.values.first?.value.renderer
                }()
                    
                if let renderer = renderer {
                
                    if !renderer.isFirstResponder {
                        renderer.makeFirstResponder()
                    }
                    renderer.setUndoSelectedRange(endCursorPosition.zeroLengthRange)
                }
            }
        }
    }
    
    private func updateRange(_ range: NSRange, withString replacementString: String, fromEditorWithId editorId: EditorId, updateAll: Bool) {
        
        assert(Thread.isMainThread)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateRange(range: %@, withString: \"%@\", fromEditorWithId: %@)", log: Log.WriterCommon.textStorage, type: .info, %%range, %%replacementString, %%editorId)
        #endif
        
        self.string.update(range: range, withString: replacementString)
        
        guard let document = self.editableStore.document.value else {
            assertionFailure("Error: document is nil")
            return
        }
        
        for (id, textStorage) in self.textStorages {
            if updateAll || id != editorId {

                guard let editorManager = self.editorManagers.values[id] else {
                    assertionFailure("Error: editorManager is nil")
                    continue
                }
                
                let renderer = editorManager.renderer
                
                // When editing two times the same files the shown
                // but unedited file could show drawing artifacts
                // stylo #1020
                editorManager.beginBackgroundEditing()
                
                let typingAttributes = renderer.getTypingAttributes()
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("updateRange -> before update for editorId: %@, textstorage: %@", log: Log.WriterCommon.textStorage, type: .info, %%editorId, %%textStorage)
                os_log("updateRange -> typingAttributes: %@", log: Log.WriterCommon.textStorage, type: .info, %%typingAttributes)
                #endif
                
                textStorage.beginEditing()
                let replacementAttributedString = NSAttributedString(string: replacementString, attributes: typingAttributes)
                textStorage.update(range: range, withAttributedString: replacementAttributedString)
                textStorage.endEditing()
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("updateRange -> result for editorId: %@, textstorage: %@", log: Log.WriterCommon.textStorage, type: .info, %%editorId, %%textStorage)
                #endif
                
                guard let visibleRange = renderer.visibleRange else {
                    // not failing for unit test support 
                    return
                }
                
                guard let visibleTopElements = self.visibleTopElements(inVisibleRange: visibleRange) else {
                    // visibleTopElements can be nil if editing stylesheet
                    return
                }
                
                // When editing two times the same files the shown
                // but unedited file could show drawing artifacts
                // stylo #1020
                editorManager.endBackgroundEditing(withVisibleTopElements: visibleTopElements, document: document, visibleCharacterRange: visibleRange)
            }
        }
        
        #if DEBUG
        for (_, textStorage) in self.textStorages {
            assert(textStorage.string == self.string)
        }
        #endif
    }
    
    private func updateAttributes(withChangeDescription changeDescription: SourceStringChangeDescription) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateAttributes(withChangeDescription: %@)", log: Log.WriterCommon.textStorage, type: .info, %%changeDescription)
        #endif
        
        executeCompilation(withChangeDescription: changeDescription)
        for (_, editorManager) in self.editorManagers.values {
            editorManager.ensureCompleteLayout()
        }
    }
}
