//
//  StyloWindowController+MainMenu.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import os
import Common

extension StyloWindowController: NSMenuItemValidation {
    
    private var atLeastOneTextSelected: Bool {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return false
        }
        
        return !documentManager.selectedFilesOutlineSelectedTextItems.values.isEmpty
    }
    
    /// [see](https://macosx.com/threads/setenabled-doesnt-work-on-an-nsmenuitem.13853/)
    public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        
        if let tag = MenuItemTag(rawValue: menuItem.tag) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Validating menu item: %@", log: Log.StyloCore.all, type: .info, %%tag)
            #endif
            
            switch tag {
            case .showHideHtmlPreview:
                
//                if toolsCollapsed {
//                    
//                    if previewShown {
//                        menuItem.title = Strings.shared.hidePreview
//                    }
//                    else {
//                        menuItem.title = Strings.shared.showPreview
//                    }
//                    menuItem.action = #selector(StyloWindowController.toggleHtmlPreview(_:))
//                    return true
//                }
                return false
                
            case .showHideStylePicker:
                
//                if toolsCollapsed && !htmlPreviewTabVisible {
//
//                    if stylePickerShown {
//                        menuItem.title = Strings.shared.hideStylePicker
//                    }
//                    else {
//                        menuItem.title = Strings.shared.showStylePicker
//                    }
//                    menuItem.action = #selector(StyloWindowController.toggleStylePicker(_:))
//                    return true
//                }
                return false
                
            case .showHideEditorSidebarTools:
                
                return false
                
            case .showHideNavigator:
                
                if navigatorShown  {
                    menuItem.title = Strings.shared.hideNavigator
                }
                else {
                    menuItem.title = Strings.shared.showNavigator
                }
                return true
                
            case .editThemes:
                if themesShown {
                    menuItem.title = Strings.shared.dismissThemes
                    menuItem.action = #selector(StyloWindowController.toggleThemesPanel(_:))
                } else {
            
                    menuItem.title = Strings.shared.showThemes
                    menuItem.action = #selector(StyloWindowController.toggleThemesPanel(_:))
                }
                return true
                
//            case .textStatisticsSessionEnabled:
//                if StyloApplication.shared.textStatisticsSessionToolsEnabled {
//                    menuItem.title = Strings.shared.disableTextStatisticsSessionTools
//                    menuItem.action = #selector(StyloWindowController.toggleTextStatisticsSessionToolsEnabledState(_:))
//                }
//                else {
//                    menuItem.title = Strings.shared.enableTextStatisticsSessionTools
//                    menuItem.action = #selector(StyloWindowController.toggleTextStatisticsSessionToolsEnabledState(_:))
//                }
//                return true
                
            case .styles:
                
                let documentType = styloDocument?.documentType.value
                
                if let documentType = documentType, documentType != .stylo {
                    return false
                }
                return true
                
            case .preview:
                menuItem.title = Strings.shared.preview
                menuItem.action = #selector(StyloWindowController.toggleHtmlPreview(_:))
                if self.atLeastOneTextSelected {
                    return true
                }
                else {
                    return false
                }
            case .addFile:
                return self.allowsAddingDirectoryAndTexts
            case .addDirectory:
                return self.allowsAddingDirectoryAndTexts
            case .addGroup:
                return self.allowsAddingGroups
            case .closeCurrentEditorsPane:
                return self.allowsCloseCurrentEditorsPane
            case .addEditorsPane:
                return self.allowsAddEditorsPane
            case .goBack:
                return self.allowsGoBack
            case .goForward:
                return self.allowsGoForward
            case .addTextInCurrentEditorsPane:
                return self.allowsAddingTextInCurrentEditorsPane
            case .disableFocus: fallthrough
            case .sentenceFocus: fallthrough
            case .paragraphFocus: fallthrough
            case .blocFocus: fallthrough
            case .file: fallthrough
            case .edit: fallthrough
            case .format: fallthrough
            case .view: fallthrough
            case .window: fallthrough
            case .help: fallthrough
            case .copySelector: fallthrough
            case .lightMode: fallthrough
            case .darkMode: fallthrough
            case .systemMode: fallthrough
            case .stylesListChoice:
                break
            }
        }
        return true
    }
    
    @IBAction func doNothing(_ sender: AnyObject?) {
        
    }
    
}
