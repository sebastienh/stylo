//
//  AppDelegate+NSMenuItemValidation.swift
//  Stylo
//
//  Created by Sebastien hamel on 2018-12-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import StyloCoreMac

extension AppDelegate: NSMenuItemValidation {
    
    private var lightModeMenuItemState: NSControl.StateValue {
        
        if let userSelectedAppearance = StyloApplication.shared.userSelectedAppearance.value {
            
            switch userSelectedAppearance {
            case .dark:
                return .off
            case .light:
                return .on
            }
        }
        else {
            return .off
        }
    }
    
    private var darkModeMenuItemState: NSControl.StateValue {
        
        if let userSelectedAppearance = StyloApplication.shared.userSelectedAppearance.value {
            
            switch userSelectedAppearance {
            case .dark:
                return .on
            case .light:
                return .off
            }
        }
        else {
            return .off
        }
    }
        
    private var systemModeMenuItemState: NSControl.StateValue {
        
        if StyloApplication.shared.userSelectedAppearance.value == nil {
            return .on
        }
        else {
            return .off
        }
    }
    
    private var sentenceFocusMenuItemState: NSControl.StateValue {
        
        switch StyloApplication.shared.focusMode.value {
        case .disabled:
            return .off
        case .enabled(let focusType):
            switch focusType {
            case .bloc:
                return .off
            case .paragraph:
                return .off
            case .sentence:
                return .on
            case .flash:
                return .off
            }
        }
    }
    
    private var paragraphFocusMenuItemState: NSControl.StateValue {
        
        switch StyloApplication.shared.focusMode.value {
        case .disabled:
            return .off
        case .enabled(let focusType):
            switch focusType {
            case .bloc:
                return .off
            case .paragraph:
                return .on
            case .sentence:
                return .off
            case .flash:
                return .off
            }
        }
    }
    
    private var blocFocusMenuItemState: NSControl.StateValue {
        
        switch StyloApplication.shared.focusMode.value {
        case .disabled:
            return .off
        case .enabled(let focusType):
            switch focusType {
            case .bloc:
                return .on
            case .paragraph:
                return .off
            case .sentence:
                return .off
            case .flash:
                return .off
            }
        }
    }
    
    /// [see](https://macosx.com/threads/setenabled-doesnt-work-on-an-nsmenuitem.13853/)
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        
        if let tag = MenuItemTag(rawValue: menuItem.tag) {
            
            switch tag {
            case .copySelector:
                return copySelectorMenuItemEnabledState(menuItem)
            case .darkMode:
                menuItem.state = darkModeMenuItemState
            case .lightMode:
                menuItem.state = lightModeMenuItemState
            case .systemMode:
                menuItem.state = systemModeMenuItemState
            case .disableFocus:
                switch StyloApplication.shared.focusMode.value {
                case .disabled:
                    return false
                case .enabled:
                    return true
                }
            case .sentenceFocus:
                menuItem.state = sentenceFocusMenuItemState
            case .paragraphFocus:
                menuItem.state = paragraphFocusMenuItemState
            case .blocFocus:
                menuItem.state = blocFocusMenuItemState
            default:
                return true
            }
        }
        return true
    }
    
    private func copySelectorMenuItemEnabledState(_ menuItem: NSMenuItem) -> Bool {
        
        let displayedWindowController = NSApplication.shared.mainWindow?.windowController
        let styloWindowController = displayedWindowController as? StyloWindowController
        
        // if there is no window this may be nil of course...
        if let styloWindowController = styloWindowController {
            
            styloWindowController.elementSelection = nil
//            let elementSelection = styloWindowController.markdownResourceEditorView?.elementSelection
//            styloWindowController.elementSelection = elementSelection
//            return styloWindowController.elementSelection != nil
            
        }
        return false
    }
}
