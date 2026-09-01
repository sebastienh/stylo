//
//  StyloAudioPlugin.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-08-29.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import SwiftProtobuf
import Common
import os

class StyloAudioPlugin: NSResponder, StyloPlugin {
    
    var editorRecordingAudioControls: [AudioControls]?
    
    var editorPlaybackAudioControls: [AudioControls]?
    
    var documentTitleOutlineButton: RecordButton?
    
    var audioToolsViewController: AudioToolsViewController?
    
    let documentManager: DocumentManager
    
    var audioPluginManager: AudioPluginManager?
    
    var name: String {
        return Constants.Plugin.Name
    }
    
    var isEdited: Bool {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return true
        }
        
        return audioPluginManager.isEdited
    }
    
    var isDraft: Bool {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return true
        }
        
        return audioPluginManager.isDraft
    }
    
    
    var editedTextManager: Dynamic<TextManager?> {
        return documentManager.editedTextManager
    }
    
    private var audioFilesManager: AudioFilesManager? {
        
        return self.audioPluginManager?.audioFilesManager
    }
    
    /// We keep the oldValue to be able to unsubscribe
    var playingAudioFileManager: AudioFileManager?
    
    /// We keep the oldValue to be able to unsubscribe
    var recordingAudioFileManager: AudioFileManager?
    
    var subscribedFilesOutlineSetManager: FilesOutlineSetManager?
    
    var subscribedSelectedFilesOutlineManager: FilesOutlineManager?
    
    private var audioFilesOutlineManager: AudioFilesOutlineManager? {
        
        return audioFilesManager?.audioFilesOutlineManager
    }
    
    private var textDocument: TextDocument? {
        
        return self.documentManager.document
    }
    
    required init(documentManager: DocumentManager) {
        
        self.documentManager = documentManager
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func goForward(_ sender: AnyObject?) {
        
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        guard let playingAudioFile = audioFilesManager.playingAudioFile.value else {
            assertionFailure("Error: playingAudioFile is nil")
            return
        }
        
        playingAudioFile.goForward()
    }
    
    @objc public func goBackward(_ sender: AnyObject?) {
        
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        guard let playingAudioFile = audioFilesManager.playingAudioFile.value else {
            assertionFailure("Error: playingAudioFile is nil")
            return
        }
        
        playingAudioFile.goBackward()
    }
    
    @objc public func startRecordingInEditedTextManager(_ sender: AnyObject?) {
        
        guard let editedTextManager = self.editedTextManager.value else {
            assertionFailure("Error: self.editedTextManager.value is nil")
            return
        }
        
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        guard let audioToolsViewController = self.audioToolsViewController else {
            assertionFailure("Error: self.audioToolsViewController is nil")
            return
        }
        
        guard let documentAudioFilesManager = audioFilesManager.documentAudioFiles(forTextId: editedTextManager.id) else {
            assertionFailure("Error: documentAudioFilesManager for text id: \(editedTextManager.id) is nil")
            return
        }

        audioToolsViewController.startNewRecording(documentAudioFilesManager: documentAudioFilesManager)
    }
    
    @objc public func startRecording(_ sender: AnyObject?) {
        
        guard let editorRecordButton = sender as? EditorRecordButton else {
            assertionFailure("Error: sender is not EditorRecordButton")
            return
        }
        
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        guard let audioToolsViewController = self.audioToolsViewController else {
            assertionFailure("Error: self.audioToolsViewController is nil")
            return
        }
        
        guard let documentAudioFilesId = editorRecordButton.documentAudioFilesId else {
            assertionFailure("Error: editorRecordButton.documentAudioFilesId is nil")
            return
        }
        
        guard let documentAudioFilesManager = audioFilesManager.documentAudioFilesSet.values[documentAudioFilesId] else {
            assertionFailure("Error: documentAudioFilesManager for id: \(documentAudioFilesId) is nil")
            return
        }
        
        audioFilesManager.audioPluginManager.notifyContentManager = false
        audioToolsViewController.startNewRecording(documentAudioFilesManager: documentAudioFilesManager)
    }
    
    @objc public func stopRecording(_ sender: AnyObject?) {
        
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        try? audioFilesManager.stopCurrentRecording(setAsPlaying: true)
    }
    
    @objc public func playPause(_ sender: AnyObject?) {
    
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        guard let playingAudioFile = audioFilesManager.playingAudioFile.value else {
            assertionFailure("Error: playingAudioFile is nil")
            return
        }
        
        switch playingAudioFile.audioState.value {
        case .playing:
            try? audioFilesManager.pausePlayingAudioFile(playingAudioFile)
        case .pausePlaying: fallthrough
        case .readyToPlay(_): fallthrough
        case .inactive:
            try? audioFilesManager.startPlayingAudioFile(playingAudioFile)
        default:
            assertionFailure("Error: case not handled: \(playingAudioFile.audioState.value)")
            break
        }
    }
    
    /// Closing the document
    func subscribeToAudioFilesOutlineManager() {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        self.handleSelectedAudio(audioFilesOutlineManager.selectedAudio.value, initPhase: true)
        audioFilesOutlineManager.selectedAudio.subscribe({ [weak self](newValue) in
            self?.handleSelectedAudio(newValue, initPhase: false)
        }, observer: self)
        
        audioFilesOutlineManager.selectedItem.subscribe({ [weak self](newValue) in
            self?.handleSelectedItem(newValue)
        }, observer: self)
        
    }
    
    private func handleSelectedItem(_ selectedItemId: String?) {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return
        }
        
        if audioPluginManager.notifyContentManager {
        
            guard let selectedItemId = selectedItemId else {
                return
            }
            
            guard let audioPluginManager = self.audioPluginManager else {
                assertionFailure("Error: self.audioPluginManager is nil")
                return
            }
            
            guard let audioFilesManager = audioPluginManager.audioFilesManager else {
                assertionFailure("Error: audioPluginManager.audioFilesManager is nil")
                return
            }
            
            guard let contentManager: ContentManager = audioFilesManager.contentManager(forSelectedItemId: selectedItemId) else {
                assertionFailure("Error: no content manager for selectedItemId: \(selectedItemId)")
                return
            }

            contentManager.isSelectedByPlugin(withName: self.name)
        }
    }
    
    private func handleSelectedAudio(_ selectedItemId: String?, initPhase: Bool) {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return
        }
        
        guard let audioFilesManager = audioPluginManager.audioFilesManager else {
            assertionFailure("Error: audioPluginManager.audioFilesManager is nil")
            return
        }
        
        if let selectedItemId = selectedItemId {
            
            guard let audioFileManager = audioFilesManager.audioFilesSet.values[selectedItemId] else {
                assertionFailure("Error: audioFileManager for id: \(selectedItemId) is nil")
                return
            }
                
            if !(audioFileManager.audioState.value.isRecording || audioFileManager.audioState.value.isReadyToRecord) {
                
                guard let audioFilesManager = self.audioFilesManager else {
                    assertionFailure("Error: self.audioFilesManager is nil")
                    return
                }
                audioFilesManager.playingAudioFile.setValue(audioFileManager)
            }
            else {
                audioFilesManager.playingAudioFile.setValue(nil)
            }
        }
        else {
            
            audioFilesManager.playingAudioFile.setValue(nil)
        }
    }

    func handleRecodingAudioFileManager(_ audioFileManager: AudioFileManager?) {
    
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return
        }
        
        guard let audioFilesManager = audioPluginManager.audioFilesManager else {
            assertionFailure("Error: audioPluginManager.audioFilesManager is nil")
            return
        }
        
        self.recordingAudioFileManager?.recordTimeString.unsubscribe(observer: self)
        
        if let audioFileManager = audioFileManager {
            
            assert(self.audioFilesOutlineManager != nil)
            if let audioFilesOutlineManager = self.audioFilesOutlineManager {
                audioFilesOutlineManager.selectItem(withId: audioFileManager.id)
            }
            
            guard let parentDocumentAudioFiles = audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: audioFileManager.parentId) else {
                assertionFailure("Error: no documentAudioFiles for id: \(audioFileManager.parentId)")
                return
            }
            
            // in these tow calls we need to have access to the current
            // playing audio file and current recording audio file
            updatePlayingBackgroundActivities(inParentDocumentAudioFiles: parentDocumentAudioFiles)
            updateRecordingBackgroundActivities(inParentDocumentAudioFiles: parentDocumentAudioFiles)
            
            // we remove the current playing audio file
            if let playingAudioFileManager = self.playingAudioFileManager {
                
                // the file might not be shown so we
                if let audioToolsViewController = self.audioToolsViewController {
                            
                    if let playingAudioFileViewController = audioToolsViewController.audioFileViewControllers[playingAudioFileManager.id] {
                        playingAudioFileViewController.hidePlaybackView()
                    }
                }
                audioFilesManager.playingAudioFile.setValue(nil)
            }
            
            // It's possible the editor record button is not created yet since
            // we may not have show the editor for this audio
            // when we create the editor we need to check if it is recording and
            // adjust the state accordingly.
            if let editorAudioControlsArray = audioFilesManager.editorAudioControls(forDocumentAudioFilesManagerId: parentDocumentAudioFiles.id, andEditorId: nil) {
                self.editorRecordingAudioControls = [AudioControls]()
                for editorAudioControls in editorAudioControlsArray {
                    editorAudioControls.controlsState = .recording
                    self.editorRecordingAudioControls!.append(editorAudioControls)
                }
            }

            audioFileManager.recordTimeString.subscribe({ [weak self](recordingTime) in
                
                guard let audioFilesManager = self?.audioFilesManager else {
                    assertionFailure("Error: self.audioFilesManager is nil")
                    return
                }
                
                guard let recordingAudioFileManager = self?.recordingAudioFileManager else {
                    assertionFailure("Error: self.recordingAudioFileManager is nil")
                    return
                }
                
                // we should not fail here since it is possible to start a recording
                // in a text editor that is not shown yet in any text editors panels
                guard let editorAudioControlsArray = audioFilesManager.editorAudioControls(forDocumentAudioFilesManagerId: recordingAudioFileManager.parentId, andEditorId: nil) else {
                    return
                }
                
                for editorAudioControls in editorAudioControlsArray {
                    editorAudioControls.updateAudioTimer(durationString: recordingTime)
                }
                
            }, observer: self)
            
            guard let contentManager = audioFilesManager.contentManager(forDocumentAudioFilesManagerId: audioFileManager.parentId) else {
                assertionFailure("Error: no content manager for id: \(audioFileManager.parentId)")
                return
            }
            
            contentManager.pluginsBackgroundActivities.updateValue(PlayingBackgroundActivity.shared, forKey: Constants.Activity.Recording)
        }
        else if let recordingAudioFileManager = self.recordingAudioFileManager {
            
            guard let parentDocumentAudioFiles = audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: recordingAudioFileManager.parentId) else {
                assertionFailure("Error: no documentAudioFiles for id: \(recordingAudioFileManager.parentId)")
                return
            }
            
            // It's possible the editor record button is not created yet since
            // we may not have show the editor for this audio
            // when we create the editor we need to check if it is recording and
            // adjust the state accordingly.
            if let editorAudioControlsArray = audioFilesManager.editorAudioControls(forDocumentAudioFilesManagerId: parentDocumentAudioFiles.id, andEditorId: nil) {
                
                // check if the currently selected playingAudioFileManager is under the same
                // parent document
                if let recordingAudioFileManager = self.recordingAudioFileManager {
                    
                    if let playingAudioFileManager = self.playingAudioFileManager {
                    
                        if recordingAudioFileManager.parentId == playingAudioFileManager.parentId {
                            setPlayingEditorAudioControlsInPausedState(forAudioFileManager: playingAudioFileManager)
                        }
                        else {
                            for editorAudioControls in editorAudioControlsArray {
                                editorAudioControls.controlsState = .idle
                            }
                        }
                    }
                    else {
                        for editorAudioControls in editorAudioControlsArray {
                            editorAudioControls.controlsState = .idle
                        }
                    }
                }
                else {
                    for editorAudioControls in editorAudioControlsArray {
                        editorAudioControls.controlsState = .idle
                    }
                }
            }
            
            hideRightButtonsInDocumentAudioFilesManagerIdTitle(inDocumentAudioFilesManagerWithId: recordingAudioFileManager.parentId)
            
            guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
                assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
                return
            }
            
            // we may have deleted the content manager so it's not an error
            // if the content manager is not there
            if let contentManager = audioFilesManager.contentManager(forDocumentAudioFilesManagerId: recordingAudioFileManager.parentId) {
                                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Removing pluginsBackgroundActivities %@ from textManager with name: %@", log: Log.Audio.all, type: .debug, %%Constants.Activity.Recording, %%contentManager.contentName.value)
                #endif
                contentManager.pluginsBackgroundActivities.removeValue(forKey: Constants.Activity.Recording)
            }
        }
        
        self.recordingAudioFileManager = audioFileManager
    }
    
    func handlePlayingAudioFileManager(_ audioFileManager: AudioFileManager?) {
        
        self.playingAudioFileManager?.completePlayTimeString.unsubscribe(observer: self)
        
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        if let audioFileManager = audioFileManager {
            
            guard let parentDocumentAudioFiles = audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: audioFileManager.parentId) else {
                assertionFailure("Error: no documentAudioFiles for id: \(audioFileManager.parentId)")
                return
            }
            
            updatePlayingBackgroundActivities(inParentDocumentAudioFiles: parentDocumentAudioFiles)
            
            // If we are recording in the same document we should not change anything in the editor controls
            if let recordingAudioFileManager = self.recordingAudioFileManager {
                if recordingAudioFileManager.parentId != audioFileManager.parentId {
                    setPlayingEditorAudioControlsInPausedState(forAudioFileManager: audioFileManager)
                }
            }
            else {
                setPlayingEditorAudioControlsInPausedState(forAudioFileManager: audioFileManager)
            }
                
            // the file might not be shown so we
            if let audioToolsViewController = self.audioToolsViewController {
                if let audioFileViewController = audioToolsViewController.audioFileViewControllers[audioFileManager.id] {
                    
                    audioFileViewController.showPlaybackView()
                    
                    // for synchronisation purpose we hide the playback view here
                    // we want both showing and hiding to happen at the same time
                    if let playingAudioFileManager = self.playingAudioFileManager {
                        if let playingAudioFileViewController = audioToolsViewController.audioFileViewControllers[playingAudioFileManager.id] {
                            playingAudioFileViewController.hidePlaybackView()
                        }
                    }
                }
            }
            
            audioFileManager.completePlayTimeString.subscribe({ [weak self](completePlayTimeString) in
                
                guard let audioFilesManager = self?.audioFilesManager else {
                    assertionFailure("Error: self.audioFilesManager is nil")
                    return
                }
                
                guard let playingAudioFileManager = self?.playingAudioFileManager else {
                    assertionFailure("Error: self.playingAudioFileManager is nil")
                    return
                }
                
                guard let editorAudioControlsArray = audioFilesManager.editorAudioControls(forDocumentAudioFilesManagerId: playingAudioFileManager.parentId, andEditorId: nil) else {
                    // it's totally possible we didn't show the document editor yet...
                    // it's not an error
                    return
                }
                
                for editorAudioControls in editorAudioControlsArray {
                    editorAudioControls.updateAudioTimer(durationString: completePlayTimeString)
                }
                
            }, observer: self)
            
            audioFileManager.audioState.subscribe({ [weak self](audioState) in
                
                
                guard let editorAudioControlsArray = self?.audioFilesManager?.editorAudioControls(forDocumentAudioFilesManagerId: parentDocumentAudioFiles.id, andEditorId: nil) else {
                    // it's totally possible we didn't show the document editor yet...
                    // it's not an error
                    return
                }
                
                for editorAudioControls in editorAudioControlsArray {
                    editorAudioControls.updateState(fromAudioFile: audioFileManager)
                }
            }, observer: self)
            
            guard let contentManager = audioFilesManager.contentManager(forDocumentAudioFilesManagerId: audioFileManager.parentId) else {
                assertionFailure("Error: no content manager for id: \(audioFileManager.parentId)")
                return
            }
            
            contentManager.pluginsBackgroundActivities.updateValue(PlayingBackgroundActivity.shared, forKey: Constants.Activity.Playing)
        }
        else if let playingAudioFileManager = self.playingAudioFileManager {
            
            guard let parentDocumentAudioFiles = audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: playingAudioFileManager.parentId) else {
                assertionFailure("Error: no documentAudioFiles for id: \(playingAudioFileManager.parentId)")
                return
            }
            
            // It's possible the editor record button is not created yet since
            // we may not have show the editor for this audio
            // when we create the editor we need to check if it is recording and
            // adjust the state accordingly.
            if let editorAudioControlsArray = audioFilesManager.editorAudioControls(forDocumentAudioFilesManagerId: parentDocumentAudioFiles.id, andEditorId: nil) {
                if let recordingAudioFileManager = self.recordingAudioFileManager {
                    if recordingAudioFileManager.parentId != playingAudioFileManager.parentId {
                        for editorAudioControls in editorAudioControlsArray {
                            editorAudioControls.controlsState = .idle
                        }
                    }
                }
                else {
                    for editorAudioControls in editorAudioControlsArray {
                        editorAudioControls.controlsState = .idle
                    }
                }
            }
            
            hideRightButtonsInDocumentAudioFilesManagerIdTitle(inDocumentAudioFilesManagerWithId: playingAudioFileManager.parentId)
            
            // we may have deleted the content manager so it's not an error
            // if the content manager is not there
            if let contentManager = audioFilesManager.contentManager(forDocumentAudioFilesManagerId: playingAudioFileManager.parentId) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Removing pluginsBackgroundActivities %@ from textManager with name: %@", log: Log.Audio.all, type: .debug, %%Constants.Activity.Playing, %%contentManager.contentName.value)
                #endif
                contentManager.pluginsBackgroundActivities.removeValue(forKey: Constants.Activity.Playing)
            }
        }
        
        self.playingAudioFileManager?.completePlayTimeString.unsubscribe(observer: self)
        self.playingAudioFileManager?.audioState.unsubscribe(observer: self)
        self.playingAudioFileManager = audioFileManager
    }
    
    /// Method that change the editor audio controls to a paused state for the
    /// AudioFileManager parameter.
    private func setPlayingEditorAudioControlsInPausedState(forAudioFileManager audioFileManager: AudioFileManager) {
        
        let documentAudioFilesId = audioFileManager.parentId
        
        guard let filesOutlineSetManager = self.documentManager.filesOutlineSetManager.value else {
            assertionFailure("Error: filesOutlineSetManager is nil")
            return
        }
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return
        }
        
        guard let textId = audioFilesManager.textIdBy(documentAudioFilesId: documentAudioFilesId) else {
            assertionFailure("Error: textId is nil")
            return
        }
        
        self.editorPlaybackAudioControls?.removeAll()
        
        let editorsIds = filesOutlineSetManager.allEditorsIds(for: textId)
        
        for editorId in editorsIds {
            
            guard let editorAudioControls = audioFilesManager.getOrCreateEditorRecordindControls(forTextManagerId: textId, andEditorId: editorId, audioPlugin: self) else {
                assertionFailure("Error: editorAudioControls is nil")
                continue
            }
                            
            editorAudioControls.controlsState = .paused
            editorAudioControls.updateAudioTimer(durationString: audioFileManager.completePlayTimeString.value)
            
            if self.editorPlaybackAudioControls != nil {
                self.editorPlaybackAudioControls!.append(editorAudioControls)
            }
            else {
                self.editorPlaybackAudioControls = [editorAudioControls]
            }
        }
    }
    
    private func updatePlayingBackgroundActivities(inParentDocumentAudioFiles parentDocumentAudioFiles: DocumentAudioFilesManager) {
    
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        // if we change the playing audio file between document audio files
        // we want to force the hidding of the previous audio controls
        if let oldPlayingAudioFileManager = self.playingAudioFileManager {
            
            guard let oldPlayingAudioFileDocumentAudioFiles = audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: oldPlayingAudioFileManager.parentId) else {
                assertionFailure("Error: no documentAudioFiles for id: \(oldPlayingAudioFileManager.parentId)")
                return
            }
            
            if oldPlayingAudioFileDocumentAudioFiles.id != parentDocumentAudioFiles.id {
                
                // we only do these steps if the old playing audio file was not under a recording
                // document... in which case we want to keep the audio recording controls visible
                if oldPlayingAudioFileDocumentAudioFiles.id != self.recordingAudioFileManager?.parentId {
                
                    guard let editorAudioControlsArray = audioFilesManager.editorAudioControls(forDocumentAudioFilesManagerId: oldPlayingAudioFileDocumentAudioFiles.id, andEditorId: nil) else {
//                        assertionFailure("Error: editorAudioControls is nil")
                        return
                    }
                    
                    for editorAudioControls in editorAudioControlsArray {
                        editorAudioControls.controlsState = .idle
                    }
                    
                    // hide the right buttons of the Document Audio Fils title of the old
                    // playing audio file parent document audio files.
                    hideRightButtonsInDocumentAudioFilesManagerIdTitle(inDocumentAudioFilesManagerWithId: oldPlayingAudioFileDocumentAudioFiles.id)
                }
                
                guard let oldPlayingAudioFileContentManager = audioFilesManager.contentManager(forDocumentAudioFilesManagerId: oldPlayingAudioFileManager.parentId) else {
                    assertionFailure("Error: no content manager for id: \(oldPlayingAudioFileManager.parentId)")
                    return
                }
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Removing pluginsBackgroundActivities %@ from textManager with name: %@", log: Log.Audio.all, type: .debug, %%Constants.Activity.Playing, %%oldPlayingAudioFileContentManager.contentName.value)
                #endif
                oldPlayingAudioFileContentManager.pluginsBackgroundActivities.removeValue(forKey: Constants.Activity.Playing)
            }
        }
    }
    
    private func updateRecordingBackgroundActivities(inParentDocumentAudioFiles parentDocumentAudioFiles: DocumentAudioFilesManager?) {
        
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        // if we change the playing audio file between document audio files
        // we want to force the hidding of the previous audio controls
        if let oldRecordingAudioFileManager = self.recordingAudioFileManager {
            
            guard let oldRecordingAudioFileDocumentAudioFiles = audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: oldRecordingAudioFileManager.parentId) else {
                assertionFailure("Error: no documentAudioFiles for id: \(oldRecordingAudioFileManager.parentId)")
                return
            }
            
            if oldRecordingAudioFileDocumentAudioFiles.id != parentDocumentAudioFiles?.id {
                
                guard let editorAudioControlsArray = audioFilesManager.editorAudioControls(forDocumentAudioFilesManagerId: oldRecordingAudioFileDocumentAudioFiles.id, andEditorId: nil) else {
//                    assertionFailure("Error: editorAudioControls is nil")
                    return
                }
                
                for editorAudioControls in editorAudioControlsArray {
                    editorAudioControls.controlsState = .idle
                }
                
                // hide the right buttons of the Document Audio Fils title of the old
                // playing audio file parent document audio files.
                hideRightButtonsInDocumentAudioFilesManagerIdTitle(inDocumentAudioFilesManagerWithId: oldRecordingAudioFileDocumentAudioFiles.id)
                
                guard let oldRecordingAudioFileContentManager = audioFilesManager.contentManager(forDocumentAudioFilesManagerId: oldRecordingAudioFileManager.parentId) else {
                    assertionFailure("Error: no content manager for id: \(oldRecordingAudioFileManager.parentId)")
                    return
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Removing pluginsBackgroundActivities %@ from textManager with name: %@", log: Log.Audio.all, type: .debug, %%Constants.Activity.Recording, %%oldRecordingAudioFileContentManager.contentName.value)
                #endif
                oldRecordingAudioFileContentManager.pluginsBackgroundActivities.removeValue(forKey: Constants.Activity.Recording)
            }
        }
    }
    
    private func hideRightButtonsInDocumentAudioFilesManagerIdTitle(inDocumentAudioFilesManagerWithId id: String) {
        
        // hide the right buttons of the Document Audio Fils title of the old
        // playing audio file parent document audio files.
        assert(self.audioToolsViewController != nil, "Error: self.audioToolsViewController is nil")
        if let audioToolsViewController = self.audioToolsViewController  {
            if let documentAudioFilesViewController = audioToolsViewController.documentAudioFilesViewControllers[id] {
                documentAudioFilesViewController.hideRightButtonsIfNecessary()
            }
        }
    }
    
    func updateEditorAudioControls(_ arrayChange: DynamicOrderedSet<String>.Change) {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audioPluginManager is nil")
            return
        }
        
        guard let audioFilesManager = audioPluginManager.audioFilesManager else {
            assertionFailure("Error: audioPluginManager.audioFilesManager is nil")
            return
        }
        
        if let playingAudioFile = audioFilesManager.playingAudioFile.value {
            
            // this is the text manager id
            guard let playingTextManagerId = playingAudioFile.associatedDocumentId else {
                assertionFailure("Error: no associatedDocumentId for playing audio file")
                return
            }
            
            switch arrayChange {
            case .deletes(_, _, _):
                break
            case .insert(let newElement, _, _):
                if playingTextManagerId == newElement {
                    
                    guard let selectedFilesOutlineManager = self.documentManager.selectedFilesOutlineManager else {
                        assertionFailure("Error: selectedFilesOutlineManager is nil")
                        break
                    }
                    
                    let editorId = selectedFilesOutlineManager.createOrGetEditorId(forTextId: newElement)
                    
                    if let editorAudioControls = audioFilesManager.getOrCreateEditorRecordindControls(forTextManagerId: playingTextManagerId, andEditorId: editorId, audioPlugin: self) {
                        
                        editorAudioControls.updateState(fromAudioFile: playingAudioFile)
                    
                        if self.editorRecordingAudioControls != nil {
                            self.editorRecordingAudioControls!.append(editorAudioControls)
                        }
                        else {
                            self.editorRecordingAudioControls = [editorAudioControls]
                        }
                    }
                }
                
            case .inserts(let newElements, _, _):
                for newElement in newElements {
                    if playingTextManagerId == newElement {
                        
                        guard let selectedFilesOutlineManager = self.documentManager.selectedFilesOutlineManager else {
                            assertionFailure("Error: selectedFilesOutlineManager is nil")
                            break
                        }
                        
                        let editorId = selectedFilesOutlineManager.createOrGetEditorId(forTextId: newElement)
                        
                        if let editorAudioControls = audioFilesManager.getOrCreateEditorRecordindControls(forTextManagerId: playingTextManagerId, andEditorId: editorId, audioPlugin: self) {

                            editorAudioControls.updateState(fromAudioFile: playingAudioFile)
                        
                            if self.editorRecordingAudioControls != nil {
                                self.editorRecordingAudioControls!.append(editorAudioControls)
                            }
                            else {
                                self.editorRecordingAudioControls = [editorAudioControls]
                            }
                        }
                    }
                }
            case .move:
                break
            case .end: fallthrough
            case .start:
                break
            }
            
        }
        
        if let recordingAudioFile = audioFilesManager.recordingAudioFile.value {
            
            // this is the text manager id
            guard let recordingTextManagerId = recordingAudioFile.associatedDocumentId else {
                assertionFailure("Error: no associatedDocumentId for recording audio file")
                return
            }
            
            switch arrayChange {
            case .deletes(_, let deletedValues, _):
                break
                for deleteValue in deletedValues {
                    if recordingTextManagerId == deleteValue {

                        guard let editorAudioControlsArray = audioFilesManager.editorRecordindControls(forTextManagerId: recordingTextManagerId, andEditorId: nil) else {
                            assertionFailure("Error: no editorRecordButton for text manager id: (deleteValue)")
                            break
                        }

                        for editorAudioControls in editorAudioControlsArray {
                            editorAudioControls.controlsState = .idle
                        }
                        self.editorRecordingAudioControls = nil

                        // Issue #499
                        let setAsPlaying: Bool = {

                            guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
                                assertionFailure("Error: audioFilesOutlineManager is nil")
                                return false
                            }

                            guard let documentAudioFiles = audioFilesManager.documentAudioFiles(forTextId: recordingTextManagerId) else {
                                assertionFailure("Error: documentAudioFiles is nil")
                                return false
                            }

                            if let selectedAudio = audioFilesOutlineManager.selectedAudio.value {
                                if documentAudioFiles.audioFileManagers.values.contains(selectedAudio) {
                                    return true
                                }
                            }
                            return false
                        }()

                    }
                }
                
            case .insert(let newElement, _, _):
                if recordingTextManagerId == newElement {
                    
                    guard let selectedFilesOutlineManager = self.documentManager.selectedFilesOutlineManager else {
                        assertionFailure("Error: selectedFilesOutlineManager is nil")
                        break
                    }
                    
                    let editorId = selectedFilesOutlineManager.createOrGetEditorId(forTextId: newElement)
                    
                    // it's possible we have no editor controls created yet for this editor since
                    // it may appear for the first time.
                    guard let editorAudioControls = audioFilesManager.getOrCreateEditorRecordindControls(forTextManagerId: recordingTextManagerId, andEditorId: editorId, audioPlugin: self) else {
                        assertionFailure("Error: editorAudioControls is nil")
                        break
                    }
                        
                    editorAudioControls.controlsState = .recording
                    editorAudioControls.updateAudioTimer(durationString: recordingAudioFile.recordTimeString.value)
                    
                    if self.editorRecordingAudioControls != nil {
                        self.editorRecordingAudioControls!.append(editorAudioControls)
                    }
                    else {
                        self.editorRecordingAudioControls = [editorAudioControls]
                    }
                }
                
            case .inserts(let newElements, _, _):
                
                guard let selectedFilesOutlineManager = self.documentManager.selectedFilesOutlineManager else {
                    assertionFailure("Error: selectedFilesOutlineManager is nil")
                    break
                }
                
                for newElement in newElements {
                    if recordingTextManagerId == newElement {
                        
                        let editorId = selectedFilesOutlineManager.createOrGetEditorId(forTextId: newElement)
                        
                        guard let editorAudioControls = audioFilesManager.getOrCreateEditorRecordindControls(forTextManagerId: recordingTextManagerId, andEditorId: editorId, audioPlugin: self) else {
                            assertionFailure("Error: editorAudioControls is nil")
                            break
                        }
                        
                        editorAudioControls.controlsState = .recording
                        editorAudioControls.updateAudioTimer(durationString: recordingAudioFile.recordTimeString.value)
                        
                        if self.editorRecordingAudioControls != nil {
                            self.editorRecordingAudioControls!.append(editorAudioControls)
                        }
                        else {
                            self.editorRecordingAudioControls = [editorAudioControls]
                        }
                    }
                }
            case .move(_, _, _, _):
                break
            case .end: fallthrough
            case .start:
                break
            }
        }
    }
    

}
