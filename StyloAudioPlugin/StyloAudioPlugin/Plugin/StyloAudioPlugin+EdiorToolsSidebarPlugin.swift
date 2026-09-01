//
//  StyloAudioPlugin+MacOSPlugin.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-04.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import StyloCoreMac

extension StyloAudioPlugin: EdiorToolsSidebarPlugin {

    public var topToolsButtons: [DisableableButton]? {
        
        return nil
    }
    
    public var middleToolsButtons: [DisableableButton]? {
        
        return nil
    }
    
    private var _recordButton: MacDisableableButton? {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audiPluginManager is nil")
            return nil
        }
        
        let pluginBundle = Bundle(for: type(of: self))
        
        guard let recordButtonImage = pluginBundle.image(forResource: NSImage.Name("RecordToolButtonImage")) else {
            assertionFailure("Error: unable to get image named: RecordToolButtonImage")
            return nil
        }
        
        let recordButton = RecordButton(image: recordButtonImage, target: audioPluginManager, action: #selector(StyloAudioPlugin.startRecordingInEditedTextManager(_:)))
        recordButton.bezelStyle = .regularSquare
        recordButton.isBordered = false
        recordButton.setButtonType(NSButton.ButtonType.momentaryLight)
        recordButton.target = self
        recordButton.identifier = NSUserInterfaceItemIdentifier(rawValue: Constants.ViewIdentifiers.StartRecordingButton)
        recordButton.isEnabled = false
        recordButton.state = .off
        return recordButton
    }
    
    private var _stopButton: MacDisableableButton? {
        
        guard let audioPluginManager = self.audioPluginManager else {
            assertionFailure("Error: self.audiPluginManager is nil")
            return nil
        }
        
        guard let audioFilesManager = audioPluginManager.audioFilesManager else {
            assertionFailure("Error: audioPluginManager.audioFilesManager is nil")
            return nil
        }
        
        let pluginBundle = Bundle(for: type(of: self))
        
        guard let enabledStopButtonImage = pluginBundle.image(forResource: NSImage.Name("StopRecordingToolButtonImage")) else {
            assertionFailure("Error: unable to get image named: StopRecordingToolButtonImage")
            return nil
        }
        
        guard let disabledStopButtonImage = pluginBundle.image(forResource: NSImage.Name("StopRecordingToolButtonDisabledImage")) else {
            assertionFailure("Error: unable to get image named: StopRecordingToolButtonDisabledImage")
            return nil
        }
        
        let stopButton = MacDisableableButton(image: disabledStopButtonImage, target: audioPluginManager, action: #selector(AudioFilesManager.stopCurrentRecordingAndSetAsPlaying(_:)))
        
        
        stopButton.alternateImage = enabledStopButtonImage
        stopButton.bezelStyle = .regularSquare
        stopButton.setButtonType(.toggle)
        stopButton.isBordered = false
        stopButton.toolTip = "Stop current recording ⌃⌘S"
        stopButton.target = audioFilesManager
        stopButton.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        stopButton.identifier = NSUserInterfaceItemIdentifier(rawValue: Constants.ViewIdentifiers.StopRecordingButton)
        stopButton.isEnabled = false
        stopButton.state = .off
        return stopButton
    }
    
    
}
