//
//  FilesOutlineManager+TextManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-11-19.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web

extension FilesOutlineManager {
    
    public func addTextManagerAndSelectIt(afterItemWithId itemId: String) {
        
        guard let textManager = addTextManager(afterItemWithId: itemId) else {
            assertionFailure("Error: unable to create text manager")
            return
        }
        
        self.select(textManager: textManager, afterItemWithId: itemId)
    }
    
    @discardableResult
    public func addTextManager(afterItemWithId itemId: String) -> TextManager? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("addTextManagerAndSelectIt(afterItemWithId: %@)", log: Log.WriterCommon.all, type: .info, %%itemId)
        #endif
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        guard let previousTextManager = sourceSetManager.directoryItemManager(withId: itemId) as? TextManager else {
            assertionFailure("Error: item with id: \(itemId) is nil or not TextManager")
            return nil
        }
        
        guard let parentDirectoryManager = sourceSetManager.directoryItemManager(withId: previousTextManager.parentID.value) as? DirectoryManager else {
            assertionFailure("Error: previousTextManager.parentID: \(previousTextManager.parentID) is not a directory")
            return nil
        }
        
        guard let textManager = sourceSetManager.createEmptyTextManager(under: parentDirectoryManager.id) else {
            assertionFailure("Error: no text manager created")
            return nil
        }
        
        do {
            sourceSetManager.addDirectoryItemManager(textManager, withId: textManager.id, afterItemWithId: itemId)
            try sourceSetManager.putItem(textManager, afterItemWithId: itemId, inParentWithId: parentDirectoryManager.id)
            self.documentManager.document?.updateChangeCount(.changeDone)
            return textManager
        }
        catch let error {
            assertionFailure("Error: \(error)")
        }
        return nil
    }
    
    public func select(textManager: TextManager, afterItemWithId itemId: String) {
        
        // select the element only if the parent is not part of the
        // final computed selection
        if !self.isItemChildOfAUserSelectedItem(textManager) {
            self.insertItemInUserSelection(textManager.id, afterItemWithId: itemId)
        }
        else {
            // otherwise we need to force an update of the selected items
            // calculation for it to be included in the selected items
            self.updateSelectedItems()
        }
    }
}
