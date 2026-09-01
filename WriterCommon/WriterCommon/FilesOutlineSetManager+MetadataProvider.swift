//
//  FilesOutlineSetManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation


extension FilesOutlineSetManager: MetadataProvider {
    
    public typealias MetadataType = FilesOutlineSetMetadata
    
    public var metadata: FilesOutlineSetMetadata? {

        assert(self.selectedFilesOutlineID.value != nil)
        return FilesOutlineSetMetadata.with {
            $0.id = self.id
            if let selectedFilesOutlineID = self.selectedFilesOutlineID.value {
                $0.selectedFilesOutlineID = selectedFilesOutlineID
            }
            $0.filesOutlines = self.filesOutlines.values.compactMap({ (filesOutlineManager) -> FilesOutlineMetadata? in
                assert(filesOutlineManager.metadata != nil)
                return filesOutlineManager.metadata
            })
        }
    }
    
    
}
