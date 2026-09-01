//
//  DocumentAudioFilesManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon

extension DocumentAudioFilesManager: MetadataProvider {
    
    public typealias MetadataType = DocumentAudioFilesMetadata
    
    private var audioFilesMetadata: [AudioFileMetadata] {
        
        var _audioFilesMetadata = [AudioFileMetadata]()
        
        for audioFileManagerId in self.audioFileManagers.values {
            
            guard let audioFileManager = audioFilesManager.audioFilesSet.values[audioFileManagerId] else {
                assertionFailure("Error: audioFilesManager with id: \(audioFileManagerId) is nil.")
                continue
            }
            
            if audioFileManager.audioState.value != .recording {
                if let audioFileMetadata = audioFileManager.metadata {    
                    _audioFilesMetadata.append(audioFileMetadata)
                }
            }
        }
        return _audioFilesMetadata
    }
    
    public var metadata: DocumentAudioFilesMetadata? {
        
        return DocumentAudioFilesMetadata.with {
            $0.id = self.identifier
            $0.associatedDocumentID = self.associatedDocumentId
            $0.audioFiles = audioFilesMetadata
        }
    }
    
}
