//
//  AudioFilesOutlineStore.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-13.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Igloo
import Common

class AudioFilesOutlineStore: Store, IdentifiableStoreType {
    
    typealias ReducerType = AudioFilesOutlineReducer
    
    let identifier: String
    
    let name: Dynamic<String>
    
    let expandedItems: DynamicSet<String>
    
    let selectedItem: Dynamic<String?>
    
    let selectedFilesFilterActive: Dynamic<Bool>
    
    let reducer: AudioFilesOutlineReducer
    
    init(name: String) {
        
        self.identifier = UUID().uuidString
        self.name = Dynamic<String>(name)
        self.expandedItems = DynamicSet<String>()
        self.selectedItem = Dynamic<String?>(nil)
        self.selectedFilesFilterActive = Dynamic<Bool>(true)
        self.reducer = AudioFilesOutlineReducer(storeIdentifier: self.identifier)
    }
    
    init(metadata: AudioFilesOutlineMetadata) {
        
        self.identifier = metadata.id
        self.name = Dynamic<String>(metadata.name)
        self.expandedItems = DynamicSet<String>(metadata.expandedItems)
        self.selectedItem = Dynamic<String?>(metadata.selectedItem)
        self.selectedFilesFilterActive = Dynamic<Bool>(metadata.selectedFilesFilterActive)
        self.reducer = AudioFilesOutlineReducer(storeIdentifier: metadata.id)
    }
    
    
}
