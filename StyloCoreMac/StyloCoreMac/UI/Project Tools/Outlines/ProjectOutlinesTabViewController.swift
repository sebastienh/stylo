//
//  ProjectOutlinesTabViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common

/// The project outline tab view controller contains
/// all the project outlines.
class ProjectOutlinesTabViewController: FilesOutlineSelectorTabViewController {
    
    var selectedProjectOutlineViewController: ProjectOutlineViewController? {
        
        let selectedTabViewItem = self.tabViewItems[self.selectedTabViewItemIndex]
        
        guard let selectedViewController = selectedTabViewItem.viewController else {
            assertionFailure("Error: selectedTabViewItem.viewController is nil")
            return nil
        }
        
        guard let projectOutlineViewController = selectedViewController as? ProjectOutlineViewController else {
            assertionFailure("Error: selectedViewController is nil ProjectOutlineViewController")
            return nil
        }
        
        return projectOutlineViewController
    }

    override func addPanel(withFilesOutlineManager filesOutlineManager: FilesOutlineManager, atIndex index: Int) {
        
        let controllerName = "ProjectOutline"
        let sceneIdentifier = NSStoryboard.SceneIdentifier(string: controllerName)
        let outlineViewController = self.storyboard!.instantiateController(withIdentifier: sceneIdentifier) as! NSViewController
        outlineViewController.representedObject = filesOutlineManager
        let outlineViewTabItem = NSTabViewItem(viewController: outlineViewController)
        self.insertTabViewItem(outlineViewTabItem, at: index)
    }
}
