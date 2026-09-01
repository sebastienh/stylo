//
//  MacStyloDocument+StylesMenu.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-06.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

extension MacStyloDocument {
    
    public var selectedStyleTitle: String? {
        
        guard let stylesMenuItem = self.stylesMenuItem else {
            assertionFailure("Error: self.stylesMenu is nil")
            return nil
        }
        
        guard let stylesMenu = stylesMenuItem.submenu else {
            assertionFailure("Error: stylesMenuItem.submenu is nil")
            return nil
        }
            
        for item in stylesMenu.items {
            if item.state == .on {
                return item.title
            }
        }
        return nil
    }
    
    private var stylesMenuItem: NSMenuItem? {
        
        return NSApplication.shared.stylesListChoiceMenu
    }
    
    @IBAction func updateSelectedStyle(_ sender: NSMenuItem?) {
        
        guard let menuItem = sender else {
            assertionFailure("Error: menuItem is nil")
            return
        }
        
        updateSelectedStyle(toStyleWithTitle: menuItem.title)
    }
    
    public func updateSelectedStyle(toStyleWithTitle title: String) {
        
        guard let styleMenuIdentifiersList = self.styleMenuIdentifiersList else {
            assertionFailure("Error: self.styleMenuIdentifiersList is nil")
            return
        }
        
        guard let styleMenuIdentifier = styleMenuIdentifiersList.stylesMenuIdentifiers[title] else {
            assertionFailure("Error: styleMenuIdentifier is nil for \(title)")
            return
        }
        
        guard let styleManager = styleMenuIdentifier.styleManager else {
            assertionFailure("Error: styleManager is nil")
            return
        }
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return
        }
        
        // calling directly the document does not display the progress indicator.
        windowController.applyStyle(from: styleManager)
    }
    
    func subscribeToSourceSetManager() {
        
        startListeningToStyleManagers()
        startListeningToSelectedStyleManager()
    }
    
    func unsubscribeToSourceSetManager() {

        self.styleSetManager?.styleManagers.unsubscribe(observer: self)
        self.styleSetManager?.selectedStyleManager.unsubscribe(observer: self)
    }
    
    public func populateStylesMenu() {
    
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        populateStylesMenu(stylesManagers: documentManager.styleSetManager.styleManagers.values)
    }
        
    public func handleSelectedStyleManager() {
        
        guard let styleSetManager = self.styleSetManager else {
            assertionFailure("Error: self.styleSetManager is nil")
            return
        }
        
        handleSelectedStyleManager(styleManager: styleSetManager.selectedStyleManager.value)
    }
    
    private func handelStyleManagersChanged(_ change: DynamicArray<StyleManager>.Change) {
        switch change {
        case .deletes(_, _, let updatedArray):
            self.populateStylesMenu(stylesManagers: updatedArray)
        case .insert(_, _, let updatedArray):
            self.populateStylesMenu(stylesManagers: updatedArray)
        case .inserts(_, _, let updatedArray):
            self.populateStylesMenu(stylesManagers: updatedArray)
        case .move(_, _, _, let updatedArray):
            self.populateStylesMenu(stylesManagers: updatedArray)
        case .start:
            assertionFailure("Error: unhandled change")
            break
        case .end:
            assertionFailure("Error: unhandled change")
            break
        }
    }
    
    private func populateStylesMenu(stylesManagers: [StyleManager]) {
        
        let styleMenuIdentifiersList = StyleMenuIdentifiersList(stylesManagers: stylesManagers)
        
        guard let stylesMenuItem = self.stylesMenuItem else {
            assertionFailure("Error: self.stylesMenu is nil")
            return 
        }
        
        let stylesMenu: NSMenu = {
           
            if let submenu = stylesMenuItem.submenu {
                return submenu
            }
            
            let submenu = NSMenu(title: stylesMenuItem.title)
            stylesMenuItem.submenu = submenu
            return submenu
        }()
        
        stylesMenu.removeAllItems()
        
        let identifiers = styleMenuIdentifiersList.stylesMenuIdentifiers.sorted { (first, second) -> Bool in
            return first.key < second.key
        }
        
        for (title, _) in identifiers {
            
            let menuItem = NSMenuItem(title: title, action: #selector(self.updateSelectedStyle(_:)), keyEquivalent: "")
            menuItem.target = self
            stylesMenu.addItem(menuItem)
        }
        
        self.styleMenuIdentifiersList = styleMenuIdentifiersList
    }

    private func startListeningToStyleManagers() {
        
        guard let styleSetManager = self.styleSetManager else {
            assertionFailure("Error: self.styleSetManager is nil")
            return
        }
        
        styleSetManager.styleManagers.subscribe({ [weak self](change) in
            self?.handelStyleManagersChanged(change)
        }, observer: self)
    }
    
    private func startListeningToSelectedStyleManager() {
        
        guard let styleSetManager = self.styleSetManager else {
            assertionFailure("Error: self.styleSetManager is nil")
            return
        }
        
        styleSetManager.selectedStyleManager.subscribe({ [weak self](newSelectedStyleManager) in
            self?.handleSelectedStyleManager(styleManager: newSelectedStyleManager)
        }, observer: self)
    }
    
    private func handleSelectedStyleManager(styleManager: StyleManager?) {
        
        guard let styleManager = styleManager else {
            assertionFailure("Error: styleManager is nil")
            return
        }
        
        self.deselectAllStyles()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        // select the new menu item
        os_log("styleName: %@", log: Log.StyloCore.all, type: .info, %%styleManager.title)
        #endif
        
        self.selectStyleName(name: styleManager.title)
    }
    
    private func deselectAllStyles() {
        
        guard let stylesMenuItem = self.stylesMenuItem else {
            assertionFailure("Error: self.stylesMenu is nil")
            return
        }
        
        guard let stylesMenu = stylesMenuItem.submenu else {
            assertionFailure("Error: stylesMenuItem.submenu is nil")
            return
        }
            
        for item in stylesMenu.items {
            item.state = NSControl.StateValue.off
        }
    }
    
    private func selectStyleName(name: String) {
        
        guard let stylesMenuItem = self.stylesMenuItem else {
            assertionFailure("Error: self.stylesMenu is nil")
            return
        }
        
        guard let stylesMenu = stylesMenuItem.submenu else {
            assertionFailure("Error: stylesMenuItem.submenu is nil")
            return
        }
        
        for item in stylesMenu.items {
            if item.title == name {
                item.state = NSControl.StateValue.on
            }
        }
    }
}
