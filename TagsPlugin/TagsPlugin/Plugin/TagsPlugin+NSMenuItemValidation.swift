//
//  TagsPlugin+NSMenuItemValidation.swift
//  TagsPlugin
//
//  Created by Sebastien Hamel on 2020-06-11.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os

extension TagsPlugin: NSMenuItemValidation {
    
    /// [see](https://macosx.com/threads/setenabled-doesnt-work-on-an-nsmenuitem.13853/)
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {

        if let tag = MenuItemTag(rawValue: menuItem.tag) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Validating menu item: %@", log: Log.Tags.all, type: .info, %%tag)
            #endif
            
            guard let selectedFilesOutlineTagsManager = self.selectedFilesOutlineTagsManager else {
                assertionFailure("Error: self.selectedFilesOutlineTagsManager is nil")
                return false
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("selectedFilesOutlineTagsManager.valuesNotEmpty.value: %@", log: Log.Tags.all, type: .info, %%selectedFilesOutlineTagsManager.valuesNotEmpty.value)
            os_log("selectedFilesOutlineTagsManager.selectionNotEmpty.value: %@", log: Log.Tags.all, type: .info, %%selectedFilesOutlineTagsManager.selectionNotEmpty.value)
            os_log("self.fileOutlineTagsViewController: %@", log: Log.Tags.all, type: .info, %%self.fileOutlineTagsViewController)
            os_log("self.fileOutlineTagsViewController.view.window: %@", log: Log.Tags.all, type: .info, %%self.fileOutlineTagsViewController?.view.window)
            os_log("selectedFilesOutlineTagsManager.allValuesSelected: %@", log: Log.Tags.all, type: .info, %%selectedFilesOutlineTagsManager.allValuesSelected)
            #endif
            
            switch tag {
            case .selectAll:
                // we can select all values if there is values and if they are
                // not already all selected
                return selectedFilesOutlineTagsManager.valuesNotEmpty.value && !selectedFilesOutlineTagsManager.allValuesSelected
            case .unselectAll:
                return selectedFilesOutlineTagsManager.selectionNotEmpty.value
            case .previous:
                return selectedFilesOutlineTagsManager.selectionNotEmpty.value
            case .next:
                return selectedFilesOutlineTagsManager.selectionNotEmpty.value
            case .filteringMode:
                guard let fileOutlineTagsViewController = self.fileOutlineTagsViewController else {
                    return false
                }
                return fileOutlineTagsViewController.view.window != nil && selectedFilesOutlineTagsManager.valuesNotEmpty.value
            case .valuesFilteringMode:
                
                updateSelectedFilteringMode(forMenuItem: menuItem)
                guard let fileOutlineTagsViewController = self.fileOutlineTagsViewController else {
                    return false
                }
                return fileOutlineTagsViewController.view.window != nil && selectedFilesOutlineTagsManager.valuesNotEmpty.value
            case .attributesFilteringMode:
                
                updateSelectedFilteringMode(forMenuItem: menuItem)
                guard let fileOutlineTagsViewController = self.fileOutlineTagsViewController else {
                    return false
                }
                return fileOutlineTagsViewController.view.window != nil && selectedFilesOutlineTagsManager.valuesNotEmpty.value
            }
        }
        return false
    }
    
    private func updateSelectedFilteringMode(forMenuItem menuItem: NSMenuItem) {
        
        guard let selectedFilesOutlineTagsManager = self.selectedFilesOutlineTagsManager else {
            assertionFailure("Error: self.selectedFilesOutlineTagsManager is nil")
            return
        }
        
        guard let tag = MenuItemTag(rawValue: menuItem.tag) else {
            assertionFailure("Error: tag is nil")
            return
        }
            
        switch selectedFilesOutlineTagsManager.attributesMode.value {
            
        case .attributes:
            switch tag {
            case .valuesFilteringMode:
                menuItem.state = .off
            case .attributesFilteringMode:
            menuItem.state = .on
            default:
                break
            }
            
        case .values:
            switch tag {
            case .valuesFilteringMode:
                menuItem.state = .on
            case .attributesFilteringMode:
                menuItem.state = .off
            default:
            break
            }
        }
    }
    
}
