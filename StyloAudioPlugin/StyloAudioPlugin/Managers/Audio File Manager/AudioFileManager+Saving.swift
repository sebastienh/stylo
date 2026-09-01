//
//  AudioFileManager+Saving.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-28.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common

extension AudioFileManager: Saving {

    public var fileWrapperId: String {
        return self.filename
    }
    
    private var url: URL? {
        
        guard let originalRecordingUrl = self.audioFileStore.originalRecordingUrl else {
            assertionFailure("Error: originalRecordingUrl is nil")
            return nil
        }
        return originalRecordingUrl
    }
    
    public func createFileWrapper() -> FileWrapper? {
        
        guard let url = self.url else {
            assertionFailure("Error: self.url is nil")
            return nil
        }
        
        do {
            let contentFileWrapper = try FileWrapper(url: url, options: [])
            self.audioPluginManager.addTemporaryFileToDelete(url)
            
            // we replace the player with a data player since the file
            // is in a temporary url and can be deleted by the system.
            let data = try Data(contentsOf: url)
            try self.createDataPlayer(fromData: data)
            
            contentFileWrapper.preferredFilename = self.fileWrapperId
            
            return contentFileWrapper
        }
        catch {
            assertionFailure("Error: error(\(error))getting content at url: \(url)")
            return nil
        }
    }
}
