//
//  AudioFilesManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import WriterCommon
import AVFoundation
import os

public enum RecordError: Error, LocalizedError {
    
    case recordPermissionDenied
    
    public var errorDescription: String? {
        switch self {
        case .recordPermissionDenied:
            return "Microphone access denied: please enable access to the microphone before recording. Go in 'Settings' -> 'Security & Privacy' -> 'Privacy' -> 'Microphone'."
        }
    }
}

public final class AudioFilesManager: NSObject, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    enum AudioFilesManagerError: Error {
        
        case nilDocumentAudioFilesManager(id: String)
    }
    
    let identifier: String
    
    /// document audio files id indexed the text id
    /// [textId: documentAudioFilesIdByTextIdId]
    /// for faster access
    let documentAudioFilesIdByTextId: DynamicDictionary<TextId, DocumentAudioFilesId>
    
    let documentAudioFilesSet: DynamicDictionary<DocumentAudioFilesId, DocumentAudioFilesManager>
    
    /// ordered list of documentAudioFiles ids
    let documentAudioFilesArray: DynamicArray<DocumentAudioFilesId>
    
    let audioFilesSet: DynamicDictionary<String, AudioFileManager>
    
    let recordingAudioFile: Dynamic<AudioFileManager?>
    
    let playingAudioFile: Dynamic<AudioFileManager?>
    
    let selectedFilesOutlineSelectedTextItems: DynamicOrderedSet<String>
    
    let selectedFilesOutline: Dynamic<FilesOutlineManager?>
    
    var audioFilesOutlineManager: AudioFilesOutlineManager!
    
    /// editor record buttons dictionary indexed by
    /// `[documentAudioFilesId: [editorId: AudioControls]]`
    var editorsAudioControls: [DocumentAudioFilesId: [EditorId: AudioControls]]
    
    public var documentAudioFilesCount: Int {
        
        return documentAudioFilesIdByTextId.count
    }
    
    var documentManager: DocumentManager? {
        
        return audioPluginManager.documentManager
    }
    
    unowned let audioPluginManager: AudioPluginManager
    
    var deletedDocumentAudioFilesIds: [String] = []
    
    private var sourceSetManager: SourceSetManagerProtocol? {
        
        return audioPluginManager.documentManager.sourceSetManager
    }
    
    init(audioPluginManager: AudioPluginManager) {
        
        self.identifier = UUID().uuidString
        self.documentAudioFilesIdByTextId = DynamicDictionary<String, String>()
        self.documentAudioFilesSet = DynamicDictionary<String, DocumentAudioFilesManager>()
        self.audioPluginManager = audioPluginManager
        self.recordingAudioFile = Dynamic<AudioFileManager?>(nil)
        self.playingAudioFile = Dynamic<AudioFileManager?>(nil)
        audioFilesSet = DynamicDictionary<String, AudioFileManager>()
        self.documentAudioFilesArray = DynamicArray<String>()
        self.selectedFilesOutlineSelectedTextItems = DynamicOrderedSet<String>()
        self.selectedFilesOutline = Dynamic<FilesOutlineManager?>(nil)
        self.editorsAudioControls = [DocumentAudioFilesId: [EditorId: AudioControls]]()
        super.init()
        self.audioFilesOutlineManager = AudioFilesOutlineManager(name: Constants.Filename.DefaultAudioFilesOutlineName, audioPluginManager: self.audioPluginManager)
        self.createInitialAudioFilesFromDocument()
        subscribeToSourceRepository()
        subscribeToDocumentManager()
    }
    
    init(audioFilesMetadata: AudioFilesMetadata, audioPluginManager: AudioPluginManager, documentsAudioFilesFileWrapper: FileWrapper) {
        
        self.identifier = audioFilesMetadata.id
        self.audioPluginManager = audioPluginManager
        self.documentAudioFilesSet = DynamicDictionary<String, DocumentAudioFilesManager>()
        self.documentAudioFilesIdByTextId = DynamicDictionary<String, String>()
        
        self.recordingAudioFile = Dynamic<AudioFileManager?>(nil)
        self.playingAudioFile = Dynamic<AudioFileManager?>(nil)
        self.audioFilesSet = DynamicDictionary<String, AudioFileManager>()
        self.documentAudioFilesArray = DynamicArray<String>()
        self.selectedFilesOutlineSelectedTextItems = DynamicOrderedSet<String>()
        self.editorsAudioControls = [DocumentAudioFilesId: [EditorId: AudioControls]]()
        self.selectedFilesOutline = Dynamic<FilesOutlineManager?>(nil)
        super.init()
        initDocumentAudioFilesSet(audioFilesMetadata: audioFilesMetadata)
        initDocumentAudioFilesIdByTextId()
        loadDocumentAudioFilesArray()
        loadAudioFileManagers(audioFilesMetadata: audioFilesMetadata, documentsAudioFilesFileWrapper: documentsAudioFilesFileWrapper)
        self.audioFilesOutlineManager = AudioFilesOutlineManager(audioFilesOutlineMetadata: audioFilesMetadata.audioFilesOutline, audioPluginManager: self.audioPluginManager)
        subscribeToSourceRepository()
        subscribeToDocumentManager()
    }
    
    func textIdBy(documentAudioFilesId id: String) -> String? {
        
        for (textId, documentId) in documentAudioFilesIdByTextId.values {
            if documentId == id {
                return textId
            }
        }
        return nil
    }
    
    func removeEditorAudioControls(forTextManagerId textManagerId: TextId, andEditorId editorId: EditorId?) {
        
        if let editorId = editorId {
            
            // the text id may have already been deleted from the documentAudioFilesIdByTextId dictionary
            // in this case we look for it everywhere
            if let documentAudioFilesId = self.documentAudioFilesIdByTextId.values[textManagerId] {
                self.editorsAudioControls[documentAudioFilesId]?.removeValue(forKey: editorId)
            }
            else {
                //  [DocumentAudioFilesId: [EditorId: AudioControls]]
                for (documentAudioFilesId, editorsIds) in self.editorsAudioControls {
                    for (_editorId, _) in editorsIds {
                        if editorId == _editorId {
                            self.editorsAudioControls[documentAudioFilesId]?.removeValue(forKey: editorId)
                            return 
                        }
                    }
                }
            }
        }
        else {
            if let documentAudioFilesId = self.documentAudioFilesIdByTextId.values[textManagerId] {
                self.editorsAudioControls.removeValue(forKey: documentAudioFilesId)
            }
        }
    }
    
    func registerEditorAudioControls(_ recordingControls: AudioControls, forDocumentAudioFilesManagerId documentAudioFilesManagerId: DocumentAudioFilesId, andEditorId editorId: EditorId) {
        
        if self.editorsAudioControls[documentAudioFilesManagerId] == nil {
            self.editorsAudioControls[documentAudioFilesManagerId] = [EditorId: AudioControls]()
        }
        
        self.editorsAudioControls[documentAudioFilesManagerId]![editorId] = recordingControls
    }
    
    func getOrCreateEditorRecordindControls(forTextManagerId textManagerId: TextId, andEditorId editorId: EditorId, audioPlugin: StyloAudioPlugin) -> AudioControls? {
    
        if let editorRecordindControlsArray = self.editorRecordindControls(forTextManagerId: textManagerId, andEditorId: editorId), !editorRecordindControlsArray.isEmpty {
            assert(editorRecordindControlsArray.count == 1)
            return editorRecordindControlsArray.first!
        }
        
        guard let documentAudioFilesId = self.documentAudioFilesIdByTextId.values[textManagerId] else {
            assertionFailure("Error: self.documentAudioFilesIdByTextId[\(textManagerId)] is nil")
            return nil
        }
        
        guard let audioControls = AudioControls.create(forDocumentAudioFilesId: documentAudioFilesId, audioPlugin: audioPlugin) else {
            assertionFailure("Error: audioControls is nil")
            return nil
        }
        
        registerEditorAudioControls(audioControls, forDocumentAudioFilesManagerId: documentAudioFilesId, andEditorId: editorId)
        
        return audioControls
    }
    
    func editorRecordindControls(forTextManagerId textManagerId: TextId, andEditorId editorId: EditorId?) -> [AudioControls]? {
        
        guard let documentAudioFilesManager = self.documentAudioFiles(forTextId: textManagerId) else {
            assertionFailure("Error: no document audio files manager for text id: \(textManagerId)")
            return nil
        }
        
        return editorAudioControls(forDocumentAudioFilesManagerId: documentAudioFilesManager.id, andEditorId: editorId)
    }

    func editorAudioControls(forDocumentAudioFilesManagerId documentAudioFilesManagerId: DocumentAudioFilesId, andEditorId editorId: EditorId?) -> [AudioControls]? {
        
        guard let documentAudioFilesManager = self.documentAudioFilesSet.values[documentAudioFilesManagerId] else {
            assertionFailure("Error: no document audio files manager for text id: \(documentAudioFilesManagerId)")
            return nil
        }
        
        guard let editorAudioControlsDictionnary: [EditorId: AudioControls] = self.editorsAudioControls[documentAudioFilesManager.id] else {
            return nil
        }
        
        if let editorId = editorId {
            if let editorAudioControls = editorAudioControlsDictionnary[editorId] {
                return [editorAudioControls]
            }
            return nil
        }
        
        return editorAudioControlsDictionnary.compactMap { (key, value) -> AudioControls? in
            return value
        }
    }
    
    func deleteAudioFile(_ audioFileManager: AudioFileManager) {
        
        switch audioFileManager.audioState.value {
        case .playing:
            try? self.stopCurrentPlaying()
        case .recording:
            try? self.stopCurrentRecording(setAsPlaying: false)
        default:
            break
        }
        
        guard let parentDocumentAudioFilesManager = self.documentAudioFiles(forDocumentAudioFilesId: audioFileManager.parentId) else {
            assertionFailure("Error: no document audio files manager for id: \(audioFileManager.parentId)")
            return
        }
        
        parentDocumentAudioFilesManager.removeAudioFile(withId: audioFileManager.id)
    }
    
    func startPlayingAudioFile(_ audioFileManager: AudioFileManager) throws {
        
        if self.recordingAudioFile.value != nil {
            try self.stopCurrentRecording(setAsPlaying: false, becauseWillPlayInDocumentAudioFilesManagerId: audioFileManager.parentId)
        }
        
        if let playingAudioFile = self.playingAudioFile.value, playingAudioFile.id != audioFileManager.id {
            try self.stopCurrentPlaying()
        }
        
        do {
            // there is no way to start playing an audio file without it being the
            // playing audio file
            try audioFileManager.startPlaying()
            assert(playingAudioFile.value!.id == audioFileManager.id)
        }
        catch let error {
            assertionFailure("Error: exeption while playing audio file: \(error)")
            throw error
        }
    }
    
    func pausePlayingAudioFile(_ audioFileManager: AudioFileManager) throws {
        
        try audioFileManager.pausePlaying()
    }
    
    func record(inAudioFileManager audioFileManager: AudioFileManager) throws {
        
        guard let documentAudioFilesManager = self.documentAudioFilesSet.values[audioFileManager.parentId] else {
            assertionFailure("Error: documentAudioFilesManager for id: \(audioFileManager.parentId) is nil.")
            throw  AudioFilesManagerError.nilDocumentAudioFilesManager(id: audioFileManager.parentId)
        }
    
        try audioFileManager.prepareRecording(documentAudioFilesDirectoryUrl: documentAudioFilesManager.documentAudioFilesDirectoryUrl)
        try audioFileManager.startRecording(documentAudioFilesDirectoryUrl: documentAudioFilesManager.documentAudioFilesDirectoryUrl)
        self.recordingAudioFile.setValue(audioFileManager, sameExecutionStack: true)
    }
    
    @objc func stopCurrentPlaying(_ sender: AnyObject? = nil) throws {
        
        guard let playingAudioFile = self.playingAudioFile.value else {
            return
        }

        try playingAudioFile.pausePlaying()
    }
    
    @objc func stopCurrentRecordingAndSetAsPlaying(_ sender: AnyObject? = nil) throws {
    
        try stopCurrentRecording(sender, setAsPlaying: true)
    }
        
    @objc func stopCurrentRecording(_ sender: AnyObject? = nil, setAsPlaying: Bool, becauseWillPlayInDocumentAudioFilesManagerId willPlayDocumentAudioFilesManagerId: String? = nil) throws {
        
        guard let currentRecordingAudioFileManager = self.recordingAudioFile.value else {
            return
        }
        
        guard let documentAudioFilesManager = self.documentAudioFilesSet.values[currentRecordingAudioFileManager.parentId] else {
            assertionFailure("Error: documentAudioFilesManager for id: \(currentRecordingAudioFileManager.parentId) is nil.")
            throw  AudioFilesManagerError.nilDocumentAudioFilesManager(id: currentRecordingAudioFileManager.parentId)
        }
        
        try currentRecordingAudioFileManager.stopRecording()
        try currentRecordingAudioFileManager.createPlayer(documentAudioFilesDirectoryUrl: documentAudioFilesManager.documentAudioFilesDirectoryUrl)
        self.recordingAudioFile.setValue(nil)
        
        if setAsPlaying {
            assert(self.audioFilesOutlineManager != nil)
            if let audioFilesOutlineManager = self.audioFilesOutlineManager {
                
                if let selectedAudio = audioFilesOutlineManager.selectedAudio.value, selectedAudio == currentRecordingAudioFileManager.id {
                    
                    self.playingAudioFile.setValue(currentRecordingAudioFileManager)
                }
            }
        }
    }
    
    func createNewAudioFile(underParentWithId parentId: String) throws -> AudioFileManager {
        
        guard let documentAudioFilesManager = self.documentAudioFilesSet.values[parentId] else {
            assertionFailure("Error: documentAudioFilesManager for id: \(parentId) is nil.")
            throw  AudioFilesManagerError.nilDocumentAudioFilesManager(id: parentId)
        }
        
        let audioFileManager = AudioFileManager(name: documentAudioFilesManager.nextAudioFileName, parentId: parentId, audioPluginManager: self.audioPluginManager, audioFilesManager: self)
        
        self.audioFilesSet.updateValue(audioFileManager, forKey: audioFileManager.id)
        try documentAudioFilesManager.appendAudioFile(withId: audioFileManager.id)
        
        return audioFileManager
    }
    
    func documentAudioFiles(forTextId id: String) -> DocumentAudioFilesManager? {
        
        guard let documentAudioFilesId = documentAudioFilesIdByTextId.values[id] else {
            return nil
        }
        
        return self.documentAudioFilesSet.values[documentAudioFilesId]
    }
    
    func documentAudioFiles(forDocumentAudioFilesId id: String) -> DocumentAudioFilesManager? {
        
        return documentAudioFilesSet.values[id]
    }
    
    public func index(ofDocumentAudioFiles documentAudioFiles: DocumentAudioFilesManager) -> Int? {
        
        return self.documentAudioFilesArray.values.firstIndex(of: documentAudioFiles.id)
    }
    
    public func documentAudioFiles(at index: Int) -> DocumentAudioFilesManager? {
        
        guard let textIds = sourceSetManager?.textManagers else {
            assertionFailure("Error: textManagersIds is nil")
            return nil
        }
        
        assert(textIds.count == self.documentAudioFilesArray.count)
        
        guard index >= 0 && index < textIds.count else {
            assertionFailure("Error: invalid index: \(index)")
            return nil
        }
        
        // for validation
        let textId = textIds.values[index]
        
        guard index >= 0 && index < self.documentAudioFilesArray.count else {
            assertionFailure("Error: invalid index: \(index)")
            return nil
        }
        
        let documentAudioFilesManagerId = self.documentAudioFilesArray.values[index]
        
        guard let documentAudioFilesManager = self.documentAudioFilesSet.values[documentAudioFilesManagerId] else {
            assertionFailure("Error: no documentAudioFilesManager for id: \(documentAudioFilesManagerId)")
            return nil
        }
        
        // this is to make sure we didn't mess up with the order
        assert(documentAudioFilesManager.associatedDocumentId == textId)
        return documentAudioFilesManager
    }
    
    /// This method read the content of the document and create the
    /// manager hierarchy for each text document in the document.
    func createInitialAudioFilesFromDocument() {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        let textManagers = sourceSetManager.textManagers.values
        
        // for each document in the source document we create a DocumentAudioFilesManager
        for (index, textManagerId) in textManagers.enumerated() {
            
            createDocumentAudioFilesManager(forTextManagerId: textManagerId, andInsertAtIndex: index)
        }
    }
    
    func subscribeToSourceRepository() {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        sourceSetManager.textManagers.subscribe({ [weak self](arrayChange) in
            
            switch arrayChange {
            case .deletes(let indexes, let deletedValues, _):
                assert(indexes.sorted() == indexes)
                for deletedValue in deletedValues {
                    self?.removeEditorAudioControls(forTextManagerId: deletedValue, andEditorId: nil)
                    self?.deleteDocumentAudioFiles(withTextManagerId: deletedValue)
                }
            case .insert(let newElement, let index, _):
                self?.createDocumentAudioFilesManager(forTextManagerId: newElement, andInsertAtIndex: index)
            case .inserts(let newElements, let indexes, _):
                
                assert(indexes.sorted() == indexes, "indexes must be sorted.")
                assert(indexes.count == newElements.count)
                
                for (index, newElement) in newElements.enumerated() {
                    
                    let insertionIndex = indexes[index]
                    self?.createDocumentAudioFilesManager(forTextManagerId: newElement, andInsertAtIndex: insertionIndex)
                }
            case .move(_, let sourceIndex, let targetIndex, _):
                self?.documentAudioFilesArray.move(elementAt: sourceIndex, to: targetIndex)
            case .end: fallthrough
            case .start:
                break
            }
        }, observer: self)
    }
    
    func contentManager(forDocumentAudioFilesManagerId id: String) -> ContentManager? {
        
        guard let documentAudioFilesManager = self.documentAudioFilesSet.values[id] else {
            assertionFailure("Error: documentAudioFilesManager for id: \(id) is nil.")
            return nil
        }
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        return sourceSetManager.contentManager(withId: documentAudioFilesManager.associatedDocumentId)
    }
    
    func contentManager(forSelectedItemId id: String) -> ContentManager? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        if let documentAudioFilesManager = documentAudioFilesSet.values[id] {
            return sourceSetManager.contentManager(withId: documentAudioFilesManager.associatedDocumentId)
        }
        if let audioFileManager = audioFilesSet.values[id] {
            if let documentAudioFilesManager = documentAudioFilesSet.values[audioFileManager.parentId] {
                return sourceSetManager.contentManager(withId: documentAudioFilesManager.associatedDocumentId)
            }
        }
        return nil
    }
    
    private func initDocumentAudioFilesSet(audioFilesMetadata: AudioFilesMetadata) {
        
        let documentAudioFilesDictionary: [String: DocumentAudioFilesManager] = Dictionary(uniqueKeysWithValues: audioFilesMetadata.documentAudioFiles.compactMap { (documentAudioFilesMetadata) -> (String, DocumentAudioFilesManager)? in
            if let documentAudioFilesManager = DocumentAudioFilesManager(metadata: documentAudioFilesMetadata, audioPluginManager: audioPluginManager, audioFilesManager: self) {
                return (documentAudioFilesMetadata.id, documentAudioFilesManager)
            }
            return nil
        })
        
        for(key, value) in documentAudioFilesDictionary {
            self.documentAudioFilesSet.updateValue(value, forKey: key, notify: false)
        }
    }
    
    private func initDocumentAudioFilesIdByTextId() {
        
        let documentAudioFilesDictionaryByTextId: [String: String] =
            Dictionary(uniqueKeysWithValues: documentAudioFilesSet.values.map { (arg0) -> (String, String) in
                let (documentAudioFilesId, documentAudioFiles) = arg0
                return (documentAudioFiles.associatedDocumentId, documentAudioFilesId)
            })
        
        for (key, value) in documentAudioFilesDictionaryByTextId {
            self.documentAudioFilesIdByTextId.updateValue(value, forKey: key, notify: false)
        }
    }
    
    private func subscribeToDocumentManager() {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        self.selectedFilesOutlineSelectedTextItems.append(contentsOf: documentManager.selectedFilesOutlineSelectedTextItems.values)
        self.selectedFilesOutlineSelectedTextItems.bind(to: documentManager.selectedFilesOutlineSelectedTextItems)
        
        guard let filesOutlineSetManager = documentManager.filesOutlineSetManager.value else {
            assertionFailure("Error: filesOutlineSetManager is nil")
            return
        }
        
        filesOutlineSetManager.selectedFilesOutlineManager.subscribe({ [weak self](selectedFilesOutlineManager) in
            self?.handleSelectedFilesOutlineManagerChange(selectedFilesOutlineManager)
        }, observer: self)
    }
    
    private func handleSelectedFilesOutlineManagerChange(_ selectedFilesOutlineManager: FilesOutlineManager?) {
        
        self.selectedFilesOutline.setValue(selectedFilesOutlineManager)
    }
    
    private func unsubscribeFromDocumentManager() {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        self.selectedFilesOutlineSelectedTextItems.unbind(from: documentManager.selectedFilesOutlineSelectedTextItems)
        
        guard let filesOutlineSetManager = documentManager.filesOutlineSetManager.value else {
            assertionFailure("Error: filesOutlineSetManager is nil")
            return
        }
        
        filesOutlineSetManager.selectedFilesOutlineManager.unsubscribe(observer: self)
    }
    
    /// Returns the documentAudioFilesId
    @discardableResult
    func createDocumentAudioFilesManager(forTextManagerId id: String, andInsertAtIndex index: Int?) -> String? {
        
        if documentAudioFilesIdByTextId.values[id] == nil {
            guard let documentAudioFilesManager = DocumentAudioFilesManager(associatedDocumentId: id, audioPluginManager: self.audioPluginManager, audioFilesManager: self) else {
                assertionFailure("Error: we should not fail here, since we are creating a completetely new DocumentAudioFilesManager")
                return nil
            }
            
            self.documentAudioFilesSet.updateValue(documentAudioFilesManager, forKey: documentAudioFilesManager.id)
            self.documentAudioFilesIdByTextId.updateValue(documentAudioFilesManager.id, forKey: id)
        }
        
        if let index = index {
            
            guard let documentAudioFilesId = documentAudioFilesIdByTextId.values[id] else {
                assertionFailure("Error: documentAudioFilesId is nil")
                return nil
            }
            self.documentAudioFilesArray.insert(documentAudioFilesId, at: index)
        }
        return documentAudioFilesIdByTextId.values[id]
    }
    
    private func insertDocumentAudioFilesManagerId(_ id: String, atIndex index: Int) {
    
        self.documentAudioFilesArray.insert(id, at: index)
    }
        
    private func deleteDocumentAudioFiles(withTextManagerId id: String) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("deleteDocumentAudioFiles(withTextManagerId: %@).", log: Log.Audio.all, type: .info, %%id)
        #endif

        guard let documentAudioFilesId = self.documentAudioFilesIdByTextId.values[id] else {
            assertionFailure("Error: self.documentAudioFilesIdByTextId is nil")
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("deleting DocumentAudioFiles with id %@).", log: Log.Audio.all, type: .info, %%documentAudioFilesId)
        #endif
        
        guard let documentAudioFilesManager = self.documentAudioFilesSet.values[documentAudioFilesId] else {
            assertionFailure("Error: no documentAudioFilesManager for id: \(documentAudioFilesId)")
            return
        }
        
        for (index, documentAudioFilesId) in self.documentAudioFilesArray.values.enumerated() {
            
            if documentAudioFilesId == documentAudioFilesManager.id {
                self.documentAudioFilesArray.remove(atIndex: index)
                break
            }
        }
        
        // cleanup the audio files, and remove any playing or recording one
        // if needed
        for audioFile in documentAudioFilesManager.audioFiles {
            
            if let playingAudioFile = self.playingAudioFile.value, audioFile.id == playingAudioFile.id {
                try? self.stopCurrentPlaying()
                self.playingAudioFile.setValue(nil)
            }
            if let recordingAudioFile = self.recordingAudioFile.value, audioFile.id == recordingAudioFile.id {
                try? self.stopCurrentRecording(setAsPlaying: false)
                self.recordingAudioFile.setValue(nil)
            }
        }
        
        self.deletedDocumentAudioFilesIds.append(documentAudioFilesId)
        self.documentAudioFilesSet.removeValue(forKey: documentAudioFilesManager.id)
        self.documentAudioFilesIdByTextId.values.removeValue(forKey: documentAudioFilesManager.associatedDocumentId)
        
    }
        
    private func unsubscribeToSourceRepository() {
        self.sourceSetManager?.textManagers.unsubscribe(observer: self)
    }
    
    
    private func loadDocumentAudioFilesArray() {
        
        // we load the DocumentAudioFiles Array based on the order
        // given by the text managers
        guard let sourceSetManager = self.audioPluginManager.documentManager.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            return
        }
        
        var handledTextManagersIds = Set<String>()
        
        for (index, textManagerId) in sourceSetManager.textManagers.values.enumerated() {
            
            if let documentAudioFilesId = self.documentAudioFilesIdByTextId.values[textManagerId] {
            
                guard let documentAudioFilesManager = self.documentAudioFilesSet.values[documentAudioFilesId] else {
                    assertionFailure("Error: no documentAudioFilesManager for documentAudioFilesId: \(documentAudioFilesId)")
                    continue
                }
                self.documentAudioFilesArray.append(documentAudioFilesManager.id)
                handledTextManagersIds.insert(textManagerId)
            }
            else {
                // we should create one
                createDocumentAudioFilesManager(forTextManagerId: textManagerId, andInsertAtIndex: index)
                handledTextManagersIds.insert(textManagerId)
            }
        }
        
        // Remove any DocumentAudioFilesManager that do not have a corresponding
        // TextManager
        for (_, documentAudioFileManager) in documentAudioFilesSet.values {
            
            if !handledTextManagersIds.contains(documentAudioFileManager.associatedDocumentId) {
                self.deleteDocumentAudioFiles(withTextManagerId: documentAudioFileManager.associatedDocumentId)
            }
        }
    }
    
    private func loadAudioFileManagers(audioFilesMetadata: AudioFilesMetadata, documentsAudioFilesFileWrapper: FileWrapper) {
        
        for documentAudioFilesMetadata in audioFilesMetadata.documentAudioFiles {
            
            guard let documentAudioFilesFileWrapper = documentsAudioFilesFileWrapper.fileWrappers?[documentAudioFilesMetadata.id] else {
                assertionFailure("Error: documentAudioFilesFileWrapper is nil")
                return
            }
            
            // here the document audio files manager referenced in the metadata could have been
            // deleted in loadDocumentAudioFilesArray() since it's associated text manager may have
            // been deleted from a version without the audio plugin, which result in deleted text managers
            // with their audio releated information still present in the audio plugin.
            if let documentAudioFilesManager = self.documentAudioFilesSet.values[documentAudioFilesMetadata.id] {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("documentAudioFilesManager url: %@", log: Log.Audio.all, type: .debug, %%documentAudioFilesManager.documentAudioFilesDirectoryUrl)
                #endif
                
                for audioFileMetadata in documentAudioFilesMetadata.audioFiles {
                    
                    let audioFileName = audioFileMetadata.id + "." + audioFileMetadata.audioFormat.fileExtension
                    
                    guard let audioFileFileWrapper = documentAudioFilesFileWrapper.fileWrappers?[audioFileName] else {
                        // we saved the metadata without the file...
                        assertionFailure("Error: audioFileFileWrapper is nil")
                        continue
                    }
                    
                    guard let audioData = audioFileFileWrapper.regularFileContents else {
                        assertionFailure("Error: audioData is nil")
                        continue
                    }
                    
                    let audioFileManager = AudioFileManager(metadata: audioFileMetadata, audioPluginManager: audioPluginManager, audioFilesManager: self, parentId: documentAudioFilesMetadata.id)
                    self.audioFilesSet.updateValue(audioFileManager, forKey: audioFileManager.id)
                    
                    do {
                        try audioFileManager.createDataPlayer(fromData: audioData)
                    }
                    catch let error {
                        assertionFailure("Error: error while create audio player: \(error)")
                        continue
                    }
                }
            }
        }
    }
    
    deinit {
        self.unsubscribeToSourceRepository()
        self.unsubscribeFromDocumentManager()
    }
}

