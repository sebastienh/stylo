//
//  StyloAudioPlugin+TextEditorToolbarPlugin.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-02.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa
import WriterCommon


extension StyloAudioPlugin: TextEditorToolbarPlugin {
    
    public func editorControlsForTextManager(withId textId: String, andEditorId editorId: String) -> [TextEditorControl]? {
        
        guard let documentAudioFilesId: String = self.documentAudioFilesId(forTextId: textId) else {
            assertionFailure("Error: documentAudioFilesId is nil")
            return nil
        }
        
        guard let editorAudioControls = self.editorAudioControls(forDocumentAudioFilesId: documentAudioFilesId, andEditorId: editorId) else {
            assertionFailure("Error: recordButton is nil")
            return nil
        }
        
        return [editorAudioControls]
    }
    
    private func editorAudioControls(forDocumentAudioFilesId documentAudioFilesId: String, andEditorId editorId: EditorId) -> AudioControls?  {
    
        guard let audioFilesManager = audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: audioPluginManager.audioFilesManager is nil")
            return nil
        }
        
        if let editorAudioControlsDictionnary = audioFilesManager.editorsAudioControls[documentAudioFilesId], let editorAudioControls = editorAudioControlsDictionnary[editorId] {
            return editorAudioControls
        }
        
        guard let textId = audioFilesManager.textIdBy(documentAudioFilesId: documentAudioFilesId) else {
            assertionFailure("Error: textId is nil")
            return nil
        }
        
        guard let audioControls = audioFilesManager.getOrCreateEditorRecordindControls(forTextManagerId: textId, andEditorId: editorId, audioPlugin: self) else {
            assertionFailure("Error: audioControls is nil")
            return nil
        }
        
        if let recordingAudioFile = self.audioPluginManager?.audioFilesManager?.recordingAudioFile.value {
            if recordingAudioFile.parentId == documentAudioFilesId {
                
                audioControls.updateState(fromAudioFile: recordingAudioFile)
            }
        }
        else if let playingAudioFile = self.audioPluginManager?.audioFilesManager?.playingAudioFile.value {
            if playingAudioFile.parentId == documentAudioFilesId {
                
                audioControls.updateState(fromAudioFile: playingAudioFile)
            }
        }
        
        return audioControls
    }

    private func documentAudioFilesId(forTextId textId: TextId) -> DocumentAudioFilesId? {
        
        guard let audioFilesManager = audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: audioPluginManager.audioFilesManager is nil")
            return nil
        }
        
        if let documentAudioFilesId = audioFilesManager.documentAudioFilesIdByTextId.values[textId] {
            return documentAudioFilesId
        }
        else {
            
            // if it does not exist we need to create it but we don't know the index
            // to which insert it...
            guard let documentAudioFilesId = audioFilesManager.createDocumentAudioFilesManager(forTextManagerId: textId, andInsertAtIndex: nil) else {
                assertionFailure("Error: documentAudioFilesId is nil")
                return nil
            }
            return documentAudioFilesId
        }
    }
    
    
}
