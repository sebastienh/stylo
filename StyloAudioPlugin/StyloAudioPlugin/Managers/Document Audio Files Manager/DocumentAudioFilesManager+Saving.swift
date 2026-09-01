//
//  DocumentAudioFilesManager+Saving.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-28.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common

extension DocumentAudioFilesManager: Saving {

    public var fileWrapperId: String {
        return self.id
    }
    
    var url: URL? {
        
        return self.documentAudioFilesDirectoryUrl
    }

    public func createFileWrapper() -> FileWrapper? {

        var audioDirectoryContent: [String: FileWrapper] = [:]
        
        for audioFileManager in self.audioFiles {
            if audioFileManager.audioState.value != .recording {
                audioDirectoryContent[audioFileManager.fileWrapperId] = audioFileManager.createFileWrapper()
            }
        }
        
        let documentAudioFilesDirectoryFileWrapper = FileWrapper(directoryWithFileWrappers: audioDirectoryContent)
        documentAudioFilesDirectoryFileWrapper.preferredFilename = self.fileWrapperId
        return documentAudioFilesDirectoryFileWrapper
    }
    
    /// we receive the document audio files manager file wrapper
    public func updateData(in documentAudioDirectoryFileWrapper: FileWrapper) {
    
        self.removeDeletedAudioFiles(in: documentAudioDirectoryFileWrapper)
        self.addAddedAudioFiles(in: documentAudioDirectoryFileWrapper)
    }
    
    private func addAddedAudioFiles(in documentAudioDirectoryFileWrapper: FileWrapper) {
        
        for audioFileManager in self.audioFiles {
            if documentAudioDirectoryFileWrapper.fileWrappers?[audioFileManager.fileWrapperId] == nil {
                if audioFileManager.audioState.value != .recording {
                    guard let audioFileWrapper = audioFileManager.createFileWrapper() else {
                        assertionFailure("Error: createFileWrapper returned nil")
                        continue 
                    }
                    audioFileWrapper.preferredFilename = audioFileManager.fileWrapperId
                    documentAudioDirectoryFileWrapper.addFileWrapper(audioFileWrapper)
                }
            }
        }
    }
    
    private func removeDeletedAudioFiles(in documentAudioDirectoryFileWrapper: FileWrapper) {
        
        for deletedAudioFileId in self.deletedAudioFilesIds {
            if let audioFileWrapper = documentAudioDirectoryFileWrapper.fileWrappers?[deletedAudioFileId] {
                documentAudioDirectoryFileWrapper.removeFileWrapper(audioFileWrapper)
            }
        }
        
        self.deletedAudioFilesIds.removeAll()
    }
    
}
