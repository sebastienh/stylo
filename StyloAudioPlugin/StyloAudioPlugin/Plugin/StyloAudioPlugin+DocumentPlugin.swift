//
//  StyloAudioPlugin+DocumentPlugin.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-11-19.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

extension StyloAudioPlugin: DocumentPlugin, Observer {
    
    public var priority: ObserverPriority {
        return .ui
    }
    
    // This is the initial step to loading a plugin.
    public func pluginDidLoad() {
        
        self.audioPluginManager = AudioPluginManager(documentManager: documentManager)
    }
    
    public func documentDidLoad() {
        
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return
        }
        
        audioFilesManager.playingAudioFile.subscribe({ [weak self](audioFileManager) in
            #if DEBUG
            let oldPlayingAudioFileManager = self?.playingAudioFileManager
            #endif
            self?.handlePlayingAudioFileManager(audioFileManager)
            #if DEBUG
            if let oldPlayingAudioFileManager = oldPlayingAudioFileManager, audioFileManager == nil {
                if let contentManager = audioFilesManager.contentManager(forDocumentAudioFilesManagerId: oldPlayingAudioFileManager.parentId) {
                    assert(contentManager.pluginsBackgroundActivities.values[Constants.Activity.Playing] == nil)
                }
            }
            #endif
        }, observer: self)
        
        audioFilesManager.recordingAudioFile.subscribe({ [weak self](audioFileManager) in
            #if DEBUG
            let oldRecordingAudioFileManager = self?.recordingAudioFileManager
            #endif
            self?.handleRecodingAudioFileManager(audioFileManager)
            #if DEBUG
            if let oldRecordingAudioFileManager = oldRecordingAudioFileManager, audioFileManager == nil {
                if let contentManager = audioFilesManager.contentManager(forDocumentAudioFilesManagerId: oldRecordingAudioFileManager.parentId) {
                    assert(contentManager.pluginsBackgroundActivities.values[Constants.Activity.Recording] == nil)
                }
            }
            #endif
        }, observer: self)
        
        self.subscribeToFilesOutlineSetManager(self.documentManager.filesOutlineSetManager.value)
        self.documentManager.filesOutlineSetManager.subscribe({ [weak self](filesOutlineSetManager) in
            self?.unsubscribeToFilesOutlineSetManager()
            self?.subscribeToFilesOutlineSetManager(filesOutlineSetManager)
        }, observer: self)
        
        subscribeToAudioFilesOutlineManager()
    }
    
    func subscribeToFilesOutlineSetManager(_ filesOutlineSetManager: FilesOutlineSetManager?) {
        
        self.subscribeToSelectedFilesOutlineManager(filesOutlineSetManager?.selectedFilesOutlineManager.value)
        filesOutlineSetManager?.selectedFilesOutlineManager.subscribe({ [weak self](selectedFilesOutlineManager) in
            self?.unsubscribeToCurrentSelectedFilesOutlineManager()
            self?.subscribeToSelectedFilesOutlineManager(selectedFilesOutlineManager)
            
        }, observer: self)
        
        filesOutlineSetManager?.filesOutlines.subscribe({ [weak self](arrayChange) in
            self?.handleFilesOutlinesChange(arrayChange)
        }, observer: self)
        
        self.subscribedFilesOutlineSetManager = filesOutlineSetManager
    }

    private func handleFilesOutlinesChange(_ arrayChange: DynamicArray<FilesOutlineManager>.Change) {
        
        switch arrayChange {
        case .deletes(_, let deletedValues, _):
            
            // we cleanup when removing files outlines
            for deletedValue in deletedValues {
                for (textId, editorId) in deletedValue.editorIds {
                    self.audioPluginManager?.audioFilesManager?.removeEditorAudioControls(forTextManagerId: textId, andEditorId: editorId)
                }
            }
        default:
            break
        }
    }
    
    func subscribeToSelectedFilesOutlineManager(_ selectedFilesOutlineManager: FilesOutlineManager?) {
    
        var shouldHandleChange = true
        selectedFilesOutlineManager?.selectedTextItems.subscribe({ [weak self](arrayChange) in
            switch arrayChange {
            case .start(let sourceArray, let destinationArray):
                // if it is a move, we dont want to handle the change since
                // there is nothing to change in the controls
                if sourceArray.count == destinationArray.count && sourceArray.sorted() == destinationArray.sorted() {
                    shouldHandleChange = false
                }
            case .end:
                shouldHandleChange = true
            default:
                if shouldHandleChange {
                    self?.updateEditorAudioControls(arrayChange)
                }
            }
        }, observer: self)
        self.subscribedSelectedFilesOutlineManager = selectedFilesOutlineManager
    }
        
    func unsubscribeToCurrentSelectedFilesOutlineManager() {
        
        self.subscribedSelectedFilesOutlineManager?.selectedTextItems.unsubscribe(observer: self)
    }
    
    func unsubscribeToFilesOutlineSetManager() {
        
        self.subscribedFilesOutlineSetManager?.selectedFilesOutlineManager.unsubscribe(observer: self)
        self.subscribedFilesOutlineSetManager?.filesOutlines.unsubscribe(observer: self)
    }
    
    func documentWillClose() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("PluginManager.prepareForClosing()", log: Log.Audio.all, type: .debug)
        #endif
        
        try? audioPluginManager?.audioFilesManager?.stopCurrentPlaying()
        try? audioPluginManager?.audioFilesManager?.stopCurrentRecording(setAsPlaying: false)
    }
    
    func documentWillSave() {
        // nothing to do
    }
    
    func documentDidSave() {
        self.audioPluginManager?.clearTemporaryFiles()
    }
}
