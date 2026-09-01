//
//  AudioFilesManager+MetadataProvider.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-08-29.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon

extension AudioFilesManager: MetadataProvider {
    
    public typealias MetadataType = AudioFilesMetadata
    
    public var metadata: AudioFilesMetadata? {
        
        return AudioFilesMetadata.with {
            
            $0.id = self.identifier
            $0.documentAudioFiles = self.documentAudioFilesArray.values.compactMap({ (id) -> DocumentAudioFilesMetadata? in
                
                guard let documentAudioFilesManager = self.documentAudioFilesSet.values[id] else {
                    assertionFailure("Error: documentAudioFilesManager with id: \(id) is nil.")
                    return nil
                }
                return documentAudioFilesManager.metadata
            })
            if let metadata = self.audioFilesOutlineManager.metadata {
                $0.audioFilesOutline = metadata
            }
        }
    }
}
