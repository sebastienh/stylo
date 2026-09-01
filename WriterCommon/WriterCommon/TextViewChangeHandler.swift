//
//  TextViewChangeHandler.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-31.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import os

public protocol TextViewChangeHandler {
    
    func textViewDidChange(_ notification: Notification)
    
}

extension CSSStyleManager: TextViewChangeHandler {}
extension StylesheetManager: TextViewChangeHandler {}
extension TextManager: TextViewChangeHandler {}

extension TextViewChangeHandler where Self: Editable {
    
    public func textViewDidChange(_ notification: Notification) {
        
        guard let renderer = notification.object as? SourceStringAttributesRenderer else {
            assertionFailure("Error: notification.object is not NSTextView")
            return
        }
        
        guard let editorManager = self.editorManagers.values[renderer.id] else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        guard let changeDescription = editorManager.currentChangeDescription else {
            return
        }
        
        // make sure we don't come back here two times if many SourceStringAttributesRenderer
        // have been registered
        for (_, editorManager) in self.editorManagers.values {
            editorManager.currentChangeDescription = nil
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("textViewDidChange, handling changeDescription: %@", log: Log.WriterCommon.textStorage, type: .info, %%changeDescription)
        #endif
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("textViewDidChange, handling changeDescription: %@", log: Log.WriterCommon.textStorage, type: .info, %%changeDescription)
        os_log("changeDescription.sourceString: %@", log: Log.WriterCommon.textStorage, type: .info, %%changeDescription.targetString.string)
        os_log("textView.textStorage: %@", log: Log.WriterCommon.textStorage, type: .info, %%textView.string)
        #endif
        
        guard let undoManager = self.undoManager as? StyloUndoManager else {
            assertionFailure("Error: self.textDocument?.undoManager is nil")
            return
        }
        
        self.doEdit(toChangeDescription: changeDescription, forEditorWithId: renderer.id, withUndoManager: undoManager, updateAll: false)
        
    }
    
}
