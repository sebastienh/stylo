//
//  StyloAudioPlugin+DataPlugin.swift
//  StyloAudioPlugin
//
//  Created by Sebastien Hamel on 2020-01-08.
//  Copyright © 2020 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon

extension StyloAudioPlugin: DataPlugin {
    
    /// New document, but can be called from an existing document that had
    /// no audio plugin data before.
    public func initData() {
        
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return
        }
        
        let audioFilesManager = AudioFilesManager(audioPluginManager: audioPluginManager)
        audioPluginManager.audioFilesManager = audioFilesManager
    }
    
    /// Reading existing document.
    public func readData(from fileWrapper: FileWrapper?) throws {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            throw PluginError.initError
        }
        
        audioPluginManager.isNew = false
        
        if let fileWrapper = fileWrapper {
            
            let audioMetadataFileWrapper = fileWrapper.fileWrappers?[Constants.Filename.AudioMetadataFileName]
            
            if let audioMetadataFileWrapper = audioMetadataFileWrapper {
            
                guard let data: Data = audioMetadataFileWrapper.regularFileContents else {
                    assertionFailure("Error: data is nil")
                    return
                }
                
                if let audioFilesMetadata = try? AudioFilesMetadata(jsonUTF8Data: data) {
                    
                    guard let documentsAudioFilesFileWrapper = documentsAudioFilesFileWrapper(inPluginFileWrapper: fileWrapper) else {
                        assertionFailure("Error: documentAudioFilesFileWrapper is nil")
                        return
                    }
                    
                    let audioFilesManager = AudioFilesManager(audioFilesMetadata: audioFilesMetadata, audioPluginManager: audioPluginManager, documentsAudioFilesFileWrapper: documentsAudioFilesFileWrapper)
                    audioPluginManager.audioFilesManager = audioFilesManager
                    
                    // we need the audioFilesManager to be set in the audio plugin maanger
                    // for the function updateSelectedItems to work.
                    audioFilesManager.audioFilesOutlineManager.updateSelectedItems()
                    
                    guard let filename = fileWrapper.filename, filename == self.name else {
                        assertionFailure("Error: wrong directory filewrapper.")
                        return
                    }
                }
                else {
                    
                    // it's possible that the file was never initialised with audio before
                    // old format or pure stylo document.
                    throw PluginError.initError
                }
            }
            else {
                
                let audioFilesManager = AudioFilesManager(audioPluginManager: audioPluginManager)
                audioPluginManager.audioFilesManager = audioFilesManager
            }
        }
        else {
            
            // it's possible that the file was never initialised with audio before
            // old format or pure stylo document.
            initData()
        }
    }
    
    private func documentsAudioFilesFileWrapper(inPluginFileWrapper pluginFileWrapper: FileWrapper) -> FileWrapper? {
        
        guard let audioDirectoryFileWrapper = pluginFileWrapper.fileWrappers?["audio"] else {
            assertionFailure("Error: audioDirectoryFileWrapper is nil")
            return nil
        }
        
        return audioDirectoryFileWrapper
    }
}
