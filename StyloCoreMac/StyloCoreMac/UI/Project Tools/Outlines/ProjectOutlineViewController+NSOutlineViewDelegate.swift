//
//  ProjectOutlineViewController+NSOutlineViewDelegate.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-25.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

extension ProjectOutlineViewController: NSOutlineViewDelegate {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSOutlineViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {

        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool {
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor viewForTableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        guard let projectOutlineItem = item as? ProjectOutlineItem else {
            assertionFailure("Error: item: \(item) is not ProjectOutlineItem")
            return nil
        }
        
        let userInterfaceItemIdentifier: String = {
            if projectOutlineItem.isTop {
                return "HeaderCell"
            }
            return "DataCell"
        }()
        
        let image: NSImage = {
            if projectOutlineItem is DirectoryManager && !projectOutlineItem.isTop {
                return NSImage(imageLiteralResourceName: NSImage.Name("directory-outline-icon"))
            }
            else {
                return NSImage(imageLiteralResourceName: NSImage.Name("file-outline-icon"))
            }
        }()
        
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: userInterfaceItemIdentifier), owner: self) as! ProjectOutlineCellView
        
        view.imageView?.image = image
        view.projectOutlineItem = projectOutlineItem
        view.filesOutlineManager = self.representedFilesOutlineManager
        view.parentProjectOutlineViewController = self
        view.updateState()
        
        assert(view.textField != nil)
        if let textField = view.textField {
            textField.stringValue = projectOutlineItem.stringValue
        }
        
        return view
    }
    
    /// see http://stackoverflow.com/questions/11127764/how-to-customize-disclosure-cell-in-view-based-nsoutlineview
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        
        return ProjectOutlineTableRowView()
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 24.0
    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        
        // we forbid restoring selection here because if we move the items
        // on top of an not expanded one and it expand in response to the
        // dragging, the items may not have moved yet
        self.shouldRestoreSelection = false
    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        
        self.projectOutlineView.reloadData()
        self.shouldRestoreSelection = true
        self.restoreAllUserSelectedItems()
    }
    
    func outlineView(_ outlineView: NSOutlineView, writeItems items: [Any], to pasteboard: NSPasteboard) -> Bool {

        do {

            let rootItems = items.compactMap({ (item: Any) -> ProjectOutlineItem? in
                return item as? ProjectOutlineItem
            }).map { (projectOutlineItem) -> String in
                return projectOutlineItem.id
            }
            let data = try NSKeyedArchiver.archivedData(withRootObject: rootItems, requiringSecureCoding: false)
            let item = NSPasteboardItem()
            item.setData(data, forType: StyloConstants.DragTypes.DirectoryItem)
            pasteboard.writeObjects([item])
            return true
        }
        catch let error {
            assertionFailure("Error: writeItems to pastboard: \(error) ")
            return false
        }
    }

    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        
        guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return NSDragOperation()
        }
        
        guard sourceSetManager.directoryItemManagerId(from: item) != nil else {
            assertionFailure("Error: self.proposedParentId(from: item) returned nil")
            return NSDragOperation()
        }
        
        return .move
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {

        guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return false
        }
        
        guard let proposedParentId: String = sourceSetManager.directoryItemManagerId(from: item) else {
            assertionFailure("Error: self.proposedParentId(from: item) returned nil")
            return false
        }
        
        let position: (parent: DirectoryManager, index: Int)? = {
            
            if let directory = sourceSetManager.directoryItemManager(withId: proposedParentId) as? DirectoryManager {
                return (directory, index)
            }
            else {
                guard let text = sourceSetManager.directoryItemManager(withId: proposedParentId) as? TextManager else {
                    assertionFailure("Error: if it's not a directory it should be a text...")
                    return nil
                }
                guard let directory = sourceSetManager.directoryItemManager(withId: text.parentID.value) as? DirectoryManager else {
                    assertionFailure("Error: a parent of a text must be a directory...")
                    return nil
                }
                    
                guard let index = directory.indexOfChild(whithId: text.id) else {
                    assertionFailure("Error: an item inside a dirctory must have an index")
                    return nil
                }
                
                return (directory, index+1)
            }
        }()
        
        guard let parent = position?.parent else {
            assertionFailure("Error: parent is nil")
            return false
        }
        
        guard let index = position?.index else {
            assertionFailure("Error: index is nil")
            return false
        }
        
        guard let source = info.draggingSource as? NSOutlineView, source === outlineView else {
            assertionFailure("Error: source is not equal to outlineView")
            return false
        }
        
        guard let itemData = info.draggingPasteboard.pasteboardItems?.first?.data(forType: StyloConstants.DragTypes.StyleType) else {
            assertionFailure("Error: no pasteboard data")
            return false
        }
        
        guard let itemIds = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(itemData) as? [String] else {
            assertionFailure("Error: unable to  unarchive object data")
            return false
        }
        
        do {
            try sourceSetManager.movesItems(withIds: itemIds, proposedParent: parent, proposedInsertionIndex: index)
        }
        catch let error as LocalizedError {
            self.windowController?.notifyUserCritical(with: error)
            return false
        }
        catch {
            return false
        }
        
        return true
    }
    
    func outlineViewItemDidExpand(_ notification: Notification) {
        
        let item = notification.userInfo!["NSObject"] as! ProjectOutlineItem
        
        if shouldNotifyExpandedItem {
            
            assert(self.representedFilesOutlineManager != nil)
            self.representedFilesOutlineManager?.addExpandedItem(with: item.id)
        }
        
        if shouldRestoreSelection {
            
            // we want to restore selections only when the expand is the
            // result of a user action,
            restoreSelections(under: item.id)
        }
    }

    func outlineViewItemDidCollapse(_ notification: Notification) {
        
        let item = notification.userInfo!["NSObject"] as! ProjectOutlineItem
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("outlineViewItemDidCollapse with name: %@", log: Log.StyloCore.all, type: .info, %%item.name.value)
        #endif
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        guard let outlineView = notification.object as? ProjectOutlineView else {
            assertionFailure("Error: notification.object is nil.")
            return
        }
        
        let selectedRowIndexes = outlineView.selectedRowIndexes
        
        if let lastSelectedRowIndexes = self.lastSelectedRowIndexes, lastSelectedRowIndexes == selectedRowIndexes {
            return
        }
        
        guard !self.selectionChangeCausedByCollapse else {
            
            // update the last selected row indexes,
            // because selection did change is might be called twice
            self.lastSelectedRowIndexes = selectedRowIndexes
            return
        }
        
        if shouldNotifySelectedItem {
            
            guard let lastEventSelectionType = self.lastEventSelectionType else {
                assertionFailure("Error: self.lastEventSelectionType is nil")
                return
            }
            
            switch lastEventSelectionType {
            case .replaceSelection:
                replaceSelection(withSelectedRowsIndexes: selectedRowIndexes, in: outlineView)
            case .extendSelection:
                extendSelection(withSelectedRowsIndexes: selectedRowIndexes, in: outlineView)
            case .shrinkSelection:
                shrinkSelection(withSelectedRowsIndexes: selectedRowIndexes, in: outlineView)
            }
        }
        
        // update the last selected row indexes,
        // because selection did change is called twice
        self.lastSelectedRowIndexes = selectedRowIndexes
        self.renameContextualMenuEnabled = selectedRowIndexes.count == 1
    }

    private func shrinkSelection(withSelectedRowsIndexes selectedRowIndexes: IndexSet, in outlineView: NSOutlineView) {
     
        // here we should never remove a selection that is under a
        // collapsed item
        guard let filesOutlineManager = self.representedFilesOutlineManager else {
            assertionFailure("Error: representedFilesOutlineManager is nil.")
            return
        }
        
        guard let lastSelectedItemsIds = self.lastSelectedItemsIds else {
            assertionFailure("Error: self.lastSelectedItemsIds is nil")
            return
        }
        
        let visibleSelectedItemsIds = self.visibleSelectedItemsIds
        let removedItemsIds = lastSelectedItemsIds.subtracting(visibleSelectedItemsIds)
        
        filesOutlineManager.shrinkUserSelectedItems(with: visibleSelectedItemsIds, removedItemsIds: removedItemsIds)
    }
    
    private func extendSelection(withSelectedRowsIndexes selectedRowIndexes: IndexSet, in outlineView: NSOutlineView) {
        
        // here we should never remove a selection that is under a
        // collapsed item
        guard let filesOutlineManager = self.representedFilesOutlineManager else {
            assertionFailure("Error: representedFilesOutlineManager is nil.")
            return
        }
        
        filesOutlineManager.mergeUserSelectedItems(with: self.visibleSelectedItemsIds)
    }
    
    private func replaceSelection(withSelectedRowsIndexes selectedRowIndexes: IndexSet, in outlineView: NSOutlineView) {
        
        // here we should never remove a selection that is under a
        // collapsed item
        guard let filesOutlineManager = self.representedFilesOutlineManager else {
            assertionFailure("Error: representedFilesOutlineManager is nil.")
            return
        }
        
        filesOutlineManager.replaceUserSelectedItems(with: self.visibleSelectedItemsIds)
    }
}


