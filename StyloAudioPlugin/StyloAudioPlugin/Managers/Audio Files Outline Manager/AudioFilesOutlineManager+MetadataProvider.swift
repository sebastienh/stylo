//
//  AudioFilesOutlineManager+MetadataProvider.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-15.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon

extension AudioFilesOutlineManager: MetadataProvider {
    
    public typealias MetadataType = AudioFilesOutlineMetadata
    
    public var metadata: AudioFilesOutlineMetadata? {

        return AudioFilesOutlineMetadata.with {
            
            $0.expandedItems = self.expandedItems.values.map({ (itemId) -> String in
                return itemId
            })
            if let selectedItem = self.selectedItem.value {
                $0.selectedItem = selectedItem
            }
            $0.selectedFilesFilterActive = self.selectedFilesFilterActive.value
        }
    }
}
