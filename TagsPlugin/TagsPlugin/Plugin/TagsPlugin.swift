//
//  TagsPlugin.swift
//  TagsPlugin
//
//  Created by Sebastien Hamel on 2020-06-04.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

class TagsPlugin: NSResponder, StyloPlugin, Observer {
    
    var priority: ObserverPriority {
        return .background
    }
    
    var name: String {
        return Constants.Plugin.Name
    }
    
    unowned let documentManager: DocumentManager
    
    var filesOutlineTagsManagers: [FilesOutlineManager.FileOutlineId: FilesOutlineTagsManager<TagsCollectionViewController.CollectionViewDiffableDataSourceType>] = [:]
    
    var projectTagsTabViewController: ProjectTagsTabViewController?
    
    var fileOutlineTagsViewController: FileOutlineTagsViewController? {
        
        guard let projectTagsTabViewController = self.projectTagsTabViewController else {
            assertionFailure("Error: self.projectTagsTabViewController is nil")
            return nil
        }
        
        guard !projectTagsTabViewController.tabViewItems.isEmpty else {
            return nil
        }
        
        guard projectTagsTabViewController.selectedTabViewItemIndex >= 0 && projectTagsTabViewController.selectedTabViewItemIndex < projectTagsTabViewController.tabViewItems.count else {
            return nil
        }
        
        let tabViewItem = projectTagsTabViewController.tabViewItems[projectTagsTabViewController.selectedTabViewItemIndex]
        
        guard let viewController = tabViewItem.viewController else {
            return nil
        }
        
        guard let fileOutlineTagsViewController = viewController as? FileOutlineTagsViewController else {
            return nil
        }
        return fileOutlineTagsViewController
    }
    
    private var filesOutlineSetManager: FilesOutlineSetManager? {
        
        return self.documentManager.filesOutlineSetManager.value
    }
    
    var selectedFilesOutlineTagsManager: FilesOutlineTagsManager<TagsCollectionViewController.CollectionViewDiffableDataSourceType>?
    
    required init(documentManager: DocumentManager) {
        
        self.documentManager = documentManager
        super.init()
        subscribeToFilesOutlineSet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func subscribeToFilesOutlineSet() {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        for filesOutlineManager in filesOutlineSetManager.filesOutlines.values {
            addHandledFilesOutlineManager(filesOutlineManager)
        }
        
        filesOutlineSetManager.filesOutlines.subscribe({ [weak self](change) in
            self?.handleFilesOutlineArrayChange(change)
        }, observer: self)
        
        self.handleSelectedFilesOutlineChange(filesOutlineSetManager.selectedFilesOutlineManager.value)
        filesOutlineSetManager.selectedFilesOutlineManager.subscribe({ [weak self](selectedFilesOutlineManager) in
            self?.handleSelectedFilesOutlineChange(selectedFilesOutlineManager)
        }, observer: self)
    }
    
    private func handleSelectedFilesOutlineChange(_ selectedFilesOutlineManager: FilesOutlineManager?) {
        
        guard let selectedFilesOutlineManager = selectedFilesOutlineManager else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return
        }
        
        guard let filesOutlineTagsManager = self.filesOutlineTagsManagers[selectedFilesOutlineManager.id] else {
            assertionFailure("Error: filesOutlineTagsManager is nil")
            return
        }
        
        self.selectedFilesOutlineTagsManager = filesOutlineTagsManager
    }
    
    private func handleFilesOutlineArrayChange(_ change: DynamicArray<FilesOutlineManager>.Change) {
        
        switch change {
        case .deletes(_, let deletedValues, _):
            for deletedValue in deletedValues {
                self.removeHandledFilesOutlineManager(deletedValue)
            }
        case .insert(let newElement, _, _):
            addHandledFilesOutlineManager(newElement)
        case .inserts(let newElements, _, _):
            for newElement in newElements {
                addHandledFilesOutlineManager(newElement)
            }
        case .move: fallthrough
        case .end: fallthrough
        case .start:
            break
        }
    }
    
    private func addHandledFilesOutlineManager(_ filesOutlineManager: FilesOutlineManager) {
        
        filesOutlineTagsManagers[filesOutlineManager.id] = FilesOutlineTagsManager<TagsCollectionViewController.CollectionViewDiffableDataSourceType>(filesOutlineManager: filesOutlineManager)
    }
    
    private func removeHandledFilesOutlineManager(_ filesOutlineManager: FilesOutlineManager) {
        
        filesOutlineTagsManagers.removeValue(forKey: filesOutlineManager.id)
    }
}
