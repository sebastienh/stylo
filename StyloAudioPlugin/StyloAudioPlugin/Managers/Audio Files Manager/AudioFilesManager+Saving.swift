//
//  AudioFilesManager+Saving.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-28.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common

extension AudioFilesManager: Saving {

    public var fileWrapperId: String {
        return ""
    }
    
    public func createFileWrapper() -> FileWrapper? {
        
        var documentAudioFilesDirectories: [String: FileWrapper] = [:]
        
        for (documentAudioFilesId, documentAudioFilesManager) in self.documentAudioFilesSet.values {
            documentAudioFilesDirectories[documentAudioFilesId] = documentAudioFilesManager.createFileWrapper()
        }
        
        let audioDirectoryFileWrapper = FileWrapper(directoryWithFileWrappers: documentAudioFilesDirectories)
        return audioDirectoryFileWrapper
    }
    
    /// The FileWrapper we receive here is our own file wrapper
    /// rooted at the plugin directory StyleAudioPlugin
    public func updateData(in audioFileWrapper: FileWrapper) {
        
        guard let documentAudioFilesFileWrappers = audioFileWrapper.fileWrappers else {
            assertionFailure("Error: audioFileWrapper.fileWrappers is nil")
            return
        }
        
        // remove deleted document audio files directories
        for deletedDocumentAudioFilesId in deletedDocumentAudioFilesIds {
            
            // it's possible we delete a document which has never been saved, so
            // it may not be in the file wrappers
            if let deletedDocumentAudioFilesFileWrapper =  documentAudioFilesFileWrappers[deletedDocumentAudioFilesId] {
                audioFileWrapper.removeFileWrapper(deletedDocumentAudioFilesFileWrapper)
            }
        }
        
        deletedDocumentAudioFilesIds.removeAll()
        
        for (documentAudioFilesId, documentAudioFilesManager) in self.documentAudioFilesSet.values {
            
            if let documentAudioFilesManagerFileWrapper = documentAudioFilesFileWrappers[documentAudioFilesId] {
                
                documentAudioFilesManager.updateData(in: documentAudioFilesManagerFileWrapper)
            }
            else {
                guard let documentAudioFilesManagerFileWrapper = documentAudioFilesManager.createFileWrapper() else {
                    assertionFailure("Error: createFileWrapper returned nil")
                    continue
                }
                documentAudioFilesManagerFileWrapper.preferredFilename = documentAudioFilesManager.fileWrapperId
                audioFileWrapper.addFileWrapper(documentAudioFilesManagerFileWrapper)
            }
        }
    }
    
}
