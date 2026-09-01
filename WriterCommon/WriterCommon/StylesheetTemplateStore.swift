//
//  StylesheetTemplateStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

import Igloo
import Common

class StylesheetTemplateStore: Store, IdentifiableStoreType {
    
    typealias ReducerType = StylesheetTemplateReducer
    
    let identifier: String
    
    let name: Dynamic<String>
    
    let expandedItems: DynamicSet<String>
    
    let selectedItem: Dynamic<String?>
    
    let selectedFilesFilterActive: Dynamic<Bool>
    
    let reducer: StylesheetTemplateReducer
    
    init(name: String) {
        
        self.identifier = UUID().uuidString
        self.name = Dynamic<String>(name)
        self.expandedItems = DynamicSet<String>()
        self.selectedItem = Dynamic<String?>(nil)
        self.selectedFilesFilterActive = Dynamic<Bool>(true)
        self.reducer = StylesheetTemplateReducer(storeIdentifier: self.identifier)
    }
    
//    init(metadata: AudioFilesOutlineMetadata) {
//        
//        self.identifier = metadata.id
//        self.name = Dynamic<String>(metadata.name)
//        self.expandedItems = DynamicSet<String>(metadata.expandedItems)
//        self.selectedItem = Dynamic<String?>(metadata.selectedItem)
//        self.selectedFilesFilterActive = Dynamic<Bool>(metadata.selectedFilesFilterActive)
//        self.reducer = StylesheetTemplateReducer(storeIdentifier: metadata.id)
//    }
}
