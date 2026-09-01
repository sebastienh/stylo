//
//  AudioFilesManager+AVAudioPlayerDelegate.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-08.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import AVFoundation
import os

extension AudioFilesManager: AVAudioPlayerDelegate {
    
    /* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("audioPlayerDidFinishPlaying", log: Log.Audio.all, type: .info)
        #endif
        
        guard let audioFileManager = self.playingAudioFile.value else {
            assertionFailure("Error: no playing audio file.")
            return
        }
        
        do {
            try audioFileManager.handleFinishedPlaying()
        }
        catch let error {
            assertionFailure("Error: exception after finish playing: \(error)")
        }
    }
    
    /* if an error occurs while decoding it will be reported to the delegate. */
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        debugPrint("audioPlayerDecodeErrorDidOccur")
    }
    
}
