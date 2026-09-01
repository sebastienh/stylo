//
//  MacStyloDocument+MacOSPlugin.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-09-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

extension MacStyloDocument: ProjectPanelPlugin {
    
    public var projectPanels: [NavigatorTool]? {
        
        guard let projectOutlinePanel = self.projectOutlinePanel else {
            assertionFailure("Error: self.projectOutlinePanel is nil")
            return nil
        }
        
        return [projectOutlinePanel]
    }
    
    public func documentWillDisableProjectPanel() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("MacStyloDocument.documentWillDisableProjectPanel()", log: Log.StyloCore.all, type: .debug)
        #endif
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return
        }
        
        
        if windowController.navigatorShown {
            if let projectToolsViewController = windowController.projectToolsViewController {
                if projectToolsViewController.isTabItemSelected(withName: "StyloCore-ProjectOutline") {
                    projectToolsViewController.selectedProjectOutlinesViewController?.disableUserInteractions()
                }
            }
            windowController.projectOutlineTitleViewController?.outlinesButton?.isEnabled = false
        }
    }
    
    public func documentWillEnableProjectPanel() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("MacStyloDocument.documentWillEnableProjectPanel()", log: Log.StyloCore.all, type: .debug)
        #endif
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return
        }
        
        if windowController.navigatorShown {
            if let projectToolsViewController = windowController.projectToolsViewController {
                if projectToolsViewController.isTabItemSelected(withName: "StyloCore-ProjectOutline") {
                    projectToolsViewController.selectedProjectOutlinesViewController?.enableUserInteractions()
                }
            }
            windowController.projectOutlineTitleViewController?.outlinesButton?.isEnabled = true
        }
    }
    
    private var projectOutlinePanel: NavigatorTool? {
        
        let bundle = Bundle(for: MacStyloDocument.self)
        let projectOutlineStoryboard = NSStoryboard(name: NSStoryboard.Name(string: "ProjectOutline"), bundle: bundle)
        guard let projectOutlinesTabViewController = projectOutlineStoryboard.instantiateInitialController() as? ProjectOutlinesTabViewController else {
            assertionFailure("Error: ProjectOutline storyboard initial controller returned nil")
            return nil
        }
        
        projectOutlinesTabViewController.representedObject = self.documentManager
        
        guard let buttonImage = NSImage(systemSymbolName: "folder", accessibilityDescription: "Files Navigator") else {
            assertionFailure("Error: directory-sidebar-icon is nil")
            return nil
        }
        
        return NavigatorTool(originPluginName: "ProjectOutline", title: "Files", order: PanelOrder.files, viewController: projectOutlinesTabViewController, buttonImage: buttonImage, buttonTooltip: "Show Files Outline")
        
    }
    
}
