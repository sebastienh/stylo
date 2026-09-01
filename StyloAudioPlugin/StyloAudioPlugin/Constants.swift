//
//  Constants.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-08-29.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Common
import WriterCommon

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

public struct Constants {
    
    public struct Plugin {
        public static let Name = §TextuallyPlugin.audio
    }
    
    public struct Activity {
        public static let Playing = "\(Plugin.Name).activity.playing"
        public static let Recording = "\(Plugin.Name).activity.recording"
    }
    
    public struct Filename {
        
        public static let DefaultAudioFileName = "Untitled Audio"
        public static let DocumentAudioDirectoryName = "audio"
        public static let DefaultAudioFilesOutlineName = "Audio Files Outline"
        public static let AudioMetadataFileName = "audio.json"
    }

    public struct Queues {
        
        public static let AudioFileRecordingQueueNamePrefix = "media.recording-queue-"
        public static let AudioFilesQueueNamePrefix = "audio-files.queue-"
        public static let AudioFilesOutlineQueueNamePrefix = "audio-files-outline.queue-"
    }
    
    public struct Views {
        
        public struct RecordingsControls {
            
            public static let StackAnimationTime: TimeInterval = 1.25
        }
        
        public struct AudioFileView {
         
            public static let StackAnimationTime: TimeInterval = 0.75
        }
    }
    
    public struct ViewIdentifiers {
     
        public static let StopRecordingButton = "stop-recording"
        public static let StartRecordingButton = "start-recording"
    }
    
    public struct AudioControls {
        
        public static let ForwardSeconds: Double = 3.0
        public static let BackwardSeconds: Double = 3.0
    }
    
    public struct Audio {
        
        // 24 hours
        public static let MaximumRecordingTimeInSeconds: Double = 86400
    }
    
    public struct Intervals {
        
        public static let UpdatePlayingTimeFrequencyInMilliseconds: Int = 1000
        public static let UpdateRecordingTimeFrequencyInMilliseconds: Int = 311
    }
}
