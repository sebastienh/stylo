//
//  FilesOutlineManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-25.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo
import Combine
import PromiseKit
import os

public class FilesOutlineManager: NSObject, Observer {
    
    public typealias FileOutlineId = String
    
    public enum SelectionState {
        case selected
        case unselected
        case single
    }
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public let id: FileOutlineId
    
    @objc dynamic public var publishedName: String = ""
    
    public let name: Dynamic<String>
    
    public let scrolledItemId: Dynamic<TextId?> = Dynamic<TextId?>(nil)
    
    public let filesOutlineDesiredScrollPosition: Dynamic<FilesOutlineScrollPosition?> = Dynamic<FilesOutlineScrollPosition?>(nil)
    
    public let filesOutlineCurrentPosition: Dynamic<FilesOutlinePosition?> = Dynamic<FilesOutlinePosition?>(nil)
    
    public let userSelectedItems: DynamicOrderedSet<String>
    
    public let currentHistoricState = Dynamic<HistoricState?>(nil)
    
    public let selectedTextItems: DynamicOrderedSet<TextId>
    
    public let styleAssemblyDescriptor: Dynamic<StyleAssemblyDescriptor>
    
    public let styleAssemblyApplicationStatus = Dynamic<StyleUpdateStatus>(.applied)
    
    public let currentEditorId = Dynamic<EditorId?>(nil)
    
    ///
    /// This variable keeps the selection status of this
    /// text editors panel.
    ///
    public let selectionState: Dynamic<SelectionState> = Dynamic<SelectionState>(.single)
    
    public let selectorString: Dynamic<String?> = Dynamic<String?>(nil)
    
    public let textManagersTokenAttributes = DynamicDictionary<TextId, [AttributeTagInputSection: Set<AttributeTagInputItem>]>()
    
    public let attributesSortingMode = Dynamic<AttributesSortingMode>(.values)
    
    public var textIds: [TextId] {
        return selectedTextItems.compactMap { (id) -> String? in
            return id
        }
    }
    
    public var selectedTextManagers: [TextManager] {
        
        return selectedTextItems.compactMap { (textManagerId) -> TextManager? in
            
            guard let sourceSetManager = self.sourceSetManager else {
                assertionFailure("Error: self.sourceSetManager is nil")
                return nil
            }
            
            guard let itemManager = sourceSetManager.directoryItemManager(withId: textManagerId) else {
                assertionFailure("Error: itemManager is nil")
                return nil
            }
            
            guard let textManager = itemManager as? TextManager else {
                assertionFailure("Error: textManager is nil")
                return nil
            }
            return textManager
        }
    }
    
    public var currentFilesOutlinePosition: FilesOutlinePosition? {
        
        // - Are we the selected files outline, if no return nil
        let selectionState = self.selectionState.value
        
        guard selectionState == .selected || selectionState == .single else {
            return nil
        }
        
        // - Is there a text edited in the files outline , if no return nil
        guard let textId = self.lastEditedContentManagerId.value else {
            return nil
        }
        
        // - Which text is edited
        guard let editorId = self.editorIds[textId] else {
            assertionFailure("Error: editorId is nil")
            return nil
        }
        
        guard let textManager = self.sourceSetManager?.textManager(withId: textId) else {
            assertionFailure("Error: textManager is nil")
            return nil
        }
        
        // - where is the cursor in this text
        guard let editorManager = textManager.editorManagers.values[editorId] else {
            assertionFailure("Error: renderer is nil")
            return nil
        }
        
        assert(Thread.isMainThread)
        let selectedRange = editorManager.renderer.selectedRange()
        
        let filesOutlinePosition = FilesOutlinePosition(textId: textId, range: selectedRange)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("currentFilesOutlinePosition: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlinePosition)
        #endif
        
        return filesOutlinePosition
    }
    
    public let expandedItems: DynamicSet<String>
    
    public let collapsedEditorItems: DynamicSet<String>
    
    public let historyBackEnabled = Dynamic<Bool>(false)
    
    public let historyForwardEnabled = Dynamic<Bool>(false)
    
    let maxHistory: Dynamic<Int>
    
    let historicStates: DynamicStack<HistoricState>
    
    let historyIndex: Dynamic<Int> = Dynamic<Int>(0)
    
    let filesOutlineStore: FilesOutlineStore
    
    public var isFirstFilesOutline: Bool {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return false
        }
        
        guard let first = filesOutlineSetManager.filesOutlines.values.first else {
            assertionFailure("Error: first is nil")
            return false
        }
        
        return first.id == self.id
    }
    
    public var isLastFilesOutline: Bool {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return false
        }
        
        guard let last = filesOutlineSetManager.filesOutlines.values.last else {
            assertionFailure("Error: last is nil")
            return false
        }
        
        return last.id == self.id
    }
    
    var dispatcher: Dispatcher? {
        return documentManager.dispatcher
    }
    
    public unowned let documentManager: DocumentManager
    
    var sourceSetManager: SourceSetManager? {
    
        return documentManager._sourceSetManager.value
    }
    
    /// This computed value contains the precomputed expandedItems
    /// where we have only kept the items which may be expanded.
    ///
    /// Note: to be considered expandable, all ancestors of an item must
    /// must also be expanded.
    public var expandableItems: OrderedSet<String>? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("expandableItems: for files outline with name %@", log: Log.WriterCommon.all, type: .info, %%self.name.value)
        #endif
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        guard let topDirectoryId = sourceSetManager.topDirectory?.id else {
            assertionFailure("Error: sourceSetManager.topDirectory?.id is nil")
            return nil
        }
        
        var expandableItems = OrderedSet<String>()
        
        let expandedItems = self.expandedItems.values
        
        for itemId in expandedItems {
            
            if itemId == topDirectoryId {
                continue
            }
            
            if let item = sourceSetManager.directoryItemManager(withId: itemId) {
                
                // all parents must be part of the expanded items
                // if we hope to expand an item, otherwise we need to remove
                // it from the itemsToExpand otherwise this loop will never end
                var canExpand = true
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("item.parentIds: %@", log: Log.WriterCommon.all, type: .info, %%item.parentIds)
                #endif
                
                for parentId in item.parentIds {
                    
                    // if parent is topDirectory
                    if topDirectoryId == parentId {
                        continue
                    }
                    
                    if !expandedItems.contains(parentId) {
                        
                        let parent = sourceSetManager.directoryItemManager(withId: parentId)
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("parent with name: %@ can not expand", log: Log.WriterCommon.all, type: .info, %%parent?.name.value)
                        #endif
                        
                        canExpand = false
                        break
                    }
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("item with id: %@ and name: %@, canExpand: %@", log: Log.WriterCommon.all, type: .info, %%item.id, %%item.name.value, %%canExpand)
                #endif
                
                if canExpand {
                    expandableItems.append(itemId)
                }
            }
            else {
                
                assertionFailure("Error: item is nil")
            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("expandableItems: %@", log: Log.WriterCommon.all, type: .info, %%expandableItems)
        #endif
        
        return expandableItems
    }
    
    public var selectedItemsArray: [TextId] {
        return Array<String>(selectedTextItems.values)
    }
    
    public var userSelectedItemsIdsArray: [TextId] {
        return Array<String>(userSelectedItems.values)
    }
    
    public var hasVisibleUserSelectedItems: Bool {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return false
        }
        
        guard let topDirectory = sourceSetManager.topDirectory else {
            assertionFailure("Error: sourceSetManager.topDirectory is nil")
            return false
        }
        
        for itemId in userSelectedItems.values {
            
            if itemId == topDirectory.id {
                continue
            }
            
            guard let item = sourceSetManager.directoryItemManager(withId: itemId) else {
                continue
            }
            
            if item.isVisible(inFilesOutlineManager: self) {
                return true
            }
        }
        
        return false
    }
    
    /// This computed value contains the precomputed userSelectedItems
    /// where we have only kept the items which may be selected.
    ///
    /// Note: to be considered selectable, all ancestors of an item must
    /// must be expanded.
    public var userSelectableItemsIdsArray: [String]? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        guard let topDirectoryId = sourceSetManager.topDirectory?.id else {
            assertionFailure("Error: sourceSetManager.topDirectory?.id is nil")
            return nil
        }
        
        guard let expandableItems = self.expandableItems else {
            assertionFailure("Error: self.expandableItems is nil")
            return nil
        }
        
        var userSelectableItemsIdsArray: [String] = []
        
        for itemId in userSelectedItems.values {
            
            if itemId == topDirectoryId {
                continue
            }
            
            if let item = sourceSetManager.directoryItemManager(withId: itemId) {
                
                // all parents must be expandable items
                // if we hope to user select an item
                var canSelect = true
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("item.parentIds: %@", log: Log.WriterCommon.all, type: .info, %%item.parentIds)
                #endif
                
                for parentId in item.parentIds {
                    
                    if topDirectoryId != parentId && !expandableItems.contains(parentId) {

                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        let parent = sourceSetManager.directoryItemManager(withId: parentId)
                        os_log("parent with name: %@ can not expand", log: Log.WriterCommon.all, type: .info, %%parent?.name.value)
                        #endif
                        
                        canSelect = false
                    }
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("item with id: %@ and name: %@, canSelect: %@", log: Log.WriterCommon.all, type: .info, %%item.id, %%item.name.value, %%canSelect)
                #endif
                
                if canSelect {
                    userSelectableItemsIdsArray.append(itemId)
                }
            }
            else {
                // item is nil, it may habe been deleted
            }
        }
        return userSelectableItemsIdsArray
    }
    
    public var collapsedEditorItemsArray: [String] {
        return Array<String>(userSelectedItems.values)
    }
    
    /// [TextId: EditorId]
    public private(set) var editorIds = [TextId: EditorId]()
    
    public var lastEditedContentManagerId = Dynamic<String?>(nil)
    
    private var filesOutlineSetManager: FilesOutlineSetManager? {
        
        self.documentManager.filesOutlineSetManager.value
    }
    
    lazy var styleAssembliesSerialQueue = DispatchQueue(label: "\(self.id)+styleAssembliesSerialQueue")
    
    public internal(set) var visiblesTextIndexes: [Int] = []
    
    init(documentManager: DocumentManager, name: String = Constants.Filename.DefaultFilesOutlineName, styleAssemblyDescriptor: StyleAssemblyDescriptor) {
        
        let filesOutlineStore = FilesOutlineStore(maxHistory: Constants.FilesOutline.MaxHistorySize, name: name)
        self.id = filesOutlineStore.identifier
        self.name = Dynamic<String>(filesOutlineStore.name.value)
        self.publishedName = filesOutlineStore.name.value
        self.userSelectedItems = DynamicOrderedSet<String>()
        self.selectedTextItems = DynamicOrderedSet<String>()
        self.expandedItems = DynamicSet<String>()
        self.collapsedEditorItems = DynamicSet<String>()
        self.maxHistory = Dynamic<Int>(Constants.FilesOutline.MaxHistorySize)
        self.historicStates = DynamicStack<HistoricState>()
        self.filesOutlineStore = filesOutlineStore
        self.documentManager = documentManager
        self.styleAssemblyDescriptor = Dynamic<StyleAssemblyDescriptor>(styleAssemblyDescriptor)
        super.init()
        dispatcher?.register(store: filesOutlineStore)
        subscribeToStore()
        subscribeToSourceSetManager()
        subscribeToSelectedTextItems()
        subscribeToClearFocusRequest()
    }
    
    init(filesOutlineMetadata: FilesOutlineMetadata, documentManager: DocumentManager, styleAssemblyDescriptor: StyleAssemblyDescriptor) {
        
        self.filesOutlineStore = FilesOutlineStore(filesOutlineMetadata, maxHistory: Constants.FilesOutline.MaxHistorySize)
        self.id = filesOutlineStore.identifier
        self.name = Dynamic<String>(filesOutlineMetadata.name)
        self.publishedName = filesOutlineStore.name.value
        self.userSelectedItems = DynamicOrderedSet<String>(filesOutlineMetadata.outlineUserSelectedItems)
        self.selectedTextItems = DynamicOrderedSet<String>()
        self.expandedItems = DynamicSet<String>(filesOutlineMetadata.outlineExpandedItems)
        self.collapsedEditorItems = DynamicSet<String>(filesOutlineMetadata.collapsedEditorItems)
        self.maxHistory = Dynamic<Int>(Constants.FilesOutline.MaxHistorySize)
        self.historicStates = DynamicStack<HistoricState>()
        self.documentManager = documentManager
        self.styleAssemblyDescriptor = Dynamic<StyleAssemblyDescriptor>(styleAssemblyDescriptor)
        super.init()
        dispatcher?.register(store: filesOutlineStore)
        subscribeToStore()
        subscribeToSourceSetManager()
        subscribeToSelectedTextItems()
        subscribeToClearFocusRequest()
    }
    
    public func updateSelectedState() {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        guard let selectedFilesOutlineID = filesOutlineSetManager.selectedFilesOutlineID.value else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return
        }
        
        if filesOutlineSetManager.filesOutlines.count > 1 {
            if self.id == selectedFilesOutlineID {
                self.selectionState.setValue(.selected)
            }
            else {
                self.selectionState.setValue(.unselected)
            }
        }
        else {
            // if there is only one panel we don't care about
            // showing it is the selected one
            self.selectionState.setValue(.single)
        }
    }
    
    public func textManager(forTextWithId textId: TextId) -> TextManager? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            let errorText = "Error: self.sourceSetManager is nil"
            assertionFailure(errorText)
            return nil
        }
        
        guard let itemManager = sourceSetManager.directoryItemManager(withId: textId) else {
            assertionFailure("Error: item manager is nil for id: \(textId)")
            return nil
        }
        
        guard let textManager = itemManager as? TextManager else {
            assertionFailure("Error: itemManager is not TextManager")
            return nil
        }
        
        return textManager
    }
    
    public func editorManager(forTextWithId textId: TextId) -> AnyEditor? {
        
        guard let textManager = self.textManager(forTextWithId: textId) else {
            assertionFailure("Error: textManager is nil")
            return nil
        }

        guard let editorId = self.editorIds[textId] else {
            assertionFailure("Error: self.editorIds[\(textId)] is nil")
            return nil
        }
        
        //
        // Since editorIts does not remove, text ids,
        // it's possible that the editor is not there anymore
        // even if it's still in the editorIds dictionary.
        //
        // Calling code should make sure if it is an error
        // to handle properly.
        //
        return textManager.editorManagers.values[editorId]
    }
    
    public func unregisterEditor(forTextId textId: TextId) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("unregisterEditor(forTextId: %@) in files outline manager with name: %@", log: Log.WriterCommon.all, type: .info, %%textId, %%self.name.value)
        #endif
        
        guard let sourceSetManager = self.documentManager._sourceSetManager.value else {
            assertionFailure("Error: sourceSetManager is nil")
            return
        }
        
        guard let editorId = self.editorId(forTextId: textId) else {
            assertionFailure("Error: editorId is nil")
            return
        }
        
        guard let textManager = sourceSetManager.textManager(withId: textId) else {
            // we may have deleted the text manager
            return
        }

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("unregisterEditor -> editorId: %@ in files outline manager with name: %@", log: Log.WriterCommon.all, type: .info, %%editorId, %%self.name.value)
        #endif
        
        textManager.unregisterEditor(withId: editorId)
    }
    
    public func isDescendantPartOfSelection(ofItemWithId itemId: String) -> Bool {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return false
        }
        
        guard let directoryItemManager = sourceSetManager.directoryItemManager(withId: itemId) else {
            assertionFailure("Error: directoryItemManager is nil")
            return false
        }
        
        guard let directoryManager = directoryItemManager as? DirectoryManager else {
            assertionFailure("Error: directoryItemManager is not DirectoryManager")
            return false
        }
        
        let selectedTextItemsSet = Set<String>(self.selectedTextItems)
        
        for descendantsItemManagerId in directoryManager.descendantsItemManagers {
            if selectedTextItemsSet.contains(descendantsItemManagerId) {
                return true
            }
        }
        return false
    }
    
    public func removeEditorId(forTextId textId: TextId) {
        
        self.editorIds.removeValue(forKey: textId)
    }
    
    public func createOrGetEditorId(forTextId textId: TextId) -> EditorId {
        
        if let editorId = self.editorIds[textId] {
            return editorId
        }
        return addEditorId(forTextId: textId)
    }
    
    public func addEditorId(forTextId textId: TextId) -> EditorId {
        
        assert(self.editorIds[textId] == nil)
        let editorId = UUID().uuidString
        self.editorIds[textId] = editorId
        return editorId
    }
    
    public func editorId(forTextId textId: TextId) -> EditorId? {
        
        return self.editorIds[textId]
    }
    
    public func rename(to name: String) throws {
        
        try canRename(to: name)
        try dispatcher?.online(store: self.filesOutlineStore, action: FilesOutlineAction.rename(name: name))
    }
    
    public func canRename(to newName: String) throws {
        
        // no error
    }
    
    public func subscribeToUserSelectedItems(observer: Observer, closure: @escaping (DynamicOrderedSet<String>.ChangeNotificationType) -> Void) {
        
        userSelectedItems.subscribe({ (change) in
            closure(change)
        }, observer: observer)
    }
    
    public func unsubscribeToUserSelectedItems(observer: Observer) {
        
        userSelectedItems.unsubscribe(observer: observer)
    }
    
    public func subscribeToExpandedItems(observer: Observer, closure: @escaping ([String], [String]) -> Void) {
        
        expandedItems.subscribe({ (setChange) in
            switch setChange {
            case .deletes(let deletedValues, _):
                closure([], deletedValues)
            case .inserts(let addedValues, _):
                closure(addedValues, [])
            }
        }, observer: observer)
    }
    
    public func unsubscribeToExpandedItems(observer: Observer) {
        
        expandedItems.unsubscribe(observer: observer)
    }
    
    public func isSubscribedToExpandedItems(observer: Observer) -> Bool {
        
        return expandedItems.subscribed(observer: observer)
    }
    
    /// Here we are removing items that we don't know if it is
    /// a user selected item or not. From the files outline manager set's
    /// selected files outline manager, we know it was not part of the user
    /// selected items but the item may be part of other files outline manager
    /// user selected items but in this case, the handling stays the same.
    public func removeItem(itemId: String) {
        
        if let lastEditedContentManagerId = self.lastEditedContentManagerId.value, id == lastEditedContentManagerId {
            self.lastEditedContentManagerId.setValue(nil)
        }
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            
            if let includingDirectoryItems = self.includingDirectoryItems(fromItemWithId: itemId) {
                try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.removeExpandedItems(itemIds: includingDirectoryItems))
            }
            
            guard let includingDescendantItemsIds = self.includingDescendantItems(ofItemWithId: itemId) else {
                assertionFailure("Error: includingDescendantItems is nil, we should at least have the deleted item")
                return
            }
            
            // for each item
            for includingDescendantItemId in includingDescendantItemsIds {
                self.removeItemFromSelectionIfNecessary(withId: includingDescendantItemId)
                self.removeExpandedItem(with: includingDescendantItemId)
            }
            self.documentManager.document?.updateChangeCount(.changeDone)
        }
        catch let error {
            assertionFailure("Error: exception in clearUserSelections: \(error)")
        }
    }
    
    private func removeItemFromSelectionIfNecessary(withId id: String) {
        
        // If the item is user selected the notification system will do
        // the work of removing the item from the selection
        // otherwise we need to the selection deletion manually.
        if self.userSelectedItemsIdsArray.contains(id) {
            
            self.removeUserSelectedItem(itemId: id)
        }
        else if self.selectedTextItems.contains(id) {
            
            // we need to update manually the selected items if
            guard let sourceSetManager = self.sourceSetManager else {
                assertionFailure("Error: self.sourceSetManager is nil")
                return
            }
            
            guard let directoryItemManager = sourceSetManager.directoryItemManager(withId: id) else {
                assertionFailure("Error: directoryItemManager is nil")
                return
            }
            
            var currentSelectedTextItems = self.selectedTextItems.values
            
            switch directoryItemManager {
            case let directoryManager as DirectoryManager:
                
                for descendantTextManagerId in directoryManager.descendantsTextManagers.reversed() {
                    
                    guard let index = currentSelectedTextItems.firstIndex(of: descendantTextManagerId) else {
                        assertionFailure("Error: index is nil")
                        continue
                    }
                    
                    currentSelectedTextItems.remove(at: index)
                }
                
            case let textManager as TextManager:
                
                guard let index = currentSelectedTextItems.firstIndex(of: textManager.id) else {
                    assertionFailure("Error: index is nil")
                    return
                }
                
                currentSelectedTextItems.remove(at: index)
                
            default:
                assertionFailure("Error: ")
                return
            }
            
            // now reconcile the list that we have with the list
            // we must have a minimum number of operations
            let edits = self.selectedTextItems.values.editOperations(to: currentSelectedTextItems)
            self.selectedTextItems.applyArrayEdits(edits, to: currentSelectedTextItems, sameExecutionStack: true)
            if currentSelectedTextItems.isEmpty {
                self.lastEditedContentManagerId.setValue(nil)
            }
        }
    }
    
    private func includingDescendantItems(ofItemWithId itemId: String) -> [String]? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        guard let directoryItemManager = sourceSetManager.directoryItemManager(withId: itemId) else {
            assertionFailure("Error: directoryItemManager is nil")
            return nil
        }
        
        switch directoryItemManager {
        case let directoryManager as DirectoryManager:
            return directoryManager.descendantsItemManagers
        case _ as TextManager:
            return [itemId]
        default:
            assertionFailure("Error: unhandled directoryItemManager type: \(type(of: directoryItemManager))")
            break
        }
        return nil
    }
    
    private func includingDirectoryItems(fromItemWithId itemId: String) -> [String]? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        guard let directoryItemManager = sourceSetManager.directoryItemManager(withId: itemId) else {
            assertionFailure("Error: directoryItemManager is nil")
            return nil
        }
        
        switch directoryItemManager {
        case let directoryManager as DirectoryManager:
            return directoryManager.selfIncludingDescendantsDirectoryManagers
        case _ as TextManager:
            return nil
        default:
            assertionFailure("Error: unhandled directoryItemManager type: \(type(of: directoryItemManager))")
            break
        }
        
        return nil
    }
    
    public func removeUserSelectedItem(itemId: String) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            
            if let includingDirectoryItems = self.includingDirectoryItems(fromItemWithId: itemId) {
                try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.removeExpandedItems(itemIds: includingDirectoryItems))
            }
            
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.removeUserSelectedItem(itemId: itemId))
            self.documentManager.document?.updateChangeCount(.changeDone)
        }
        catch let error {
            assertionFailure("Error: exception in clearUserSelections: \(error)")
        }
    }
    
    public func removeUserSelectedItems(withIds itemIds: [String]) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.removeItems(itemIds: itemIds))
            
            // since we remove the notifications for removed items we
            // need to remove them manually here.
            for itemId in itemIds {
                if let includingDirectoryItems = self.includingDirectoryItems(fromItemWithId: itemId) {
                    try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.removeExpandedItems(itemIds: includingDirectoryItems))
                    self.expandedItems.remove(includingDirectoryItems, notify: false)
                }
            }
            
            self.documentManager.document?.updateChangeCount(.changeDone)
        }
        catch let error {
            assertionFailure("Error: exception in clearUserSelections: \(error)")
        }
    }
    
    
    public func removeAllUserSelectedItems(itemIds: [String]) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.removeAllUserSelectedItems(itemIds: itemIds))
            
            // since we remove the notifications for removed items we
            // need to remove them manually here.
            for itemId in itemIds {
                if let includingDirectoryItems = self.includingDirectoryItems(fromItemWithId: itemId) {
                    try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.removeExpandedItems(itemIds: includingDirectoryItems))
                    self.expandedItems.remove(includingDirectoryItems, notify: false)
                }
            }
            
            self.userSelectedItems.removeAll(notify: false)
            self.documentManager.document?.updateChangeCount(.changeDone)
        }
        catch let error {
            assertionFailure("Error: exception in clearUserSelections: \(error)")
        }
    }
    
    /// Simply replace the current selection with the received selected items ids.
    public func replaceUserSelectedItems(with newSelectedItemsIds: [String]) {
        
        let editOperations = self.userSelectedItems.values.editOperations(to: newSelectedItemsIds)
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("self.userSelectedItems.values.contents: %@", log: Log.WriterCommon.all, type: .info, %%self.userSelectedItems.values.contents)
            os_log("editOperations: %@", log: Log.WriterCommon.all, type: .info, %%editOperations)
            os_log("newSelectedItemsIds: %@", log: Log.WriterCommon.all, type: .info, %%newSelectedItemsIds)
            #endif
            
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.applyUserSelectedItemsEdits(edits: editOperations, destinationArray: newSelectedItemsIds))
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("self.userSelectedItems.values.contents: %@", log: Log.WriterCommon.all, type: .info, %%self.userSelectedItems.values.contents)
            #endif
            
            assert(self.userSelectedItems.values.contents == newSelectedItemsIds)
            self.documentManager.document?.updateChangeCount(.changeDone)
        }
        catch let error {
            assertionFailure("Error: exception in replaceUserSelectedItems: \(error)")
        }
    }
    
    /// Merge the user selected items with the new visibleSelectedItemsIds.
    /// Since we know there was no removed items, we just call shrinkUserSelectedItems
    /// with an empty removed items ids set.
    public func mergeUserSelectedItems(with visibleSelectedItemsIds: [String]) {
        
        shrinkUserSelectedItems(with: visibleSelectedItemsIds, removedItemsIds: Set<String>())
    }
    
    /// Merge the user selected items with the new visibleSelectedItemsIds by not including
    /// the items from the removed items.
    public func shrinkUserSelectedItems(with visibleSelectedItemsIds: [String], removedItemsIds: Set<String>) {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        // not items
        guard !sourceSetManager.directoryItemManagers.values.isEmpty else {
            replaceUserSelectedItems(with: visibleSelectedItemsIds)
            return
        }
        
        // nothing selected
        guard !self.userSelectedItems.isEmpty else {
            replaceUserSelectedItems(with: visibleSelectedItemsIds)
            return
        }
        
        guard let mergedKeys = mergeUserSelectedItems(with: visibleSelectedItemsIds, removedItemsIds: removedItemsIds) else {
            assertionFailure("Error: mergedKeys is nil")
            return
        }
        
        #if DEBUG
        // if we are adding items
        if visibleSelectedItemsIds.count > self.userSelectedItems.count && removedItemsIds.isEmpty {
            assert(mergedKeys.contents == visibleSelectedItemsIds)
        }
        #endif
        
        // this one will compute the minimal changes to execute
        // the change.
        replaceUserSelectedItems(with: mergedKeys.contents)
    }
    
    public func mergeUserSelectedItems(with visibleSelectedItemsIds: [String], removedItemsIds: Set<String>) -> OrderedSet<String>? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        let itemsIdsAndGlobalIndex: [(String, Int)] = visibleSelectedItemsIds.compactMap { (key) -> (String, Int)? in
            guard let keyIndex = sourceSetManager.directoryItemManagers.values.index(forKey: key) else {
                assertionFailure("Error: no index for key \(key)")
                return nil
            }
            return (key, keyIndex)
        }.sorted { (first, second) -> Bool in
            return first.1 < second.1
        }
        
        let orderedKeys: [(String, Int)] = self.userSelectedItems.values.compactMap { (key) -> (String, Int)? in
            guard let keyIndex = sourceSetManager.directoryItemManagers.values.index(forKey: key) else {
                assertionFailure("Error: no index for key \(key)")
                return nil
            }
            return (key, keyIndex)
        }.sorted { (first, second) -> Bool in
            return first.1 < second.1
        }
        
        return mergeUserSelectedItems(with: itemsIdsAndGlobalIndex, existingItemsIds: orderedKeys, removedItemsIds: removedItemsIds)
    }
    
    public func mergeUserSelectedItems(with selectedItemsIds: [(String, Int)], existingItemsIds: [(String, Int)], removedItemsIds: Set<String>) -> OrderedSet<String>?  {
        
        #if DEBUG
        let sortedSelectedItemsIds = selectedItemsIds.sorted { (first, second) -> Bool in
            return first.1 < second.1
        }
        for i in 0..<sortedSelectedItemsIds.count {
            let sortedSelectedItemsId = sortedSelectedItemsIds[i].0
            let selectedItemsId = selectedItemsIds[i].0
            assert(sortedSelectedItemsId == selectedItemsId)
            
            let sortedSelectedItemsIndex = sortedSelectedItemsIds[i].1
            let selectedItemsIndex = selectedItemsIds[i].1
            assert(sortedSelectedItemsIndex == selectedItemsIndex)
        }
        
        let sortedExistingItemsIds = existingItemsIds.sorted { (first, second) -> Bool in
            return first.1 < second.1
        }
        
        for i in 0..<sortedExistingItemsIds.count {
            let sortedExistingItemsId = sortedExistingItemsIds[i].0
            let existingItemsId = existingItemsIds[i].0
            assert(sortedExistingItemsId == existingItemsId)
            
            let sortedExistingItemsIndex = sortedExistingItemsIds[i].1
            let existingItemsIndex = existingItemsIds[i].1
            assert(sortedExistingItemsIndex == existingItemsIndex)
        }
        #endif
        
        var selectedItemsIds = selectedItemsIds
        var mergedKeys: OrderedSet<String> = []
        for (orderedKey, keyIndex) in existingItemsIds {
            
            while !selectedItemsIds.isEmpty {
                let (key, index) = selectedItemsIds.first!
                if index == keyIndex {
                    // the key is already included in the user selected items
                    // we know the subsequent keys indexes will be greater
                    // so we stop
                    selectedItemsIds.removeFirst()
                    break
                }
                else if index < keyIndex {
                    mergedKeys.append(key)
                    selectedItemsIds.removeFirst()
                }
                else if index > keyIndex {
                    break
                }
            }
            if !removedItemsIds.contains(orderedKey) {
                mergedKeys.append(orderedKey)
            }
        }
        
        // empty whats left that we know is not smaller
        // than any previous keys
        while !selectedItemsIds.isEmpty {
            let (key, _) = selectedItemsIds.first!
            mergedKeys.append(key)
            selectedItemsIds.removeFirst()
        }
        
        return mergedKeys
    }
    
    public func isItemExpanded(id: String) -> Bool {
        
        return self.expandedItems.contains(id)
    }
    
    public func addExpandedItem(with id: String, increaseChangeCount: Bool = true) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.itemExpanded(id: id))
            if increaseChangeCount {
                self.documentManager.document?.updateChangeCount(.changeDone)
            }
        }
        catch let error {
            assert(false, "Error: unable to expand item in project outline: \(error)")
        }
    }
    
    public func removeExpandedItem(with id: String, notify: Bool = true) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.itemCollapsed(id: id))
        }
        catch let error {
            assert(false, "Error: unable to expand item in project outline: \(error)")
        }
    }
    
    public func userSelectionIndex(of itemId: String) -> Int? {
        
        for (index, value) in self.userSelectedItems.values.enumerated() {
            if value ==  itemId {
                return index
            }
        }
        return nil
    }
    
    public func selectionIndex(of itemId: String) -> Int? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("selectionIndex(of: %@)", log: Log.WriterCommon.all, type: .info, %%itemId)
        #endif
        
        for (index, value) in self.selectedItemsArray.enumerated() {
            if value ==  itemId {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectionIndex -> index: %@", log: Log.WriterCommon.all, type: .info, %%index)
                #endif
                
                return index
            }
        }
        return nil
    }
    
    public func isItemSelected(with id: TextId) -> Bool {
        
        return selectedTextItems.contains(id)
    }

    public func isLastItemSelected(with id: TextId) -> Bool {
        
        return selectedTextItems.values.last == id
    }
    
    public func isItemChildOfAUserSelectedItem(_ directoryItemManager: DirectoryItemManager) -> Bool {
        
        for parentId in directoryItemManager.parentIds {
            
            if self.userSelectedItems.contains(parentId) {
                return true
            }
        }
        return false
    }
    
    public func isItemUserSelected(with id: String) -> Bool {
        
        return userSelectedItems.contains(id)
    }
    
    public func replaceUserSelection(withItemWithId id: String) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.replaceUserSelection(id: id))
            self.documentManager.document?.updateChangeCount(.changeDone)
        }
        catch let error {
            assert(false, "Error: unable to select item in project outline: \(error)")
        }
    }
    
    public func appendItemToExistingUserSelection(with id: String, increaseChangeCount: Bool = true) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.userSelectedItemAppended(id: id))
            if increaseChangeCount {
                self.documentManager.document?.updateChangeCount(.changeDone)
            }
        }
        catch let error {
            assert(false, "Error: unable to select item in project outline: \(error)")
        }
    }
    
    private func removeCollapseEditor(forItemWithId itemId: String) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        try? dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.editorUncollapsed(id: itemId))
    }
    
    func insertItemInUserSelection(_ itemId: String, afterItemWithId previousItemId: String) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.insertItemInUserSelectionAfter(id: itemId, previous: previousItemId))
        }
        catch let error {
            assert(false, "Error: unable to select item in project outline: \(error)")
        }
    }
    
    public func insertItemInUserSelection(id: String, at index: Int) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: id, index: index))
            self.documentManager.document?.updateChangeCount(.changeDone)
        }
        catch let error {
            assert(false, "Error: unable to append item to selection in project outline: \(error)")
        }
    }
    
    private func subscribeToSourceSetManager() {
        
        // the source set manager may not have been initialized
        if let sourceSetManager = self.sourceSetManager {
            self.handleSourceSetManagerChange(sourceSetManager)
        }
        else {
            self.documentManager._sourceSetManager.subscribe({ [weak self](sourceSetManager) in
                if let sourceSetManager = sourceSetManager {
                    self?.handleSourceSetManagerChange(sourceSetManager)
                }
            }, observer: self)
        }
    }
    
    private func handleSourceSetManagerChange(_ sourceSetManager: SourceSetManager) {
        
        self.updateExpandedItems()
        sourceSetManager.directoryItemManagers.subscribe({ [weak self](change) in
            self?.handleDirectoryItemManagersChange(change)
        }, observer: self)
    }
    
    private func updateExpandedItems() {
        
        guard let sourceSetManager = self.sourceSetManager else {
            // not failing for unit test support 
            return
        }
        
        for expandedItem in self.expandedItems.values {
            if !sourceSetManager.directoryItemManagerExists(withId: expandedItem) {
                self.removeExpandedItem(with: expandedItem)
            }
        }
    }
    
    private func handleDirectoryItemManagersChange(_ change: DynamicOrderedDictionary<String, DirectoryItemManager>.Change) {
        switch change {
        case .deletes(let removedValues, _):
            // removedValues: Dictionary<String, DirectoryItemManager>
            for (key, _) in removedValues {
                if self.expandedItems.contains(key) {
                    self.removeExpandedItem(with: key)
                }
            }
            break
        case .move:
            break
        case .insert: fallthrough
        case .updates:
            // nothing to do here
            break
        case .start: fallthrough
        case .end:
            break
        }
    }
    
    private func unsubscribeToSourceSetManager() {
        
        sourceSetManager?.directoryItemManagers.unsubscribe(observer: self)
    }
    
    private func subscribeToStore() {
        
        self.filesOutlineStore.name.subscribe({ [weak self](newName) in
            assert(self != nil)
            self?.name.setValue(newName)
            self?.publishedName = newName
        }, observer: self)
        
        self.filesOutlineStore.expandedItems.subscribe({ [weak self] (setChange) in
            assert(self != nil)
            switch setChange {
            case .deletes(let values, _):
                self?.expandedItems.remove(values, sameExecutionStack: true)
            case .inserts(let values, _):
                self?.expandedItems.insert(values, sameExecutionStack: true)
            }
        }, observer: self)
        
        self.filesOutlineStore.userSelectedItems.subscribe({ [weak self] (arrayChange) in
            assert(self != nil)
            switch arrayChange {
            case .deletes(let indexes, _, _):
                self?.userSelectedItems.remove(atIndexes: indexes.sorted(), sameExecutionStack: true)
            case .inserts(let newElements, let indexes, _):
                self?.userSelectedItems.insert(newElements: newElements, at: indexes.sorted(), sameExecutionStack: true)
            case .insert(let newElement, let index, _):
                self?.userSelectedItems.insert(newElement, at: index, sameExecutionStack: true)
            case .move(_, let sourceIndex, let targetIndex, _):
                self?.userSelectedItems.move(elementAt: sourceIndex, to: targetIndex)
            case .end:
                #if DEBUG
                assert(Set<String>(self!.userSelectedItems.values).count == self!.userSelectedItems.values.count)
                #endif
                self?.updateSelectedItems()
            case .start:
                break
            }
        }, observer: self)
        
        self.filesOutlineStore.collapsedEditorItems.subscribe({ [weak self] (setChange) in
            assert(self != nil)
            
            guard let _self = self else {
                assertionFailure("Error: self is nil")
                return
            }
            
            switch setChange {
            case .deletes(let textIds, _):
                _self.collapsedEditorItems.remove(textIds, notify: !_self.removeCollapsedEditors, sameExecutionStack: false)
                for textId in textIds {
                    _self.subscribe(toTextManagerTokenAttributesWithId: textId)
                }
            case .inserts(let textIds, _):
                _self.collapsedEditorItems.insert(textIds, sameExecutionStack: false)
                for textId in textIds {
                    _self.textManagersTokenAttributes.removeValue(forKey: textId)
                    _self.unsubscribe(fromTextManagerTokenAttributesWithId: textId)
                }
            }
        }, observer: self)
        
        self.filesOutlineStore.currentHistoricState.subscribe({ [weak self](newHistoricState) in
            self?.handleHistoricStateChange(newHistoricState)
        }, observer: self)
        
        self.maxHistory.bind(to: self.filesOutlineStore.maxHistory)
        self.historicStates.bind(to: self.filesOutlineStore.historicStates)
        self.historyBackEnabled.bind(to: self.filesOutlineStore.historyBackEnabled)
        self.historyForwardEnabled.bind(to: self.filesOutlineStore.historyForwardEnabled)
    }
    
    private func unsubscribeToStore() {
        
        self.filesOutlineStore.name.unsubscribe(observer: self)
        self.filesOutlineStore.expandedItems.unsubscribe(observer: self)
        self.filesOutlineStore.userSelectedItems.unsubscribe(observer: self)
        self.maxHistory.unbind(from: self.filesOutlineStore.maxHistory)
        self.historicStates.unbind(from: self.filesOutlineStore.historicStates)
        self.filesOutlineStore.currentHistoricState.unsubscribe(observer: self)
        self.historyBackEnabled.unbind(from: self.filesOutlineStore.historyBackEnabled)
        self.historyForwardEnabled.unbind(from: self.filesOutlineStore.historyForwardEnabled)
    }
    
    ///
    /// stylo #815
    ///
    /// Since before a fix, deleted items from the files outline
    /// were not removed from the collapsed editors items, we need
    /// to do this to avoid collapsing new editors that have been
    /// saved as "collapsed" in the .styloproj document.
    ///
    /// Since we can not make the difference between text
    /// that open at startup and those who
    private var removeCollapsedEditors: Bool = false
    
    public func updateSelectedItems(removeCollapsedEditors: Bool = true) {
        
        self.removeCollapsedEditors = removeCollapsedEditors
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateSelectedItems(removeCollapsedEditors: %@) called in files outlines with name: %@", log: Log.WriterCommon.textStorage, type: .debug, %%removeCollapsedEditors, %%self.name.value)
        #endif
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        let topItems = sourceSetManager.computeTopItems(for: self.userSelectedItems.values)
        let selectedItems = selectedItemsListFromUserTopSelectedItems(topItems)

        // now reconcile the list that we have with the list
        // we must have a minimum number of operations
        let edits = self.selectedTextItems.values.editOperations(to: selectedItems)
        self.selectedTextItems.applyArrayEdits(edits, to: selectedItems, sameExecutionStack: true)
        if selectedItems.isEmpty {
            self.lastEditedContentManagerId.setValue(nil)
        }
        
        self.removeCollapsedEditors = false
        
        // note: we don't cleanup the user selected items anymore
        // the reason being, we want to touch as less as possible
        // what the user has done, even if is not taken into consideration
        // in our computations (see computeTopItems(...).
        //
        // self.cleanupUserSelectedItems(usingTopItems: topItems)
        
//        #if DEBUG
//        validateAllSelectedTextItemsHaveCorrespondingRenderer()
//        #endif
    }
    
    ///
    /// if an item in the user selected items is not a top item
    /// we should remove it from the user selected items, since it is
    /// indirectly a selected item.
    ///
    /// This situation can happen for example if we move a selected item
    /// under an already selected directory from another files outline.
    private func cleanupUserSelectedItems(usingTopItems topItems: OrderedSet<String>) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("cleanupUserSelectedItems(usingTopItems: %@) called in files outlines with name: %@", log: Log.WriterCommon.textStorage, type: .debug, %%topItems, %%self.name.value)
        #endif
        
        for (index, userSelectedItem) in self.userSelectedItems.values.enumerated() {
            if !topItems.contains(userSelectedItem) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("cleanupUserSelectedItems -> topItems does not contains %@ in files outlines with name: %@", log: Log.WriterCommon.textStorage, type: .debug, %%userSelectedItem, %%self.name.value)
                #endif
                
                self.userSelectedItems.remove(atIndex: index, notify: false)
            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("cleanupUserSelectedItems -> resulting self.userSelectedItems: %@) called in files outlines with name: %@", log: Log.WriterCommon.textStorage, type: .debug, %%self.userSelectedItems.values, %%self.name.value)
        #endif
    }
    
    /// This method computes the selected items based on the
    /// user selected ones.
    private func selectedItemsListFromUserTopSelectedItems(_ topItems: OrderedSet<String>) -> OrderedSet<String> {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return []
        }
        
        let orderedToItems = self.orderedUserSelectedItems(from: topItems)
        
        var selectedItemsIds = OrderedSet<String>()
        
        for topItem in orderedToItems {
            
            // here item can be nil since we can go back to an non existent
            // item from history
            guard let directoryItemManager = sourceSetManager.directoryItemManager(withId: topItem) else {
                continue
            }
            
            switch directoryItemManager {
            case _ as TextManager:
                selectedItemsIds.append(topItem)
            case let directoryManager as DirectoryManager:
                selectedItemsIds.append(contentsOf: directoryManager.descendantsTextManagers)
            default:
                assertionFailure("Error: unhandled item of type: \(type(of: directoryItemManager))")
                break
            }
        }
        
        return selectedItemsIds
    }
    
    private func orderedUserSelectedItems(from userSelectItems: OrderedSet<String>) -> [String] {
     
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return []
        }
        
        return sourceSetManager.directoryItemManagers.values.filter { (arg) -> Bool in
            return userSelectItems.contains(arg.key)
        }.map { (arg) -> String in
            return arg.key
        }
    }
    
    private func subscribeToSelectedTextItems() {
        
        self.selectedTextItems.subscribe({ [weak self](change) in
            
            // since we are listening to ourselves, it seems
            // we are asked to handle the selected items before
            // the ui which get the token attributes changes before.
            DispatchQueue.asyncOnMain { [weak self] in
                self?.handleSelectedTextItemsChange(change)
            }
        }, observer: self)
    }
    
    private var isMove: Bool = false
    
    private func handleSelectedTextItemsChange(_ change: DynamicOrderedSet<TextId>.Change) {
        switch change {
        case .deletes(_, let deletedTextIds, _):
            for deletedTextId in deletedTextIds {
                if !isMove {
                    self.removeCollapseEditor(forItemWithId: deletedTextId)
                }
                self.textManagersTokenAttributes.removeValue(forKey: deletedTextId)
                self.unsubscribe(fromTextManagerWithId: deletedTextId)
            }
            
        case .insert(let newTextId, _, _):
            // stylo #815
            if removeCollapsedEditors {
                self.removeCollapseEditor(forItemWithId: newTextId)
            }
            self.subscribe(toTextManagerWithId: newTextId)
        case .inserts(let newTextIds, _, _):
            for newTextId in newTextIds {
                // stylo #815
                if removeCollapsedEditors {
                    self.removeCollapseEditor(forItemWithId: newTextId)
                }
                self.subscribe(toTextManagerWithId: newTextId)
            }
        case .end:
            self.isMove = false
        case .move:
            break
        case .start(let sourceOrderedSet, let destinationOrderedSet):
            
            if sourceOrderedSet.containsSameElements(as: destinationOrderedSet) {
                self.isMove = true
            }
            break
        }
        self.handleSelectionChanged()
    }
    
    private func subscribe(toTextManagerWithId textManagerId: TextId) {
        
        if !self.collapsedEditorItems.contains(textManagerId) {
            self.subscribe(toTextManagerTokenAttributesWithId: textManagerId)
        }
    }
    
    private func subscribe(toTextManagerTokenAttributesWithId textManagerId: TextId) {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        guard let textManager = sourceSetManager.textManager(withId: textManagerId) else {
            assertionFailure("Error: expecting text manager")
            return
        }
        
        updateTokenAttributes(fromTextManagerId: textManagerId)
        textManager.tokensAttributes.subscribe({ [weak self](attributesMaps) in
            guard let attributesMaps = attributesMaps else {
                self?.textManagersTokenAttributes.removeValue(forKey: textManager.id)
                return
            }
            self?.textManagersTokenAttributes.updateValue(attributesMaps, forKey: textManager.id)
        }, observer: self)
    }
    
    private func updateTokenAttributes(fromTextManagerId textId: TextId) {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        guard let textManager = sourceSetManager.textManager(withId: textId) else {
            assertionFailure("Error: expecting text manager")
            return
        }
        
        if let attributesMaps = textManager.tokensAttributes.value {
            self.textManagersTokenAttributes.updateValue(attributesMaps, forKey: textManager.id)
        }
    }
    
    private func unsubscribe(fromTextManagerWithId textManagerId: TextId) {
        
        self.unsubscribe(fromTextManagerTokenAttributesWithId: textManagerId)
    }
    
    private func unsubscribe(fromTextManagerTokenAttributesWithId textManagerId: TextId) {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        guard let textManager = sourceSetManager.textManager(withId: textManagerId) else {
            // we may have deleted the manager
            return
        }
        
        textManager.tokensAttributes.unsubscribe(observer: self)
    }
    
    #if DEBUG
    private func validateAllSelectedTextItemsHaveCorrespondingRenderer() {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        for textId in self.selectedTextItems.values {
            
            guard let editorId = self.editorIds[textId] else {
                assertionFailure("Error: editorId is nil")
                continue
            }
            
            guard let textManager = sourceSetManager.textManager(withId: textId) else {
                assertionFailure("Error: textManager is nil")
                continue
            }
            
            assert(textManager.editor(for: editorId) != nil)
        }
    }
    #endif
    
    deinit {
        self.unsubscribeToStore()
        self.unsubscribeToSourceSetManager()
    }
}
