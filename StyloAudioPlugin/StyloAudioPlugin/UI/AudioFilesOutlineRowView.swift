//
//  AudioFilesOutlineRowView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common

final class AudioFilesOutlineRowView: NSTableRowView {
    
    var audioOutlineItem: AudioOutlineItem?
    
    var audioFilesManager: AudioFilesManager? {
        willSet {
            if self.audioFilesManager != nil {
                unsubscribeToAudioFileManagerIfNecessary()
                unsubscribeToAudioFilesOutlineManager()
            }
        }
        didSet {
            subscribeToAudioFilesOutlineManager()
            subscribeToAudioFileManagerIfNecessary()
        }
    }
    
    var selectionView: NSVisualEffectView? {
        didSet {
            self.selectionView?.blendingMode = .behindWindow
            self.selectionView?.isEmphasized = false
        }
    }
    
    private var audioFilesOutlineManager: AudioFilesOutlineManager? {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return nil
        }
        
        return audioFilesManager.audioFilesOutlineManager
    }
    
    private var isActive: Bool = false {
        didSet {
            updateSelectionConfiguration()
        }
    }
    
    private var isPartOfSelection: Bool = false {
        didSet {
            updateSelectionConfiguration()
        }
    }
    
    private var activeAudioMaterial: NSVisualEffectView.Material {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            return .selection
        case .aqua?:
            return .selection
        default:
            assert(false)
            return .dark
        }
    }
    
    private var selectedGroupMaterial: NSVisualEffectView.Material {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            return .selection
        case .aqua?:
            return .selection
        default:
            assert(false)
            return .selection
        }
    }
    
    private var selectedAudioMaterial: NSVisualEffectView.Material {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            return .dark
        case .aqua?:
            return .mediumLight
        default:
            assert(false)
            return .underWindowBackground
        }
    }
    
    private var unselectedAudioMaterial: NSVisualEffectView.Material {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            return .underWindowBackground
        case .aqua?:
            return .underWindowBackground
        default:
            assert(false)
            return .underWindowBackground
        }
    }
    
    private var unselectedGroupMaterial: NSVisualEffectView.Material {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            return .underWindowBackground
        case .aqua?:
            return .underWindowBackground
        default:
            assert(false)
            return .underWindowBackground
        }
    }
    
    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        updateSelectionConfiguration()
    }

    private func updateSelectionConfiguration() {
        
        if let audioOutlineItem = self.audioOutlineItem {
            
            if audioOutlineItem.isGroup && self.isPartOfSelection {
                self.selectionView?.material = selectedGroupMaterial
            }
            else if isActive && self.isPartOfSelection {
                self.selectionView?.material = activeAudioMaterial
            }
            else if !audioOutlineItem.isGroup && self.isPartOfSelection {
                self.selectionView?.material = selectedAudioMaterial
            }
            else if audioOutlineItem.isGroup {
                self.selectionView?.material = unselectedGroupMaterial
            }
            else {
                self.selectionView?.material = unselectedAudioMaterial
            }
        }
        else {
            self.selectionView?.material = unselectedAudioMaterial
        }
    }
    
    override func drawSeparator(in dirtyRect: NSRect) {
        
    }
    
    override func drawDraggingDestinationFeedback(in dirtyRect: NSRect) {
        
        fatalError("missing implementation")
    }
    
    override func didAddSubview(_ subview: NSView) {
        super.didAddSubview(subview)
        
        if subview.className == "NSBannerView" {
            subview.isHidden = true
        }
    }
    
    private func subscribeToAudioFileManagerIfNecessary() {
        
        guard let audioOutlineItem = self.audioOutlineItem else {
            assertionFailure("Error: self.audioOutlineItem is nil")
            return
        }
        
        guard let audioFileManager = audioOutlineItem as? AudioFileManager else {
            return
        }
        
        audioFileManager.audioState.subscribe({ (audioState) in
            
//            switch audioState {
//            case .readyToRecord(_): fallthrough
//            case .empty: fallthrough
//            case .inactive:
//                self.isActive = false
//            case preparedToPlay(_): fallthrough
//            case .playing: fallthrough
//            case .pausePlaying: fallthrough
//            case .recording:
//                self.isActive = true
//            }
        }, observer: self)
        
    }
    
    private func unsubscribeToAudioFileManagerIfNecessary() {
        
        guard let audioOutlineItem = self.audioOutlineItem else {
            assertionFailure("Error: self.audioOutlineItem is nil")
            return
        }
        
        guard let audioFileManager = audioOutlineItem as? AudioFileManager else {
            return
        }
        
        audioFileManager.audioState.unsubscribe(observer: self)
    }
    
    private func subscribeToAudioFilesOutlineManager() {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        guard let audioOutlineItem = self.audioOutlineItem else {
            assertionFailure("Error: self.audioOutlineItem is nil")
            return
        }
        
        switch audioOutlineItem {
            
        case _ as AudioFileManager:
            
            handleAudioFileSelected(selectedItemId: audioFilesOutlineManager.selectedAudio.value)
            handleDocumentAudioSelected(selectedItemId: audioFilesOutlineManager.selectedDocument.value)
            
            audioFilesOutlineManager.selectedAudio.subscribe({ [weak self](newValue) in
                self?.handleAudioFileSelected(selectedItemId: newValue)
            }, observer: self)
            
            audioFilesOutlineManager.selectedDocument.subscribe({ [weak self](newValue) in
                self?.handleDocumentAudioSelected(selectedItemId: newValue)
            }, observer: self)
            
        case _ as DocumentAudioFilesManager:
            
            handleDocumentAudioSelected(selectedItemId: audioFilesOutlineManager.selectedDocument.value)
            audioFilesOutlineManager.selectedDocument.subscribe({ [weak self](newValue) in
                self?.handleDocumentAudioSelected(selectedItemId: newValue)
            }, observer: self)
            
        default:
            assertionFailure("Error: unsupported type: \(type(of: audioOutlineItem))")
            break
        }
    }
 
    func handleAudioFileSelected(selectedItemId: String?) {
        
        guard let audioOutlineItem = self.audioOutlineItem else {
            assertionFailure("Error: self.audioOutlineItem is nil")
            return
        }
        
        guard let selectedItemId = selectedItemId else {
            self.isActive = false
            return
        }
        
        switch audioOutlineItem {
        case let audioFileManager as AudioFileManager:
            
            if selectedItemId == audioFileManager.id {
                if !self.isActive {
                    self.isActive = true
                }
            }
            else {
                if self.isActive {
                    self.isActive = false
                }
            }
            
        default:
            assertionFailure("Error: unsupported type: \(type(of: audioOutlineItem))")
            break
        }
    }
    
    func handleDocumentAudioSelected(selectedItemId: String?) {
        
        guard let audioOutlineItem = self.audioOutlineItem else {
            assertionFailure("Error: self.audioOutlineItem is nil")
            return
        }

        guard let selectedItemId = selectedItemId else {
            if self.isPartOfSelection {
                self.isPartOfSelection = false
            }
            return
        }
        
        switch audioOutlineItem {
        case let audioFileManager as AudioFileManager:
        
            if selectedItemId == audioFileManager.parentId {
                if !self.isPartOfSelection {
                    self.isPartOfSelection = true
                }
            }
            else {
                if self.isPartOfSelection {
                    self.isPartOfSelection = false
                }
            }
        
        case _ as DocumentAudioFilesManager:
            
            if selectedItemId == audioOutlineItem.id {
                if !self.isPartOfSelection {
                    self.isPartOfSelection = true
                }
            }
            else {
                if self.isPartOfSelection {
                    self.isPartOfSelection = false
                }
            }
        default:
            assertionFailure("Error: unsupported type: \(type(of: audioOutlineItem))")
            break
        }
    }
    
    override func addSubview(_ view: NSView, positioned place: NSWindow.OrderingMode, relativeTo otherView: NSView?) {
        
        if !(view is NSVisualEffectView) {
            super.addSubview(view, positioned: place, relativeTo: otherView)
        }
//        else {
//            if self.selectionView.superview == nil {
//                super.addSubview(self.selectionView, positioned: place, relativeTo: otherView)
//                self.selectionView.frame = self.bounds
//            }
//        }
    }
    
    private func unsubscribeToAudioFilesOutlineManager() {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        guard let audioOutlineItem = self.audioOutlineItem else {
            assertionFailure("Error: self.audioOutlineItem is nil")
            return
        }
        
        switch audioOutlineItem {
        case _ as AudioFileManager:
            audioFilesOutlineManager.selectedAudio.unsubscribe(observer: self)
        case _ as DocumentAudioFilesManager:
            audioFilesOutlineManager.selectedDocument.unsubscribe(observer: self)
        default:
            assertionFailure("Error: unsupported type: \(type(of: audioOutlineItem))")
            break
        }
    }
    
    deinit {
        unsubscribeToAudioFileManagerIfNecessary()
        unsubscribeToAudioFilesOutlineManager()
    }
}
