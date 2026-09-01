//
//  FilesOutlineManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-25.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation


extension FilesOutlineManager: MetadataProvider {
    
    public typealias MetadataType = FilesOutlineMetadata
    
    public var metadata: FilesOutlineMetadata? {
        
        return FilesOutlineMetadata.with {
            $0.id = self.id
            $0.outlineExpandedItems = Array<String>(self.filesOutlineStore.expandedItems.values)
            $0.collapsedEditorItems = Array<String>(self.filesOutlineStore.collapsedEditorItems.values)
            $0.outlineUserSelectedItems = Array<String>(self.filesOutlineStore.userSelectedItems.values)
            $0.name = self.filesOutlineStore.name.value
        }
    }
}
