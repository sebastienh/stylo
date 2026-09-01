//
//  StyloApplication+ThemesMenuItems.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-14.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon

extension StyloApplication {
    
    public func populateThemesMenu(themesMenu: NSMenu) {
        
        assert(self.printThemeSetManager != nil)
        if let printThemeSetManager = self.printThemeSetManager {
            
            for themeManager in printThemeSetManager.themeManagers {
                
                let menuItem = NSMenuItem(title: themeManager.name.value, action: #selector(self.selectTheme(_:)), keyEquivalent: "")
                menuItem.target = self
                themesMenu.addItem(menuItem)
            }
        }
    }
    
    @objc func selectTheme(_ sender: NSMenuItem) {
                
        let themeName = sender.title
        selectPrintTheme(with: themeName)
    }
}
