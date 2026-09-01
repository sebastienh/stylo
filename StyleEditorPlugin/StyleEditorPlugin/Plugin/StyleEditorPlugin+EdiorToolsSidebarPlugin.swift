//
//  StyleEditorPlugin+EdiorToolsSidebarPlugin.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2019-12-31.
//  Copyright © 2019 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import StyloCoreMac

extension StyleEditorPlugin: EdiorToolsSidebarPlugin {

    public var topToolsButtons: [DisableableButton]? {
        
        return nil
    }
    
    public var middleToolsButtons: [DisableableButton]? {
        
        guard StyloApplication.shared.styleEditorPluginCanWrite else {
            return nil
        }
        
        guard let showStylesListButton = self.showStylesListButton else {
            assertionFailure("Error: self.showStylesListButton is nil")
            return nil
        }
        
        return [showStylesListButton]
    }
    
    private var showStylesListButton: MacDisableableButton? {

        let button = AppearanceFollowerButton()
        button.setButtonType(NSButton.ButtonType.toggle)
        button.bezelStyle = .regularSquare
        button.isBordered = false
        button.isTransparent = false
        button.image = NSImage(named: NSImage.Name("brush"))
        button.action = #selector(StyleEditorPlugin.toggleStylesList(_:))
        button.target = self
        button.identifier = NSUserInterfaceItemIdentifier(StyloConstants.ViewIdentifiers.ToolsStylesButton)
        return button
    }
}
