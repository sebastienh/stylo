//
//  AudioFilesOutlineManager.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-13.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import Igloo

class AudioFilesOutlineManager: NSObject, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    let name: Dynamic<String>
    
    let expandedItems: DynamicSet<String>
    
    let selectedItem: Dynamic<String?>
    
    let selectedDocument: Dynamic<String?>

    let selectedAudio: Dynamic<String?>
    
    let selectedFilesFilterActive: Dynamic<Bool>
    
    private let identifier: String
    
    private let audioFilesOutlineStore: AudioFilesOutlineStore
    
    private unowned let audioPluginManager: AudioPluginManager
    
    private var audioFilesManager: AudioFilesManager? {
        return audioPluginManager.audioFilesManager
    }
    
    private var dispatcher: Dispatcher? {
        return audioPluginManager.audioPluginDispatcher
    }
    
    init(name: String, audioPluginManager: AudioPluginManager) {
        
        self.audioFilesOutlineStore = AudioFilesOutlineStore(name: name)
        self.identifier = self.audioFilesOutlineStore.identifier
        self.name = Dynamic<String>(name)
        self.expandedItems = DynamicSet<String>()
        self.selectedItem = Dynamic<String?>(nil)
        self.selectedDocument = Dynamic<String?>(nil)
        self.selectedAudio = Dynamic<String?>(nil)
        self.selectedFilesFilterActive = Dynamic<Bool>(true)
        self.audioPluginManager = audioPluginManager
        super.init()
        subscribeToStore()
    }
    
    init(audioFilesOutlineMetadata: AudioFilesOutlineMetadata, audioPluginManager: AudioPluginManager) {
        
        self.audioFilesOutlineStore = AudioFilesOutlineStore(metadata: audioFilesOutlineMetadata)
        self.identifier = self.audioFilesOutlineStore.identifier
        self.name = Dynamic<String>(audioFilesOutlineMetadata.name)
        self.expandedItems = DynamicSet<String>(audioFilesOutlineMetadata.expandedItems)
        self.selectedItem = Dynamic<String?>(audioFilesOutlineMetadata.selectedItem.isEmpty ? nil : audioFilesOutlineMetadata.selectedItem)
        self.selectedDocument = Dynamic<String?>(nil)
        self.selectedAudio = Dynamic<String?>(nil)
        self.selectedFilesFilterActive = Dynamic<Bool>(audioFilesOutlineMetadata.selectedFilesFilterActive)
        self.audioPluginManager = audioPluginManager
        super.init()
        subscribeToStore()
    }
    
    public func updateSelectedFilesFilterState(to newValue: Bool) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        try? dispatcher.online(store: self.audioFilesOutlineStore, action: AudioFilesOutlineAction.updateSelectedFilesFilterActiveState(state: newValue))
    }
    
    public func addExpandedItem(withId id: String) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        try? dispatcher.online(store: self.audioFilesOutlineStore, action: AudioFilesOutlineAction.documentAudioExpanded(id: id))
    }
    
    public func removeExpandedItem(withId id: String) {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        try? dispatcher.online(store: self.audioFilesOutlineStore, action: AudioFilesOutlineAction.documentAudioCollapsed(id: id))
    }
    
    public func unselectCurrentItem() {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        try? dispatcher.online(store: self.audioFilesOutlineStore, action: AudioFilesOutlineAction.userUnselectedItem)
    }
    
    public func selectItem(withId id: String) {
        
        // we don't want to select two two times the same element
        if let selectedItem = self.selectedItem.value, id == selectedItem {
            return
        }
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        // make sure there is no selection anymore, we just need to make sure that these two are
        // ordered, hence the sync followed by async call.
        dispatcher.async(store: self.audioFilesOutlineStore, action: AudioFilesOutlineAction.userSelectedItem(id: id).asyncAction)
    }
    
    func updateSelectedItems() {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return
        }
        
        guard let selectedItemIdValue = self.selectedItem.value else {
            // no error, there is simply no selection
            return
        }
        
        if let audioFileManager = audioFilesManager.audioFilesSet.values[selectedItemIdValue] {
            self.selectedDocument.setValue(audioFileManager.parentId)
            
            // #550: we stop the current playing only if the newly selected item is not the currently
            // playing one
            if let playingAudioFile = audioFilesManager.playingAudioFile.value, playingAudioFile.id != selectedItemIdValue {
                try? audioFilesManager.stopCurrentPlaying()
            }
            self.selectedAudio.setValue(selectedItemIdValue)
        }
        else if audioFilesManager.documentAudioFilesSet.values[selectedItemIdValue] != nil {
            
            self.selectedDocument.setValue(selectedItemIdValue)
            self.selectedAudio.setValue(nil)
        }
        else {
            self.selectedDocument.setValue(nil)
            self.selectedAudio.setValue(nil)
        }
    }
    
    private func subscribeToStore() {
        
        self.name.bind(to: self.audioFilesOutlineStore.name)
        self.expandedItems.bind(to: self.audioFilesOutlineStore.expandedItems)
        self.audioFilesOutlineStore.selectedItem.subscribe({ [weak self](newValue) in
            self?.selectedItem.setValue(newValue, sameExecutionStack: true)
            self?.updateSelectedItems()
        }, observer: self)
        self.selectedFilesFilterActive.bind(to: self.audioFilesOutlineStore.selectedFilesFilterActive)
    }
    
    private func unsubscribeToStore() {
        
        self.name.unbind(from: self.audioFilesOutlineStore.name)
        self.expandedItems.unbind(from: self.audioFilesOutlineStore.expandedItems)
        self.audioFilesOutlineStore.selectedItem.unsubscribe(observer: self)
    }
    
    deinit {
        self.unsubscribeToStore()
    }
    
}
