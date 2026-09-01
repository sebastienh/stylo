//
//  StyloAudioPlugin+ProjectPanelPlugin.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

extension StyloAudioPlugin: ProjectPanelPlugin {

    public var projectPanels: [NavigatorTool]? {
        
        let buttonImageName = "speaker"
        let storyboardStringName = "AudioTools"
        let storyboardName = NSStoryboard.Name(string: storyboardStringName)
        
        let pluginBundle = Bundle(for: type(of: self))
        
        let storyboard = NSStoryboard(name: storyboardName, bundle: pluginBundle)
        guard let audioToolsViewController = storyboard.instantiateInitialController() as? AudioToolsViewController else {
            assertionFailure("Error: storyboard initial controller is not AudioToolsViewController")
            return nil
        }
        
        self.audioToolsViewController = audioToolsViewController
        
        guard let audioFilesManager = self.audioPluginManager?.audioFilesManager else {
            assertionFailure("Error: self.audioPluginManager?.audioFilesManager is nil")
            return nil
        }
        
        // AudioFilesManager
        audioToolsViewController.representedObject = audioFilesManager
        
        guard let buttonImage = NSImage(systemSymbolName: buttonImageName, accessibilityDescription: "Audio Tool") else {
            assertionFailure("Error: no image named \"\(buttonImageName)\"")
            return nil
        }
        
        return [NavigatorTool(originPluginName: storyboardStringName, title: "Audio", order: PanelOrder.audio, viewController: audioToolsViewController, buttonImage: buttonImage, buttonTooltip: "Show Audio Tools")]
    }
    
    public func documentWillDisableProjectPanel() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("StyloAudioPlugin.documentWillDisableProjectPanel()", log: Log.Audio.all, type: .debug)
        #endif
        
        guard let audioToolsViewController = self.audioToolsViewController else {
            assertionFailure("Error: self.audioToolsViewController is nil")
            return
        }
        
        audioToolsViewController.disableUserInteractions()
    }
    
    public func documentWillEnableProjectPanel() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("StyloAudioPlugin.documentWillDisableProjectPanel()", log: Log.Audio.all, type: .debug)
        #endif
        
        guard let audioToolsViewController = self.audioToolsViewController else {
            assertionFailure("Error: self.audioToolsViewController is nil")
            return
        }
        
        audioToolsViewController.enableUserInteractions()
    }
    
}
