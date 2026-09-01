//
//  DirectoryManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation


extension DirectoryManager: MetadataProvider {
    
    public typealias MetadataType = DirectoryItemMetadata
    
    public var metadata: DirectoryItemMetadata? {
        
        return DirectoryItemMetadata.with {
            $0.directory = DirectoryMetadata.with {
                $0.id = self.id
                $0.name = self.name.value

                $0.items = self.directoryItemsIds.compactMap ({ (itemId) -> DirectoryItemMetadata? in
                    
                    guard let directoryItemManager = self.sourceSetManager?.directoryItemManager(withId: itemId) else {
                        assert(false, "directoryItemManager is nil")
                        return nil
                    }

                    switch directoryItemManager {
                    case let directoryManager as DirectoryManager:
                        return directoryManager.metadata
                    case let textManager as TextManager:
                        return textManager.metadata
                    default:
                        assert(false, "unhandled manager: \(directoryItemManager)")
                        return nil
                    }
                })
            }
        }
    }
    
}
