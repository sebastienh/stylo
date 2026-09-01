//
//  NSApplication+CopySelectorMenuItem.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-19.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common

extension NSApplication {
    
    var copySelectorMenuItem: NSMenuItem? {
        
        let editMenu = self.mainMenu?.item(withTag: §MenuItemTag.edit)?.submenu
        
        assert(editMenu != nil)
        return editMenu?.item(withTag: §MenuItemTag.copySelector)
    }
    
    var stylesListChoiceMenu: NSMenuItem? {
        
        let viewMenu = self.mainMenu?.item(withTag: §MenuItemTag.view)?.submenu
        
        assert(viewMenu != nil)
        return viewMenu?.item(withTag: §MenuItemTag.stylesListChoice)
    }
    
    var showHideHtmlPreviewMenuItem: NSMenuItem? {
        
        let viewMenu = self.mainMenu?.item(withTag: §MenuItemTag.view)?.submenu
        
        assert(viewMenu != nil)
        let showHideHtmlPreviewMenuItem = viewMenu?.item(withTag: §MenuItemTag.showHideHtmlPreview)
        
        assert(showHideHtmlPreviewMenuItem != nil)
        return showHideHtmlPreviewMenuItem
    }
}
