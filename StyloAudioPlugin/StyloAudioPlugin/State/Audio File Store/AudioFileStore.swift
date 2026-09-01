//
//  AudioTrackStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import SwiftProtobuf
import Common
import AVFoundation

class AudioFileStore: Store, IdentifiableStoreType {
    
    typealias ReducerType = AudioFileReducer
    
    let identifier: String
    
    let name: Dynamic<String>
    
    let audioState: Dynamic<AudioState>

    let audioPlayerState: Dynamic<AudioPlayerState>
    
    let reducer: AudioFileReducer
    
    let recordedDate: Dynamic<Date?>
    
    let audioFormat: AudioFormat

    let secondsDuration: Dynamic<Double>
    
    let recordTimeString: Dynamic<String>
    
    let completePlayTimeString: Dynamic<String>
    
    let currentPlayTimeString: Dynamic<String>
    
    let leftPlayTimeString: Dynamic<String>
    
    let currentPlayTime: Dynamic<Double>
    
    let fileNameExtension: String
    
    var parentId: String
    
    let sampleRate: UInt32
    
    let channelsMode: ChannelsMode
    
    let audioQuality: AudioQuality
    
    /// We keep this value to know where the audio is
    /// whenever we need it. 
    var originalRecordingUrl: URL?
    
    init(audioFileMetadata: AudioFileMetadata, parentId: String) {
        
        self.identifier = audioFileMetadata.id
        self.name = Dynamic<String>(audioFileMetadata.name)
        self.recordedDate = Dynamic<Date?>(audioFileMetadata.recordedDate.date)
        self.audioFormat = audioFileMetadata.audioFormat
        self.secondsDuration = Dynamic<Double>(0)
        self.recordTimeString = Dynamic<String>(Double(0).hoursMinutesSecondsMilliseconds)
        self.currentPlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)")
        self.leftPlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)")
        self.completePlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)/\(Double(0).hoursMinutesSeconds)")
        self.audioState = Dynamic<AudioState>(self.recordedDate.value != nil ? AudioState.inactive : AudioState.empty)
        self.currentPlayTime = Dynamic<Double>(0)
        self.fileNameExtension = audioFileMetadata.audioFormat.fileExtension
        self.parentId = parentId
        self.sampleRate = audioFileMetadata.sampleRate
        self.channelsMode = audioFileMetadata.mode
        self.audioQuality = audioFileMetadata.audioQuality
        self.audioPlayerState = Dynamic<AudioPlayerState>(audioFileMetadata.audioPlayerState)
        self.reducer = AudioFileReducer(storeIdentifier: self.identifier)
    }
    
    // Note: audio format cannot change once an AudioFileStore is created
    init(name: String, audioFormat: AudioFormat = AudioFormat.default, parentId: String,
         sampleRate: UInt32 = 44100,
         channelsMode: ChannelsMode = ChannelsMode.default,
         audioQuality: AudioQuality = AudioQuality.default) {
        
        self.identifier = UUID().uuidString
        self.parentId = parentId
        // will be set when we start recording
        self.recordedDate = Dynamic<Date?>(nil)
        // by default it is Apple Losseless
        self.audioFormat = audioFormat
        self.audioState = Dynamic<AudioState>(AudioState.empty)
        self.secondsDuration = Dynamic<Double>(0)
        self.recordTimeString = Dynamic<String>(Double(0).hoursMinutesSecondsMilliseconds)
        self.currentPlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)")
        self.leftPlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)")
        self.completePlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)/\(Double(0).hoursMinutesSeconds)")
        self.currentPlayTime = Dynamic<Double>(0)
        self.name = Dynamic<String>(name)
        self.fileNameExtension = audioFormat.fileExtension
        self.sampleRate = sampleRate
        self.channelsMode = channelsMode
        self.audioQuality = audioQuality
        self.audioPlayerState = Dynamic<AudioPlayerState>(.notShow)
        self.reducer = AudioFileReducer(storeIdentifier: self.identifier)
    }
}

extension ChannelsMode {
    
    static var `default`: ChannelsMode {
        return ChannelsMode.mono
    }
}

extension AudioQuality {
    
    static var `default`: AudioQuality {
        return AudioQuality.min
    }
    
    var avAudioQuality: AVAudioQuality {
        
        switch self {
        
        case .unknownAudioQuality:
            return AudioQuality.default.avAudioQuality
        case .min:
            return AVAudioQuality.min
        case .low:
            return AVAudioQuality.low
        case .medium:
            return AVAudioQuality.medium
        case .high:
            return AVAudioQuality.high
        case .max:
            return AVAudioQuality.max
        case .UNRECOGNIZED(_):
            return AudioQuality.default.avAudioQuality
        }
    }
    
}

extension AudioFormat {
    
    static var `default`: AudioFormat {
        return AudioFormat.mpeg4Aac
    }
    
    var fileExtension: String {
        switch self {
        case .amr:
            return "amr"
        case .applelosseless:
            return "m4a"
        case .pcm:
            return "wav"
        case .flac:
            return "flac"
        case .mpeg4Aac:
            return "m4a"
        case .unknownAudioFormat:
            assertionFailure("Error: unknown audio format.")
            return AudioFormat.default.fileExtension
        case .UNRECOGNIZED(let value):
            assertionFailure("Error: unrecognized audio format: \(value)")
            return AudioFormat.default.fileExtension
        }
    }
    
    var recordingFormat: Int {

        switch self {
        case .amr:
            return Int(kAudioFormatAMR)
        case .applelosseless:
            return Int(kAudioFormatAppleLossless)
        case .pcm:
            return Int(kAudioFormatLinearPCM)
        case .flac:
            return Int(kAudioFormatFLAC)
        case .mpeg4Aac:
            return Int(kAudioFormatMPEG4AAC)
        case .unknownAudioFormat:
            assertionFailure("Error: unknown audio format.")
            return AudioFormat.default.recordingFormat
        case .UNRECOGNIZED(let value):
            assertionFailure("Error: unrecognized audio format: \(value)")
            return AudioFormat.default.recordingFormat
        }
    }
    
}
