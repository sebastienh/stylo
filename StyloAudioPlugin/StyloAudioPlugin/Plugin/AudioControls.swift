//
//  TextEditorControls.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-11-08.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa
import WriterCommon

class AudioControls: NSStackView, TextEditorControl {
    
    var maxWidth: CGFloat {
        return 180.0
    }
    
    public enum State {
        case idle
        case recording
        case playing
        case paused
    }
    
//    var canHide: Bool = true 
    
    var controlsState: State = .idle {
        
        didSet {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
            os_log("Going from: %@ to %@", log: Log.Audio.all, type: .info, %%oldValue, %%self.controlsState)
            #endif
            
            switch self.controlsState {
            case .idle:
                
                switch oldValue {
                case .idle:
                    break
                case .playing:
                    self.removeView(timer)
                    self.removeView(playPauseButton)
                    self.insertArrangedSubview(recordButton, at: 0)
                    
                case .recording:
                    recordButton.stopPulsating()
                    self.removeView(timer)
                    self.removeView(stopButton)
                case .paused:
                    self.removeView(timer)
                    self.removeView(playPauseButton)
                    self.insertArrangedSubview(recordButton, at: 0)
                }
                assert(self.arrangedSubviews.count == 1)
                
            case .recording:
                
                switch oldValue {
                case .idle:
                    self.insertArrangedSubview(stopButton, at: 1)
                    self.insertArrangedSubview(timer, at: 2)
                case .playing:
                    self.removeView(playPauseButton)
                    self.insertArrangedSubview(stopButton, at: 1)
                case .recording:
                    break
                case .paused:
                    self.removeView(playPauseButton)
                    self.insertArrangedSubview(stopButton, at: 1)
                }
                recordButton.startPulsating()
                assert(self.arrangedSubviews.count == 3)
                
            case .playing:
                
                switch oldValue {
                case .idle:
                    self.insertArrangedSubview(playPauseButton, at: 1)
                    self.insertArrangedSubview(timer, at: 2)
                case .recording:
                    recordButton.stopPulsating()
                    self.removeView(stopButton)
                    self.insertArrangedSubview(playPauseButton, at: 1)
                case .playing:
                    break
                case .paused:
                    break
                }
                playPauseButton.state = .on
                assert(self.arrangedSubviews.count == 3)
                
            case .paused:
                
                switch oldValue {
                case .idle:
                    self.insertArrangedSubview(playPauseButton, at: 1)
                    self.insertArrangedSubview(timer, at: 2)
                case .recording:
                    recordButton.stopPulsating()
                    self.removeView(stopButton)
                    self.insertArrangedSubview(playPauseButton, at: 1)
                case .playing:
                    break
                case .paused:
                    break
                }
                playPauseButton.state = .off
                assert(self.arrangedSubviews.count == 3)
            }
        }
    }
    
    let recordButton: EditorRecordButton
    
    let playPauseButton: EditorPlayPauseButton
    
    let stopButton: EditorStopButton
    
    let timer: TimerField
    
    
    static func create(forDocumentAudioFilesId documentAudioFilesId: String, audioPlugin: StyloAudioPlugin) -> AudioControls? {
        
        guard let editorRecordButton = AudioControls.editorRecordButton(forDocumentAudioFilesId: documentAudioFilesId, audioPlugin: audioPlugin) else {
            assertionFailure("Error: recordButton is nil")
            return nil
        }
        
        guard let editorPlayPauseButton = AudioControls.editorPlayPauseButton(audioPlugin: audioPlugin) else {
            assertionFailure("Error: editorPlayPauseButton is nil")
            return nil
        }
        
        guard let editorStopButton = AudioControls.editorStopButton(audioPlugin: audioPlugin) else {
            assertionFailure("Error: editorStopButton is nil")
            return nil
        }
        
        let timer = TimerField(frame: .zero)
        timer.isEditable = false
        timer.focusRingType = .none
        return AudioControls(recordButton: editorRecordButton, timer: timer, frame: .zero, playPauseButton: editorPlayPauseButton, stopButton: editorStopButton)
    }
    
    private init(recordButton: EditorRecordButton, timer: TimerField, frame: NSRect, playPauseButton: EditorPlayPauseButton, stopButton: EditorStopButton) {
        
        self.recordButton = recordButton
        self.playPauseButton = playPauseButton
        self.stopButton = stopButton
        self.timer = timer
        self.timer.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.timer.translatesAutoresizingMaskIntoConstraints = false
        self.timer.backgroundColor = NSColor.clear
        self.timer.drawsBackground = true
        self.timer.isBordered = false
        self.timer.isBezeled = false
        super.init(frame: frame)
        self.addArrangedSubview(recordButton)
        self.addArrangedSubview(self.timer)
        self.orientation = .horizontal
        self.distribution = .fill
        self.alignment = .centerY
        self.spacing = 8.0
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("Unhandled initializer")
    }

    func updateState(fromAudioFile audioFile: AudioFileManager?) {
    
        if let audioFile = audioFile {
            switch audioFile.audioState.value {
            case .playing:
                self.updateAudioTimer(durationString: audioFile.completePlayTimeString.value)
                self.controlsState = .playing
            case .readyToPlay(_):
                self.updateAudioTimer(durationString: audioFile.completePlayTimeString.value)
                self.controlsState = .paused
            case .pausePlaying:
                self.updateAudioTimer(durationString: audioFile.completePlayTimeString.value)
                self.controlsState = .paused
            case .inactive:
//                self.controlsState = .idle
                break
            case .recording:
                self.updateAudioTimer(durationString: audioFile.recordTimeString.value)
                if self.controlsState != .recording {
                    self.controlsState = .recording
                }
            case .readyToRecord(_):
//                self.controlsState = .idle
                break
            case .empty:
//                self.controlsState = .idle
                break
            }
        }
        else {
            self.controlsState = .idle
        }
    }
    
    private static func editorRecordButton(forDocumentAudioFilesId documentAudioFilesId: String, audioPlugin: StyloAudioPlugin) -> EditorRecordButton? {
        
        let editorRecordButton = EditorRecordButton(documentAudioFilesId: documentAudioFilesId)
        
        let pluginBundle = Bundle(for: type(of: editorRecordButton))
        
        guard let recordButtonImage = pluginBundle.image(forResource: NSImage.Name("record-button-editor-title")) else {
            assertionFailure("Error: unable to get image named: record-button-editor-title")
            return nil
        }
        
        editorRecordButton.image = recordButtonImage
        editorRecordButton.target = audioPlugin
        editorRecordButton.action = #selector(StyloAudioPlugin.startRecording(_:))
        editorRecordButton.bezelStyle = .regularSquare
        editorRecordButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        editorRecordButton.widthAnchor.constraint(equalToConstant: 12).isActive = true
        editorRecordButton.isBordered = false
        editorRecordButton.identifier = NSUserInterfaceItemIdentifier(rawValue: documentAudioFilesId)
        editorRecordButton.setButtonType(NSButton.ButtonType.momentaryLight)
        editorRecordButton.isEnabled = true
        editorRecordButton.state = .off
        editorRecordButton.toolTip = "Record/Add Recording"
        return editorRecordButton
    }
    
    private static func editorStopButton(audioPlugin: StyloAudioPlugin) -> EditorStopButton? {
        
        let stopButton = EditorStopButton()
        let pluginBundle = Bundle(for: type(of: stopButton))
        
        guard let playButtonImage = pluginBundle.image(forResource: NSImage.Name("stop-editor")) else {
            assertionFailure("Error: unable to get image named: stop-editor")
            return nil
        }
        
        stopButton.image = playButtonImage
        stopButton.target = audioPlugin
        stopButton.action = #selector(StyloAudioPlugin.stopRecording(_:))
        stopButton.bezelStyle = .regularSquare
        stopButton.isBordered = false
        stopButton.setButtonType(NSButton.ButtonType.momentaryLight)
        stopButton.isEnabled = true
        stopButton.state = .off
        stopButton.toolTip = "Stop"
        return stopButton
    }
    
    private static func editorPlayPauseButton(audioPlugin: StyloAudioPlugin) -> EditorPlayPauseButton? {
        
        let playPauseButton = EditorPlayPauseButton()
        
        let pluginBundle = Bundle(for: type(of: playPauseButton))
        
        guard let playButtonImage = pluginBundle.image(forResource: NSImage.Name("play-editor")) else {
            assertionFailure("Error: unable to get image named: play-editor")
            return nil
        }
        
        guard let pauseButtonImage = pluginBundle.image(forResource: NSImage.Name("pause-editor")) else {
            assertionFailure("Error: unable to get image named: pause-editor")
            return nil
        }
        
        playPauseButton.image = playButtonImage
        playPauseButton.alternateImage = pauseButtonImage
        playPauseButton.target = audioPlugin
        playPauseButton.action = #selector(StyloAudioPlugin.playPause(_:))
        playPauseButton.bezelStyle = .regularSquare
        playPauseButton.isBordered = false
        playPauseButton.setButtonType(NSButton.ButtonType.toggle)
        playPauseButton.isEnabled = true
        playPauseButton.state = .off
        playPauseButton.toolTip = "Play/Pause"
        return playPauseButton
    }
    
    func updateAudioTimer(durationString: String) {
        
        self.timer.attributedStringValue = self.attributedDuration(fromDuration: durationString)
        self.timer.invalidateIntrinsicContentSize()
    }
 
    private func attributedDuration(fromDuration duration: String) -> NSAttributedString {
        
        guard let font = NSFont(name: "Roboto Mono Light", size: 11) else {
            assertionFailure("Error: nil font")
            return NSAttributedString(string: duration)
        }
        
        return NSMutableAttributedString(string: duration, attributes: [NSAttributedString.Key.font : font])
    }
}
