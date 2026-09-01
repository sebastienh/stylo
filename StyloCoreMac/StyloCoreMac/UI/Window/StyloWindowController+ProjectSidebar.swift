//
//  StyloWindowController+ProjectSidebar.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension StyloWindowController {

    var projectOutlineTitleViewController: NavigatorViewController? {
        
        guard let styloStyleInspectorSplitViewController = self.styloStyleInspectorSplitViewController else {
            assertionFailure("Error: cssStyleSplitViewItem.viewController is nil")
            return nil
        }
        
        let projectSidebarSplitViewItem = styloStyleInspectorSplitViewController.splitViewItems[§StyloStyleInspectorSplitViewController.SplitItem.navigator]
        
        guard let projectOutlineTitleViewController = projectSidebarSplitViewItem.viewController as? NavigatorViewController else {
            assertionFailure("Error: projectSidebarSplitViewItem.viewController is not ProjectOutlineTitleViewController")
            return nil
        }
        
        return projectOutlineTitleViewController
    }
    
    
    var projectToolsViewController: ProjectToolsViewController? {
        
        guard let projectOutlineTitleViewController = projectOutlineTitleViewController else {
            assertionFailure("Error: projectOutlineTitleViewController is not ProjectOutlineTitleViewController")
            return nil
        }

        return projectOutlineTitleViewController.projectToolsTabViewController
    }
    
    func selectProjectTabItem(withName name: String) {
        
        guard let projectToolsViewController = self.projectToolsViewController else {
            assertionFailure("Error: self.projectToolsViewController is nil")
            return
        }
        
        projectToolsViewController.selectProjectToolTab(withName: name)
    }
    
    func projectToolsItemShown(withName name: String) -> Bool {
        
        guard let projectToolsViewController = self.projectToolsViewController else {
            assertionFailure("Error: self.projectToolsViewController is nil")
            return false
        }
        
        return projectToolsViewController.isTabItemSelected(withName: name)
    }
    
}
