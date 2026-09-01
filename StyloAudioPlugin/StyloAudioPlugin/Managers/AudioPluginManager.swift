//
//  AudioPluginManager.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-08-29.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon

class AudioPluginManager {
    
    let documentManager: DocumentManager
    let audioPluginState: AudioPluginState
    let audioPluginDispatcher: AudioPluginDispatcher
    
    var audioFilesManager: AudioFilesManager?
    
    private var temporaryFilesToDelete: [URL]
    
    var isEdited: Bool = false {
        didSet {
            self.isNew = false
        }
    }
    
    var notifyContentManager: Bool = true
    
    var isDraft: Bool {
        
        return isNew && isEdited
    }
    
    var isNew: Bool = true
    
    var pluginUrl: URL {
        
        return self.documentManager.pluginUrl(withName: Constants.Plugin.Name)
    }
    
    init(documentManager: DocumentManager) {
        
        self.documentManager = documentManager
        self.audioPluginState = AudioPluginState()
        self.audioPluginDispatcher = AudioPluginDispatcher(state: self.audioPluginState)
        self.temporaryFilesToDelete = [URL]()
    }
    
    func addTemporaryFileToDelete(_ url: URL) {
        
        temporaryFilesToDelete.append(url)
    }
    
    func clearTemporaryFiles() {
        
        for temporaryFileToDelete in temporaryFilesToDelete {
            
            do {
                try FileManager.default.removeItem(at: temporaryFileToDelete)
            }
            catch let error {
                assertionFailure("Error: unable to remove item at url: \(temporaryFileToDelete): \(error)")
            }
        }
        for temporaryFileToDelete in temporaryFilesToDelete {
        
            var _temporaryFileToDelete = temporaryFileToDelete
            _temporaryFileToDelete.deleteLastPathComponent()
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: _temporaryFileToDelete.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    do {
                        let contents = try FileManager.default.contentsOfDirectory(atPath: _temporaryFileToDelete.path)
                        if contents.isEmpty {
                            try FileManager.default.removeItem(atPath: _temporaryFileToDelete.path)
                        }
                    }
                    catch let error {
                        assertionFailure("Error: \(error)")
                        continue
                    }
                }
            }
        }
        
        temporaryFilesToDelete.removeAll()
    }
    
}
