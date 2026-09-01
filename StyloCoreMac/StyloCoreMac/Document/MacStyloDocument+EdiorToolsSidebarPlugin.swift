//
//  MacStyloDocument+EdiorToolsSidebarPlugin.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon

extension MacStyloDocument: EdiorToolsSidebarPlugin {
    
    public var topToolsButtons: [DisableableButton]? {
        return _topToolsButtons
    }
    
    public var middleToolsButtons: [DisableableButton]? {
        return _middleToolsButtons
    }
    
    public var bigStylesButton: BigStylesSidebarButton {
        
        let button = BigStylesSidebarButton(frame: NSMakeRect(0, 0, 18, 60))
        button.setButtonType(NSButton.ButtonType.momentaryPushIn)
        button.bezelStyle = .regularSquare
        button.isBordered = false
        button.isTransparent = false
        button.action = #selector(Sidebar.selectStylesSidebarViewTab(_:))
        button.target = nil
        button.wantsLayer = true
        button.imageScaling = .scaleProportionallyUpOrDown
        button.widthAnchor.constraint(equalToConstant: 18.0).isActive = true
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 60.0)
        heightConstraint.priority = .dragThatCannotResizeWindow
        heightConstraint.isActive = true
        
        button.identifier = NSUserInterfaceItemIdentifier(StyloConstants.ViewIdentifiers.ToolsBigStylesButton)
        return button
    }
    
    public var showPreviewButton: MacDisableableButton? {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return nil
        }
        
        let button = AppearanceFollowerButton(frame: NSMakeRect(0, 0, 16, 16))
        button.setButtonType(NSButton.ButtonType.momentaryPushIn)
        button.bezelStyle = .regularSquare
        button.isBordered = false
        button.isTransparent = false
        let image = NSImage(named: NSImage.Name("NSQuickLookTemplate"))
        image?.isTemplate = true
        button.image = image
        button.action = #selector(StyloWindowController.toggleHtmlPreview(_:))
        button.target = windowController
        button.wantsLayer = true
        button.toolTip = "Show export window ⌘R"
        button.imageScaling = .scaleProportionallyUpOrDown
        button.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        button.identifier = NSUserInterfaceItemIdentifier(StyloConstants.ViewIdentifiers.ToolsPreviewButton)
        return button
    }
    
}
