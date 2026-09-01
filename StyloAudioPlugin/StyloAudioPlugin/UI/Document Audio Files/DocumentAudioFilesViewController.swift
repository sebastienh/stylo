//
//  DocumentAudioFilesViewController.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-11-01.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import StyloCoreMac

class DocumentAudioFilesViewController: NSViewController {
    
    @IBOutlet var lowerSeparatorView: NSView!
    
    @IBOutlet var documentAudioFilesView: DocumentAudioFilesView! {
        didSet {
            documentAudioFilesView.delegate = self
            documentAudioFilesView.createTrackingArea()
        }
    }
    
    @IBOutlet var textField: NSTextField!
    
    @IBOutlet var showHideButton: NSButton? {
        didSet {
            hideRightButtonsIfNecessary()
        }
    }
    
    @IBOutlet var recordButton: EditorRecordButton? {
        didSet {
            let pluginBundle = Bundle(for: type(of: self))
            guard let recordButtonImage = pluginBundle.image(forResource: NSImage.Name("record-button-editor-title")) else {
                assertionFailure("Error: unable to get image named: record-button-editor-title")
                return
            }
            self.recordButton?.image = recordButtonImage
            hideRightButtonsIfNecessary()
        }
    }
    
    @objc dynamic var selected: Bool = false {
        didSet {
            if selected {
                showRightButtons()
                self.lowerSeparatorView.isHidden = true
            }
            else {
                // never hide a plusating button
                if let recordButton = recordButton, !recordButton.pulsating {
                    hideRightButtonsIfNecessary()
                }
                self.lowerSeparatorView.isHidden = false
            }
        }
    }
    
    @objc dynamic var isExpanded: Bool = false {
        didSet {
            guard let documentAudioFilesManager = self.documentAudioFilesManager else {
                assertionFailure("Error: self.documentAudioFilesManager is nil")
                return
            }
            
            if documentAudioFilesManager.isEmpty {
                showHideButton?.title = "Show"
                showHideButton?.isEnabled = false
            }
            else {
                showHideButton?.title = isExpanded ? "Hide" : "Show"
            }
        }
    }
    
    weak var audioToolsViewController: AudioToolsViewController?
    
    private var audioFilesManager: AudioFilesManager? {
        
        guard let documentAudioFilesManager = self.documentAudioFilesManager else {
            assertionFailure("Error: self.documentAudioFilesManager is nil")
            return nil
        }
        
        return documentAudioFilesManager.audioFilesManager
    }
    
    var documentAudioFilesManager: DocumentAudioFilesManager? {

        guard let representedObject = self.representedObject else {
            return nil
        }
        
        guard let documentAudioFilesManager = representedObject as? DocumentAudioFilesManager else {
            assertionFailure("Error: representedObject is not DocumentAudioFilesManager")
            return nil
        }
        
        return documentAudioFilesManager
    }
    
    override var representedObject: Any? {

        didSet {
            updateTitleName()
            subscribeToContentManager()
            subscribeToAudioFilesOutlineManager()
        }
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
    
    private var upperView: NSTableCellView? {
        if let row = self.row {
            return self.audioOutlineView?.view(atColumn: 0, row: row-1, makeIfNecessary: true) as? NSTableCellView
        }
        return nil
    }
    
    private var row: Int? {
        
        return self.audioOutlineView?.row(forItem: documentAudioFilesManager)
    }
    
    private var audioFilesOutlineManager: AudioFilesOutlineManager? {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return nil
        }
        
        return audioFilesManager.audioFilesOutlineManager
    }
    
    private var contentManagerId: String? {
        
        guard let documentAudioFilesManager = self.documentAudioFilesManager else {
            assertionFailure("Error: self.documentAudioFilesManager is nil")
            return nil
        }
        
        return documentAudioFilesManager.associatedDocumentId
    }
    
    private var documentManager: DocumentManagerProtocol? {
        
        return audioFilesManager?.documentManager
    }
    
    private var sourceSetManager: SourceSetManagerProtocol? {
        
        return documentManager?.sourceSetManager
    }
    
    private var isRecording: Bool {
        
        guard let documentAudioFilesManager = self.documentAudioFilesManager else {
            assertionFailure("Error: self.documentAudioFilesManager is nil")
            return false
        }
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return false
        }
        
        guard let recordingAudioFile = audioFilesManager.recordingAudioFile.value else {
            return false
        }
        
        for audioFileManagerId in documentAudioFilesManager.audioFileManagers.values {
            if audioFileManagerId == recordingAudioFile.id {
                return true
            }
        }
        return false
    }
    
    private var contentManager: ContentManager? {
        
        guard let contentManagerId = self.contentManagerId else {
            assertionFailure("Error: self.contentManagerId is nil")
            return nil
        }
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        guard let editableManager = sourceSetManager.contentManager(withId: contentManagerId) else {
            assertionFailure("Error: contentManager for id:\(contentManagerId) is nil")
            return nil
        }
        
        return editableManager
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        if isRecording {
            self.recordButton?.startPulsating()
        }
        else {
            self.recordButton?.stopPulsating()
        }
    }
    
    @IBAction func startNewDocumentRecording(_ sender: NSButton) {
        
        guard let documentAudioFilesManager = self.documentAudioFilesManager else {
            assertionFailure("Error: self.documentAudioFilesManager is nil")
            return
        }
        
        guard let audioToolsViewController = self.audioToolsViewController else {
            assertionFailure("Error: self.audioToolsViewController is nil")
            return
        }
        
        assert(self.audioFilesManager?.audioPluginManager != nil)
        self.audioFilesManager?.audioPluginManager.notifyContentManager = true
        audioToolsViewController.startNewRecording(documentAudioFilesManager: documentAudioFilesManager)
    }
    
    @IBAction func showHideItem(_ sender: Any?) {
        
        guard let documentAudioFilesManager = self.documentAudioFilesManager else {
            assertionFailure("Error: self.documentAudioFilesManager is nil")
            return
        }
        
        guard let audioToolsViewController = self.audioToolsViewController else {
            assertionFailure("Error: self.audioToolsViewController is nil")
            return
        }
        
        if self.isExpanded {
            audioToolsViewController.collapseItem(documentAudioFilesManager)
        }
        else {
            audioToolsViewController.expandItem(documentAudioFilesManager)
        }
    }
    
    private func updateTitleName() {
        
        guard let contentManager = self.contentManager else {
            assertionFailure("Error: self.contentManager is nil")
            return
        }
        
        guard let textField = self.textField else {
            assertionFailure("Error: self.textField is nil")
            return
        }
        
        textField.stringValue = contentManager.contentName.value
    }
    
    private func subscribeToContentManager() {
        
        guard let contentManager = self.contentManager else {
            assertionFailure("Error: self.contentManager is nil")
            return
        }
        
        contentManager.contentName.subscribe({ [weak self](newName) in
            
            guard let textField = self?.textField else {
                assertionFailure("Error: self.textField is nil")
                return
            }
            
            if newName != textField.stringValue {
                self?.updateTitleName()
            }
        }, observer: self)
    }
    
    private func unsubscribeToContentManager() {
        
        if self.documentAudioFilesManager?.id != nil {
            if let contentManager = self.contentManager {
                contentManager.contentName.unsubscribe(observer: self)
            }
        }
    }
    
    private func subscribeToAudioFilesOutlineManager() {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        self.handleSelected(audioFilesOutlineManager.selectedDocument.value)
        audioFilesOutlineManager.selectedDocument.subscribe({ [weak self](newValue) in
            self?.handleSelected(newValue)
        }, observer: self)
        
        guard let documentAudioFilesManager = self.documentAudioFilesManager else {
            assertionFailure("Error: self.documentAudioFilesManager is nil")
            return
        }
        
        self.handleAudioFilesManagerChange(documentAudioFilesManager.audioFileManagers.values)
        documentAudioFilesManager.audioFileManagers.subscribe({ [weak self](change) in
            if let updatedArray = change.updatedArray {
                self?.handleAudioFilesManagerChange(updatedArray)
            }
        }, observer: self)
        
        //        self.handleSelectedFilesFilterActive(audioFilesOutlineManager.selectedFilesFilterActive.value)
        //        audioFilesOutlineManager.selectedFilesFilterActive.subscribe({ [weak self](newSelectedFilesFilterActiveValue) in
        //            self?.handleSelectedFilesFilterActive(newSelectedFilesFilterActiveValue)
        //        }, observer: self)
    }
    
    private func handleAudioFilesManagerChange(_ updatedArray: [String]) {
        
        if updatedArray.isEmpty {
            showHideButton?.title = "Show"
            showHideButton?.isEnabled = false
        }
        else {
            showHideButton?.isEnabled = true
            showHideButton?.title = isExpanded ? "Hide" : "Show"
        }
    }
    
    
    //    private func handleSelectedFilesFilterActive(_ selectedFilesFilterActive: Bool) {
    //
    //        audioFilesOutlineManager?.selectedFilesFilterActive
    //
    //    }
    //
    private func handleSelected(_ selectedItemId: String?) {
        
        guard let documentAudioFilesManagerId = self.documentAudioFilesManager?.id else {
            assertionFailure("Error: self.documentAudioFilesManagerId is nil")
            return
        }
        
        if let selectedItemId = selectedItemId, selectedItemId == documentAudioFilesManagerId {
            self.selected = true
        }
        else {
            self.selected = false
        }
    }
    
    
    private func unsubscribeToAudioFilesOutlineManager() {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        audioFilesOutlineManager.selectedDocument.unsubscribe(observer: self)
    }
    
    func updateDisplayUpperSeparatorView() {
        
        if let row = self.row {
            
            if row == 0 {
                self.lowerSeparatorView.isHidden = true
                return
            }
            
            guard let upperView = self.upperView else {
                // we are the last view, we draw the separator
                self.lowerSeparatorView.isHidden = true
                return
            }
            
            if !(upperView is DocumentTitleCellView) {
                self.lowerSeparatorView.isHidden = true
            }
            else {
                self.lowerSeparatorView.isHidden = true
            }
        }
        else {
            self.lowerSeparatorView.isHidden = true
        }
    }
    
    deinit {
        unsubscribeToContentManager()
        unsubscribeToAudioFilesOutlineManager()
    }
}
