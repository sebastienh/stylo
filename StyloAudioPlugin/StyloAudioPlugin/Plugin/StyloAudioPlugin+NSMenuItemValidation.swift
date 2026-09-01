//
//  StyloAudioPlugin+NSMenuItemValidator.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-12-05.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Cocoa

extension StyloAudioPlugin: NSMenuItemValidation {
    
    /// [see](https://macosx.com/threads/setenabled-doesnt-work-on-an-nsmenuitem.13853/)
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {

        if let tag = MenuItemTag(rawValue: menuItem.tag) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Validating menu item: %@", log: Log.Stylo.all, type: .info, %%tag)
            #endif
            
            switch tag {
            case .stopCurrentRecording:
                if recordingAudioFileManager != nil {
                    return true
                }
            case .startNewRecording:
                if editedTextManager.value != nil {
                    return true
                }
            case .playPauseCurrentRecording:
                if playingAudioFileManager != nil {
                    return true
                }
            case .advancePlaying:
                if playingAudioFileManager != nil {
                    return true
                }
            case .backPlaying:
                if playingAudioFileManager != nil {
                    return true
                }
            }
        }
        return false
    }
}
