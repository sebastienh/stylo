//
//  ProjectOutlineViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-25.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import Foundation
import os

class ProjectOutlineViewController: NSViewController, ProjectToolTabItemViewController {
    
    private let groupDirectoryMenuItemIdentifier = NSUserInterfaceItemIdentifier("GroupDirectoryMenuItem")
    private let groupTextMenuItemIdentifier = NSUserInterfaceItemIdentifier("GroupTextMenuItem")
    
    @objc dynamic var renameContextualMenuEnabled: Bool = false
    
    @IBOutlet var addItemButton: NSPopUpButton?
    
    @IBOutlet var deleteItemButton: MacDisableableButton?
    
    @IBOutlet var contextualMenu: NSMenu!
    
    @IBOutlet var projectOutlineView: ProjectOutlineView! {
        didSet {
            projectOutlineView.registerForDraggedTypes([StyloConstants.DragTypes.DirectoryItem])
        }
    }
    
    var documentManager: DocumentManager? {
        assert(self.representedFilesOutlineManager != nil)
        return self.representedFilesOutlineManager?.documentManager
    }
    
    var sourceSetManager: SourceSetManager? {
        
        return self.documentManager?._sourceSetManager.value
    }
    
    var representedFilesOutlineManager: FilesOutlineManager? {
        return self.representedObject as? FilesOutlineManager
    }
    
    override var representedObject: Any? {
        willSet {
            unsubscribeToFilesOutlineManager()
        }
    }
    
    @objc dynamic var allowsAddingDirectoryAndTexts: Bool = false
    
    var lastEventSelectionType: ProjectOutlineView.EventSelectionType?
    
    var shouldNotifyExpandedItem: Bool = true
    
    var shouldNotifySelectedItem: Bool = true
    
    var shouldRestoreSelection: Bool = true
    
    var selectionChangeCausedByCollapse: Bool = false
    
    var lastSelectedRowIndexes: IndexSet? {
        didSet {
            lastSelectedItemsIds = Set<String>(visibleSelectedItemsIds)
        }
    }
    
    var lastSelectedItemsIds: Set<String>?
    
    var visibleSelectedItemsIds: [String] {
        
        var visibleSelectedItemsIds: [String] = []
        let selectedRowIndexes = self.projectOutlineView.selectedRowIndexes
        
        for index in selectedRowIndexes {
            if let item = self.projectOutlineView.item(atRow: index) as? ProjectOutlineItem {
                visibleSelectedItemsIds.append(item.id)
            }
            else {
                assertionFailure("Error: item at row: \(index) is nil.")
            }
        }
        return visibleSelectedItemsIds
    }
    
    var visibleSelectedItemsByParent: OrderedDictionary<String, [DirectoryItemManager]> {
        
        var visibleSelectedItemsIndexesByParent: OrderedDictionary<String, [DirectoryItemManager]> = [:]
        let selectedRowIndexes = self.projectOutlineView.selectedRowIndexes
        
        for index in selectedRowIndexes {
            if let item = self.projectOutlineView.item(atRow: index) as? DirectoryItemManager {
                if visibleSelectedItemsIndexesByParent[item.parentID.value] == nil {
                    visibleSelectedItemsIndexesByParent[item.parentID.value] = []
                }
                visibleSelectedItemsIndexesByParent[item.parentID.value]!.append(item)
            }
            else {
                assertionFailure("Error: item at row: \(index) is nil.")
            }
        }
        return visibleSelectedItemsIndexesByParent
    }
    
    private var initialized: Bool = false
    
    private var clickedItem: ProjectOutlineItem? {
        
        let clickedRow = self.projectOutlineView.clickedRow
        
        guard clickedRow != -1 else {
            assertionFailure("Error: clickedRow is -1")
            return nil
        }
        
        return self.projectOutlineView.item(atRow: clickedRow) as? ProjectOutlineItem
    }
    
    private var lastVisibleSelectedItem: DirectoryItemManager? {
        
        guard let lastVisibleSelectedItemId = self.visibleSelectedItemsIds.last else {
            assertionFailure("Error: no item selected")
            return nil
        }
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        return sourceSetManager.directoryItemManager(withId: lastVisibleSelectedItemId)
    }
    
    @IBAction func removeUserSelectedItems(_ sender: Any?) {
        
        self.shouldNotifySelectedItem = false
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        do {
            
            let visibleSelectedItemsIds = self.visibleSelectedItemsIds
            projectOutlineView.beginUpdates()
            for (parentId, items) in self.visibleSelectedItemsByParent.reversed() {
                guard let parentDirectory = sourceSetManager.directoryItemManager(withId: parentId) as? DirectoryManager else {
                    assertionFailure("Error: parentDirectory is nil")
                    continue
                }
                var indexes: [Int] = []
                for item in items {
                    guard let index = sourceSetManager.indexInParentOfItem(item) else {
                        assertionFailure("Error: index in parent is nil")
                        continue
                    }
                    indexes.append(index)
                }
                self.projectOutlineView.removeItems(at: IndexSet(indexes), inParent: parentDirectory, withAnimation: .effectFade)
            }
            projectOutlineView.endUpdates()
            try documentManager.removeVisibleItems(visibleSelectedItemsIds)
        }
        catch let error as LocalizedError {
            assertionFailure("Error: \(error)")
            self.windowController?.notifyUserInformation(with: error)
        }
        catch {
            assertionFailure("Error: \(error)")
        }
        
        self.shouldNotifySelectedItem = true
    }
    
    @IBAction func renameRightClickedItem(_ sender: Any?) {
        
        // to force all edited field commit
        self.view.window?.makeFirstResponder(nil)
        
        guard let clickedItem = self.clickedItem else {
            assertionFailure("Error: clickedItem is nil")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            
            self?.setEditMode(to: clickedItem)
            // for a unknown reason mouse events are not received anymore
            // if we don't do this.
            self?.view.window?.becomeKey()
        }
    }
    
    @IBAction func removeRightClickedItem(_ sender: Any?) {
        
        shouldNotifySelectedItem = false
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let item = self.clickedItem else {
            assertionFailure("Error: item is nil")
            return
        }
        
        if visibleSelectedItemsIds.contains(item.id) {
            self.removeUserSelectedItems(self)
        }
        else {
        
            do {
                
                if let textManager = item as? TextManager {
                    
                    guard let sourceSetManager = self.sourceSetManager else {
                        assertionFailure("Error: self.sourceSetManager is nil")
                        return
                    }
                    
                    guard let indexInParent = sourceSetManager.indexInParentOfItem(textManager) else {
                         assertionFailure("Error: indexInParent is nil")
                         return
                    }
                    
                    let deletedUserSelectedItems = try documentManager.removeItem(item, visibleItems: visibleSelectedItemsIds)
                    
                    if deletedUserSelectedItems {
                        projectOutlineView.beginUpdates()
                        self.projectOutlineView.removeItems(at: IndexSet([indexInParent]), inParent: textManager.parent, withAnimation: .effectFade)
                        projectOutlineView.endUpdates()
                    }
                }
                else if let directoryManager = item as? DirectoryManager {
                    
                    guard let sourceSetManager = self.sourceSetManager else {
                        assertionFailure("Error: self.sourceSetManager is nil")
                        return
                    }
                    
                    guard let indexInParent = sourceSetManager.indexInParentOfItem(directoryManager) else {
                         assertionFailure("Error: indexInParent is nil")
                         return
                    }
                    
                    let deletedUserSelectedItems = try documentManager.removeItem(item, visibleItems: visibleSelectedItemsIds)
                    
                    if deletedUserSelectedItems {
                        projectOutlineView.beginUpdates()
                        self.projectOutlineView.removeItems(at: IndexSet([indexInParent]), inParent: directoryManager.parent, withAnimation: .effectFade)
                        projectOutlineView.endUpdates()
                    }
                }
            }
            catch let error as LocalizedError {
                assertionFailure("Error: \(error)")
                self.windowController?.notifyUserInformation(with: error)
            }
            catch {
                assertionFailure("Error: \(error)")
            }
        }
        shouldNotifySelectedItem = true
    }
    
    @IBAction func addGroup(_ sender: Any?) {
        
        // to force all edited field commit
        self.view.window?.makeFirstResponder(nil)
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let directoryManager = documentManager.addUntitledGroup() else {
            assertionFailure("Error: no filesGroupManager returned")
            return
        }
        self.projectOutlineView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
            
            self?.setEditMode(to: directoryManager)
            // for a unknown reason mouse events are not received anymore
            // if we don't do this.
            self?.view.window?.becomeKey()
        }
    }
    
    @IBAction func addDirectoryUnderRightClickedItem(_ sender: Any?) {
    
        // to force all edited field commit
        self.view.window?.makeFirstResponder(nil)
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let item = self.clickedItem else {
            assertionFailure("Error: item is nil")
            return
        }
        
        guard let directoryItemManager = item as? DirectoryItemManager else {
            assertionFailure("Error: item is not DirectoryItemManager")
            return
        }
        
        if let clickedDirectoryManager = directoryItemManager as? DirectoryManager {
        
            let itemsCount = clickedDirectoryManager.itemsCount
            self.projectOutlineView.expandItem(clickedDirectoryManager)
            guard let directoryManager = documentManager.addUntitledDirectory(atEndOfDirectory: clickedDirectoryManager) else {
                assertionFailure("Error: no textManager returned")
                return
            }
            addItem(directoryManager, atIndex: itemsCount, underDirectory: clickedDirectoryManager)
        }
        else if let clickedTextManager = item as? TextManager {
            guard let directoryManager = documentManager.addUntitledDirectoryAfter(clickedTextManager, directlyAfter: true) else {
                assertionFailure("Error: no directoryManager returned")
                return
            }
            
            self.addItem(directoryManager, after: clickedTextManager)
        }
    }
    
    @IBAction func addTextUnderRightClickedItem(_ sender: Any?) {
        
        // to force all edited field commit
        self.view.window?.makeFirstResponder(nil)
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }

        guard let item = self.clickedItem else {
            assertionFailure("Error: item is nil")
            return
        }
        
        if let directoryManager = item as? DirectoryManager {
        
            let itemsCount = directoryManager.itemsCount
            self.projectOutlineView.expandItem(directoryManager)
            guard let textManager = documentManager.addUntitledText(atEndOfDirectory: directoryManager) else {
                assertionFailure("Error: no textManager returned")
                return
            }
            addItem(textManager, atIndex: itemsCount, underDirectory: directoryManager)
        }
        else if let clickedTextManager = item as? TextManager {
            guard let textManager = documentManager.addUntitledTextAfter(clickedTextManager, directlyAfter: true) else {
                assertionFailure("Error: no textManager returned")
                return
            }
            self.addItem(textManager, after: clickedTextManager)
        }
    }
    
    @IBAction func addDirectory(_ sender: Any?) {
    
        // to force all edited field commit
        self.view.window?.makeFirstResponder(nil)
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let lastVisibleSelectedItem = self.lastVisibleSelectedItem else {
            assertionFailure("Error: self.lastVisibleSelectedItem is nil")
            return
        }
        
        if let selectedDirectoryManager = lastVisibleSelectedItem as? DirectoryManager {
        
            let itemsCount = selectedDirectoryManager.itemsCount
            self.projectOutlineView.expandItem(selectedDirectoryManager)
            guard let directoryManager = documentManager.addUntitledDirectory(atEndOfDirectory: selectedDirectoryManager) else {
                assertionFailure("Error: no textManager returned")
                return
            }
            addItem(directoryManager, atIndex: itemsCount, underDirectory: selectedDirectoryManager)
        }
        else {
            guard let directoryManager = documentManager.addUntitledDirectoryAfter(lastVisibleSelectedItem, directlyAfter: true) else {
                assertionFailure("Error: no directoryManager returned")
                return
            }
            
            self.addItem(directoryManager, after: lastVisibleSelectedItem)
        }
    }
    
    @IBAction func addText(_ sender: Any?) {
        
        // to force all edited field commit
        self.view.window?.makeFirstResponder(nil)
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let lastVisibleSelectedItem = self.lastVisibleSelectedItem else {
            assertionFailure("Error: lastVisibleSelectedItem is nil")
            return
        }
        
        if let directoryManager = lastVisibleSelectedItem as? DirectoryManager {
        
            let itemsCount = directoryManager.itemsCount
            self.projectOutlineView.expandItem(directoryManager)
            guard let textManager = documentManager.addUntitledText(atEndOfDirectory: directoryManager) else {
                assertionFailure("Error: no textManager returned")
                return
            }
            addItem(textManager, atIndex: itemsCount, underDirectory: directoryManager)
        }
        else {
            guard let textManager = documentManager.addUntitledTextAfter(lastVisibleSelectedItem, directlyAfter: true) else {
                assertionFailure("Error: no textManager returned")
                return
            }
            self.addItem(textManager, after: lastVisibleSelectedItem)
        }
    }
    
    @IBAction func addDirectoryAfter(_ sender: Any?) {
        
        // to force all edited field commit
        self.view.window?.makeFirstResponder(nil)
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let directoryManager = documentManager.addUntitledDirectory(directlyAfter: true) else {
            assertionFailure("Error: no directoryManager returned")
            return
        }

        self.projectOutlineView.reloadData()
        self.expandAncestors(ofItemWithId: directoryManager.id)
        DispatchQueue.main.async { [weak self] in
            self?.setEditMode(to: directoryManager)
            // for a unknown reason mouse events are not received anymore
            // if we don't do this.
            self?.view.window?.becomeKey()
        }
    }
    
    @IBAction func addTextAfter(_ sender: Any?) {
        
        // to force all edited field commit
        self.view.window?.makeFirstResponder(nil)
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let textManager = documentManager.addUntitledText(directlyAfter: true) else {
            assertionFailure("Error: no textManager returned")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.setEditMode(to: textManager)
            // for a unknown reason mouse events are not received anymore
            // if we don't do this.
            self?.view.window?.becomeKey()
        }
    }
    
    @IBAction func showHideItem(_ sender: Any?) {
        
        guard let showHideButton = sender as? NSButton else {
            assertionFailure("Error: sender: \(String(describing: sender)) is not NSButton")
            return
        }
        
        guard let tableCellView = showHideButton.superview as? GroupProjectOutlineCellView else {
            assertionFailure("Error: showHideButton parent: \(String(describing: sender)) is not ProjectOutlineCellView")
            return
        }
        
        let projectOutlineItem = tableCellView.projectOutlineItem
        
        assert(projectOutlineItem != nil, "Error: projectOutlineItem is nil")
        self.shouldNotifySelectedItem = false
        if let projectOutlineItem = projectOutlineItem {
            if tableCellView.isExpanded {
                self.projectOutlineView.collapseItem(projectOutlineItem)
                representedFilesOutlineManager?.removeExpandedItem(with: projectOutlineItem.id)
                tableCellView.isExpanded = false
                
            }
            else {
                self.projectOutlineView.expandItem(projectOutlineItem)
                representedFilesOutlineManager?.addExpandedItem(with: projectOutlineItem.id)
                tableCellView.isExpanded = true
            }
        }
        self.shouldNotifySelectedItem = true 
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if !initialized {
            self.restorePersistedState()
            subscribeToSourceSetManager()
            subscribeToDocumentManager()
            initialized = true
        }
        else {
            self.restorePersistedState()
        }
    }

    func disableUserInteractions() {
        
        deleteItemButton?.disableUserInteractions()
        assert(self.addItemButton != nil)
        self.addItemButton?.isEnabled = false
        
        disableSelection()
    }
    
    func enableUserInteractions() {
        
        // the addItemButton can not be disabled
        self.addItemButton?.isEnabled = true
        self.deleteItemButton?.enableUserInteractions()
        enableSelection()
    }
    
    private func disableSelection() {
        
        self.projectOutlineView.isEnabled = false
    }
    
    private func enableSelection() {
        
        self.projectOutlineView.isEnabled = true
    }
    
    private func addItem(_ item: ProjectOutlineItem, atIndex index: Int, underDirectory directoryItem: DirectoryManager) {
    
         projectOutlineView.beginUpdates()
         projectOutlineView.insertItems(at: IndexSet([index]), inParent: directoryItem, withAnimation: .slideDown)
         projectOutlineView.endUpdates()

         DispatchQueue.main.async { [weak self] in
             self?.setEditMode(to: item)
             // for a unknown reason mouse events are not received anymore
             // if we don't do this.
             self?.view.window?.becomeKey()
         }
    }
    
    private func addItem(_ item: ProjectOutlineItem, after previousItem: DirectoryItemManager) {
    
         guard let sourceSetManager = self.sourceSetManager else {
             assertionFailure("Error: self.sourceSetManager is nil")
             return
         }
         
         guard let parent = sourceSetManager.directoryItemManager(withId: previousItem.parentID.value) else {
             assertionFailure("Error: parent is nil")
             return
         }
         
         guard let indexInParent = sourceSetManager.indexInParentOfItem(previousItem) else {
             assertionFailure("Error: indexInParent is nil")
             return
         }
        
         projectOutlineView.beginUpdates()
         projectOutlineView.insertItems(at: IndexSet([indexInParent+1]), inParent: parent, withAnimation: .slideDown)
         projectOutlineView.endUpdates()

         DispatchQueue.main.async { [weak self] in
             self?.setEditMode(to: item)
             // for a unknown reason mouse events are not received anymore
             // if we don't do this.
             self?.view.window?.becomeKey()
         }
    }
    
    private func restorePersistedState() {
        
        guard let filesOutlineManager = self.representedFilesOutlineManager else {
            assertionFailure("Error: representedFilesOutlineManager is nil")
            return
        }
        
        if !filesOutlineManager.isSubscribedToExpandedItems(observer: self) {
            subscribeToFilesOutlineManager()
        }
        
        // we dont want to trigg selection restoration while restoring
        // expanded items
        self.projectOutlineView.reloadData()
        self.shouldRestoreSelection = false
        self.restoreExpandedItems()
        self.shouldRestoreSelection = true
        self.restoreAllUserSelectedItems()
    }

    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 2 {
            self.nextResponder?.mouseDown(with: event)
        }
        else {
            super.mouseDown(with: event)
        }
    }
    
    func removeUnselectedItems() {
    
        self.shouldNotifySelectedItem = false
        
        guard let filesOutlineManager = self.representedFilesOutlineManager else {
            assertionFailure("Error: self.representedFilesOutlineManager  is nil")
            return
        }
        
        let selectedItemsSet = Set<String>(filesOutlineManager.userSelectedItemsIdsArray)
        
        for selectedRowIndex in self.projectOutlineView.selectedRowIndexes {
        
            guard let item = self.projectOutlineView.item(atRow: selectedRowIndex) as? DirectoryItemManager else {
                assertionFailure("Error: item is nil")
                continue
            }
            
            if !selectedItemsSet.contains(item.id) {
                self.projectOutlineView.deselectRow(selectedRowIndex)
            }
        }
        
        self.shouldNotifySelectedItem = true
    }
        
    func restoreSelections(under itemId: String) {
     
        if shouldRestoreSelection {
        
            guard let filesOutlineManager = self.representedFilesOutlineManager else {
                assertionFailure("Error: self.representedFilesOutlineManager  is nil")
                return
            }
            
            var existingSelection = [Int]()
            let selectedItemsSet = Set<String>(filesOutlineManager.userSelectedItemsIdsArray)
            selections(under: itemId, selectedItemsSet: selectedItemsSet, existingSelection: &existingSelection)
            
            if !existingSelection.isEmpty {
                shouldNotifySelectedItem = false
                let indexes = IndexSet(existingSelection)
                self.projectOutlineView.selectRowIndexes(indexes, byExtendingSelection: true)
                shouldNotifySelectedItem = true
            }
        }
    }
    
    func selections(under itemId: String, selectedItemsSet: Set<String>, existingSelection: inout [Int]) {
        
        guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return
        }
        
        guard let item = sourceSetManager.directoryItemManager(withId: itemId) as? DirectoryManager else {
            assertionFailure("Error: item with id: \(itemId) is nil")
            return
        }
        
        if let childs = item.childs {
            
            // iterate through the children
            for projectOutlineItem in childs {

                if selectedItemsSet.contains(projectOutlineItem.id) {
                    let elementIndex = self.projectOutlineView.row(forItem: projectOutlineItem)
                    existingSelection.append(elementIndex)
                }
                
                if projectOutlineItem.isExpandable && self.projectOutlineView.isItemExpanded(projectOutlineItem) {
                    selections(under: projectOutlineItem.id, selectedItemsSet: selectedItemsSet, existingSelection: &existingSelection)
                }   
            }
        }
    }
    
    func restoreAllUserSelectedItems() {
        
        guard let filesOutlineManager = self.representedFilesOutlineManager else {
            assertionFailure("Error: self.representedFilesOutlineManager  is nil")
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("restoreAllUserSelectedItems() in files outline with name: %@", log: Log.StyloCore.all, type: .info, %%filesOutlineManager.name.value)
        #endif
        
        guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return
        }
        
        guard let userSelectableItemsIdsArray = filesOutlineManager.userSelectableItemsIdsArray else {
            assertionFailure("Error: filesOutlineManager.userSelectableItemsIdsArray is nil")
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("restoreAllUserSelectedItems -> userSelectableItemsIdsArray: %@ in files outline with name: %@", log: Log.StyloCore.all, type: .info, %%userSelectableItemsIdsArray, %%filesOutlineManager.name.value)
        #endif
        
        shouldNotifySelectedItem = false
        
        var selectedIndexes = [Int]()
        
        for selectedItemId in userSelectableItemsIdsArray {
            
            // item could have been deleted (history case)
            if let item = sourceSetManager.directoryItemManager(withId: selectedItemId) {
                
                let elementIndex = self.projectOutlineView.row(forItem: item)
                selectedIndexes.append(elementIndex)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("restoring index: %@", log: Log.StyloCore.all, type: .info, %%elementIndex)
                #endif
            }
        }
        
        let indexes = IndexSet(selectedIndexes)
        self.projectOutlineView.selectRowIndexes(indexes, byExtendingSelection: false)
        
        assert(self.projectOutlineView.selectedRowIndexes == indexes, "selectedRowIndexes: \(self.projectOutlineView.selectedRowIndexes) is not the same as indexes: \(indexes)")
        shouldNotifySelectedItem = true
    }
    
    private func expandAncestors(ofItemWithId itemId: String) {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager si nil")
            return
        }
        
        guard let sourceSetManager = documentManager._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return
        }
        
        guard let topDirectoryId = sourceSetManager.topDirectory?.id else {
            assertionFailure("Error: sourceSetManager.topDirectory?.id is nil")
            return
        }
        
        guard let directoryItemManager = sourceSetManager.directoryItemManager(withId: itemId) else {
            assertionFailure("Error: no directoryItemManager with id: \(itemId)")
            return
        }
        
        shouldNotifyExpandedItem = true
        
        // we expand starting from the top
        for parentId in directoryItemManager.ordereredLowerToHigherParentIds.reversed() {
            
            guard parentId != topDirectoryId else {
                continue
            }
            
            guard let item = sourceSetManager.directoryItemManager(withId: parentId) else {
                assertionFailure("Error: no item with id: \(parentId)")
                continue
            }
            
            guard self.projectOutlineView.row(forItem: item) != -1 else {
                assertionFailure("Error: item with id: \(parentId) is not shown")
                continue
            }
            
            self.projectOutlineView.expandItem(item)
        }
    }
    
    private func restoreExpandedItems() {
        
        guard let filesOutlineManager = self.representedFilesOutlineManager else {
            assertionFailure("Error: self.representedFilesOutlineManager  is nil")
            return
        }
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager si nil")
            return
        }
        
        guard let sourceSetManager = documentManager._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return
        }
        
        // expand all items
        shouldNotifyExpandedItem = false
        
        guard let expandableItems = filesOutlineManager.expandableItems else {
            assertionFailure("Error: filesOutlineManager.expandableItems is nil")
            return
        }
        
        var itemsToExpand = Set<String>(expandableItems)
        
        if !itemsToExpand.isEmpty {
        
            while !itemsToExpand.isEmpty {
        
                for expandedItemId in expandableItems {
                    
                    if itemsToExpand.contains(expandedItemId) {
                    
                        guard let item = sourceSetManager.directoryItemManager(withId: expandedItemId) else {
                            assertionFailure("Error: no item with id: expandedItemId")
                            continue
                        }

                        assert(item.isExpandable)
                        if self.projectOutlineView.row(forItem: item) != -1 {
                            
                            self.projectOutlineView.expandItem(item)
                            itemsToExpand.remove(expandedItemId)
                        }
                    }
                }
            }
        }
        else if documentManager.loadedFormatVersion < Constants.Versions.project {
            
            guard let item = sourceSetManager.firstDirectoryManager else {
                assertionFailure("Error: itemView is not GroupProjectOutlineCellView")
                return
            }
            
            self.projectOutlineView.expandItem(item)
        }
        
        shouldNotifyExpandedItem = true
    }

    internal func subscribeToDocumentManager() {
        assert(self.documentManager != nil)
        if let documentManager = self.documentManager {
            self.allowsAddingDirectoryAndTexts = documentManager.allowsAddingDirectoryAndTexts.value
            documentManager.allowsAddingDirectoryAndTexts.subscribe({ [weak self](newValue) in
                self?.allowsAddingDirectoryAndTexts = newValue
            }, observer: self)
        }
    }
    
    func unsubscribeToDocumentManager() {
        
        documentManager?.name.unsubscribe(observer: self)
        documentManager?.allowsAddingDirectoryAndTexts.unsubscribe(observer: self)
    }
    
    private func subscribeToSourceSetManager() {
        
        guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return
        }
        
        if !sourceSetManager.subscribedToDirectoryItemsManagers(observer: self) {
        
            sourceSetManager.subscribeToDirectoryItemsManagers(observer: self) { [weak self](change: DynamicOrderedDictionary<String, DirectoryItemManager>.Change) in
                switch change {
                case .insert: fallthrough
                case .deletes: fallthrough
                case .updates: fallthrough
                case .move: fallthrough
                case .start: fallthrough
                case .end:
                    self?.projectOutlineView.reloadData()
                    DispatchQueue.asyncOnMain { [weak self] in
                        self?.restoreAllUserSelectedItems()
                    }
                }
            }
        }
    }
    
    private func unsubscribeToSourceSetManager() {
        
        guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return
        }
        
        sourceSetManager.unsubscribeFromDirectoryItemsManagers(observer: self)
    }
    
    private func unsubscribeToFilesOutlineManager() {
        
        self.representedFilesOutlineManager?.userSelectedItems.unsubscribe(observer: self)
        self.representedFilesOutlineManager?.unsubscribeToExpandedItems(observer: self)
        self.representedFilesOutlineManager?.unsubscribeToUserSelectedItems(observer: self)
    }
    
    private func subscribeToFilesOutlineManager() {
        
        guard let filesOutlineManager = self.representedFilesOutlineManager else {
            assertionFailure("Error: self.representedFilesOutlineManager  is nil")
            return
        }
        
        self.handleUserSelectedItems(filesOutlineManager.userSelectedItems.values)
        filesOutlineManager.userSelectedItems.subscribe({ [weak self](change) in
            self?.handleUserSelectedItems(change.updatedOrderedSet)
        }, observer: self)
        
        filesOutlineManager.currentHistoricState.subscribe({ [weak self](historicState) in
            self?.handleHistoricStateChanged(historicState)
        }, observer: self)
        
        filesOutlineManager.subscribeToExpandedItems(observer: self) {[weak self](addedItems: [String], deletedItems: [String]) in
            assert(self != nil)
            self?.handleExpandedItems(ids: addedItems)
        }
    }
    
    private func handleUserSelectedItems(_ updatedOrderedSet: OrderedSet<String>?) {
        
        guard let updatedOrderedSet = updatedOrderedSet else {
            assertionFailure("Error: updatedOrderedSet is nil")
            return
        }
        
        self.deleteItemButton?.isEnabled = !updatedOrderedSet.isEmpty
        
        #if DEBUG
        if !updatedOrderedSet.isEmpty {
            assert(self.addItemButton?.isEnabled == true)
        }
        #endif
    }
    
    private func handleExpandedItems(ids: [String]) {
        for id in ids {
            self.handleExpandedItem(id: id)
        }
    }
    
    private func handleExpandedItem(id: String) {
        
        guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return
        }
        
        // we just do the following if we are expanding a file group manager
        //
        self.shouldNotifyExpandedItem = false
        if let filesGroupItem = sourceSetManager.groupDirectory(withId: id) {
            if !self.projectOutlineView.isItemExpanded(filesGroupItem) {
                self.projectOutlineView.expandItem(filesGroupItem)
            }
        }
        else if let directoryManager = sourceSetManager.directoryItemManager(withId: id) as? DirectoryManager {
            if !self.projectOutlineView.isItemExpanded(directoryManager) {
                self.projectOutlineView.expandItem(directoryManager)
            }
        }
        self.shouldNotifyExpandedItem = true
    }
    
    private func handleHistoricStateChanged(_ historicState: HistoricState?) {
        
        // close every items that are not necesssary to have expanded
        // every change to the actual state should be notified to
        // the files outline store.
        //
        if let historicState = historicState {
            
            StyloNotification.willNavigateInHistory.sendNotification()
            self.endEditingIfNecessary()
            self.restoreUserSelectedItems(fromHistoricState: historicState)
            StyloNotification.didNavigateInHistory.sendNotification()
        }
    }
    private func endEditingIfNecessary() {
        
        self.view.window?.makeFirstResponder(nil)
    }
    
    private func restoreUserSelectedItems(fromHistoricState historicState: HistoricState) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("restoreUserSelectedItems", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        shouldNotifySelectedItem = false
        removeUnselectedItems()
        restoreSelections(under: documentManager.id)
        shouldNotifySelectedItem = true
    }
    
    ///
    /// Method that validates that all ancestors of an item are expanded in the current project outline view
    /// @param item the item for which we need to validate the ancestors
    ///
    private func areAllParentsExpanded(ofItem item: DirectoryItemManager) -> Bool {
        
        guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
            assertionFailure("Error: nil sourceSetManager")
            return false
        }
        
        // if the item is a top item
        guard !sourceSetManager.isTopLevelDirectory(id: item.id) else {
            return true
        }
            
        var allExpanded = true
        
        for parentId in item.parentIds {
            
            guard let parentItem = sourceSetManager.directoryItemManager(withId: parentId) else {
                assertionFailure("Error: parentItem is nil")
                continue
            }
            
            if !self.projectOutlineView.isItemExpanded(parentItem.id) {
                allExpanded = false
                break
            }
        }
        
        return allExpanded
    }
    
    private func setEditMode(to item: ProjectOutlineItem) {
        
        let newItemRow = self.projectOutlineView.row(forItem: item)
        
        guard newItemRow != -1 else {
            assertionFailure("Error: newItemRow is -1")
            return
        }
        
        self.projectOutlineView.editColumn(0, row: newItemRow, with: nil, select: false)
    }
    
    private func itemId(from menuItem: NSMenuItem) -> String? {
        
        guard let outlineAddMenuItem = menuItem as? OutlineAddMenuItem else {
            assertionFailure("Error: menuItem is not OutlineAddMenuItem")
            return nil
        }
        
        guard let itemId = outlineAddMenuItem.itemId else {
            assertionFailure("Error: itemId is nil")
            return nil
        }
        
        return itemId
    }
    
    deinit {
        self.unsubscribeToDocumentManager()
        self.unsubscribeToFilesOutlineManager()
        self.unsubscribeToSourceSetManager()
    }
}
