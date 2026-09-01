//
//  AudioState.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-06.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import AVFoundation

enum AudioState {
    
    case empty
    case readyToRecord(audioRecorder: AVAudioRecorder)
    case recording
    case readyToPlay(audioPlayer: AVAudioPlayer)
    case playing
    case pausePlaying
    case inactive
    
    var isRecording: Bool {
        
        switch self {
        case .empty: fallthrough
        case .inactive: fallthrough
        case .pausePlaying: fallthrough
        case .playing: fallthrough
        case .readyToPlay(_): fallthrough
        case .readyToRecord(_):
            return false
        case .recording:
            return true
        }
    }
    
    var isReadyToRecord: Bool {
        
        switch self {
        case .empty: fallthrough
        case .inactive: fallthrough
        case .pausePlaying: fallthrough
        case .playing: fallthrough
        case .readyToPlay(_): fallthrough
        case .recording: 
            return false
        case .readyToRecord(_):
            return true
        }
    }
    
}

extension AudioState: Equatable {
    
    static func ==(lhs: AudioState, rhs: AudioState) -> Bool {
        
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.readyToRecord(_), .readyToRecord(_)):
            return true
        case (.recording, .recording):
            return true
        case (.readyToPlay(_), .readyToPlay(_)):
            return true
        case (.playing, .playing):
            return true
        case (.pausePlaying, .pausePlaying):
            return true
        case (.inactive, .inactive):
            return true
        default:
            return false
        }
    }
}
