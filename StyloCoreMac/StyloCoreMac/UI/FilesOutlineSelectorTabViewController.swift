//
//  ProjectToolTabViewController.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os


/// This is the superclass of all tools that need to switch tabs
/// when a different files outline is selected
open class FilesOutlineSelectorTabViewController: NSTabViewController {
    
    private var initiated: Bool = false
    
    var documentManager: DocumentManager? {
        assert(self.representedObject is DocumentManager)
        return self.representedObject as? DocumentManager
    }
    
    var filesOutlineManagers: [FilesOutlineManager]? {
        assert(self.filesOutlineSetManager != nil)
        return filesOutlineSetManager?.filesOutlines.values
    }
    
    var filesOutlineSetManager: FilesOutlineSetManager? {
        assert(self.documentManager != nil)
        return documentManager?.filesOutlineSetManager.value
    }
    
    var selectedFilesOutlineId: String = "" {
        didSet {
            self.updateSelectedTab()
        }
    }
    
    open override func viewWillAppear() {
        if !self.initiated {
            initChildControllers()
        }
        super.viewWillAppear()
        #if DEBUG
        self.validateFilesOutlineManagers()
        #endif
    }
    
    private func initChildControllers() {
        
        guard let filesOutlineManagers = self.filesOutlineManagers else {
            assertionFailure("Error: self.filesOutlineManagers is nil")
            return
        }
        
        for (index, filesOutlineManager) in filesOutlineManagers.enumerated() {
            self.addPanel(withFilesOutlineManager: filesOutlineManager, atIndex: index)
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil.")
            return
        }
        
        guard let selectedFilesOutlineId = filesOutlineSetManager.selectedFilesOutlineID.value else {
            assertionFailure("Error: selectedFilesOutlineId is nil.")
            return
        }
        
        self.selectedFilesOutlineId = selectedFilesOutlineId
        bindToProjectOutlineSet()
        #if DEBUG
        self.validateFilesOutlineManagers()
        #endif
        self.initiated = true
    }
    
    private func updateSelectedTab() {
        
        // when called from the selected it's possible we didn't update the number of tabs yet so
        if let tabViewIndex = self.tabViewIndex(with: self.selectedFilesOutlineId) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
            os_log("setting selected index: %@ on project outline tab view controller", log: Log.StyloCore.all, type: .info, %%tabViewIndex)
            os_log("self.tabViewItems.count: %@", log: Log.StyloCore.all, type: .info, %%self.tabViewItems.count)
            #endif
            
            self.selectedTabViewItemIndex = tabViewIndex
        }
    }
    
    private func tabViewIndex(with id: String) -> Int? {
        
        guard self.filesOutlinesSynched else {
            return nil
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return 0
        }
        
        let filesOutlines = filesOutlineSetManager.filesOutlines.values
        
        var foundIndex: Int?
        for (index, filesOutlineManager) in filesOutlines.enumerated() {
            if id == filesOutlineManager.id {
                foundIndex = index
            }
        }
        if let foundIndex = foundIndex {
            guard foundIndex < self.tabViewItems.count else {
                assertionFailure("Error: self.tabViewItems.count: \(self.tabViewItems.count)")
                return nil
            }
            return foundIndex
        }
        return nil
    }
    
    private func bindToProjectOutlineSet() {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil.")
            return
        }
        
        filesOutlineSetManager.filesOutlines.subscribe({ [weak self](change) in
            self?.handleFilesOutlinesChange(change)
            self?.updateSelectedTab()
        }, observer: self)
        
        filesOutlineSetManager.selectedFilesOutlineID.subscribe({ [weak self](newValue) in
            assert(newValue != nil)
            if let newValue = newValue {
                self?.selectedFilesOutlineId = newValue
            }
        }, observer: self)
    }
    
    private func handleFilesOutlinesChange(_ change: DynamicArray<FilesOutlineManager>.Change) {
        
        switch change {
        case .deletes(let indexes, _, _):
            for index in indexes.sorted().reversed() {
                self.deletePanel(atIndex: index)
            }
        case .insert(let filesOutlineManager, let index, _):
            self.addPanel(withFilesOutlineManager: filesOutlineManager, atIndex: index)
        case .inserts(let newElements, let indexes, _):
            assert(newElements.count == indexes.count)
            for i in 0..<newElements.count {
                let filesOutlineManager = newElements[i]
                let index = indexes[i]
                self.addPanel(withFilesOutlineManager: filesOutlineManager, atIndex: index)
            }
        case .move:
            assertionFailure("Error: unhandled move")
            break
        case .start: fallthrough
        case .end:
            break
        }
    }
    
    private func deletePanel(atIndex index: Int) {
        
        self.removeTabViewItem(self.tabViewItems[index])
    }
    
    open func addPanel(withFilesOutlineManager filesOutlineManager: FilesOutlineManager, atIndex index: Int) {
        
        fatalError("Subclass must implement addPanel(...) method")
    }
    
    #if DEBUG
    private func validateFilesOutlineManagers() {
        assert(self.filesOutlinesSynched)
        assert(self.selectedFilesOutlineSynched)
    }
    #endif
    
    private var selectedFilesOutlineSynched: Bool {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil.")
            return false
        }
        
        guard let selectedFilesOutlineManager = filesOutlineSetManager.selectedFilesOutlineManager.value else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return false
        }
        
        guard let selectedProjectOutlineViewController = self.tabViewItems[self.selectedTabViewItemIndex].viewController as? ProjectToolTabItemViewController else {
            assertionFailure("Error: selectedProjectOutlineViewController is nil")
            return false
        }
        
        guard let selectedTabFilesOutlineManager = selectedProjectOutlineViewController.representedFilesOutlineManager else {
            assertionFailure("Error: selectedTabFilesOutlineManager is nil")
            return false
        }
        
        return selectedTabFilesOutlineManager.id == selectedFilesOutlineManager.id
    }
    
    private var filesOutlinesSynched: Bool {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil.")
            return false
        }
        
        if filesOutlineSetManager.filesOutlines.count != self.tabViewItems.count {
            return false
        }
        
        for (index, filesOutline) in filesOutlineSetManager.filesOutlines.enumerated() {
            
            guard let projectOutlineViewController = self.tabViewItems[index].viewController as? ProjectToolTabItemViewController else {
                assertionFailure("Error: projectOutlineViewController at index: \(index) is nil")
                return false
            }
            
            guard let representedFilesOutlineManager = projectOutlineViewController.representedFilesOutlineManager else {
                assertionFailure("Error: representedFilesOutlineManager is nil")
                return false
            }
            
            if representedFilesOutlineManager.id != filesOutline.id {
                
                return false
            }
        }
        return true
    }
    
    deinit {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil.")
            return
        }
        
        filesOutlineSetManager.selectedFilesOutlineID.unsubscribe(observer: self)
    }
}
