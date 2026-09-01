//
//  DocumentAudioFilesManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo

enum DocumentAudioFilesManagerError: Error {
    
    case nilAudioFilesManager
}

public final class DocumentAudioFilesManager {
    
    public var audioFiles: [AudioFileManager] {
        return audioFileManagers.compactMap({ (audioFileManagerId) -> AudioFileManager? in
            return audioFilesManager.audioFilesSet.values[audioFileManagerId]
        })
    }
    
    public var audioFilesCount: Int {
        
        return audioFileManagers.values.count
    }
    
    public var isEmpty: Bool {
        
        return audioFileManagers.values.isEmpty
    }
    
    public let identifier: String
    
    let associatedDocumentId: String
    
    let audioFileManagers: DynamicArray<String>
    
    unowned let audioPluginManager: AudioPluginManager
    
    var deletedAudioFilesIds: [String] = []
    
    private var dispatcher: Dispatcher {
        
        return audioPluginManager.audioPluginDispatcher
    }
    
    private var styloDocumentUrl: URL? {
        
        return audioPluginManager.documentManager.baseUrl
    }
    
    private var pluginUrl: URL {
        
        return audioPluginManager.pluginUrl
    }
    
    var documentAudioFilesDirectoryUrl: URL {
        return self.pluginUrl.appendingPathComponent(Constants.Filename.DocumentAudioDirectoryName + "/" + self.identifier)
    }
    
    var nextAudioFileName: String {
        
        var itemWithDefaultUntitledNameExists: Bool = false
        var audioFilesNames = [String]()
        
        for audioFileManagerId in audioFileManagers {
            
            guard let audioFileManager = audioFilesManager.audioFilesSet.values[audioFileManagerId] else {
                assertionFailure("Error: no audio file manager with id: \(audioFileManagerId)")
                continue
            }
            
            let audioFileName = audioFileManager.name.value
            
            if audioFileName.lowercased() == Constants.Filename.DefaultAudioFileName.lowercased() {
                itemWithDefaultUntitledNameExists = true
            }
            audioFilesNames.append(audioFileName)
        }
        
        if !itemWithDefaultUntitledNameExists {
            return Constants.Filename.DefaultAudioFileName
        }
        return "\(Constants.Filename.DefaultAudioFileName) \(audioFilesNames.nextFreeEndNumber)"
    }
    
    unowned let audioFilesManager: AudioFilesManager
    
    init?(associatedDocumentId: String, audioPluginManager: AudioPluginManager, audioFilesManager: AudioFilesManager) {
        
        self.identifier = UUID().uuidString
        self.associatedDocumentId = associatedDocumentId
        self.audioPluginManager = audioPluginManager
        self.audioFilesManager = audioFilesManager
        self.audioFileManagers = DynamicArray<String>()
        createDocumentAudioFilesDirectory()
    }
    
    init?(metadata: DocumentAudioFilesMetadata, audioPluginManager: AudioPluginManager, audioFilesManager: AudioFilesManager) {
        
        self.identifier = metadata.id
        self.associatedDocumentId = metadata.associatedDocumentID
        self.audioPluginManager = audioPluginManager
        self.audioFilesManager = audioFilesManager
        self.audioFileManagers = DynamicArray<String>(
            metadata.audioFiles.map({ (audioFileMetadata) -> String in
                return audioFileMetadata.id
            })
        )
        createDocumentAudioFilesDirectory()
    }
    
    public func containsAudioFile(withFilename filename: String) -> Bool {
        
        let audioId = (filename as NSString).deletingPathExtension as String
        for audioFileManager in audioFileManagers.values {
            if audioFileManager == audioId {
                return true
            }
        }
        return false
    }
    
    public func removeFromDisk() {
        
        do {
            guard FileManager.default.fileExists(atPath: documentAudioFilesDirectoryUrl.path) else {
                assertionFailure("Error: trying to remove non-existing file.")
                return
            }
            try FileManager.default.removeItem(at: documentAudioFilesDirectoryUrl)
        }
        catch let error {
            assertionFailure("Error: unable to create removeFromDisk: \(error)")
        }
    }
    
    public func audioFileManager(atIndex index: Int) -> AudioFileManager? {
        
        guard index >= 0 && index < audioFileManagers.count else {
            assertionFailure("Error: invalid index")
            return nil
        }
        
        let audioFileManagerId = audioFileManagers.values[index]
        return audioFilesManager.audioFilesSet.values[audioFileManagerId]
    }
    
    func moveAudioFile(_ audioFileManager: AudioFileManager, toIndex index: Int) {
        
        assert(audioFileManagers.contains(audioFileManager.id))
    }
    
    func appendAudioFile(withId id: String) throws {
        
        self.audioFileManagers.append(id)
    }
    
    func removeAudioFile(withId id: String) {
        
        guard let index = indexOfAudioFileManager(withId: id) else {
            assertionFailure("Error: request for removing an audio file that does not exist")
            return
        }
        
        self.deletedAudioFilesIds.append(id)
        self.audioFileManagers.remove(atIndex: index)
        
        // we removed the playing audio file
        if audioFilesManager.playingAudioFile.value?.id == id {
            audioFilesManager.playingAudioFile.setValue(nil)
        }
        else if audioFilesManager.recordingAudioFile.value?.id == id {
            audioFilesManager.recordingAudioFile.setValue(nil)
        }
    }
    
    private func indexOfAudioFileManager(withId id: String) -> Int? {
        
        var index: Int?
        for (_index, audioFileManagerId) in self.audioFileManagers.enumerated() {
            
            if audioFileManagerId == id {
                index = _index
                break
            }
        }
        return index
    }
    
    private func createDocumentAudioFilesDirectory() {
        
        do {
            if !FileManager.default.fileExists(atPath: documentAudioFilesDirectoryUrl.path) {
                try FileManager.default.createDirectory(atPath: documentAudioFilesDirectoryUrl.path, withIntermediateDirectories: true, attributes: nil)
            }
        }
        catch let error {
            assertionFailure("Error: unable to create documentAudioFilesDirectory: \(error)")
        }
    }
    
}
