//
//  AudioFilesManager+AVAudioRecorderDelegate.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-08.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import AVFoundation
import os

extension AudioFilesManager: AVAudioRecorderDelegate {

    /* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("audioRecorderDidFinishRecording", log: Log.Audio.all, type: .info)
        #endif
    }
    
    /* if an error occurs while encoding it will be reported to the delegate. */
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("audioRecorderEncodeErrorDidOccur", log: Log.Audio.all, type: .info)
        #endif
        self.recordingAudioFile.setValue(nil)
    }
    
}
