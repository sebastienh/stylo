//
//  FileOutlineTagsViewController.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import StyloCoreMac

class FileOutlineTagsViewController: NSViewController, ProjectToolTabItemViewController {
    
    @IBOutlet var filterTextField: NSTextField? {
        didSet {
            filterTextField?.backgroundColor = NSColor.clear
            filterTextField?.isBezeled = false
            filterTextField?.focusRingType = .none
            self.subscribeToControlTextDidChange()
        }
    }
    
    @IBOutlet var filterActiveButton: NSButton!
    
    @IBOutlet var bottomSubSectionSeparator: ColoredLineView!
    
    @IBOutlet var sortingSelectionButton: NSPopUpButton!
    
    @IBOutlet var selectAllTags: MacDisableableButton?
    
    @IBOutlet var unselectAllTags: MacDisableableButton?
    
    @IBOutlet var previousTag: MacDisableableButton?
    
    @IBOutlet var nextTag: MacDisableableButton?
    
    @objc dynamic var selectionNotEmpty: Bool = true
    
    @objc dynamic var valuesNotEmpty: Bool = true
    
    var representedFilesOutlineManager: FilesOutlineManager? {
        
        return filesOutlineTagsManager?.filesOutlineManager
    }
    
    var filesOutlineTagsManager: FilesOutlineTagsManager<TagsCollectionViewController.CollectionViewDiffableDataSourceType>? {
        return self.representedObject as? FilesOutlineTagsManager<TagsCollectionViewController.CollectionViewDiffableDataSourceType>
    }
    
    private var initialized: Bool = false
    
    private var tagsCollectionTabViewController: TagsCollectionTabViewController? {
        for child in self.children {
            if let tagsCollectionTabViewController = child as? TagsCollectionTabViewController {
                return tagsCollectionTabViewController
            }
        }
        return nil
    }
    
    var tagsCollectionViewController: TagsCollectionViewController? {
        
        return tagsCollectionTabViewController?.tagsCollectionViewController
    }
    
    var filterString: String? {
        didSet {
            tagsCollectionViewController?.filterString = filterString
            if self.filterString != oldValue {
                let bundle = Bundle(for: type(of: self))
                if self.filterString != nil {
                    self.filterActiveButton.contentTintColor = NSColor.controlAccentColor
                    self.filterActiveButton.image = nsImage(named: "applied-filter", bundle: bundle)
                }
                else {
                    self.filterActiveButton.contentTintColor = nsColor(named: "default-button-tint-color", bundle: bundle)
                    self.filterActiveButton.image = nsImage(named: "filter", bundle: bundle)
                }
            }
        }
    }
    
    override func viewWillAppear() {
        
        if !initialized {
            
            guard let filesOutlineTagsManager = self.filesOutlineTagsManager else {
                assertionFailure("Error: filesOutlineTagsManager is nil")
                return
            }
            
            assert(self.tagsCollectionTabViewController != nil)
            tagsCollectionTabViewController?.representedObject = filesOutlineTagsManager
            tagsCollectionViewController?.representedObject = filesOutlineTagsManager
            subscribe(toFilesOutlineTagsManager: filesOutlineTagsManager)
            self.initialized = true
        }
        super.viewWillAppear()
    }
        
    @IBAction func setValuesSortingMode(_ sender: AnyObject?) {
        
        self.filesOutlineTagsManager?.setValuesSortingMode()
    }
    
    @IBAction func setAttributesSortingMode(_ sender: AnyObject?) {
        
        self.filesOutlineTagsManager?.setAttributesSortingMode()
    }
    
    func enableUserInteractions() {
        
        self.filterTextField?.isEnabled = true
        self.filterTextField?.isEditable = true
        self.filterActiveButton.isEnabled = true
        self.sortingSelectionButton.isEnabled = true
        
        self.selectAllTags?.enableUserInteractions()
        self.unselectAllTags?.enableUserInteractions()
        self.previousTag?.enableUserInteractions()
        self.nextTag?.enableUserInteractions()
        
        self.tagsCollectionViewController?.enableUserInteractions()
    }
    
    func disableUserInteractions() {
        
        self.filterTextField?.isEnabled = false
        self.filterTextField?.isEditable = false
        self.filterActiveButton.isEnabled = false
        self.sortingSelectionButton.isEnabled = false
        
        self.selectAllTags?.disableUserInteractions()
        self.unselectAllTags?.disableUserInteractions()
        self.previousTag?.disableUserInteractions()
        self.nextTag?.disableUserInteractions()
        
        self.tagsCollectionViewController?.disableUserInteractions()
    }
    
    private func subscribe(toFilesOutlineTagsManager filesOutlineTagsManager: FilesOutlineTagsManager<TagsCollectionViewController.CollectionViewDiffableDataSourceType>) {
    
        if !filesOutlineTagsManager.valuesCount.subscribed(observer: self) {
            handleValuesCountChange(filesOutlineTagsManager.valuesCount.value)
            filesOutlineTagsManager.valuesCount.subscribe({ [weak self](valuesCount) in
                self?.handleValuesCountChange(valuesCount)
            }, observer: self)
        }
           
        if !filesOutlineTagsManager.selectionNotEmpty.subscribed(observer: self) {
            self.selectionNotEmpty = filesOutlineTagsManager.selectionNotEmpty.value
            filesOutlineTagsManager.selectionNotEmpty.subscribe({ [weak self](selectionNotEmpty) in
                self?.selectionNotEmpty = selectionNotEmpty
            }, observer: self)
        }
        
        if !filesOutlineTagsManager.attributesMode.subscribed(observer: self) {
            updateAtributesSortingModeIcon(forAttributesMode: filesOutlineTagsManager.attributesMode.value)
            filesOutlineTagsManager.attributesMode.subscribe({ [weak self](attributesMode) in
                self?.updateAtributesSortingModeIcon(forAttributesMode: attributesMode)
            }, observer: self)
        }
    }
    
    private func handleValuesCountChange(_ count: Int) {
        
        self.valuesNotEmpty = count > 0
        
        guard let tagsCollectionTabViewController = self.tagsCollectionTabViewController else {
            assertionFailure("Error: self.tagsCollectionTabViewController is nil")
            return
        }
        
        if count == 0 {
            tagsCollectionTabViewController.selectedTabViewItemIndex = 1
        }
        else {
            tagsCollectionTabViewController.selectedTabViewItemIndex = 0
        }
    }
    
    private func updateAtributesSortingModeIcon(forAttributesMode attributesMode: AttributesSortingMode) {
        
        switch attributesMode {
        case .attributes:
            if sortingSelectionButton.indexOfSelectedItem != 1 {
                sortingSelectionButton.selectItem(at: 1)
            }
        case .values:
            if sortingSelectionButton.indexOfSelectedItem != 0 {
                sortingSelectionButton.selectItem(at: 0)
            }
        }
    }
}
