//
//  ProjectTagsTabViewController.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import StyloCoreMac

class ProjectTagsTabViewController: FilesOutlineSelectorTabViewController {
    
    weak var tagsPlugin: TagsPlugin?
    
    private var selectedFilesOutlineTagsViewController: FileOutlineTagsViewController? {
        
        guard !self.tabViewItems.isEmpty else {
            return nil
        }
        
        let tabItem = self.tabViewItems[self.selectedTabViewItemIndex]
        
        guard let viewController = tabItem.viewController else {
            return nil
        }
        
        return viewController as? FileOutlineTagsViewController
    }
    
    func enableSelectedPanel() {
        
        guard let selectedFilesOutlineTagsViewController = self.selectedFilesOutlineTagsViewController else {
            return
        }
        
        selectedFilesOutlineTagsViewController.enableUserInteractions()
    }
    
    func disableSelectedPanel() {
        
        guard let selectedFilesOutlineTagsViewController = self.selectedFilesOutlineTagsViewController else {
            return
        }
        
        selectedFilesOutlineTagsViewController.disableUserInteractions()
    }
    
    override func addPanel(withFilesOutlineManager filesOutlineManager: FilesOutlineManager, atIndex index: Int) {
            
        guard let tagsPlugin = self.tagsPlugin else {
            assertionFailure("Error: self.tagsPlugin is nil")
            return
        }
        
        guard let filesOutlineTagsManager = tagsPlugin.filesOutlineTagsManagers[filesOutlineManager.id] else {
            assertionFailure("Error: filesOutlineTagsManager is nil")
            return
        }
        
        let controllerName = "OutlineTags"
        let sceneIdentifier = NSStoryboard.SceneIdentifier(string: controllerName)
        let outlineViewController = self.storyboard!.instantiateController(withIdentifier: sceneIdentifier) as! NSViewController
        outlineViewController.representedObject = filesOutlineTagsManager
        let outlineViewTabItem = NSTabViewItem(viewController: outlineViewController)
        self.insertTabViewItem(outlineViewTabItem, at: index)
    }
    
}
