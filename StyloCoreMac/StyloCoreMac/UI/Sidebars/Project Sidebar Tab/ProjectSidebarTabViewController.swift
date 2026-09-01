//
//  ProjectSidebarTabViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-23.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import Common
import os
import WriterCommon

class ProjectSidebarTabViewController: NSTabViewController {
    
    enum ProjectSidebarTab: Int, CaseIterable {
        
        case project
    }
    
    var selectedTab: ProjectSidebarTab? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG  && DEBUG_LOGS_ENABLED
        os_log("selectedTabViewItemIndex: %@", log: Log.StyloCore.all, type: .error, %%selectedTabViewItemIndex)
        #endif
        
        return ProjectSidebarTab(rawValue: selectedTabViewItemIndex)
    }
    
    var projectSidebarMenuViewController: ProjectSidebarMenuViewController? {
        
        let projectSidebarTabViewItem = tabViewItems[§ProjectSidebarTabViewController.ProjectSidebarTab.project]
        return projectSidebarTabViewItem.viewController as? ProjectSidebarMenuViewController
    }
    
    var documentManager: DocumentManager? {
        
        return self.representedObject as? DocumentManager
    }
    
    override var representedObject: Any? {
        didSet {
            assert(representedObject is DocumentManager)
            updateChildsRepresentedObject()
        }
    }
    
    func selectTab(sidebarTab: ProjectSidebarTab) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG  && DEBUG_LOGS_ENABLED
        os_log("Selecting sidebar tab index: %@", log: Log.StyloCore.all, type: .info, %%sidebarTab)
        #endif
        
        self.tabView.selectTabViewItem(at: §sidebarTab)
        self.transitionOptions = NSViewController.TransitionOptions.allowUserInteraction
    }
    
    private func updateChildsRepresentedObject() {
        
        projectSidebarMenuViewController?.representedObject = self.representedObject
    }
} 
