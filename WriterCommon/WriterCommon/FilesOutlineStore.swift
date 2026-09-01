//
//  FilesOutlineStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo

/// A project context shows
final class FilesOutlineStore: Store, IdentifiableStoreType {
    
    typealias ReducerType = FilesOutlineReducer
    
    let identifier: String
    
    let reducer: FilesOutlineReducer
    
    var name: Dynamic<String>
    
    let userSelectedItems: DynamicOrderedSet<String>
    
    /// This value is used to store the expanded items in the project outline.
    let expandedItems: DynamicSet<String>
    
    /// This value is used to store the collapsed editors in the project editor. 
    let collapsedEditorItems: DynamicSet<String>
    
    let maxHistory: Dynamic<Int>
    
    let historicStates: DynamicStack<HistoricState>
    
    let historyIndex: Dynamic<Int> = Dynamic<Int>(0)
    
    let historyBackEnabled = Dynamic<Bool>(false)
    
    let historyForwardEnabled = Dynamic<Bool>(false)
    
    let currentHistoricState = Dynamic<HistoricState?>(nil)
    
    init(maxHistory: Int = Constants.FilesOutline.MaxHistorySize, name: String) {
        
        self.identifier = UUID().uuidString
        self.reducer = FilesOutlineReducer()
        self.name = Dynamic<String>(name)
        self.userSelectedItems = DynamicOrderedSet<String>()
        self.expandedItems = DynamicSet<String>()
        self.collapsedEditorItems = DynamicSet<String>()
        self.maxHistory = Dynamic<Int>(maxHistory)
        self.historicStates = DynamicStack<HistoricState>()
        self.historicStates.push(HistoricState.empty)
    }
    
    init(_ filesOutlineMetaData: FilesOutlineMetadata, maxHistory: Int = Constants.FilesOutline.MaxHistorySize) {
        
        self.reducer = FilesOutlineReducer()
        self.identifier = filesOutlineMetaData.id
        self.name = Dynamic<String>(filesOutlineMetaData.name)
        self.userSelectedItems = DynamicOrderedSet<String>(filesOutlineMetaData.outlineUserSelectedItems)
        self.expandedItems = DynamicSet<String>(filesOutlineMetaData.outlineExpandedItems)
        self.collapsedEditorItems = DynamicSet<String>(filesOutlineMetaData.collapsedEditorItems)
        self.maxHistory = Dynamic<Int>(maxHistory)
        let originHistoricState = HistoricState(userSelectedItems: filesOutlineMetaData.outlineUserSelectedItems, expandedItems: Set<String>(filesOutlineMetaData.outlineExpandedItems))
        self.historicStates = DynamicStack<HistoricState>()
        self.historicStates.push(originHistoricState)
    }
}
