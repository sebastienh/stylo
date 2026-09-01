//
//  FilesOutlineSetManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo
import os

enum FilesOutlineSetManagerError: Error {
    
    case noSelectedFilesOutline
}


public class FilesOutlineSetManager: NSObject, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    let id: String
    
    public let selectedFilesOutlineID: Dynamic<String?>
    
    public let filesOutlines: DynamicArray<FilesOutlineManager>
    
    let filesOutlineSetStore: FilesOutlineSetStore
    
    public var selectedFilesOutlineManager: Dynamic<FilesOutlineManager?>
    
    public var selectedTextFiles: Set<String> {
        
        var selectedFiles = Set<String>()
        
        for filesOutline in filesOutlines.values {
            for selectedItem in filesOutline.selectedTextItems.values {
                selectedFiles.insert(selectedItem)
            }
        }
        return selectedFiles
    }
    
    public let activeEditors = DynamicDictionary<TextId, Set<EditorId>>()
    
    private unowned let documentManager: DocumentManager
    
    private var dispatcher: Dispatcher? {
        
        return documentManager.dispatcher
    }
    
    var nextAvailableUntitledFilesOutlineName: String {
        
        var filesOutlinesNames = [String]()
        
        var filesOutlineManagerNameWithDefaultUntitledNameExists: Bool = false
        
        for filesOutlineManager in self.filesOutlines.values {
            
            let filesOutlineManagerName = filesOutlineManager.name.value
            
            if filesOutlineManagerName.lowercased() == Constants.Filename.DefaultFilesOutlineName.lowercased() {
                filesOutlineManagerNameWithDefaultUntitledNameExists = true
            }
            
            filesOutlinesNames.append(filesOutlineManagerName)
        }
        
        if !filesOutlineManagerNameWithDefaultUntitledNameExists {
            return Constants.Filename.DefaultFilesOutlineName
        }
        return "\(Constants.Filename.DefaultFilesOutlineName) \(filesOutlinesNames.nextFreeEndNumber)"
    }
    
    init(documentManager: DocumentManager) {
        
        self.id = UUID().uuidString
        self.filesOutlines = DynamicArray<FilesOutlineManager>()
        
        // create a default project outline store
        self.filesOutlineSetStore = FilesOutlineSetStore()
        self.selectedFilesOutlineID = Dynamic<String?>(nil)
        self.selectedFilesOutlineManager = Dynamic<FilesOutlineManager?>(nil)
        self.documentManager = documentManager
        super.init()
        addEmptyFilesOutlineManagerAndSelectIt()
        subscribeToStore()
    }
    
    init(filesOutlineSetMetadata: FilesOutlineSetMetadata, documentManager: DocumentManager) {
        
        self.id = filesOutlineSetMetadata.id
        self.filesOutlineSetStore = FilesOutlineSetStore(filesOutlineSetMetadata)
        
        // the selected files outline maanger is handled in subscribeToStore method
        self.selectedFilesOutlineID = Dynamic<String?>(nil)
        self.selectedFilesOutlineManager = Dynamic<FilesOutlineManager?>(nil)
        self.filesOutlines = DynamicArray<FilesOutlineManager>()
        self.documentManager = documentManager
        super.init()
        loadProjectContexts(filesOutlineSetMetadata)
        subscribeToStore()
    }
    
    public func allEditorsIds(for textId: TextId) -> [EditorId] {
        self.filesOutlines.values.compactMap({ (filesOutlineManager) -> EditorId? in
            return filesOutlineManager.editorId(forTextId: textId)
        })
    }
    
    /// When the user moves selected items that are not part of the user selected
    /// items we do not handle it in the FilesOutlineManagers since its selectedTextItems
    /// is a derived value from userSelectedTextItems and respond to change from this
    /// only.
    ///
    /// This code also handles the case where a files outline user selected items
    /// contains a directory and this directory is modified outside the files outline
    /// manager. Typical case is we add a text using the edior plus button and another
    /// files selects the containing directory. The later needs to also show the
    /// new text manager.
    ///
    ///
    /// Moves are sent to the SourceSetManager which controls the textManagers array
    /// so the complexity of handling the final position of an element after a move is
    /// already handled in SourceSetManager.
    public func handleGlobalTextManagersChange() {
        
        self.updateAllSelectedItems()
    }
    
    /// Remove an item that is not currently user selected (note that
    /// it may be part of the computed selection though).
    public func removeSelectedFilesOutlineNotUserSelectedItem(withId id: String) throws {
        
        #if DEBUG
        // validate that we are not mistakenly deleting an item from the user
        // selected items of the selected flies outline manager...
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager.value else {
            assertionFailure("Error: self.selectedFilesOutlineManager.value is nil")
            throw FilesOutlineSetManagerError.noSelectedFilesOutline
        }
        assert(!selectedFilesOutlineManager.userSelectedItemsIdsArray.contains(id))
        #endif
        
        for filesOutline in filesOutlines.values {
            filesOutline.removeItem(itemId: id)
        }
    }
    
    public func removeUserSelectedItems(withIds ids: [String]) throws -> [String] {
    
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager.value else {
            assertionFailure("Error: self.selectedFilesOutlineManager.value is nil")
            throw FilesOutlineSetManagerError.noSelectedFilesOutline
        }
        
        selectedFilesOutlineManager.removeUserSelectedItems(withIds: ids)
        
        for filesOutline in filesOutlines.values {
            
            // for all the other files outline we should manage the deletion
            // on a per item basis.
            if filesOutline.id != selectedFilesOutlineManager.id {
                for id in ids {
                    filesOutline.removeItem(itemId: id)
                }
            }
        }
        return ids
    }
    
    /// Remove the user selected items from the selected files outline manager
    /// and returns the deleted top items (no recursion to go into directories)
    public func removeSelectedFilesOutlineUserSelectedItems() throws -> [String] {
        
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager.value else {
            assertionFailure("Error: self.selectedFilesOutlineManager.value is nil")
            throw FilesOutlineSetManagerError.noSelectedFilesOutline
        }
        
        let selectedFilesOutlineUserSelectedItemdsIds = selectedFilesOutlineManager.userSelectedItemsIdsArray
        
        selectedFilesOutlineManager.removeAllUserSelectedItems(itemIds: selectedFilesOutlineUserSelectedItemdsIds)
        
        for filesOutline in filesOutlines.values {
            
            // for all the other files outline we should manage the deletion
            // on a per item basis.
            if filesOutline.id != selectedFilesOutlineManager.id {
                
                for selectedFilesOutlineUserSelectedItemdId in selectedFilesOutlineUserSelectedItemdsIds {
                    filesOutline.removeItem(itemId: selectedFilesOutlineUserSelectedItemdId)
                }
            }
        }
        return selectedFilesOutlineUserSelectedItemdsIds
    }
    
    public func index(ofFilesOutlineManager filesOutlineManager: FilesOutlineManager) -> Int? {
        
        for (index, outline) in self.filesOutlines.values.enumerated() {
            if outline.id == filesOutlineManager.id {
                return index
            }
        }
        return nil
    }

    public func filesOutlineManager(withTitle filesOutlineManagerTitle: String) -> FilesOutlineManager? {
        
        for projectOutline in self.filesOutlines.values {
            if projectOutline.name.value == filesOutlineManagerTitle {
                return projectOutline
            }
        }
        return nil
    }
    
    public func filesOutlineManager(withId filesOutlineManagerId: String) -> FilesOutlineManager? {
        
        for projectOutline in self.filesOutlines.values {
            if projectOutline.id == filesOutlineManagerId {
                return projectOutline
            }
        }
        return nil
    }
    
    func addEmptyFilesOutlineManagerAndSelectIt() {
        
        guard let currentSourceStyleAssemblyDescriptor = self.documentManager.currentSourceStyleAssemblyDescriptor else {
            assertionFailure("Error: self.currentPermanentStyleAssemblyDescriptor is nil")
            return
        }
        
        let filesOutlineManager = FilesOutlineManager(documentManager: documentManager, styleAssemblyDescriptor: currentSourceStyleAssemblyDescriptor)
        addFilesOutlineManager(filesOutlineManager)
        filesOutlineManagerSelected(withId: filesOutlineManager.id)
    }

    public func filesOutlineManagerSelected(withId id: String) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        assert(self.filesOutlineManager(withId: id) != nil)
        if let selectedFilesOutlineID = self.selectedFilesOutlineID.value {
            if selectedFilesOutlineID != id {
                try? dispatcher.online(store: self.filesOutlineSetStore, action: FilesOutlineSetAction.filesOutlineSelected(id: id))
            }
        }
        else {
            try? dispatcher.online(store: self.filesOutlineSetStore, action: FilesOutlineSetAction.filesOutlineSelected(id: id))
        }
    }

    func removeFilesOutlineManager(_ filesOutlineManager: FilesOutlineManager, atIndex index: Int) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        unregisterActiveEditors(from: filesOutlineManager)
        unregisterEditors(from: filesOutlineManager)
        let lastIndex = self.filesOutlines.count-1
        try? dispatcher.online(store: self.filesOutlineSetStore, action: FilesOutlineSetAction.filesOutlineRemovedAtIndex(index: index))
        self.filesOutlines.remove(atIndex: index)
        unsubscribe(from: filesOutlineManager)
        
        guard let selectedFilesOutlineID = self.selectedFilesOutlineID.value else {
            assertionFailure("Error: selectedFilesOutlineID is nil")
            return
        }
        
        if filesOutlineManager.id == selectedFilesOutlineID {
            DispatchQueue.main.async { [weak self] in
                self?.changeSelectedFilesOutline(forDeletedIndex: index, wasLast: index == lastIndex)
            }
        }
    }
    
    private func changeSelectedFilesOutline(forDeletedIndex index: Int, wasLast last: Bool) {
        
        // if the deleted files outline manager was the first one
        // we promote the new "first one" to the new selected one
        
        let nextFilesOutlineManagerIndex: Int = {
            if index == 0 {
                return 0
            }
            else if !last {
                guard index >= 0 && index < self.filesOutlines.values.count else {
                    assertionFailure("Error: it seems the index is out of range")
                    // we default to 0
                    return 0
                }
                return index-1
            }
            else {
                // we promote the files outline before the index that was deleted
                guard index > 0 else {
                    assertionFailure("Error: it seems the index is out of range")
                    // we default to 0
                    return 0
                }
                return index-1
            }
        }()
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        let filesOutlineManagerToSelect = self.filesOutlines.values[nextFilesOutlineManagerIndex]
        try? dispatcher.online(store: self.filesOutlineSetStore, action: FilesOutlineSetAction.filesOutlineSelected(id: filesOutlineManagerToSelect.id))
        
        #if DEBUG
        self.validateFilesOutlinesStore()
        #endif
    }
    
    func addFilesOutlineManager(_ filesOutlineManager: FilesOutlineManager) {
        
        self.addFilesOutlineManager(filesOutlineManager, atIndex: self.filesOutlines.count)
    }
    
    func addFilesOutlineManager(_ filesOutlineManager: FilesOutlineManager, atIndex index: Int) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        try? dispatcher.online(store: self.filesOutlineSetStore, action: FilesOutlineSetAction.filesOutlineAddedAtIndex(id: filesOutlineManager.id, index: index))
        self.filesOutlines.insert(filesOutlineManager, at: index)
        registerActiveEditors(from: filesOutlineManager)
        subscribe(to: filesOutlineManager)
        #if DEBUG
        self.validateFilesOutlinesStore()
        #endif
    }
    
    public func updateAllSelectedItems() {
        
        for projectOutline in self.filesOutlines.values {
            projectOutline.updateSelectedItems(removeCollapsedEditors: false)
        }
    }
    
    private func subscribeToStore() {
        
        self.handleSelectedFilesOutlineManager(withId: filesOutlineSetStore.selectedFilesOutlineId.value)
        filesOutlineSetStore.selectedFilesOutlineId.subscribe({ [weak self] (newSelectedProjectContextId) in
            self?.handleSelectedFilesOutlineManager(withId: newSelectedProjectContextId)
        }, observer: self)
        
        filesOutlineSetStore.activeEditors.subscribe({ [weak self](change) in
            self?.handleActiveEditorsChange(change)
        }, observer: self)
    }
    
    private func handleActiveEditorsChange(_ change: DynamicDictionary<TextId, Set<EditorId>>.DictionaryChange) {
        
        switch change {
        case .deletes(let removedValues, _):
            for (key, _) in removedValues {
                self.activeEditors.removeValue(forKey: key)
            }
        case .updates(let keys, let udpatedValues):
            for key in keys {
                guard let value = udpatedValues[key] else {
                    assertionFailure("Error: no value for key: \(key)")
                    continue
                }
                self.activeEditors.updateValue(value, forKey: key)
            }
        case .start: fallthrough
        case .end:
            assertionFailure("Error: unhandled case")
            break
        }
    }
    
    private func handleSelectedFilesOutlineManager(withId id: String?) {
        
        guard let id = id else {
            // it's possible the files is might be nil
            return
        }
        
        self.selectedFilesOutlineID.setValue(id)
        self.updateSelectedFilesOutlineManager()
    }
    
    private func loadProjectContexts(_ filesOutlineSetMetadata: FilesOutlineSetMetadata) {

        guard let currentSourceStyleAssemblyDescriptor = self.documentManager.currentSourceStyleAssemblyDescriptor else {
            assertionFailure("Error: self.currentSourceStyleAssemblyDescriptor is nil")
            return
        }
        
        for filesOutlineMetadata in filesOutlineSetMetadata.filesOutlines {
            let filesOutlineManager = FilesOutlineManager(filesOutlineMetadata: filesOutlineMetadata, documentManager: self.documentManager, styleAssemblyDescriptor: currentSourceStyleAssemblyDescriptor)
            self.filesOutlines.append(filesOutlineManager)
            registerActiveEditors(from: filesOutlineManager)
            subscribe(to: filesOutlineManager)
        }
    }
    
    private func updateSelectedFilesOutlineManager() {
        
        let selectedFilesOutlineID = self.selectedFilesOutlineID.value
        for filesOutline in filesOutlines.values {
            if filesOutline.id == selectedFilesOutlineID {
                self.selectedFilesOutlineManager.setValue(filesOutline)
                break
            }
        }
        assert(selectedFilesOutlineManager.value != nil)
    }

    private func validateFilesOutlinesStore() {
        #if DEBUG
        assert(filesOutlines.values.count == self.filesOutlineSetStore.filesOutlines.count)
        for i in 0..<filesOutlines.values.count {
            let filesOutline = filesOutlines.values[i]
            let storeFilesOutline = self.filesOutlineSetStore.filesOutlines.values[i]
            assert(filesOutline.id == storeFilesOutline)
        }
        #endif
    }
    
    private func unsubscribe(from filesOutlineManager: FilesOutlineManager) {

        filesOutlineManager.selectedTextItems.unsubscribe(observer: self)
    }
    
    func subscribe(to filesOutlineManager: FilesOutlineManager) {

        filesOutlineManager.selectedTextItems.subscribe({ [weak self](arrayChange) in
            self?.handleSelectedItemsChange(arrayChange, inFilesOutlineManager: filesOutlineManager)
        }, observer: self)
    }
    
    private func handleSelectedItemsChange(_ arrayChange: DynamicOrderedSet<String>.Change, inFilesOutlineManager filesOutlineManager: FilesOutlineManager) {
        
        switch arrayChange {
        case .insert(let textId, _, _):
            registerActiveEditor(forTextId: textId, in: filesOutlineManager)
        case .inserts(let newElements, _, _):
            for textId in newElements {
                registerActiveEditor(forTextId: textId, in: filesOutlineManager)
            }
        case .deletes(_, let deletedValues, _):
            for textId in deletedValues {
                unregisterActiveEditor(forTextId: textId, in: filesOutlineManager)
            }
        case .move: fallthrough
        case .start: fallthrough
        case .end:
            break
        }
    }
    
    private func registerActiveEditors(from filesOutlineManager: FilesOutlineManager) {
     
        for textId in filesOutlineManager.selectedTextItems.values {
            registerActiveEditor(forTextId: textId, in: filesOutlineManager)
        }
    }
    
    private func unregisterActiveEditors(from filesOutlineManager: FilesOutlineManager) {
        
        for textId in filesOutlineManager.selectedTextItems.values {
            unregisterActiveEditor(forTextId: textId, in: filesOutlineManager)
        }
    }
    
    private func unregisterEditors(from filesOutlineManager: FilesOutlineManager) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("unregisterEditors(from: %@)", log: Log.WriterCommon.textStorage, type: .debug, %%filesOutlineManager)
        #endif
        
        for textId in filesOutlineManager.selectedTextItems.values {
            
            filesOutlineManager.unregisterEditor(forTextId: textId)
        }
    }
    
    private func unregisterActiveEditor(forTextId textId: TextId, in filesOutlineManager: FilesOutlineManager) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        guard let editorId = filesOutlineManager.editorId(forTextId: textId) else {
            assertionFailure("Error: editorId is nil")
            return
        }
        try? dispatcher.online(store: self.filesOutlineSetStore, action: FilesOutlineSetAction.unregisterEditorForTextId(editorId: editorId, textId: textId))
    }
    
    private func registerActiveEditor(forTextId textId: TextId, in filesOutlineManager: FilesOutlineManager) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        let editorId = filesOutlineManager.createOrGetEditorId(forTextId: textId)
        try? dispatcher.online(store: self.filesOutlineSetStore, action: FilesOutlineSetAction.registerEditorForTextId(editorId: editorId, textId: textId))
    }
    
    deinit {
        filesOutlineSetStore.selectedFilesOutlineId.unsubscribe(observer: self)
        filesOutlineSetStore.filesOutlines.unsubscribe(observer: self)
        filesOutlineSetStore.activeEditors.unsubscribe(observer: self)
    }
    
}
