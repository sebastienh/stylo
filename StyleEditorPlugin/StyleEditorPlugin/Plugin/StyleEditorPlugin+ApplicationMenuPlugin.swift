//
//  StyleEditorPlugin+ApplicationMenuPlugin.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2019-12-31.
//  Copyright © 2019 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import Cocoa

extension StyleEditorPlugin: ApplicationMenuPlugin {
    
    // case startNewRecording = 26
    // case showHideProjectTools = 27
    public static var applicationMenu: NSMenuItem? {
        
        guard StyloApplication.shared.styleEditorPluginCanWrite else {
            return nil 
        }
            
        let stylesMenu = NSMenuItem(title: "Styles", action: nil, keyEquivalent: "")
        stylesMenu.submenu = NSMenu(title: "Styles")
        
        // Show Styles
        let showStylesMenuItem = NSMenuItem(title: "Show Styles", action: nil, keyEquivalent: "")
        showStylesMenuItem.action = #selector(StyleEditorPlugin.toggleStylesList(_:))
        showStylesMenuItem.tag = §MenuItemTag.toggleStylesList
        showStylesMenuItem.keyEquivalent = "s"
        showStylesMenuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.shift, NSEvent.ModifierFlags.command]
        showStylesMenuItem.target = nil
        stylesMenu.submenu?.addItem(showStylesMenuItem)
        
        // Add Style
        let addStyleMenuItem = NSMenuItem(title: "Add Style", action:  #selector(StyleEditorPlugin.addStyle(_:)), keyEquivalent: "a")
        addStyleMenuItem.tag = §MenuItemTag.addStyle
        addStyleMenuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.shift, NSEvent.ModifierFlags.command]
        addStyleMenuItem.target = nil
        stylesMenu.submenu?.addItem(addStyleMenuItem)
        
        // Open Style Inspector
        let editStyleMenuItem = NSMenuItem(title: Strings.shared.openStyleInspector, action:  #selector(StyleEditorPlugin.editStyle(_:)), keyEquivalent: "e")
        editStyleMenuItem.tag = §MenuItemTag.openStyleInspector
        editStyleMenuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.shift, NSEvent.ModifierFlags.command]
        editStyleMenuItem.target = nil
        stylesMenu.submenu?.addItem(editStyleMenuItem)
        
        // Apply Pending Style Changes
        let applyPendingStyleChangesMenuItem = NSMenuItem(title: "Update Document Style", action:  #selector(StyleEditorPlugin.applyPendingStyleChanges(_:)), keyEquivalent: "c")
        applyPendingStyleChangesMenuItem.tag = §MenuItemTag.applyStyle
        applyPendingStyleChangesMenuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.shift, NSEvent.ModifierFlags.command]
        applyPendingStyleChangesMenuItem.target = nil
        stylesMenu.submenu?.addItem(applyPendingStyleChangesMenuItem)
        
        stylesMenu.submenu?.addItem(NSMenuItem.separator())
        
        // Dismiss stylesheet
        let dismissStylesheetMenuItem = NSMenuItem(title: "Dismiss Stylesheet", action:  #selector(StyleEditorPlugin.dismissStylesheetEditor(_:)), keyEquivalent: "h")
        dismissStylesheetMenuItem.tag = §MenuItemTag.dismissStylesheet
        dismissStylesheetMenuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.shift, NSEvent.ModifierFlags.command]
        dismissStylesheetMenuItem.target = nil
        stylesMenu.submenu?.addItem(dismissStylesheetMenuItem)
        
        // Show Issues
        let showIssuesMenuItem = NSMenuItem(title: "Show Issues", action:  #selector(StyleEditorPlugin.showIssues(_:)), keyEquivalent: "i")
        showIssuesMenuItem.tag = §MenuItemTag.showHideCssIssues
        showIssuesMenuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.shift, NSEvent.ModifierFlags.command]
        showIssuesMenuItem.target = nil
        stylesMenu.submenu?.addItem(showIssuesMenuItem)
        

        
        return stylesMenu
    }
    
}

