//
//  TagsPlugin+ApplicationMenuPlugin.swift
//  TagsPlugin
//
//  Created by Sebastien Hamel on 2020-06-11.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

extension TagsPlugin: ApplicationMenuPlugin {
    
    // case startNewRecording = 26
    // case showHideProjectTools = 27
    public static var applicationMenu: NSMenuItem? {
        
        let tagsMenu = NSMenuItem(title: "Tags", action: nil, keyEquivalent: "")
        tagsMenu.submenu = NSMenu(title: "Tags")
        
        let selectAllTagsMenuItem = NSMenuItem(title: "Select All", action:  #selector(TagsPlugin.selectAllTags(_:)), keyEquivalent: "a")
        selectAllTagsMenuItem.target = nil
        selectAllTagsMenuItem.tag = §MenuItemTag.selectAll
        selectAllTagsMenuItem.keyEquivalentModifierMask = [.control, .command]
        tagsMenu.submenu?.addItem(selectAllTagsMenuItem)

        let unselectAllTagsMenuItem = NSMenuItem(title: "Unselect All", action:  #selector(TagsPlugin.unselectAllTags(_:)), keyEquivalent: "u")
        unselectAllTagsMenuItem.target = nil
        unselectAllTagsMenuItem.tag = §MenuItemTag.unselectAll
        unselectAllTagsMenuItem.keyEquivalentModifierMask = [.control, .command]
        tagsMenu.submenu?.addItem(unselectAllTagsMenuItem)
        
        let previousTagMenuItem = NSMenuItem(title: "Go to Previous", action:  #selector(TagsPlugin.previousTag(_:)), keyEquivalent: "")
        previousTagMenuItem.tag = §MenuItemTag.previous
        previousTagMenuItem.target = nil
        let upCharacters = [unichar(NSUpArrowFunctionKey)]
        previousTagMenuItem.keyEquivalent = NSString(characters: upCharacters, length: 1) as String
        previousTagMenuItem.keyEquivalentModifierMask = [.control, .command]
        tagsMenu.submenu?.addItem(previousTagMenuItem)
        
        let nextTagMenuItem = NSMenuItem(title: "Go to Next", action:  #selector(TagsPlugin.nextTag(_:)), keyEquivalent: "")
        nextTagMenuItem.tag = §MenuItemTag.next
        nextTagMenuItem.target = nil
        let downCharacters = [unichar(NSDownArrowFunctionKey)]
        nextTagMenuItem.keyEquivalent = NSString(characters: downCharacters, length: 1) as String
        nextTagMenuItem.keyEquivalentModifierMask = [.control, .command]
        tagsMenu.submenu?.addItem(nextTagMenuItem)
        
        let filteringModeMenuItem = NSMenuItem(title: "Filtering Mode", action: nil, keyEquivalent: "")
        filteringModeMenuItem.tag = §MenuItemTag.filteringMode
        filteringModeMenuItem.target = nil
        filteringModeMenuItem.submenu = NSMenu(title: "Filtering Mode")
        tagsMenu.submenu?.addItem(filteringModeMenuItem)

        let valuesFilteringModeMenuItem = NSMenuItem(title: "Values", action:  #selector(TagsPlugin.selectValuesFilteringMode(_:)), keyEquivalent: "")
        valuesFilteringModeMenuItem.target = nil
        valuesFilteringModeMenuItem.tag = §MenuItemTag.valuesFilteringMode
        valuesFilteringModeMenuItem.keyEquivalent = ""
        valuesFilteringModeMenuItem.keyEquivalentModifierMask = [.control, .command]
        filteringModeMenuItem.submenu?.addItem(valuesFilteringModeMenuItem)
        
        let attributesFilteringModeMenuItem = NSMenuItem(title: "Attributes", action:  #selector(TagsPlugin.selectAtrributesFilteringMode(_:)), keyEquivalent: "")
        attributesFilteringModeMenuItem.tag = §MenuItemTag.attributesFilteringMode
        attributesFilteringModeMenuItem.target = nil
        attributesFilteringModeMenuItem.keyEquivalent = ""
        attributesFilteringModeMenuItem.keyEquivalentModifierMask = [.control, .command]
        filteringModeMenuItem.submenu?.addItem(attributesFilteringModeMenuItem)
        
        return tagsMenu
    }
    
    @IBAction func selectAllTags(_ sender: AnyObject?) {
        
        guard let selectedFilesOutlineTagsManager = self.selectedFilesOutlineTagsManager else {
            assertionFailure("Error: self.selectedFilesOutlineTagsManager is nil")
            return
        }
        
        assert(selectedFilesOutlineTagsManager.valuesCount.value != 0)
        selectedFilesOutlineTagsManager.selectAllTags()
        
        self.fileOutlineTagsViewController?.tagsCollectionViewController?.tagsCollectionView.resetFlashedItems()
    }
    
    @IBAction func unselectAllTags(_ sender: AnyObject?) {
        
        guard let selectedFilesOutlineTagsManager = self.selectedFilesOutlineTagsManager else {
            assertionFailure("Error: self.selectedFilesOutlineTagsManager is nil")
            return
        }
        
        assert(selectedFilesOutlineTagsManager.selectionNotEmpty.value)
        selectedFilesOutlineTagsManager.unselectAllTags()
        
        self.fileOutlineTagsViewController?.tagsCollectionViewController?.tagsCollectionView.resetFlashedItems()
    }

    @IBAction func previousTag(_ sender: AnyObject?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("previousTag(%@)", log: Log.Tags.all, type: .info, %%sender)
        #endif
        
        guard let selectedFilesOutlineTagsManager = self.selectedFilesOutlineTagsManager else {
            assertionFailure("Error: self.selectedFilesOutlineTagsManager is nil")
            return
        }
        
        assert(selectedFilesOutlineTagsManager.selectionNotEmpty.value)
        selectedFilesOutlineTagsManager.scrollToPreviousTag()
    }

    @IBAction func nextTag(_ sender: AnyObject?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("nextTag(%@)", log: Log.Tags.all, type: .info, %%sender)
        #endif
        
        guard let selectedFilesOutlineTagsManager = self.selectedFilesOutlineTagsManager else {
            assertionFailure("Error: self.selectedFilesOutlineTagsManager is nil")
            return
        }
        
        assert(selectedFilesOutlineTagsManager.selectionNotEmpty.value)
        selectedFilesOutlineTagsManager.scrollToNextTag()
    }
    
    @IBAction func selectValuesFilteringMode(_ sender: AnyObject?) {
        
        guard let selectedFilesOutlineTagsManager = self.selectedFilesOutlineTagsManager else {
            assertionFailure("Error: self.selectedFilesOutlineTagsManager is nil")
            return
        }
        
        assert(selectedFilesOutlineTagsManager.valuesNotEmpty.value)
        selectedFilesOutlineTagsManager.setValuesSortingMode()
    }
    
    @IBAction func selectAtrributesFilteringMode(_ sender: AnyObject?) {
        
        guard let selectedFilesOutlineTagsManager = self.selectedFilesOutlineTagsManager else {
            assertionFailure("Error: self.selectedFilesOutlineTagsManager is nil")
            return
        }
        
        assert(selectedFilesOutlineTagsManager.valuesNotEmpty.value)
        selectedFilesOutlineTagsManager.setAttributesSortingMode()
    }
    
}
