//
//  StyleEditorPlugin+NSMenuItemValidation.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2019-12-31.
//  Copyright © 2019 Sebastien hamel. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac

extension StyleEditorPlugin: NSMenuItemValidation {
    
    /// [see](https://macosx.com/threads/setenabled-doesnt-work-on-an-nsmenuitem.13853/)
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {

        if let tag = MenuItemTag(rawValue: menuItem.tag) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Validating menu item: %@", log: Log.MacWriterCommon.all, type: .info, %%tag)
            #endif
            
            switch tag {
        
            case .deleteStyle:
                if stylesToolsShown && !currentlyEditingCssStylesheet {
                    return true
                }
                return false
                
            case .style:
                
                if !toolsCollapsed && currentlyEditingCssStylesheet {
                    return true
                }
                return false
                
            case .showHideCssIssues:
                
                if stylesToolsShown && currentlyEditingCssStylesheet && !styleShown {
                    if let stylesheetHasIssues = self.stylesheetHasIssues, stylesheetHasIssues {
                        if self.issuesPanelShown {
                            menuItem.title = Strings.shared.dismissIssues
                            menuItem.action = #selector(StyleEditorPlugin.dismissIssues(_:))
                        }
                        else {
                            menuItem.title = Strings.shared.showIssues
                            menuItem.action = #selector(StyleEditorPlugin.showIssues(_:))
                        }
                        return true
                    }
                    else if self.issuesPanelShown {
                        menuItem.title = Strings.shared.dismissIssues
                        menuItem.action = #selector(StyleEditorPlugin.dismissIssues(_:))
                        return true
                    }
                }
                return false
                
            case .applyStyle:
                
                if styleShown && styleHasPendingChanges {
                        
                    menuItem.title = Strings.shared.updateDocumentStyle
                    menuItem.action = #selector(StyleEditorPlugin.applyPendingStyleChanges(_:))
                    return true
                }
                return false
                
            case .openStyleInspector:
                
                guard stylesToolsShown else {
                    menuItem.title = Strings.shared.openStyleInspector
                    menuItem.action = #selector(StyleEditorPlugin.editStyle(_:))
                    return false
                }
                
                guard !currentlyEditingCssStylesheet else {
                    menuItem.title = Strings.shared.dismissStyle
                    menuItem.action = #selector(StyleEditorPlugin.dismissStyleEditor(_:))
                    return false
                }
                
                if styleShown && !toolsCollapsed {
                    menuItem.title = Strings.shared.dismissStyle
                    menuItem.action = #selector(StyleEditorPlugin.dismissStyleEditor(_:))
                    return true
                }
                else {
                    menuItem.title = Strings.shared.openStyleInspector
                    menuItem.action = #selector(StyleEditorPlugin.editStyle(_:))
                    return true
                }
            
            case .addStyle:
                if stylesListShown && !toolsCollapsed && !currentlyEditingCssStylesheet {
                    return true
                }
                return false
                
            case .toggleStylesList:
                                    
                if stylesToolsShown && !toolsCollapsed {
                    menuItem.title = Strings.shared.hideStyles
                }
                else {
                    menuItem.title = Strings.shared.showStyles
                }
                menuItem.action = #selector(StyleEditorPlugin.toggleStylesList(_:))
                return true
            case .editStylesheet:
                return true
            case .dismissStylesheet:
                if stylesToolsShown && !toolsCollapsed && currentlyEditingCssStylesheet{
                    return true
                }
                return false
            }
        }
        return false
    }
}
