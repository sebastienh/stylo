//
//  FilesOutlineManager+Focus.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-11-16.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web

extension FilesOutlineManager {
    
    func setFocusMode(_ focusMode: FocusMode) {
        
        guard let sourceSetManager = self.sourceSetManager else {
            let errorText = "Error: self.sourceSetManager is nil"
            assertionFailure(errorText)
            return
        }
        
        for textId in self.selectedTextItems.values {
            
            guard let editorId = self.editorIds[textId] else {
                assertionFailure("Error: self.editorIds[\(textId)] is nil")
                continue
            }
            
            guard let itemManager = sourceSetManager.directoryItemManager(withId: textId) else {
                assertionFailure("Error: item manager is nil for id: \(textId)")
                continue
            }
            
            guard let textManager = itemManager as? TextManager else {
                assertionFailure("Error: itemManager is not TextManager")
                continue
            }
            
            textManager.setFocusMode(focusMode, toEditorWithId: editorId)
        }
    }
    
    func disableFocus() {
        
        guard let sourceSetManager = self.sourceSetManager else {
            let errorText = "Error: self.sourceSetManager is nil"
            assertionFailure(errorText)
            return
        }
        
        for textId in self.selectedTextItems.values {
            
            guard let editorId = self.editorIds[textId] else {
                assertionFailure("Error: self.editorIds[\(textId)] is nil")
                continue
            }
            
            guard let itemManager = sourceSetManager.directoryItemManager(withId: textId) else {
                assertionFailure("Error: item manager is nil for id: \(textId)")
                continue
            }
            
            guard let textManager = itemManager as? TextManager else {
                assertionFailure("Error: itemManager is not TextManager")
                continue
            }
            
            guard let editorManager = textManager.editorManagers.values[editorId] else {
                assertionFailure("Error: editorManager is nil")
                continue
            }
            
            editorManager.disableFocus()
        }
    }
    
    func requestClearFocus() {
        
        // do not clear focus attributes at loading time
        guard !self.documentManager.loading.value else {
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleScroll() in FilesOutlineManager with id: %@", log: Log.WriterCommon.all, type: .debug, %%self.id)
        #endif
        
        guard self.documentManager.focusMode.value != .disabled else {
            return
        }
        
        // if we are scrolling a files outline manager
        // we need to clear the focus in this files outline too, that's
        // why here we don't pass our own id.
        self.documentManager.clearFocusRequested(fromFilesOutlineWithId: self.id)
    }
    
    func subscribeToClearFocusRequest() {
        
        self.documentManager.clearFocusRequest.subscribe({ [weak self](filesOutlineId) in
            self?.handleDocumentClearFocusRequest(fromFilesOutlineWithId: filesOutlineId)
        }, observer: self)
    }
    
    func handleDocumentClearFocusRequest(fromFilesOutlineWithId filesOutlineId: FileOutlineId?) {
        
        // do not clear focus attributes at loading time
        guard !self.documentManager.loading.value else {
            return
        }
        
        guard filesOutlineId != self.id else {
            // we dont handle request made by ourself
            return
        }

        guard let sourceSetManager = self.sourceSetManager else {
            let errorText = "Error: self.sourceSetManager is nil"
            assertionFailure(errorText)
            return
        }
        
        for textId in self.selectedTextItems.values {
            
            guard let editorId = self.editorIds[textId] else {
                // could be nil
                continue
            }
            
            guard let itemManager = sourceSetManager.directoryItemManager(withId: textId) else {
                assertionFailure("Error: item manager is nil for id: \(textId)")
                continue
            }
            
            guard let textManager = itemManager as? TextManager else {
                assertionFailure("Error: itemManager is not TextManager")
                continue
            }
            
            textManager.handleScroll(forEditorWithId: editorId)
        }
    }
    
}
