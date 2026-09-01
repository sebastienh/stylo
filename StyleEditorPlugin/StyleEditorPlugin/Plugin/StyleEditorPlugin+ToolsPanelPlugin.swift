//
//  StyleEditorPlugin+ToolsPanelPlugin.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-01-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon

extension StyleEditorPlugin: ToolsPanelPlugin {
    
    var toolPanels: [ToolPanel]? {
        
        guard StyloApplication.shared.styleEditorPluginCanWrite else {
            return nil
        }
        
        let buttonImageName = "brush"
        let storyboardStringName = "CSS"
        let storyboardName = NSStoryboard.Name(string: storyboardStringName)
        let pluginBundle = Bundle(for: type(of: self))
        
        let storyboard = NSStoryboard(name: storyboardName, bundle: pluginBundle)
        guard let cssViewController = storyboard.instantiateInitialController() as? CSSViewController else {
            assertionFailure("Error: storyboard initial controller is not CSSViewController")
            return nil
        }
        
        self.cssViewController = cssViewController
        self.cssViewController?.styleEditorPlugin = self
        
        cssViewController.representedObject = documentManager
        
        guard let buttonImage = pluginBundle.image(forResource: NSImage.Name(string: buttonImageName)) else {
            assertionFailure("Error: no image named \"\(buttonImageName)\"")
            return nil
        }
        
        return [ToolPanel(name: storyboardStringName, viewController: cssViewController, buttonImage: buttonImage, buttonTooltip: "Show Styles List")]
        
    }
    
    func toolsPanelDidCollapsed() {
        
        dismissStylesheetEditorIfShown()
    }
}
