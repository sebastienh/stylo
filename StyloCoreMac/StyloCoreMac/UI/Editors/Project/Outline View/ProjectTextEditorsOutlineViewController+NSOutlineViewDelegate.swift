//
//  ProjectTextEditorsOutlineViewController+NSOutlineViewDelegate.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

extension ProjectTextEditorsOutlineViewController: NSOutlineViewDelegate {
    
    //////////////////////////////////////////////////////////////////////////////////
    //              MARK: NSOutlineViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        
        guard let textEditorsOutlineItem = item as? TextEditorsOutlineItem else {
            assertionFailure("Error: item is not TextEditorsOutlineItem")
            return false
        }
        
        return textEditorsOutlineItem.itemType == .title
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        
        guard let textEditorOutlineItem = item as? TextEditorsOutlineItem else {
            assertionFailure("Error: item is not TextEditorsOutlineItem")
            return nil
        }
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        guard let textManager = sourceSetManager.directoryItemManager(withId: textEditorOutlineItem.id) as? TextManager else {
            assertionFailure("Error: no text manager with id: \(textEditorOutlineItem.id)")
            return nil
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return nil
        }
    
        let editorId = filesOutlineManager.createOrGetEditorId(forTextId: textManager.id)
        
        return ProjectTextEditorsOutlineRowView(textManager: textManager, editorId: editorId)
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor viewForTableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        guard let textEditorsOutlineItem = item as? TextEditorsOutlineItem else {
            assertionFailure("Error: item is not TextEditorsOutlineViewItem")
            return nil
        }
        
        switch textEditorsOutlineItem.itemType {
        case .add:
            
            guard let addOutlineCellView = self.projectTextEditorsOutlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "add"), owner: self) as? AddTextOutlineCellView else {
                assertionFailure("Error: addOutlineCellView built view is nil")
                return nil
            }
            
            addOutlineCellView.documentManager = self.documentManager
            addOutlineCellView.textManagerId = textEditorsOutlineItem.id
            addOutlineCellView.textEditorsOutlineItem = textEditorsOutlineItem
            addOutlineCellView.identifier = nil
            return addOutlineCellView
            
        case .editor:
            
            guard let textEditorCellView = self.textEditorCellView(for: textEditorsOutlineItem) else {
                assertionFailure("Error: textEditorCellView for id: \(textEditorsOutlineItem.id) is nil")
                return nil
            }
            return textEditorCellView
            
        case .title:
            
            guard let titleOutlineCellView = self.titleOutlineCellView(for: textEditorsOutlineItem) else {
                assertionFailure("Error: textEditorCellView for id: \(textEditorsOutlineItem.id) is nil")
                return nil
            }
            return titleOutlineCellView
        }
    }

    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        
        let defaultWidth: CGFloat = 40.0
        
        guard let textEditorsOutlineViewItem = item as? TextEditorsOutlineItem else {
            assertionFailure("Error: item is not TextEditorsOutlineViewItem")
            return defaultWidth
        }
        
        switch textEditorsOutlineViewItem.itemType {
        case .add:
            return 48.0//0.5
        case .editor:
            guard let textEditorCellView = self.textEditorCellView(for: textEditorsOutlineViewItem) else {
                assertionFailure("Error: no textEditorCellView for id: \(textEditorsOutlineViewItem.id)")
                return defaultWidth
            }
            guard let textEditor = textEditorCellView.textEditor else {
                assertionFailure("Error: textEditor is nil")
                return defaultWidth
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Returning editor height: %@", log: Log.StyloCore.all, type: .debug, %%textEditor.intrinsicContentSize.height)
            #endif
            return textEditor.intrinsicContentSize.height
            
        case .title:
            return 25.0
        }
    }
}
