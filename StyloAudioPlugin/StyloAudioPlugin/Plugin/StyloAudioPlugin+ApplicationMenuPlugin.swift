//
//  StyloAudioPlugin+ApplicationMenuPlugin.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-12-05.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common

extension StyloAudioPlugin: ApplicationMenuPlugin {
    
    // case startNewRecording = 26
    // case showHideProjectTools = 27
    public static var applicationMenu: NSMenuItem? {
        
        let audioMenu = NSMenuItem(title: "Audio", action: nil, keyEquivalent: "")
        audioMenu.submenu = NSMenu(title: "Audio")
        
        let startAddRecordingMenuItem = NSMenuItem(title: "Start/Add a recording", action:  #selector(StyloAudioPlugin.startRecordingInEditedTextManager(_:)), keyEquivalent: "")
        startAddRecordingMenuItem.tag = §MenuItemTag.startNewRecording
        startAddRecordingMenuItem.keyEquivalent = "r"
        startAddRecordingMenuItem.keyEquivalentModifierMask = [.control, .command]
        
        startAddRecordingMenuItem.target = nil
        audioMenu.submenu?.addItem(startAddRecordingMenuItem)

        let stopRecordingMenuItem = NSMenuItem(title: "Stop current recording", action:
            #selector(StyloAudioPlugin.stopRecording(_:)), keyEquivalent: "")
        stopRecordingMenuItem.tag = §MenuItemTag.stopCurrentRecording
        stopRecordingMenuItem.keyEquivalent = "s"
        stopRecordingMenuItem.keyEquivalentModifierMask = [.control, .command]
        stopRecordingMenuItem.target = nil
        audioMenu.submenu?.addItem(stopRecordingMenuItem)
        
        let playRecordingMenuItem = NSMenuItem(title: "Play/Pause current recording", action:
            #selector(StyloAudioPlugin.playPause(_:)), keyEquivalent: "")
        playRecordingMenuItem.tag = §MenuItemTag.playPauseCurrentRecording
        playRecordingMenuItem.keyEquivalent = "p"
        playRecordingMenuItem.keyEquivalentModifierMask = [.control, .command]
        playRecordingMenuItem.target = nil
        audioMenu.submenu?.addItem(playRecordingMenuItem)
        
        let advancePlayingMenuItem = NSMenuItem(title: "Advance playing", action:
            #selector(StyloAudioPlugin.goForward(_:)), keyEquivalent: "")
        advancePlayingMenuItem.tag = §MenuItemTag.advancePlaying
        
        let rightCharacters = [unichar(NSRightArrowFunctionKey)]
        advancePlayingMenuItem.keyEquivalent = NSString(characters: rightCharacters, length: 1) as String
        advancePlayingMenuItem.keyEquivalentModifierMask = [.control, .command]
        advancePlayingMenuItem.target = nil
        audioMenu.submenu?.addItem(advancePlayingMenuItem)
        
        
        let backPlayingMenuItem = NSMenuItem(title: "Back playing", action:
            #selector(StyloAudioPlugin.goBackward(_:)), keyEquivalent: "")
        backPlayingMenuItem.tag = §MenuItemTag.backPlaying
        let leftCharacters = [unichar(NSLeftArrowFunctionKey)]
        backPlayingMenuItem.keyEquivalent = NSString(characters: leftCharacters, length: 1) as String
        backPlayingMenuItem.keyEquivalentModifierMask = [.control, .command]
        backPlayingMenuItem.target = nil
        audioMenu.submenu?.addItem(backPlayingMenuItem)
        
        return audioMenu
    }
    
}
