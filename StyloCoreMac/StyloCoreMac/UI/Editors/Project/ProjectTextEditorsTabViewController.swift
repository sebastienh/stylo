//
//  ProjectTextEditorsTabViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-11-14.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common

class ProjectTextEditorsTabViewController: NSTabViewController {
    
    enum Tab: Int {
        case editors
        case emptySelection
    }
    
    var selectedTab: Tab? {
        switch self.selectedTabViewItemIndex {
        case 0:
            return .editors
        case 1:
            return .emptySelection
        default:
            assertionFailure("Error: unhandled selected index case: \(selectedTabViewItemIndex)")
            return nil
        }
    }
    
    private var filesOutlineManager: FilesOutlineManager? {
        
        guard let representedObject = self.representedObject else {
            assertionFailure("Error: self.representedObject is nil")
            return nil
        }
        
        guard let filesOutlineManager = representedObject as? FilesOutlineManager else {
            assertionFailure("Error: representedObject is not FilesOutlineManager")
            return nil
        }
        
        return filesOutlineManager
    }
    
    var projectTextEditorsEmptySelectionViewController: ProjectTextEditorsEmptySelectionViewController? {
        
        return self.tabViewItems[§Tab.emptySelection].viewController as? ProjectTextEditorsEmptySelectionViewController
    }

    var editorsViewController: EditorsViewController? {
        
        let projectTextEditorsListSplitViewController = self.tabViewItems[§Tab.editors].viewController as? ProjectTextEditorsListSplitViewController
        
        return projectTextEditorsListSplitViewController?.editorsViewController
    }
    
    var projectTextEditorsTableViewController: ProjectTextEditorsTableViewController? {
        
        return self.tabViewItems[§Tab.editors].viewController as? ProjectTextEditorsTableViewController
    }
    
    func disableScrolling() {
    
        self.projectTextEditorsTableViewController?.disableScrolling()
    }
    
    func enableScrolling() {
        
        self.projectTextEditorsTableViewController?.enableScrolling()
    }
    
    override func viewDidLoad() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        for tabViewItem in self.tabViewItems {
            tabViewItem.viewController?.representedObject = filesOutlineManager
        }
        subscribeToFilesOutlineManager()
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        handleSelectionUpdate(filesOutlineManager.selectedTextItems.values)
    }
    
    override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
        
        if let viewController = tabViewItem?.viewController, viewController.representedObject == nil {
            viewController.representedObject = filesOutlineManager
        }
        super.tabView(tabView, willSelect: tabViewItem)
    }
    
    private func subscribeToFilesOutlineManager() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        var shouldChangeTab: Bool = false
        filesOutlineManager.selectedTextItems.subscribe( { [weak self](change) in
            switch change {
            case .deletes(_, _, _):
                break
            case .insert(_, _, _):
                break
            case .inserts(_, _, _):
                break
            case .move(_, _, _, _):
                break
            case .end(let updatedArray):
                if shouldChangeTab {
                    self?.handleSelectionUpdate(updatedArray)
                    shouldChangeTab = false
                }
            case .start(let sourceArray, let destinationArray):
                if sourceArray.isEmpty != destinationArray.isEmpty {
                    shouldChangeTab = true
                }
            }
        }, observer: self)
    }
    
    private func handleSelectionUpdate<C>(_ updatedCollection: C) where C: Collection, C.Element == String {
        
        guard let selectedTab = self.selectedTab else {
            assertionFailure("Error: self.selectedTab is nil")
            return
        }
        
        if updatedCollection.isEmpty {
            switch selectedTab {
            case .editors:
                self.selectedTabViewItemIndex = §Tab.emptySelection
            case .emptySelection:
                break
            }
        }
        else {
            switch selectedTab {
            case .editors:
                break
            case .emptySelection:
                self.selectedTabViewItemIndex = §Tab.editors
                self.updateTableColumnWidth()
            }
        }
    }
    
    func updateTableColumnWidth() {
        
        guard let selectedTab = self.selectedTab else {
            assertionFailure("Error: selectedTab is nil")
            return
        }
        
        guard selectedTab == .editors else {
            return
        }
        
        guard let projectTextEditorsTableViewController = self.projectTextEditorsTableViewController else {
            assertionFailure("Error: projectTextEditorsTableViewController is nil")
            return
        }
        
        projectTextEditorsTableViewController.projectTextEditorsTableView.sizeLastColumnToFit()
    }
    
    private func unsubscribeToFilesOutlineManager() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        filesOutlineManager.selectedTextItems.unsubscribe(observer: self)
    }
    
    deinit {
        
        self.unsubscribeToFilesOutlineManager()
    }
    
}
