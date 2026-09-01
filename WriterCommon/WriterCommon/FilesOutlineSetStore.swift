//
//  FilesOutlineSetStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo

class FilesOutlineSetStore: Store, IdentifiableStoreType {
    
    typealias ReducerType = FilesOutlineSetReducer
    
    let identifier: String
    
    let reducer: FilesOutlineSetReducer
    
    let selectedFilesOutlineId: Dynamic<String?>
    
    let filesOutlines: DynamicArray<String>
    
    /// Stylo 761: This was used for allowing non-contiguous layout when there
    /// was only one registered editor, in case of multiple text editor
    /// for the same text we had problems with the display. Since we
    /// have a different NSTextStorage for each editor now, we could
    /// possibly remove this variable.
    let activeEditors: DynamicDictionary<TextId, Set<EditorId>>
    
    init() {
        
        self.identifier = UUID().uuidString
        self.selectedFilesOutlineId = Dynamic<String?>(nil)
        self.filesOutlines = DynamicArray<String>()
        self.activeEditors = DynamicDictionary<TextId, Set<EditorId>>()
        self.reducer = FilesOutlineSetReducer()
    }
    
    init(_ filesOutlineSetMetadata: FilesOutlineSetMetadata) {
        
        self.identifier = filesOutlineSetMetadata.id
        self.selectedFilesOutlineId = Dynamic<String?>(filesOutlineSetMetadata.selectedFilesOutlineID)
        self.filesOutlines = DynamicArray<String>(filesOutlineSetMetadata.filesOutlines.map { (filesOutlineMetadata) -> String in
            return filesOutlineMetadata.id
        }, selectedIndexes: [])
        // this value is updated by the files outline managers when they have computed
        // the selected text items (as opposed to user selected items)
        self.activeEditors = DynamicDictionary<TextId, Set<EditorId>>()
        self.reducer = FilesOutlineSetReducer()
    }
}
