//
//  AudioPluginManager+Saving.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-28.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common

extension AudioPluginManager: Saving {
    
    public var fileWrapperId: String {
        return "audio"
    }
    
    public func createFileWrapper() -> FileWrapper? {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return nil
        }
        
        guard let audioFilesManagerFileWrapper = audioFilesManager.createFileWrapper() else {
            assertionFailure("Error: createFileWrapper returned nil")
            return nil
        }
        audioFilesManagerFileWrapper.preferredFilename = self.fileWrapperId
        return audioFilesManagerFileWrapper
    }
    
    /// The FileWrapper we receive here is our own file wrapper
    /// rooted at the plugin directory StyleAudioPlugin
    public func updateData(in fileWrapper: FileWrapper) -> FileWrapper {
        
        guard let fileWrappers = fileWrapper.fileWrappers else {
            assertionFailure("Error: fileWrapper.fileWrappers is nil")
            return fileWrapper
        }
        
        guard let audioFileWrapper = fileWrappers[self.fileWrapperId] else {
            assertionFailure("Error: fileWrappers[\"\(self.fileWrapperId)\"] is nil")
            return fileWrapper
        }
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return fileWrapper
        }
        
        audioFilesManager.updateData(in: audioFileWrapper)
        return fileWrapper
    }
    
}
