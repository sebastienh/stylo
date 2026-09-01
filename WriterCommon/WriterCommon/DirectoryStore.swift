//
//  DirectoryStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-25.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common

class DirectoryStore: Store, IdentifiableStoreType {
    
    typealias ReducerType = DirectoryReducer
    
    let identifier: String
    
    let reducer: DirectoryReducer
    
    let directoryItemsIds: DynamicArray<String>
    
    let name: Dynamic<String>
    
    public let parentID: Dynamic<String>
    
    public let pathComponents: DynamicArray<String>
    
    init(id: String, name: String, parentId: String) {
        
        self.identifier = id
        self.reducer = DirectoryReducer()
        self.directoryItemsIds = DynamicArray<String>()
        self.name = Dynamic<String>(name)
        self.parentID = Dynamic<String>(parentId)
        self.pathComponents = DynamicArray<String>()
    }
    
    init(directoryMetadata: DirectoryMetadata, name: String, parentId: String) {
        
        self.identifier = directoryMetadata.id
        self.reducer = DirectoryReducer()
        self.directoryItemsIds = DynamicArray<String>()
        self.name = Dynamic<String>(name)
        self.parentID = Dynamic<String>(parentId)
        self.pathComponents = DynamicArray<String>()
    }
}
