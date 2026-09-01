//
//  StyloAudioPlugin+Saving.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-03.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common

extension StyloAudioPlugin: Saving {
    
    var fileWrapperId: String {
        return self.name
    }
    
    func createFileWrapper() -> FileWrapper? {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return nil
        }
        
        var fileWrappersDictionary = [String: FileWrapper]()
        
        let audioPluginFileWrapper = audioPluginManager.createFileWrapper()
        fileWrappersDictionary["audio"] = audioPluginFileWrapper
        
        let pluginDirectoryFileWrapper = FileWrapper(directoryWithFileWrappers: fileWrappersDictionary)
        addMetadata(toFileWrapper: pluginDirectoryFileWrapper)
        pluginDirectoryFileWrapper.preferredFilename = self.fileWrapperId
        updateIsEditedFlag()
        return pluginDirectoryFileWrapper
    }
    
    /// The FileWrapper we receive here is our own file wrapper
    /// rooted at the plugin directory StyleAudioPlugin
    public func fileWrapper(fromCurrentFileWrapper fileWrapper: FileWrapper) -> FileWrapper? {
    
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return fileWrapper
        }
        audioPluginManager.updateData(in: fileWrapper)
        addMetadata(toFileWrapper: fileWrapper)
        updateIsEditedFlag()
        return fileWrapper
    }
    
    private func addMetadata(toFileWrapper fileWrapper: FileWrapper) {
        
        guard let proto = self.metadata else {
            assertionFailure("Error: proto is nil")
            return
        }
        
        guard let data = try? proto.jsonUTF8Data() else {
            assertionFailure("Error: jsonUTF8Data() returned nil")
            return
        }
    
        if let metadataFileWrapper = fileWrapper.fileWrappers?[Constants.Filename.AudioMetadataFileName] {
            fileWrapper.removeFileWrapper(metadataFileWrapper)
        }
        
        fileWrapper.addRegularFile(withContents: data, preferredFilename: Constants.Filename.AudioMetadataFileName)
    }
    
    private func updateIsEditedFlag() {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return
        }
        
        // if there is a recording audio file we skipped it while
        // saving, so the plugin is still edited.
        if self.recordingAudioFileManager == nil {
            audioPluginManager.isEdited = false
        }
    }
    
}
