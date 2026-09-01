//
//  AudioFileManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common

public final class AudioFileManager: NSObject, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    var identifier: String {
        return audioFileStore.identifier
    }
    
    let audioFileStore: AudioFileStore
    
    let name: Dynamic<String>
    
    let audioState: Dynamic<AudioState>
    
    let audioPlayerState: Dynamic<AudioPlayerState>
    
    let recordTime: Dynamic<Double>
    
    let recordTimeString: Dynamic<String>
    
    let completePlayTimeString: Dynamic<String>
    
    let currentPlayTimeString: Dynamic<String>
    
    let leftPlayTimeString: Dynamic<String>
    
    let recordedDate: Dynamic<Date?>
    
    let currentPlayTime: Dynamic<Double>
    
    var parentId: String {
        return audioFileStore.parentId
    }
    
    var parent: DocumentAudioFilesManager? {
        
        guard let documentAudioFilesManager = audioPluginManager.audioFilesManager?.documentAudioFiles(forDocumentAudioFilesId: self.parentId) else {
            assertionFailure("Error: no document audio files manager with id: \(self.parentId)")
            return nil
        }
        
        return documentAudioFilesManager
    }
    
    var indexInParent: Int? {
        
        guard let parent = self.parent else {
            assertionFailure("Error: self.parent is nil")
            return nil
        }
        
        for (index, audioFileManagerId) in parent.audioFileManagers.values.enumerated() {
            if audioFileManagerId == self.id {
                return index
            }
        }
        return nil
    }
    
    var associatedDocumentId: String? {
        
        guard let documentAudioFilesManager = audioPluginManager.audioFilesManager?.documentAudioFiles(forDocumentAudioFilesId: self.parentId) else {
            assertionFailure("Error: no document audio files manager with id: \(self.parentId)")
            return nil
        }
        return documentAudioFilesManager.associatedDocumentId
    }
    
    var audioFileExistOnDisk: Bool {
        
        guard let audioFileUrl = self.audioFileUrl else {
            assertionFailure("Error: self.audioFileUrl is nil")
            return false
        }
        
        return FileManager.default.fileExists(atPath: audioFileUrl.path)
    }
    
    unowned let audioPluginManager: AudioPluginManager
    
    unowned let audioFilesManager: AudioFilesManager
    
    private var dispatcher: Dispatcher {
        
        return audioPluginManager.audioPluginDispatcher
    }
    
    private var recordTimer: DispatchSourceTimer?
    
    private var playingTimer: DispatchSourceTimer?
    
    private var audioFileUrl: URL? {
        
        guard let parentDocumentAudioFilesManager = self.parent else {
            assertionFailure("Error: self.parent is nil")
            return nil
        }
        
        return parentDocumentAudioFilesManager.documentAudioFilesDirectoryUrl.appendingPathComponent("/" + self.filename)
    }
    
    var filename: String {
        
        return self.id + "." + self.audioFileStore.audioFormat.fileExtension
    }
    
    init(metadata: AudioFileMetadata, audioPluginManager: AudioPluginManager, audioFilesManager: AudioFilesManager, parentId: String) {
        
        self.audioPluginManager = audioPluginManager
        self.audioFilesManager = audioFilesManager
        self.audioFileStore = AudioFileStore(audioFileMetadata: metadata, parentId: parentId)
        self.name = Dynamic<String>("")
        self.audioState = Dynamic<AudioState>(self.audioFileStore.audioState.value)
        self.recordedDate = Dynamic<Date?>(self.audioFileStore.recordedDate.value)
        self.audioPlayerState = Dynamic<AudioPlayerState>(self.audioFileStore.audioPlayerState.value)
        self.recordTime = Dynamic<Double>(0)
        self.recordTimeString = Dynamic<String>(Double(0).hoursMinutesSecondsMilliseconds)
        self.completePlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)/\(Double(0).hoursMinutesSeconds)")
        self.currentPlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)")
        self.leftPlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)")
        self.currentPlayTime = Dynamic<Double>(0)
        super.init()
        dispatcher.register(store: self.audioFileStore)
        subscribeToStore()
    }

    init(name: String, parentId: String, audioPluginManager: AudioPluginManager, audioFilesManager: AudioFilesManager) {
        
        self.audioPluginManager = audioPluginManager
        self.audioFilesManager = audioFilesManager
        self.audioFileStore = AudioFileStore(name: name, parentId: parentId)
        self.name = Dynamic<String>("")
        self.audioState = Dynamic<AudioState>(AudioState.empty)
        self.recordedDate = Dynamic<Date?>(nil)
        self.recordTime = Dynamic<Double>(0)
        self.recordTimeString = Dynamic<String>(Double(0).hoursMinutesSecondsMilliseconds)
        self.completePlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)/\(Double(0).hoursMinutesSeconds)")
        self.currentPlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)")
        self.leftPlayTimeString = Dynamic<String>("\(Double(0).hoursMinutesSeconds)")
        self.currentPlayTime = Dynamic<Double>(0)
        self.audioPlayerState = Dynamic<AudioPlayerState>(.notShow)
        super.init()
        dispatcher.register(store: self.audioFileStore)
        subscribeToStore()
    }
    
    func goForward() {
        
        do {
            
            let totalSeconds = self.recordTime.value
            let forwardValue = self.currentPlayTime.value+Constants.AudioControls.ForwardSeconds
            if forwardValue <= totalSeconds  {
                try self.setPlayingTime(seconds: forwardValue)
            }
            else {
                try self.setPlayingTime(seconds: 0)
            }
        }
        catch let error {
            assertionFailure("Error: errro while setting playing time: \(error)")
        }
    }
    
    func goBackward() {

        do {
            let backwardValue = self.currentPlayTime.value-Constants.AudioControls.BackwardSeconds
            if backwardValue >= 0 {
                try self.setPlayingTime(seconds: backwardValue)
            }
            else {
                try self.setPlayingTime(seconds: 0)
            }
        }
        catch let error {
            assertionFailure("Error: errro while setting playing time: \(error)")
        }
    }
    
    func showPlayer() {
        
        self.dispatcher.sync(store: self.audioFileStore, action: AudioFileAction.showPlayer.syncAction)
    }
    
    func showRecorder() {
        
        self.dispatcher.sync(store: self.audioFileStore, action: AudioFileAction.showRecorder.syncAction)
    }
    
    func hideAudioPlayer() {
        
        self.dispatcher.sync(store: self.audioFileStore, action: AudioFileAction.hideAudioPlayer.syncAction)
    }
    
    public func removeAudioFile(documentAudioFilesDirectoryUrl: URL) {
        
        let action = AudioFileAction.removeFile(documentAudioFilesDirectoryUrl: documentAudioFilesDirectoryUrl)
        self.dispatcher.sync(store: self.audioFileStore, action: action.syncAction)
    }
    
    
    public func rename(to newName: String) throws {
        
        self.dispatcher.async(store: self.audioFileStore, action: AudioFileAction.rename(newName: newName).asyncAction)
    }
    
    public func setPlayingTime(seconds: Double) throws {
        
        self.dispatcher.async(store: self.audioFileStore, action: AudioFileAction.setPlayingTime(seconds: seconds).asyncAction)
    }
    
    private func updateRecordedTime() throws {
        
        self.dispatcher.async(store: self.audioFileStore, action: AudioFileAction.updateRecordTime.asyncAction)
    }
    
    private func reflectPlayerCurrentTime() throws {
        
        self.dispatcher.async(store: self.audioFileStore, action: AudioFileAction.reflectPlayerCurrentTime.asyncAction)
    }
    
    public func stopRecording() throws {
        
        self.dispatcher.sync(store: self.audioFileStore, action: AudioFileAction.stopRecording.syncAction)
        self.recordTimer?.cancel()
    }
    
    public func createPlayer(documentAudioFilesDirectoryUrl: URL) throws {
        
        self.dispatcher.async(store: self.audioFileStore, action: AudioFileAction.createPlayer(documentAudioFilesDirectoryUrl: documentAudioFilesDirectoryUrl).asyncAction)
    }
    
    public func createDataPlayer(fromData data: Data) throws {
        
        self.dispatcher.async(store: self.audioFileStore, action: AudioFileAction.createDataPlayer(audioData: data).asyncAction)
    }
    
    public func handleFinishedPlaying() throws {
        
        self.dispatcher.sync(store: self.audioFileStore, action: AudioFileAction.finishedPlaying.syncAction)
        self.playingTimer?.cancel()
    }
    
    
    public func startPlaying() throws {
        
        self.dispatcher.sync(store: self.audioFileStore, action: AudioFileAction.startPlaying.syncAction)
        setupUpdatePlayingMeter()
    }
    
    public func pausePlaying() throws {
        
        self.dispatcher.sync(store: self.audioFileStore, action: AudioFileAction.pausePlaying.syncAction)
        self.playingTimer?.cancel()
    }
    
    public func prepareRecording(documentAudioFilesDirectoryUrl: URL) throws {
     
        self.dispatcher.sync(store: self.audioFileStore, action: AudioFileAction.prepareRecording(documentAudioFilesDirectoryUrl: documentAudioFilesDirectoryUrl).syncAction)
    }
    
    public func startRecording(documentAudioFilesDirectoryUrl: URL) throws {
        
        self.dispatcher.async(store: self.audioFileStore, action: AudioFileAction.startRecording.asyncAction)
        setupUpdateRecordingMeter()
    }
    
    func setupUpdatePlayingMeter() {
        
        self.playingTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        
        guard let playingTimer = self.playingTimer else {
            assertionFailure("Error: self.playingTimer is nil")
            return
        }
        
        playingTimer.schedule(deadline: .now(), repeating: .milliseconds(Constants.Intervals.UpdatePlayingTimeFrequencyInMilliseconds))
        playingTimer.setEventHandler { [weak self] in
            do {
                try self?.reflectPlayerCurrentTime()
            }
            catch let error {
                assertionFailure("Error: exception \(error)")
                self?.playingTimer?.cancel()
            }
        }
        playingTimer.resume()
    }
    
    private func setupUpdateRecordingMeter() {
        
        self.recordTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)

        guard let recordTimer = self.recordTimer else {
            assertionFailure("Error: self.timer is nil")
            return
        }
        
        recordTimer.schedule(deadline: .now(), repeating: .milliseconds(Constants.Intervals.UpdateRecordingTimeFrequencyInMilliseconds))
        recordTimer.setEventHandler { [weak self] in
            do {
                try self?.updateRecordedTime()
            }
            catch let error {
                assertionFailure("Error: exception \(error)")
                self?.recordTimer?.cancel()
            }
        }
        recordTimer.resume()
    }
    
    private func subscribeToStore() {
        
        self.name.setValue(audioFileStore.name.value)
        audioFileStore.name.subscribe({ [weak self](newName) in
            self?.name.setValue(newName)
        }, observer: self)
        
        
        self.handleAudioState(audioState: audioFileStore.audioState.value)
        audioFileStore.audioState.subscribe({ [weak self](newAudioState) in
            self?.handleAudioState(audioState: newAudioState)
        }, observer: self)
        
        self.recordedDate.bind(to: audioFileStore.recordedDate)
        
        audioFileStore.secondsDuration.subscribe({ [weak self](duration) in
            self?.handleRecordTimeChange(duration)
        }, observer: self)
        
        self.recordTime.bind(to: audioFileStore.secondsDuration)
        self.currentPlayTime.bind(to: audioFileStore.currentPlayTime)
        self.audioPlayerState.bind(to: audioFileStore.audioPlayerState)
        self.recordTimeString.bind(to: audioFileStore.recordTimeString)
        self.completePlayTimeString.bind(to: audioFileStore.completePlayTimeString)
        self.currentPlayTimeString.bind(to: audioFileStore.currentPlayTimeString)
        self.leftPlayTimeString.bind(to: audioFileStore.leftPlayTimeString)
    }
    
    private func handleRecordTimeChange(_ duration: Double) {
        
        self.recordTime.setValue(duration)
        
        // stylo #584
        if duration >= Constants.Audio.MaximumRecordingTimeInSeconds {
            try? self.stopRecording()
        }
    }
    
    private func handleAudioState(audioState: AudioState) {
        switch audioState {
        case .empty:
            break
        case .recording:
            break
        case .readyToPlay(let audioPlayer):
            audioPlayer.delegate = audioFilesManager
        case .playing:
            break
        case .pausePlaying:
            break
        case .inactive:
            break
        case .readyToRecord(let audioRecorder):
            audioRecorder.delegate = audioFilesManager
        }
        // forward the event
        self.audioState.setValue(audioState, sameExecutionStack: true)
    }
    
    private func unsubscribeToStore() {
        
        audioFileStore.name.unsubscribe(observer: self)
        audioFileStore.audioState.unsubscribe(observer: self)
        self.recordTimeString.unbind(from: audioFileStore.recordTimeString)
        self.completePlayTimeString.unbind(from: audioFileStore.completePlayTimeString)
        self.recordedDate.unbind(from: audioFileStore.recordedDate)
        audioFileStore.secondsDuration.unsubscribe(observer: self)
        self.audioPlayerState.unbind(from: audioFileStore.audioPlayerState)
        self.currentPlayTimeString.unbind(from: audioFileStore.currentPlayTimeString)
        self.leftPlayTimeString.unbind(from: audioFileStore.leftPlayTimeString)
    }
    
    deinit {
        unsubscribeToStore()
    }
}
