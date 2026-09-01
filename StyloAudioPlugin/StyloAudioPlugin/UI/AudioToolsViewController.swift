//
//  AudioToolsViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import AVFoundation
import Common
import os

class AudioToolsViewController: NSViewController {
    
    @IBOutlet var audioOutlineView: AudioOutlineView? {
        didSet {
            assert(audioOutlineView != nil)
            audioOutlineView?.intercellSpacing = .zero
            audioOutlineView?.gridStyleMask = []
            audioOutlineView?.gridColor = NSColor.clear
        }
    }
    
    @IBOutlet var panelTitleView: NSVisualEffectView! 
    
    @IBOutlet var selectedFilesFilterActiveButton: NSButton?
    
    @IBOutlet var stopRecordingButton: NSButton?
    
    
    /// Audio file
    var audioFileViewControllers: [String: AudioFileViewController] = [:]
    
    private var audioFileOutlineCellViews: [String: AudioFileCellView] = [:]
    
    /// Document Audio Files
    var documentAudioFilesViewControllers: [String: DocumentAudioFilesViewController] = [:]
    
    private var titleOutlineCellViews: [String: DocumentTitleCellView] = [:]
    
    private var recordingAudioFileManager: AudioFileManager?
    
    @objc dynamic var currentlyRecording: Bool = false

    var selectedFilesFilterActive: Bool = true
    
    var selectedDocumentAudioFilesManager: DocumentAudioFilesManager? {
        
        guard audioOutlineView?.selectedRow != -1 else {
            assertionFailure("Error: button should not be enabled when there is no selection")
            return nil
        }
        
        guard let audioOutlineView = self.audioOutlineView else {
            assertionFailure("Error: self.audioOutlineView is nil")
            return nil
        }
        
        guard let selectedAudioOutlineItem = audioOutlineView.item(atRow: audioOutlineView.selectedRow) else {
            assertionFailure("Error: item at selected row: \(audioOutlineView.selectedRow) is nil")
            return nil
        }
        
        let _documentAudioFilesManager: DocumentAudioFilesManager? = {
            switch selectedAudioOutlineItem {
            case let documentAudioFilesManager as DocumentAudioFilesManager:
                return documentAudioFilesManager
            case let audioFileManager as AudioFileManager:
                guard let audioFilesManager = self.audioFilesManager else {
                    assertionFailure("Error: self.audioFilesManager is nil.")
                    return nil
                }
                return audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: audioFileManager.parentId)
            default:
                assertionFailure("Error: unsupported item type: \(type(of: selectedAudioOutlineItem))")
                return nil
            }
        }()
        
        return _documentAudioFilesManager
    }
    
    var audioFilesManager: AudioFilesManager? {
        
        guard let representedObject = self.representedObject else {
            assertionFailure("Error: representedObject is nil")
            return nil
        }
        
        guard let audioFilesManager = representedObject as? AudioFilesManager else {
            assertionFailure("Error: representedObject is not a AudioFilesManager")
            return nil
        }
        
        return audioFilesManager
    }
    
    var audioFilesOutlineManager: AudioFilesOutlineManager? {
        
        return audioFilesManager?.audioFilesOutlineManager
    }
    
    override func viewDidLoad() {
        assert(self.representedObject != nil)
        subscribeToAudioFilesManager()
        subscribeToAudioFilesOutlineManager()
        restoreOutlineState()
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        restoreOutlineState()
    }
    
    @IBAction func updateSelectedFilesFilterState(_ sender: NSButton) {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        switch sender.state {
        case .on:
            audioFilesOutlineManager.updateSelectedFilesFilterState(to: true)
        case .off:
            audioFilesOutlineManager.updateSelectedFilesFilterState(to: false)
        default:
            assertionFailure("Error: unsupported state: \(sender.state)")
            break
        }
    }
    
    @IBAction func stopCurrentRecording(_ sender: NSButton) {
        
        do {
            
            guard let audioFilesManager = self.audioFilesManager else {
                assertionFailure("Error: self.audioFilesManager is nil.")
                return
            }
            
            try audioFilesManager.stopCurrentRecording(setAsPlaying: true)
        }
        catch let error {
            assertionFailure("Error: exception while stoping recording: \(error)")
        }
    }
    
    @IBAction func startNewRecording(_ sender: NSButton) {
        
        guard let documentAudioFilesManager = self.selectedDocumentAudioFilesManager else {
            assertionFailure("Error: _documentAudioFilesManager is nil")
            return
        }
        
        startNewRecording(documentAudioFilesManager: documentAudioFilesManager)
    }
    
    var shouldNotifyExpandedItem = true
    
    var shouldNotifySelectedItem = true
    
    private func restoreOutlineState() {
        
        restoreExpandedItems()
        restoreSelectedItems()
    }
    
    private func restoreExpandedItems() {
        
        shouldNotifyExpandedItem = false
        
        defer {
            shouldNotifyExpandedItem = true
        }
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        
        for expandedItemId in audioFilesOutlineManager.expandedItems.values {
            
            // This special handling considers the case an expanded item set by an application
            // with the audio plugin installed have set this value, and the file has later been
            // modified by an application without the same audio plugin installed that removed
            // this particular file.
            if let documentAudioFilesManager = audioFilesManager.documentAudioFilesSet.values[expandedItemId] {
                self.expandItem(documentAudioFilesManager)
            }
        }
    }
    
    private func restoreSelectedItems() {
        
        shouldNotifySelectedItem = false
        
        defer {
            shouldNotifySelectedItem = true
        }
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        guard let selectedItem = audioFilesOutlineManager.selectedItem.value else {
            // no selection to restore
            return
        }
        
        if let audioFileManager = audioFilesManager.audioFilesSet.values[selectedItem] {
            self.selectItem(audioFileManager)
        }
        else if let documentAudioFileManager = audioFilesManager.documentAudioFilesSet.values[selectedItem] {
            self.selectItem(documentAudioFileManager)
        }
    }
    
    func view(for audioOutlineItem: AudioOutlineItem) -> NSView? {
        
        switch audioOutlineItem.type {
        case .title:
            return titleView(for: audioOutlineItem)
        case .file:
            return audioFileView(for: audioOutlineItem)
        }
    }
    
    
    private var stopRecordingButtonWasEnabled: Bool = false
    
    func disableUserInteractions() {
        
        self.stopRecordingButtonWasEnabled = self.stopRecordingButton?.isEnabled ?? false
        self.stopRecordingButton?.isEnabled = false
        
        // the state is what makes it highlight or not
        // so we can change the enable value independantly
        self.selectedFilesFilterActiveButton?.isEnabled = false
        self.audioOutlineView?.isEnabled = false
    }
    
    func enableUserInteractions() {
        
        if stopRecordingButtonWasEnabled {
            self.stopRecordingButton?.isEnabled = true
        }
        
        // the state is what makes it highlight or not
        // so we can change the enable value independantly
        selectedFilesFilterActiveButton?.isEnabled = true
        self.audioOutlineView?.isEnabled = true
    }
    
    func audioFileView(for audioOutlineItem: AudioOutlineItem) -> NSView? {
        
        assert(audioOutlineItem.type == .file)
        if let audioFileOutlineCellView = self.audioFileOutlineCellViews[audioOutlineItem.id] {
            return audioFileOutlineCellView
        }
        
        guard let (audioFileOutlineCellView, audioFileViewController) = createAudioFileOutlineCellView(with: audioOutlineItem) else {
            assertionFailure("Error: createAudioFileOutlineCellView returned nil")
            return nil
        }
        
        self.audioFileViewControllers[audioOutlineItem.id] = audioFileViewController
        self.audioFileOutlineCellViews[audioOutlineItem.id] = audioFileOutlineCellView
        return audioFileOutlineCellView
    }
    
    func audioFileViewController(for row: Int) -> AudioFileViewController? {
        
        var topIndex = 0
        var globalIndex = 0
        
        while globalIndex <= row {
            
            let audioOutlineItem = self.audioOutlineItem(child: topIndex, ofItem: nil)
            
            guard let documentAudioFilesManager = audioOutlineItem as? DocumentAudioFilesManager else {
                assertionFailure("Error: audioOutlineItem is not DocumentAudioFilesManager")
                return nil
            }
            globalIndex += 1
            
            for childIndex in 0..<documentAudioFilesManager.numberOfChildren {
                
                let audioFileOutlineItem = self.audioOutlineItem(child: childIndex, ofItem: documentAudioFilesManager)
                
                guard let audioFileManager = audioFileOutlineItem as? AudioFileManager else {
                    assertionFailure("Error: audioFileOutlineItem is not AudioFileManager")
                    return nil
                }
                
                if globalIndex == row {
                    return self.audioFileViewControllers[audioFileManager.id]
                }
                globalIndex += 1
            }
            
            if globalIndex >= row {
                return nil
            }
            topIndex += 1
        }
        return nil
    }
    
    var needsRowItemsUpdate = true
    
    var rowItems: [AudioOutlineItem] = []
    
    private func computeRowItems() {
        
        rowItems.removeAll(keepingCapacity: true)
        
        let numberOfToItems = self.numberOfChildren(ofItem: nil)
        
        for topItemIndex in 0..<numberOfToItems {
        
            let audioOutlineItem = self.audioOutlineItem(child: topItemIndex, ofItem: nil)
            
            guard let documentAudioFilesManager = audioOutlineItem as? DocumentAudioFilesManager else {
                assertionFailure("Error: audioOutlineItem is not DocumentAudioFilesManager")
                return
            }
            
            rowItems.append(documentAudioFilesManager)
            
            for childIndex in 0..<documentAudioFilesManager.numberOfChildren {
                
                let audioFileOutlineItem = self.audioOutlineItem(child: childIndex, ofItem: documentAudioFilesManager)
                
                guard let audioFileManager = audioFileOutlineItem as? AudioFileManager else {
                    assertionFailure("Error: audioFileOutlineItem is not AudioFileManager")
                    return
                }
                
                rowItems.append(audioFileManager)
            }
        }
    }
    
    func numberOfChildren(ofItem item: Any?) -> Int {
    
        if item == nil {
            
            guard let audioFilesManager = self.audioFilesManager else {
                assertionFailure("Error: self.audioFilesManager is nil")
                return 0
            }
            
            if selectedFilesFilterActive {
                return audioFilesManager.selectedFilesOutlineSelectedTextItems.values.count
            }
            else {
                return audioFilesManager.documentAudioFilesCount
            }
        }
        
        guard let audioOutlineItem = item as? AudioOutlineItem else {
            assertionFailure("Error: item is not AudioOutlineItem")
            return 0
        }
        
        guard let documentAudioFilesManager = audioOutlineItem as? DocumentAudioFilesManager else {
            assertionFailure("Error: audioOutlineItem is not DocumentAudioFilesManager")
            return 0
        }
        
        return documentAudioFilesManager.audioFilesCount
    }
    
    func audioOutlineItem(child index: Int, ofItem item: Any?) -> AudioOutlineItem? {
        
        if item == nil {
            
            if self.selectedFilesFilterActive {
                
                guard let audioFilesManager = self.audioFilesManager else {
                    assertionFailure("Error: self.audioFilesManager is nil")
                    return nil
                }
                
                let values = audioFilesManager.selectedFilesOutlineSelectedTextItems.values
                
                assert(index < values.count)
                
                guard let documentAudioFilesManager = audioFilesManager.documentAudioFiles(forTextId: values[index]) else {
                    assertionFailure("Error: no document audio files for text id: \(values[index])")
                    return nil
                }
                return documentAudioFilesManager
            }
            else {
                
                guard let audioFilesManager = self.audioFilesManager else {
                    assertionFailure("Error: self.audioFilesManager is nil")
                    return nil
                }
                
                guard let documentAudioFilesManager = audioFilesManager.documentAudioFiles(at: index) else {
                    assertionFailure("Error: no document audio files at index: \(index)")
                    return nil
                }
                
                return documentAudioFilesManager
            }
        }
        
        guard let audioOutlineItem = item as? AudioOutlineItem else {
            assertionFailure("Error: item is not AudioOutlineItem")
            return nil
        }
        
        guard let documentAudioFilesManager = audioOutlineItem as? DocumentAudioFilesManager else {
            assertionFailure("Error: audioOutlineItem is not DocumentAudioFilesManager")
            return nil
        }
        
        guard let audioFileManager = documentAudioFilesManager.audioFileManager(atIndex: index) else {
            assertionFailure("Error: no audioFileManager at index: \(index)")
            return nil
        }
        
        return audioFileManager
    }
    
    /// https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/requesting_authorization_for_media_capture_on_macos?language=objc
    func startNewRecording(documentAudioFilesManager: DocumentAudioFilesManager) {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        audioFilesManager.audioPluginManager.isEdited = true
        
        func stopPlaying() {
            try? audioFilesManager.stopCurrentPlaying()
        }
        
        func record(_ audioFileManager: AudioFileManager) throws {
            
            // if the parent document audio file is not expanded,
            // the the audio file will not be selected and the selection
            // will stay where it is. We do this to force
            // the selection to change.
            if let audioOutlineView = self.audioOutlineView {
                if !audioOutlineView.isItemExpanded(documentAudioFilesManager) {
                    self.selectItem(documentAudioFilesManager)
                }
            }

            try audioFilesManager.stopCurrentRecording(setAsPlaying: false)
            try audioFilesManager.record(inAudioFileManager: audioFileManager)
            audioFilesManager.recordingAudioFile.setValue(audioFileManager)
        }
        
        func removeAudioFile(_ audioFileManager: AudioFileManager) {
            
            audioFilesManager.deleteAudioFile(audioFileManager)
        }
        
        func displayRecordingAlert(withError error: Error? = nil) {
            
            DispatchQueue.main.async {
                let alert: NSAlert = NSAlert()
                if let error = error as? LocalizedError, let errorDescription = error.errorDescription {
                    alert.messageText = errorDescription
                }
                else {
                    alert.messageText = "An error occured while trying to record."
                }
                
                alert.alertStyle = NSAlert.Style.critical
                alert.runModal()
            }
        }
        
        do {
            
            let audioFileManager = try audioFilesManager.createNewAudioFile(underParentWithId: documentAudioFilesManager.id)
            
            do {
                
                switch AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) {
                case .authorized:
                    stopPlaying()
                    try record(audioFileManager)
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: AVMediaType.audio) {(granted) in
                        DispatchQueue.main.async {
                            if granted {
                                do {
                                    stopPlaying()
                                    try record(audioFileManager)
                                }
                                catch let error {
                                    removeAudioFile(audioFileManager)
                                    displayRecordingAlert(withError: error)
                                }
                            }
                            else {
                                removeAudioFile(audioFileManager)
                                displayRecordingAlert(withError: RecordError.recordPermissionDenied)
                            }
                        }
                    }
                case .denied: fallthrough
                case .restricted: fallthrough
                @unknown default:
                    removeAudioFile(audioFileManager)
                    displayRecordingAlert(withError: RecordError.recordPermissionDenied)
                }
            }
            catch let error {
                removeAudioFile(audioFileManager)
                displayRecordingAlert(withError: error)
            }
        }
        catch let error {
            displayRecordingAlert(withError: error)
        }
    }
    
    private func titleView(for audioOutlineItem: AudioOutlineItem) -> NSView? {
        
        assert(audioOutlineItem.type == .title)
        if let documentTitleOutlineCellView = self.titleOutlineCellViews[audioOutlineItem.id] {
            return documentTitleOutlineCellView
        }
        
        guard let (documentTitleOutlineCellView, documentAudioFilesViewController) = createDocumentTitleOutlineCellView(with: audioOutlineItem) else {
            assertionFailure("Error: createDocumentTitleOutlineCellView returned nil")
            return nil
        }
        
        self.documentAudioFilesViewControllers[audioOutlineItem.id] = documentAudioFilesViewController
        self.titleOutlineCellViews[audioOutlineItem.id] = documentTitleOutlineCellView
        return documentTitleOutlineCellView
    }
    
    private func createDocumentTitleOutlineCellView(with audioOutlineItem: AudioOutlineItem) -> (DocumentTitleCellView, DocumentAudioFilesViewController)? {
    
        guard audioOutlineItem.type == .title else {
            assertionFailure("Error: audioOutlineItem.type is not \".title\"")
            return nil
        }
        
        guard let documentAudioFilesManager = audioOutlineItem as? DocumentAudioFilesManager else {
            assertionFailure("Error: audioOutlineItem is not DocumentAudioFilesManager.")
            return nil
        }
        
        guard let documentAudioFilesViewController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "DocumentAudioFilesView")) as? DocumentAudioFilesViewController else {
            assertionFailure("Error: documentAudioFilesViewController is nil")
            return nil
        }
        
        let documentAudioFilesView = documentAudioFilesViewController.view
        documentAudioFilesViewController.representedObject = documentAudioFilesManager
        documentAudioFilesViewController.audioToolsViewController = self
        
        let documentTitleCellView = DocumentTitleCellView(frame: .zero)
        documentTitleCellView.documentAudioFilesViewController = documentAudioFilesViewController
        documentTitleCellView.translatesAutoresizingMaskIntoConstraints = false
        
        documentAudioFilesView.translatesAutoresizingMaskIntoConstraints = false
        documentTitleCellView.addSubview(documentAudioFilesView)
        documentTitleCellView.identifier = nil
        
        let bottomConstraint = NSLayoutConstraint(item: documentAudioFilesView, attribute: .bottom, relatedBy: .equal, toItem: documentTitleCellView, attribute: .bottom, multiplier:1, constant:0)
        
        let leadingConstraint = NSLayoutConstraint(item: documentAudioFilesView, attribute: .leading, relatedBy: .equal, toItem: documentTitleCellView, attribute: .leading, multiplier:1, constant:0)
        
        let trailingConstraint = NSLayoutConstraint(item: documentAudioFilesView, attribute: .trailing, relatedBy: .equal, toItem: documentTitleCellView, attribute: .trailing, multiplier:1, constant:0)
        
        let topConstraint = NSLayoutConstraint(item: documentAudioFilesView, attribute: .top, relatedBy: .equal, toItem: documentTitleCellView, attribute: .top, multiplier:1, constant:0)
        
        documentTitleCellView.addConstraint(bottomConstraint)
        documentTitleCellView.addConstraint(leadingConstraint)
        documentTitleCellView.addConstraint(trailingConstraint)
        documentTitleCellView.addConstraint(topConstraint)
        documentTitleCellView.needsUpdateConstraints = true
        return (documentTitleCellView, documentAudioFilesViewController)
    }
    
    private func createAudioFileOutlineCellView(with audioOutlineItem: AudioOutlineItem) -> (AudioFileCellView, AudioFileViewController)? {
        
        guard audioOutlineItem.type == .file else {
            assertionFailure("Error: audioOutlineItem.type is not \".file\"")
            return nil
        }
        
        guard let audioFileManager = audioOutlineItem as? AudioFileManager else {
            assertionFailure("Error: audioOutlineItem is not AudioFileManager.")
            return nil
        }
        
        guard let audioFileViewController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "AudioFileViewController")) as? AudioFileViewController else {
            assertionFailure("Error: audioFileViewController is nil")
            return nil
        }
        
        audioFileViewController.representedObject = audioFileManager
        
        let audioFileCellView = AudioFileCellView(frame: .zero)
        audioFileCellView.translatesAutoresizingMaskIntoConstraints = false

        let audioFileView = audioFileViewController.view
        audioFileView.translatesAutoresizingMaskIntoConstraints = false
        audioFileCellView.addSubview(audioFileView)
        audioFileCellView.identifier = nil
        
        let bottomConstraint = NSLayoutConstraint(item: audioFileView, attribute:NSLayoutConstraint.Attribute.bottom, relatedBy:NSLayoutConstraint.Relation.equal, toItem:audioFileCellView, attribute:NSLayoutConstraint.Attribute.bottom, multiplier:1, constant:0)
        
        let leadingConstraint = NSLayoutConstraint(item: audioFileView, attribute:NSLayoutConstraint.Attribute.leading, relatedBy:NSLayoutConstraint.Relation.equal, toItem:audioFileCellView, attribute:NSLayoutConstraint.Attribute.leading, multiplier:1, constant:0)
        
        let trailingConstraint = NSLayoutConstraint(item: audioFileView, attribute:NSLayoutConstraint.Attribute.trailing, relatedBy:NSLayoutConstraint.Relation.equal, toItem:audioFileCellView, attribute:NSLayoutConstraint.Attribute.trailing, multiplier:1, constant:0)
        
        let topConstraint = NSLayoutConstraint(item: audioFileView, attribute:NSLayoutConstraint.Attribute.top, relatedBy:NSLayoutConstraint.Relation.equal, toItem:audioFileCellView, attribute:NSLayoutConstraint.Attribute.top, multiplier:1, constant:0)
        
        audioFileCellView.addConstraint(bottomConstraint)
        audioFileCellView.addConstraint(leadingConstraint)
        audioFileCellView.addConstraint(trailingConstraint)
        audioFileCellView.addConstraint(topConstraint)
        audioFileCellView.needsUpdateConstraints = true
        audioFileCellView.audioFileViewController = audioFileViewController
        return (audioFileCellView,audioFileViewController)
    }
    
    func expandItem(_ audioOutlineItem: AudioOutlineItem) {
        
        guard let audioOutlineView = self.audioOutlineView else {
            assertionFailure("Error: self.audioOutlineView is nil")
            return
        }
        
        guard let documentAudioFilesManager = audioOutlineItem as? DocumentAudioFilesManager else {
            assertionFailure("Error: only support expanding DocumentAudioFilesManager")
            return
        }
        
        let itemRow = audioOutlineView.row(forItem: documentAudioFilesManager)
        
        // we could have expanded items that are not shown (filtering applied)
        // so there are not present in the outline view.
        if itemRow != -1  {
            
            guard let documentTitleCellView = self.titleView(for: audioOutlineItem) as? DocumentTitleCellView else {
                assertionFailure("Error: documentTitleCellView is nil")
                return
            }
            
            audioOutlineView.expandItem(documentAudioFilesManager)
            
            guard let documentAudioFilesViewController = documentTitleCellView.documentAudioFilesViewController else {
                assertionFailure("Error: documentAudioFilesViewController is nil")
                return
            }
            
            documentAudioFilesViewController.isExpanded = true
        }
    }
    
    func collapseItem(_ audioOutlineItem: AudioOutlineItem) {
        
        guard let audioOutlineView = self.audioOutlineView else {
            assertionFailure("Error: self.audioOutlineView is nil")
            return
        }
        
        guard let documentAudioFilesManager = audioOutlineItem as? DocumentAudioFilesManager else {
            assertionFailure("Error: only support collapsing DocumentAudioFilesManager")
            return
        }
        
        let itemRow = audioOutlineView.row(forItem: documentAudioFilesManager)
        
        guard itemRow != -1 else {
            assertionFailure("Error: item does not exists in outline view")
            return
        }
        
        guard let documentAudioFilesViewController = self.documentAudioFilesViewControllers[documentAudioFilesManager.id] else {
            assertionFailure("Error: self.documentAudioFilesViewControllers is nil")
            return
        }
        
        audioOutlineView.collapseItem(documentAudioFilesManager)
        documentAudioFilesViewController.isExpanded = false
    }
  
    private func scrollToItem(_ audioOutlineItem: AudioOutlineItem) {
        
        guard let audioOutlineView = self.audioOutlineView else {
            assertionFailure("Error: self.audioOutlineView is nil")
            return
        }
        
        let row = audioOutlineView.row(forItem: audioOutlineItem)
        if row != -1 {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
            os_log("Scrolling to row: %@", log: Log.Audio.all, type: .info, %%row)
            #endif
            if audioOutlineView.numberOfRows-1 == row {
                audioOutlineView.scrollToEndOfDocument(self)
            }
            else if audioOutlineView.numberOfRows-1 > row {
                audioOutlineView.scrollRowToVisible(row+2)
            }
            else if audioOutlineView.numberOfRows > row {
                audioOutlineView.scrollRowToVisible(row+1)
            }
            else {
                audioOutlineView.scrollRowToVisible(row)
            }
        }
    }
    
    private func selectItem(_ audioOutlineItem: AudioOutlineItem) {
        
        guard let audioOutlineView = self.audioOutlineView else {
            assertionFailure("Error: self.audioOutlineView is nil")
            return
        }
        
        let itemRow = audioOutlineView.row(forItem: audioOutlineItem)
        
        // we could have selected items that are not shown (filtering applied)
        // so there are not present in the outline view.
        if itemRow != -1 {
            
            let indexes = IndexSet([itemRow])
            audioOutlineView.selectRowIndexes(indexes, byExtendingSelection: false)
        }
    }
    
    private func subscribeToAudioFilesManager() {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        
        self.handleRecordingAudioFile(audioFilesManager.recordingAudioFile.value)
        audioFilesManager.recordingAudioFile.subscribe({ [weak self](audioFileManager) in
            self?.handleRecordingAudioFile(audioFileManager)
        }, observer: self)
        
        for documentAudioFilesManagerId in audioFilesManager.documentAudioFilesArray.values {
            subscribe(toDocumentAudioFilesManagerWithId: documentAudioFilesManagerId)
        }
        
        var animate = false
        audioFilesManager.documentAudioFilesArray.subscribe({ [weak self](change) in
            
            guard let audioOutlineView = self?.audioOutlineView else {
                assertionFailure("Error: self.audioOutlineView is nil")
                return
            }
            
            if self?.selectedFilesFilterActive == false {
                switch change {
                case .deletes(let indexes, let deletedValues, _):
                    
                    for documentAudioFilesManagerId in deletedValues {
                        self?.unsubscribe(fromDocumentAudioFilesManagerWithId: documentAudioFilesManagerId)
                    }
                    if animate {
                        audioOutlineView.beginUpdates()
                        audioOutlineView.removeItems(at: IndexSet(indexes), inParent: nil, withAnimation: NSTableView.AnimationOptions.slideLeft)
                        audioOutlineView.endUpdates()
                    }
                case .insert(let newElement, let index, _):
                    self?.subscribe(toDocumentAudioFilesManagerWithId: newElement)
                    if animate {
                        audioOutlineView.beginUpdates()
                        audioOutlineView.insertItems(at: [index], inParent: nil, withAnimation: NSTableView.AnimationOptions.slideRight)
                        audioOutlineView.endUpdates()
                    }
                case .inserts(let newElements, let indexes, _):
                    for documentAudioFilesManagerId in newElements {
                        self?.subscribe(toDocumentAudioFilesManagerWithId: documentAudioFilesManagerId)
                    }
                    if animate {
                        audioOutlineView.beginUpdates()
                        audioOutlineView.insertItems(at: IndexSet(indexes), inParent: nil, withAnimation: NSTableView.AnimationOptions.slideRight)
                        audioOutlineView.endUpdates()
                    }
                case .move(_, let sourceIndex, let targetIndex, _):
                    if animate {
                        audioOutlineView.beginUpdates()
                        audioOutlineView.moveItem(at: sourceIndex, inParent: nil, to: targetIndex, inParent: nil)
                        audioOutlineView.endUpdates()
                    }
                case .end:
                    if !animate {
                        animate = false
                        self?.freshReload()
                    }
                    else {
                        self?.restoreOutlineState()
                    }
                case .start(let sourceArray, let destinationArray):
                    if abs(sourceArray.count-destinationArray.count) <= 1 && self?.requiresReload == false {
                        animate = true
                    }
                    else {
                        animate = false
                    }
                }
            }
        }, observer: self)
        
        audioFilesManager.selectedFilesOutline.subscribe({ [weak self](selectedFilesOutline) in
            self?.handleSelectedFilesOutlineChange(selectedFilesOutline)
        }, observer: self)
        
        
        audioFilesManager.selectedFilesOutlineSelectedTextItems.subscribe({[weak self](change) in
            
            guard let audioOutlineView = self?.audioOutlineView else {
                assertionFailure("Error: self.audioOutlineView is nil")
                return
            }
            
            if self?.selectedFilesFilterActive == true {
                switch change {
                case .deletes(let indexes, let deletedTextElementIds, _):
                    
                    for deletedTextElementId in deletedTextElementIds {
                        self?.unsubscribe(fromDocumentAudioFilesManagerWithAssociatedTextId: deletedTextElementId)
                    }
                    
                    guard let audioOutlineView = self?.audioOutlineView else {
                        assertionFailure("Error: self.audioOutlineView is nil")
                        return
                    }
                    
                    if animate {
                        audioOutlineView.beginUpdates()
                        audioOutlineView.removeItems(at: IndexSet(indexes), inParent: nil, withAnimation: NSTableView.AnimationOptions.effectFade)
                        audioOutlineView.endUpdates()
                    }
                    
                case .insert(let newTextElementId, let index, _):
                    if animate {
                        audioOutlineView.beginUpdates()
                        audioOutlineView.insertItems(at: [index], inParent: nil, withAnimation: .slideDown)
                        audioOutlineView.endUpdates()
                    }
                    self?.subscribe(toDocumentAudioFilesManagerWithAssociatedTextId: newTextElementId)
                case .inserts(let newTextElementIds, let indexes, _):
                    if animate {
                        audioOutlineView.beginUpdates()
                        audioOutlineView.insertItems(at: IndexSet(indexes), inParent: nil, withAnimation: .slideDown)
                        audioOutlineView.endUpdates()
                    }
                    for newTextElementId in newTextElementIds {
                        self?.subscribe(toDocumentAudioFilesManagerWithAssociatedTextId: newTextElementId)
                    }
                case .move:
                    break
                case .end:
                    if !animate {
                        animate = false
                        self?.freshReload()
                    }
                    else {
                        self?.restoreOutlineState()
                    }
                case .start(let sourceArray, let destinationArray):
                    if abs(sourceArray.count-destinationArray.count) <= 1 && self?.requiresReload == false {
                        animate = true
                    }
                    else {
                        animate = false
                    }
                }
            }
        }, observer: self)
    }
    
    private var requiresReload: Bool = true
    
    private func handleSelectedFilesOutlineChange(_ selectedFilesOutline: FilesOutlineManager?) {
                
        self.requiresReload = true
    }
    
    private func freshReload() {
        
        guard let audioOutlineView = self.audioOutlineView else {
            assertionFailure("Error: self.audioOutlineView is nil")
            return
        }
        
        audioOutlineView.reloadData()
        restoreOutlineState()
        self.requiresReload = false
    }
    
    private func subscribe(toDocumentAudioFilesManagerWithAssociatedTextId id: String) {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        
        guard let documentAudioFilesManager = audioFilesManager.documentAudioFiles(forTextId: id) else {
            assertionFailure("Error: no document audio files manager with id: \(id)")
            return
        }
        
        documentAudioFilesManager.audioFileManagers.subscribe({ [weak self](arrayChange) in
            self?.handleAudioFileManagersChange(arrayChange)
        }, observer: self)
    }
    
    private func subscribe(toDocumentAudioFilesManagerWithId id: String) {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        
        guard let documentAudioFilesManager = audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: id) else {
            assertionFailure("Error: no document audio files manager with id: \(id)")
            return
        }
        
        documentAudioFilesManager.audioFileManagers.subscribe({ [weak self](arrayChange) in
            self?.handleAudioFileManagersChange(arrayChange)
        }, observer: self)
    }

    private func unsubscribe(fromDocumentAudioFilesManagerWithAssociatedTextId id: String) {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        
        guard let documentAudioFilesManager = audioFilesManager.documentAudioFiles(forTextId: id) else {
            return
        }
        
        documentAudioFilesManager.audioFileManagers.unsubscribe(observer: self)
    }
    
    private func unsubscribe(fromDocumentAudioFilesManagerWithId id: String) {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        
        // it could have been deleted
        guard let documentAudioFilesManager = audioFilesManager.documentAudioFiles(forDocumentAudioFilesId: id) else {
            return
        }
        
        documentAudioFilesManager.audioFileManagers.unsubscribe(observer: self)
    }
    
    private func handleAudioFileManagersChange(_ arrayChange: DynamicArray<String>.Change) {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil")
            return
        }
        
        guard let audioOutlineView = self.audioOutlineView else {
            assertionFailure("Error: self.audioOutlineView is nil")
            return
        }
        
        switch arrayChange {
        case .deletes(let indexes, let deletedValues, _):
            audioOutlineView.beginUpdates()
            for (index, deletedValue) in deletedValues.enumerated() {
                guard let audioFileManager = audioFilesManager.audioFilesSet.values[deletedValue] else {
                    assertionFailure("Error: audioFilesManager.audioFilesSet.values[\(deletedValue)] is nil")
                    continue
                }
                
                guard let documentAudioFilesManager = audioFilesManager.documentAudioFilesSet.values[audioFileManager.parentId] else {
                    assertionFailure("Error: audioFilesManager.documentAudioFilesSet.values[\(audioFileManager.parentId)] is nil")
                    continue
                }
                
                let audioFileIndex = indexes[index]
                audioOutlineView.removeItems(at: [audioFileIndex], inParent: documentAudioFilesManager, withAnimation: .effectFade)
            }
            audioOutlineView.endUpdates()
            
        case .insert(let newElement, let index, _):
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Inserting newElement: %@ at index: %@", log: Log.Audio.all, type: .info, %%newElement, %%index)
            #endif
            
            audioOutlineView.beginUpdates()
            guard let audioFileManager = audioFilesManager.audioFilesSet.values[newElement] else {
                assertionFailure("Error: audioFilesManager.audioFilesSet.values[\(newElement)] is nil")
                break
            }
            
            guard let documentAudioFilesManager = audioFilesManager.documentAudioFilesSet.values[audioFileManager.parentId] else {
                assertionFailure("Error: audioFilesManager.documentAudioFilesSet.values[\(audioFileManager.parentId)] is nil")
                break
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("self.audioOutlineView.insertItems(at: [%@], inParent: %@", log: Log.Audio.all, type: .info, %%index, %%documentAudioFilesManager.id)
            #endif
            
            audioOutlineView.insertItems(at: [index], inParent: documentAudioFilesManager, withAnimation: [])
            self.scrollToItem(audioFileManager)
            audioOutlineView.endUpdates()
            self.selectItem(audioFileManager)
            
        case .inserts(let newElements, let indexes, _):
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Inserting newElements: %@ at indexes: %@", log: Log.Audio.all, type: .info, %%newElements, %%indexes)
            #endif
            
            audioOutlineView.beginUpdates()
            var lastAddedAudioFileManager: AudioFileManager?
            for (index, newElement) in newElements.enumerated() {
            
                guard let audioFileManager = audioFilesManager.audioFilesSet.values[newElement] else {
                    assertionFailure("Error: audioFilesManager.audioFilesSet.values[\(newElement)] is nil")
                    continue
                }
                
                guard let documentAudioFilesManager = audioFilesManager.documentAudioFilesSet.values[audioFileManager.parentId] else {
                    assertionFailure("Error: audioFilesManager.documentAudioFilesSet.values[\(audioFileManager.parentId)] is nil")
                    continue
                }
                
                let audioFileIndex = indexes[index]
                audioOutlineView.insertItems(at: [audioFileIndex], inParent: documentAudioFilesManager, withAnimation: NSTableView.AnimationOptions.slideLeft)
                lastAddedAudioFileManager = audioFileManager
            }
            if let lastAddedAudioFileManager = lastAddedAudioFileManager {
                self.scrollToItem(lastAddedAudioFileManager)
            }
            audioOutlineView.endUpdates()
            
        case .move(_, _, _, _):
            assertionFailure("Error: missing implementation")
            break
        case .end: fallthrough
        case .start:
            break
        }
    }
    
    private func handleRecordingAudioFile(_ audioFileManager: AudioFileManager?) {
               
        // stop the pulsating button, if there is
        if let recordingAudioFileManager = self.recordingAudioFileManager {
            
            // the
            if let documentTitleCellView = self.documentAudioFilesViewControllers[recordingAudioFileManager.parentId] {
                documentTitleCellView.recordButton?.stopPulsating()
            }
        }
        
        if let audioFileManager = audioFileManager {
            
            let documentAudioFilesViewController: DocumentAudioFilesViewController? = {
                if let documentAudioFilesViewController = self.documentAudioFilesViewControllers[audioFileManager.parentId] {
                    return documentAudioFilesViewController
                }
                else {
                    
                    guard let audioFilesManager = self.audioFilesManager else {
                        assertionFailure("Error: self.audioFilesManager is nil")
                        return nil
                    }
                    
                    guard let documentAudioFilesManager = audioFilesManager.documentAudioFilesSet.values[audioFileManager.parentId] else {
                        assertionFailure("Error: audioFilesManager.documentAudioFilesSet.values[\(audioFileManager.parentId)] is nil")
                        return nil
                    }
                    
                    _ = titleView(for: documentAudioFilesManager)
                    guard let documentAudioFilesViewController = self.documentAudioFilesViewControllers[audioFileManager.parentId] else {
                        assertionFailure("Error: audioFilesManager.documentAudioFilesSet.values[\(audioFileManager.parentId)] is nil")
                        return nil
                    }
                    return documentAudioFilesViewController
                }
            }()
            
            documentAudioFilesViewController?.showRightButtons()
            documentAudioFilesViewController?.recordButton?.startPulsating()
            self.currentlyRecording = true
            self.stopRecordingButton?.state = .on
        }
        else {
            self.currentlyRecording = false
            self.stopRecordingButton?.state = .off
        }
        self.recordingAudioFileManager = audioFileManager
    }
    
    private func unsubscribeToAudioFilesManager() {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        audioFilesManager.recordingAudioFile.unsubscribe(observer: self)
        audioFilesManager.selectedFilesOutlineSelectedTextItems.unsubscribe(observer: self)
    }
    
    private func subscribeToAudioFilesOutlineManager() {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        self.handleSelectedFilesFilterActive(audioFilesOutlineManager.selectedFilesFilterActive.value)
        audioFilesOutlineManager.selectedFilesFilterActive.subscribe({ [weak self](newValue) in
            self?.handleSelectedFilesFilterActive(newValue)
        }, observer: self)
    }
    
    private func handleSelectedFilesFilterActive(_ newValue: Bool) {
        
        guard let audioOutlineView = self.audioOutlineView else {
            assertionFailure("Error: self.audioOutlineView is nil")
            return
        }
        
        if newValue != self.selectedFilesFilterActive {
        
            self.selectedFilesFilterActive = newValue
            audioOutlineView.reloadData()
            if newValue {
                self.selectedFilesFilterActiveButton?.state = .on
            }
            else {
                self.selectedFilesFilterActiveButton?.state = .off
            }
        }
    }
    
    private func unsubscribeToAudioFilesOutlineManager() {
        
        guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
            assertionFailure("Error: self.audioFilesOutlineManager is nil")
            return
        }
        
        audioFilesOutlineManager.selectedFilesFilterActive.unsubscribe(observer: self)
    }
    
    deinit {
        
        guard let audioFilesManager = self.audioFilesManager else {
            assertionFailure("Error: self.audioFilesManager is nil.")
            return
        }
        
        for documentAudioFilesManagerId in audioFilesManager.documentAudioFilesArray.values {
            unsubscribe(fromDocumentAudioFilesManagerWithId: documentAudioFilesManagerId)
        }
        
        self.unsubscribeToAudioFilesManager()
        self.unsubscribeToAudioFilesOutlineManager()
    }
}

