//
//  AudioFileViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import AVFoundation
import Common

class AudioFileViewController: NSViewController, AVAudioRecorderDelegate {
    
    @IBOutlet var recordingIndicatorButton: RecordButton! {
        didSet {
            recordingIndicatorButton.isHidden = true
        }
    }
    
    @IBOutlet var audioAccessoryButton: NSButton!
    
    @IBOutlet var stackView: NSStackView!
    
    @IBOutlet var titleView: AudioFileTitleView!
    
    @IBOutlet var name: AudioFileTitleTextField!
    
    @IBOutlet var dateLabel: NSTextField!
    
    @IBOutlet var duration: NSTextField!
    
    @IBOutlet var playbackView: NSView!
 
    @IBOutlet var audioSlider: NSSlider!
    
    @IBOutlet var currentPlayTime: NSTextField!
    
    @IBOutlet var leftPlayTime: NSTextField!
 
    @IBOutlet var playButton: NSButton!
    
    @IBOutlet var playbackViewHeightConstraint: NSLayoutConstraint!
    
    private let audioPlayerState: Dynamic<AudioPlayerState> = Dynamic<AudioPlayerState>(.notShow)
    
    var wasPlayingWhenPaused: Bool = false
    
    var isShowingPlaybackView: Bool {
        
        return self.stackView.arrangedSubviews.count > 1
    }
    
    // This value is used to not display the playback controls
    // when we finish recording if another recording has been started
    var startedOtherRecording: Bool = false
    
    private var audioFileManager: AudioFileManager? {
        
        return self.representedObject as? AudioFileManager
    }
    
    private var audioFilesManager: AudioFilesManager? {
        
        return audioFileManager?.audioPluginManager.audioFilesManager
    }
    
    private var audioFilesOutlineManager: AudioFilesOutlineManager? {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return nil
        }
        
        return audioFilesManager.audioFilesOutlineManager
    }
    
    private var initialized: Bool = false
    
    private var isLastAudioFileInDocumentAudioFilesManager : Bool {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return false
        }

        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return false
        }

        guard let parentDocumentAudioFilesManager = audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: audioFileManager.parentId) else {
            assertionFailure("Error: parentDocumentAudioFilesMaanger is nil for id: (audioFileManager.parentId)")
            return false
        }

        guard let lastAudioFileManager = parentDocumentAudioFilesManager.audioFiles.last else {
            assertionFailure("Error: parentDocumentAudioFilesManager.audioFiles.last is nil")
            return false
        }

        return lastAudioFileManager.id == audioFileManager.id
    }
    
    var selected: Bool {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return false
        }
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return false
        }
        
        guard let audioFilesOutlineManager = audioFilesManager.audioFilesOutlineManager else {
            assertionFailure("Error: audioFilesManager.audioFilesOutlineManager is nil")
            return false
        }
        
        if let selectedAudioFileId = audioFilesOutlineManager.selectedItem.value {
            if selectedAudioFileId == audioFileManager.id {
                return true
            }
        }
        return false
    }
    
    private var audioOutlineView: AudioOutlineView? {
        
        var view: NSView? = self.view
        while view != nil {
            if let outlineView = view as? AudioOutlineView {
                return outlineView
            }
            view = view?.superview
        }
        return nil
    }
    
    @IBAction func goForward(_ sender: AnyObject?) {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        audioFileManager.goForward()
    }
    
    @IBAction func goBackward(_ sender: AnyObject?) {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        audioFileManager.goBackward()
    }
    
    @IBAction func deleteAudioFile(_ sender: AnyObject?) {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return
        }
     
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        if let recordingAudioFileManager = audioFilesManager.recordingAudioFile.value, recordingAudioFileManager.id == audioFileManager.id {
            try? recordingAudioFileManager.stopRecording()
            audioFilesManager.recordingAudioFile.setValue(nil)
        }

        if let playingAudioFileManager = audioFilesManager.playingAudioFile.value, playingAudioFileManager.id == audioFileManager.id {
            try? playingAudioFileManager.pausePlaying()
            audioFilesManager.playingAudioFile.setValue(nil)
        }
        
        audioFilesManager.deleteAudioFile(audioFileManager)
    }
    
    @IBAction func handleSliderDrag(_ sender: AnyObject?) {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        do {
            try audioFileManager.setPlayingTime(seconds: audioSlider.doubleValue)
        }
        catch let error {
            assertionFailure("Error: errro while setting playing time: \(error)")
        }
    }
    
    @IBAction func pause(_ sender: AnyObject?) {
     
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return
        }
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        do {
            
            switch audioFileManager.audioState.value {
            case .playing:
                self.wasPlayingWhenPaused = true
            default:
                self.wasPlayingWhenPaused = false
            }
            
            try audioFilesManager.pausePlayingAudioFile(audioFileManager)
        }
        catch let error {
            assertionFailure("Error: exception while playing audio: \(error)")
        }
    }
    
    @IBAction func play(_ sender: AnyObject?) {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return
        }
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        do {
            
            switch audioFileManager.audioState.value {
            case .pausePlaying: fallthrough
            case .inactive: fallthrough
            case .readyToPlay(_):
                try audioFilesManager.startPlayingAudioFile(audioFileManager)
            default:
                try audioFilesManager.pausePlayingAudioFile(audioFileManager)
            }
        }
        catch let error {
            assertionFailure("Error: exception while playing audio: \(error)")
        }
    }
    
    @IBAction func playAtNewPosition(_ sender: AnyObject?) {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return
        }
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        do {
            
            switch audioFileManager.audioState.value {
            case .pausePlaying: fallthrough
            case .inactive: fallthrough
            case .playing: fallthrough
            case .readyToPlay(_):
                try audioFilesManager.startPlayingAudioFile(audioFileManager)
            default:
                try audioFilesManager.pausePlayingAudioFile(audioFileManager)
            }
        }
        catch let error {
            assertionFailure("Error: exception while playing audio: \(error)")
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if !initialized {
            initialize()
            initialized = true
        }
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return
        }
        
        // we do this here because we not have been shown when the audio file was set
        // as the playing audio file. 
        if let playingAudioFile = audioFilesManager.playingAudioFile.value, playingAudioFile.id == audioFileManager.id {
            self.showPlaybackView()
            self.handleAudioState(audioState: audioFileManager.audioState.value)
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.restoreRecordingStateIfNecessary()
    }
    
    private func initialize() {

        audioSlider.doubleValue = 0
        
        guard let name = self.audioFileManager?.audioFileStore.name.value else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        self.name.stringValue = name
        
        NotificationCenter.default.addObserver(forName: NSControl.textDidEndEditingNotification, object: self.name, queue: nil) { [weak self](notification) in
            self?.controlTextDidChange(notification)
        }
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }

        self.setAudioSliderTotalTime(recordingTime: audioFileManager.recordTime.value)
        self.hidePlaybackView()
        subscribeToAudioFileManager()
        subscribeToAudioFilesOutlineManager()
    }
    
    private func restoreRecordingStateIfNecessary() {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return
        }
        
        if let recordingAudioFile = audioFilesManager.recordingAudioFile.value, recordingAudioFile.id == audioFileManager.id {
            self.recordingIndicatorButton.isHidden = false
            self.recordingIndicatorButton.startPulsating()
        }
        else {
            self.recordingIndicatorButton.isHidden = true
            self.recordingIndicatorButton.stopPulsating()
        }
    }
    
    @objc func controlTextDidChange(_ obj: Notification) {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil.")
            return
        }
        
        let textField: NSTextField = obj.object as! NSTextField
        
        do {
            try audioFileManager.rename(to: textField.stringValue)
        }
        catch let error {
            assertionFailure("Error: unhandled error type: \(error)")
        }
    }
    
    private func subscribeToAudioFileManager() {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil.")
            return
        }
        
        // name
        self.name.stringValue = audioFileManager.name.value
        audioFileManager.name.subscribe({ [weak self](newName) in
            if newName != self?.name.stringValue {
                self?.name.stringValue = newName
            }
        }, observer: self)
        
        // audioState
//        self.handleAudioState(audioState: audioFileManager.audioState.value)
        audioFileManager.audioState.subscribe({ [weak self](newAudioState) in
            self?.handleAudioState(audioState: newAudioState)
        }, observer: self)
        
        // recordedDate
        self.handleRecordedDate(date: audioFileManager.recordedDate.value)
        audioFileManager.recordedDate.subscribe({ [weak self](newDate) in
            self?.handleRecordedDate(date: newDate)
        }, observer: self)
        
        // recordTime
        handleRecordDuration(duration: audioFileManager.recordTimeString.value)
        audioFileManager.recordTimeString.subscribe({ [weak self](newDuration) in
            self?.handleRecordDuration(duration: newDuration)
        }, observer: self)
        
        // currentPlayTime
        handleCurrentPlayTime(playTime: audioFileManager.currentPlayTime.value, recordDuration: audioFileManager.recordTime.value)
        audioFileManager.currentPlayTime.subscribe({ [weak self](newCurrentPlayTime) in
            self?.handleCurrentPlayTime(playTime: newCurrentPlayTime, recordDuration: audioFileManager.recordTime.value)
        }, observer: self)
        
        self.audioPlayerState.setValue(audioFileManager.audioPlayerState.value)
        self.audioPlayerState.bind(to: audioFileManager.audioPlayerState)
    }
    
    private func handleCurrentPlayTime(playTime: Double, recordDuration: Double) {
        
        self.currentPlayTime.stringValue = playTime.hoursMinutesSeconds
        let leftTime: Double = recordDuration-playTime
        self.leftPlayTime.stringValue = leftTime.hoursMinutesSeconds
        self.audioSlider.doubleValue = playTime
    }
    
    private func handleRecordDuration(duration: String) {
    
        updateRecordingTime(withDurationString: duration)
    }
    
    private func updateRecordingTime(withDurationString durationString: String) {
        
        self.duration.stringValue = durationString
    }
    
    private func handleRecordedDate(date: Date?) {
        
        if let date = date {
            let dateString = DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
            dateLabel.stringValue = dateString
        }
        else {
            dateLabel.stringValue = ""
        }
    }
    
    private func handleAudioState(audioState: AudioState) {
        
        switch audioState {
        case .empty:
            break
        case .recording:
            self.recordingIndicatorButton.isHidden = false
            self.recordingIndicatorButton.startPulsating()
        case .playing:
            updatePlayButtonInPauseMode()
        case .pausePlaying:
            updatePlayButtonInPlayMode()
        case .inactive:
            break
        case .readyToRecord(_):
            break
        case .readyToPlay(_):
            self.recordingIndicatorButton.isHidden = true
            self.recordingIndicatorButton.stopPulsating()
            updatePlayButtonInPlayMode()
            updateLeftPlayingTime()
            
            guard let audioFileManager = self.audioFileManager else {
                assertionFailure("Error: self.audioFileManager is nil")
                return
            }
            self.setAudioSliderTotalTime(recordingTime: audioFileManager.recordTime.value)
//            updateRecordingTime(withDurationString: audioFileManager.recordTime.value.hoursMinutesSeconds)
        }
    }
    
    private func updateLeftPlayingTime() {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        let recordDuration = audioFileManager.recordTime.value
        let playTime = audioFileManager.currentPlayTime.value
        handleCurrentPlayTime(playTime: playTime, recordDuration: recordDuration)
    }
    
    private func updatePlayButtonInPauseMode() {
        
        let pluginBundle = Bundle(for: type(of: self))
        playButton.image =  pluginBundle.image(forResource: NSImage.Name("PausePlaying"))
    }
    
    private func updatePlayButtonInPlayMode() {
        
        let pluginBundle = Bundle(for: type(of: self))
        playButton.image =  pluginBundle.image(forResource: NSImage.Name("PlayRecording"))
    }
    
    private func setAudioSliderTotalTime(recordingTime: Double) {
        
        audioSlider.minValue = 0
        audioSlider.maxValue = recordingTime
    }
    
    func showPlaybackView() {
        
        if playbackView.isHidden && self.stackView.arrangedSubviews.count == 1 {
            
            playbackView.isHidden = false
            self.stackView.addArrangedSubview(playbackView)
            self.name.selected = true
            self.titleView.selected = true
            self.audioFileManager?.showPlayer()
        }
    }
    
    func hidePlaybackView() {
        
        if !playbackView.isHidden && self.stackView.arrangedSubviews.count > 1 {
            playbackView.isHidden = true
            self.stackView.removeArrangedSubview(playbackView)
            playbackView.isHidden = true
            self.name.selected = false
            self.titleView.selected = false
            self.audioFileManager?.hideAudioPlayer()
        }
    }
    
    private func unsubscribeToAudioFileManager() {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil.")
            return
        }
        
        audioFileManager.name.unsubscribe(observer: self)
        audioFileManager.audioState.unsubscribe(observer: self)
        audioFileManager.recordedDate.unsubscribe(observer: self)
        audioFileManager.recordTime.unsubscribe(observer: self)
        self.audioPlayerState.unbind(from: audioFileManager.audioPlayerState)
    }
    
    private func subscribeToAudioFilesOutlineManager() {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        self.handleSelected(audioFilesOutlineManager.selectedAudio.value, initPhase: true)
        audioFilesOutlineManager.selectedAudio.subscribe({ [weak self](newValue) in
            self?.handleSelected(newValue, initPhase: false)
        }, observer: self)
    }
    
    private func handleSelected(_ selectedItemId: String?, initPhase: Bool) {
        
        guard let audioFileManager = self.audioFileManager else {
            assertionFailure("Error: self.audioFileManager is nil")
            return
        }
        
        if let selectedItemId = selectedItemId {
            if selectedItemId == audioFileManager.id {

                self.titleView.selected = true
                self.name.selected = true
            }
            else {
                // no need to hide on init since by default we hide in initialize
                if !initPhase {
                    // self.hidePlaybackView()
                    self.titleView.selected = false
                    self.name.selected = false
                }
            }
        }
        else {
            self.hidePlaybackView()
            self.titleView.selected = false
            self.name.selected = false
        }
    }
    
    private func unsubscribeToAudioFilesOutlineManager() {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        audioFilesOutlineManager.selectedAudio.unsubscribe(observer: self)
    }

    private func nextAudioOutlineItemManager() -> AudioOutlineItem? {
        
        guard let indexInParent = self.audioFileManager?.indexInParent else {
            assertionFailure("Error: self.audioFileManager.indexInParent is nil")
            return nil
        }
        
        guard let parent = self.audioFileManager?.parent else {
            assertionFailure("Error: self.audioFileManager?.parent is nil")
            return nil
        }
        
        // we are not the last
        if indexInParent < parent.audioFilesCount-1 {
            
            let nextItemIndex = indexInParent+1
            let nextItemId = parent.audioFileManagers.values[nextItemIndex]
            
            guard let audioFilesManager = self.audioFilesManager else {
                assertionFailure("Error: self.audioFilesManager is nil")
                return nil
            }
            
            return audioFilesManager.audioFilesSet.values[nextItemId]
        }
        return nil
    }
    
    /// Returns the audio outline item
    private func previousAudioOutlineItemManager() -> AudioOutlineItem? {
        
        guard let indexInParent = self.audioFileManager?.indexInParent else {
            assertionFailure("Error: self.audioFileManager.indexInParent is nil")
            return nil
        }
        
        guard let parent = self.audioFileManager?.parent else {
            assertionFailure("Error: self.audioFileManager?.parent is nil")
            return nil
        }
        
        if indexInParent == 0 {
            return parent
        }
        else {
            
            let previousItemIndex = indexInParent-1
            let previousItemId = parent.audioFileManagers.values[previousItemIndex]
            
            guard let audioFilesManager = self.audioFilesManager else {
                assertionFailure("Error: self.audioFilesManager is nil")
                return nil
            }
            
            return audioFilesManager.audioFilesSet.values[previousItemId]
        }
    }
    
    deinit {
        unsubscribeToAudioFileManager()
        unsubscribeToAudioFilesOutlineManager()
        NotificationCenter.default.removeObserver(self)
    }
    
}
