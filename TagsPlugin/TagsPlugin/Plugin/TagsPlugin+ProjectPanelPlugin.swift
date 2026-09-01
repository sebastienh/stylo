//
//  TagsPlugin+ProjectPanelPlugin.swift
//  TagsPlugin
//
//  Created by Sebastien Hamel on 2020-06-04.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon

extension TagsPlugin: ProjectPanelPlugin {

    public var projectPanels: [NavigatorTool]? {
        
        let buttonImageName = "tag"
        let storyboardStringName = "Tags"
        let storyboardName = NSStoryboard.Name(string: storyboardStringName)
        
        let pluginBundle = Bundle(for: type(of: self))
        
        let storyboard = NSStoryboard(name: storyboardName, bundle: pluginBundle)
        guard let projectTagsTabViewController = storyboard.instantiateInitialController() as? ProjectTagsTabViewController else {
            assertionFailure("Error: storyboard initial controller is not ProjectTagsTabViewController")
            return nil
        }
        
        projectTagsTabViewController.tagsPlugin = self
        projectTagsTabViewController.representedObject = self.documentManager
        self.projectTagsTabViewController = projectTagsTabViewController
        
        guard let buttonImage = NSImage(systemSymbolName: "tag", accessibilityDescription: "Tags Tool") else {
            assertionFailure("Error: no image named \"\(buttonImageName)\"")
            return nil
        }
        
        return [NavigatorTool(originPluginName: storyboardStringName, title: "Tags", order: PanelOrder.tags, viewController: projectTagsTabViewController, buttonImage: buttonImage, buttonTooltip: "Show Tags")]
    }
    
    func documentWillDisableProjectPanel() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("TagsPlugin.documentWillDisableProjectPanel()", log: Log.Tags.all, type: .debug)
        #endif
        
        guard let projectTagsTabViewController = self.projectTagsTabViewController else {
            assertionFailure("Error: self.projectTagsTabViewController is nil")
            return
        }
        
        projectTagsTabViewController.disableSelectedPanel()
    }
    
    func documentWillEnableProjectPanel() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("TagsPlugin.documentWillDisableProjectPanel()", log: Log.Tags.all, type: .debug)
        #endif
        
        guard let projectTagsTabViewController = self.projectTagsTabViewController else {
            assertionFailure("Error: self.projectTagsTabViewController is nil")
            return
        }
        
        projectTagsTabViewController.enableSelectedPanel()
    }
    
}
