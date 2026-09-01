//
//  AudioTrackReducer.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit
import AVKit
import os 

enum AudioFileError: Error {
    
    case noItemWithId(id: String)
}

enum AudioError: Error {
    
    case noRecordingDeviceConfigured
    case noRecordingPermission(error: Error)
    case failedToPrepareRecording
    case noAudioRecorder
    case recordingNotStarted
    case noAudioPlayer
    case playingNotStarted
}

enum AudioFileAction: ActionType {
    
    case rename(newName: String)
    case prepareRecording(documentAudioFilesDirectoryUrl: URL)
    case startRecording
    case updateRecordTime
    case stopRecording
    case createPlayer(documentAudioFilesDirectoryUrl: URL)
    case createDataPlayer(audioData: Data)
    case startPlaying
    case setPlayingTime(seconds: Double)
    case reflectPlayerCurrentTime
    case pausePlaying
    case finishedPlaying
    case move(toParentWithId: String, documentAudioFilesDirectoryUrl: URL)
    case removeFile(documentAudioFilesDirectoryUrl: URL)
    case showPlayer
    case showRecorder
    case hideAudioPlayer
}

enum AudioFileErrorActionResult: ActionResult {
    
    
}

class AudioFileReducer: NSObject, Reducer, SerialReducer, AVAudioRecorderDelegate {
    
    private var audioRecorder: AVAudioRecorder?
    
    private var audioPlayer: AVAudioPlayer?
    
    let serialQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialQueue = DispatchQueue(label: Constants.Queues.AudioFileRecordingQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
        super.init()
    }
    
    func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        guard let audioFileAction = action as? AudioFileAction else {
            assertionFailure("Error: action is not of type AudioFileAction")
            return nil
        }
        
        guard let audioFileStore = store as? AudioFileStore else {
            assertionFailure("Error: store is not an AudioFileStore")
            return nil
        }
        
        switch audioFileAction {
            
        case .prepareRecording(let documentAudioFilesDirectoryUrl):
            
            #if DEBUG
            validateRecordAccess()
            #endif
            
            let settings = [
                AVFormatIDKey: audioFileStore.audioFormat.recordingFormat,
                AVSampleRateKey: Int(audioFileStore.sampleRate),
                AVNumberOfChannelsKey: audioFileStore.channelsMode.rawValue,
                AVEncoderAudioQualityKey: audioFileStore.audioQuality.avAudioQuality.rawValue
            ]
            
            let audioFileUrl = self.audioFileUrl(from: documentAudioFilesDirectoryUrl, audioFileStore: audioFileStore)

            self.audioRecorder = try AVAudioRecorder(url: audioFileUrl, settings: settings)
            
            guard let audioRecorder = self.audioRecorder else {
                assertionFailure("Error: self.audioRecorder is nil")
                throw AudioError.failedToPrepareRecording
            }
            
            audioRecorder.isMeteringEnabled = true

            if audioRecorder.prepareToRecord() {
                audioFileStore.audioState.setValue(.readyToRecord(audioRecorder: audioRecorder))
                audioRecorder.record()
                audioRecorder.stop()
            }
            else {
                throw AudioError.failedToPrepareRecording
            }
            audioFileStore.originalRecordingUrl = audioFileUrl
            assert(audioFileStore.audioState.value.isReadyToRecord)
            
            
        case .startRecording:
            
            #if DEBUG
            validateRecordAccess()
            #endif
            
            assert(audioFileStore.audioState.value.isReadyToRecord)
            
            audioRecorder!.record()
            audioFileStore.recordedDate.setValue(Date())
            audioFileStore.audioState.setValue(.recording)
            
            
        case .stopRecording:
            
            #if DEBUG
            validateRecordAccess()
            #endif
            
            guard let audioRecorder = self.audioRecorder else {
                assertionFailure("Error: self.audioRecorder is nil.")
                return nil
            }
            audioRecorder.stop()
            audioFileStore.audioState.setValue(.inactive)
            
        case .createPlayer(let documentAudioFilesDirectoryUrl):
            
            assert(self.audioPlayer == nil)
            guard let recordingUrl = audioFileStore.originalRecordingUrl else {
                assertionFailure("Error: audioFileStore.originalRecordingUrl is nil")
                return nil
            }
            
            self.audioPlayer = try AVAudioPlayer(contentsOf: recordingUrl)
            
            guard let audioPlayer = self.audioPlayer else {
                assertionFailure("Error: audioFileStore.audioPlayer is nil")
                return nil
            }
            
            guard audioPlayer.prepareToPlay() else {
                assertionFailure("Error: prepareToPlay() returned false")
                return nil
            }
            
            let totalDuration = audioPlayer.duration
            audioFileStore.audioState.setValue(.readyToPlay(audioPlayer: audioPlayer))
            audioFileStore.secondsDuration.setValue(totalDuration)
            audioFileStore.recordTimeString.setValue(totalDuration.hoursMinutesSeconds)
            
            let leftTime: Double = totalDuration
            let currentPlayTimeString = Double(0).hoursMinutesSeconds
            let leftPlayTimeString = leftTime.hoursMinutesSeconds
            audioFileStore.currentPlayTimeString.setValue(currentPlayTimeString)
            audioFileStore.leftPlayTimeString.setValue(leftPlayTimeString)
            audioFileStore.completePlayTimeString.setValue("\(currentPlayTimeString)/\(leftPlayTimeString)")
            
        case .createDataPlayer(let audioData):
            
            self.audioPlayer = try AVAudioPlayer(data: audioData)
            
            guard let audioPlayer = self.audioPlayer else {
                assertionFailure("Error: audioFileStore.audioPlayer is nil")
                return nil
            }
            
            guard audioPlayer.prepareToPlay() else {
                assertionFailure("Error: prepareToPlay() returned false")
                return nil
            }
            
            let totalDuration = audioPlayer.duration
            audioFileStore.audioState.setValue(.readyToPlay(audioPlayer: audioPlayer))
            audioFileStore.secondsDuration.setValue(totalDuration)
            audioFileStore.recordTimeString.setValue(totalDuration.hoursMinutesSeconds)
            
            let leftTime: Double = totalDuration
            let currentPlayTimeString = Double(0).hoursMinutesSeconds
            let leftPlayTimeString = leftTime.hoursMinutesSeconds
            audioFileStore.currentPlayTimeString.setValue(currentPlayTimeString)
            audioFileStore.leftPlayTimeString.setValue(leftPlayTimeString)
            audioFileStore.completePlayTimeString.setValue("\(currentPlayTimeString)/\(leftPlayTimeString)")
            
        case .startPlaying:
            
            guard let audioPlayer = self.audioPlayer else {
                assertionFailure("Error: self.audioPlayer is nil")
                throw AudioError.noAudioPlayer
            }
            
            // atTime: audioFileStore.currentPlayTime.value
            guard audioPlayer.play() else {
                assertionFailure("Error: play() returned false")
                throw AudioError.playingNotStarted
            }
            audioFileStore.audioState.setValue(.playing)
            
        case .pausePlaying:
            
            guard let audioPlayer = self.audioPlayer else {
                assertionFailure("Error: self.audioPlayer is nil.")
                return nil
            }

            switch audioFileStore.audioState.value {
            case .playing:
                audioPlayer.pause()
                audioFileStore.audioState.setValue(.pausePlaying)
            case .pausePlaying:
                break
            default:
                break
            }
            
        case .rename(let newName):
            audioFileStore.name.setValue(newName)
            
        case .move(let newParentId, let documentAudioFilesDirectoryUrl):
            
            let currentUrl = audioFileUrl(from: documentAudioFilesDirectoryUrl, audioFileStore: audioFileStore)
            assert(FileManager.default.fileExists(atPath: currentUrl.path))
            audioFileStore.parentId = newParentId
            let newUrl = audioFileUrl(from: documentAudioFilesDirectoryUrl, audioFileStore: audioFileStore)
            try FileManager.default.copyItem(at: currentUrl, to: newUrl)
            assert(FileManager.default.fileExists(atPath: newUrl.path))
            
        case .updateRecordTime:
            
            guard let audioRecorder = self.audioRecorder else {
                assertionFailure("Error: self.audioRecorder is nil")
                throw AudioError.noAudioRecorder
            }
            
            let time = audioRecorder.currentTime
            audioFileStore.secondsDuration.setValue(time)
            audioFileStore.recordTimeString.setValue(time.hoursMinutesSecondsMilliseconds)
            
        case .setPlayingTime(let milliseconds):
            
            assert(audioFileStore.recordedDate.value != nil)
            assert(audioPlayer != nil)
            audioPlayer?.currentTime = milliseconds
            audioFileStore.currentPlayTime.setValue(milliseconds)
        
            let leftTime: Double = audioFileStore.secondsDuration.value-milliseconds
            let currentPlayTimeString = milliseconds.hoursMinutesSeconds
            let leftPlayTimeString = leftTime.hoursMinutesSeconds
            audioFileStore.currentPlayTimeString.setValue(currentPlayTimeString)
            audioFileStore.leftPlayTimeString.setValue(leftPlayTimeString)
            audioFileStore.completePlayTimeString.setValue("\(currentPlayTimeString)/\(leftPlayTimeString)")
            
        case .reflectPlayerCurrentTime:
            
            guard let audioPlayer = self.audioPlayer else {
                assertionFailure("Error: audioFileStore.audioPlayer is nil")
                return nil
            }

            let playTime = audioPlayer.currentTime
            audioFileStore.currentPlayTime.setValue(playTime)
            
            let leftTime: Double = audioFileStore.secondsDuration.value-playTime
            let currentPlayTimeString = playTime.hoursMinutesSeconds
            let leftPlayTimeString = leftTime.hoursMinutesSeconds
            audioFileStore.currentPlayTimeString.setValue(currentPlayTimeString)
            audioFileStore.leftPlayTimeString.setValue(leftPlayTimeString)
            audioFileStore.completePlayTimeString.setValue("\(currentPlayTimeString)/\(leftPlayTimeString)")
            
        case .finishedPlaying:
            
            guard let audioPlayer = self.audioPlayer else {
                assertionFailure("Error: audioFileStore.audioPlayer is nil")
                return nil
            }
            
            audioFileStore.audioState.setValue(.readyToPlay(audioPlayer: audioPlayer))
            audioFileStore.currentPlayTime.setValue(0)
            
            let totalDuration = audioPlayer.duration
            audioFileStore.audioState.setValue(.readyToPlay(audioPlayer: audioPlayer))
            audioFileStore.secondsDuration.setValue(totalDuration)
            audioFileStore.recordTimeString.setValue(totalDuration.hoursMinutesSeconds)
            
            let leftTime: Double = totalDuration
            let currentPlayTimeString = Double(0).hoursMinutesSeconds
            let leftPlayTimeString = leftTime.hoursMinutesSeconds
            audioFileStore.currentPlayTimeString.setValue(currentPlayTimeString)
            audioFileStore.leftPlayTimeString.setValue(leftPlayTimeString)
            audioFileStore.completePlayTimeString.setValue("\(currentPlayTimeString)/\(leftPlayTimeString)")
            
            
        case .removeFile(let documentAudioFilesDirectoryUrl):
            
            let currentUrl = audioFileUrl(from: documentAudioFilesDirectoryUrl, audioFileStore: audioFileStore)
            assert(FileManager.default.fileExists(atPath: currentUrl.path))
            
            try FileManager.default.removeItem(at: currentUrl)
            audioFileStore.audioState.setValue(.empty)
            
        case .showPlayer:
            audioFileStore.audioPlayerState.setValue(.player, sameExecutionStack: true)
        case .showRecorder:
            audioFileStore.audioPlayerState.setValue(.recorder, sameExecutionStack: true)
        case .hideAudioPlayer:
            audioFileStore.audioPlayerState.setValue(.notShow, sameExecutionStack: true)
        }
        return nil
    }
    
    private func audioFileUrl(from documentAudioFilesDirectoryUrl: URL, audioFileStore: AudioFileStore) -> URL {
        
        do {
            
            let audioFilePath = self.audioFilePath(of: audioFileStore)
            let fileUrl = documentAudioFilesDirectoryUrl.appendingPathComponent(audioFilePath)
            let temporaryDirectoryURL = try FileManager.default.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: fileUrl, create: true)
            return temporaryDirectoryURL.appendingPathComponent(audioFilePath)
        }
        catch {
            assertionFailure("Error: \(error)")
            let audioFilePath = self.audioFilePath(of: audioFileStore)
            return URL(fileURLWithPath: audioFilePath, isDirectory: false, relativeTo: FileManager.default.temporaryDirectory)
        }
    }
    
    private func audioFilePath(of audioFileStore: AudioFileStore) -> String {
        return audioFileStore.identifier + "." + audioFileStore.fileNameExtension
    }
    
    private func validateRecordAccess() {
        
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) {
        case .authorized:
            break
        case .notDetermined: fallthrough
        case .denied: fallthrough
        case .restricted: fallthrough
        @unknown default:
            assertionFailure("Error: should not allowed prepare recording without the proper authorization")
            break
        }
    }
    
}


