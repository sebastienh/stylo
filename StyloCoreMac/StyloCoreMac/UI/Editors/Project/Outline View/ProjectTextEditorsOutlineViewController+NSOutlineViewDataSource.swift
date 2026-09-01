//
//  ProjectTextEditorsOutlineViewController+NSOutlineViewDataSource.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

extension ProjectTextEditorsOutlineViewController: NSOutlineViewDataSource {


    ////////////////////////////////////////////////////////////////////////////////
    //                  MARK: NSOutlineViewDataSource protocol
    ////////////////////////////////////////////////////////////////////////////////
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        guard let textEditorsOutlineItem = item as? TextEditorsOutlineItem else {
            assertionFailure("Error: item is not TextEditorsOutlineItem")
            return false
        }
        
        return textEditorsOutlineItem.itemType == .title
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if item == nil {

            guard let filesOutlineManager = self.filesOutlineManager else {
                assertionFailure("Error: self.filesOutlineManager is nil")
                return "error"
            }
            
            let itemId = filesOutlineManager.selectedItemsArray[index]
            
            #if DEBUG
            for selectedItem in filesOutlineManager.selectedItemsArray {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectedItem id: %@", log: Log.StyloCore.all, type: .debug, %%selectedItem)
                #endif
                
                assert(self.sourceSetManager!.directoryItemManager(withId: itemId) is TextManager)
            }
            if self.sourceSetManager!.directoryItemManager(withId: itemId) is DirectoryManager {
                assertionFailure("Error: item with id: \(itemId) is a directory manager")
            }
            #endif
            
            guard let titleEditorsOutlineItem = self.titleEditorsOutlineItem(for: itemId) else {
                assertionFailure("Error: titleEditorsOutlineItem is nil")
                return "error"
            }
            
            // special case for title since we need to have the value
            // for expanding
            return titleEditorsOutlineItem
        }
        
        guard let textEditorOutlineItem = item as? TextEditorsOutlineItem else {
            assertionFailure("Error: item is not a TextEditorsOutlineItem")
            return 0
        }
        
        switch index {
            
        case 0:
            return TextEditorsOutlineItem(id: textEditorOutlineItem.id, itemType: .editor)
        case 1:
            return TextEditorsOutlineItem(id: textEditorOutlineItem.id, itemType: .add)
        default:
            assertionFailure("Error: unhandled index: \(index)")
            return "error"
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil {
            
            guard let filesOutlineManager = self.filesOutlineManager else {
                assertionFailure("Error: self.filesOutlineManager is nil")
                return 0
            }
        
            return filesOutlineManager.selectedItemsArray.count
        }
        
        guard let textEditorsOutlineItem = item as? TextEditorsOutlineItem else {
            assertionFailure("Error: item is not a TextEditorsOutlineItem")
            return 0
        }
        
        switch textEditorsOutlineItem.itemType {
            
        case .add:
            return 0
        case .editor:
            return 0
        case .title:
            return 2
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        
        return item
    }
    
}
