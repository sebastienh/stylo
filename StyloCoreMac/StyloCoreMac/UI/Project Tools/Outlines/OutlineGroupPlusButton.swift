//
//  OutlineGroupPlusButton.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-08.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

class OutlineGroupPlusButton: NSPopUpButton {
    
    private var associatedItemId: String? {
    
        guard let projectOutlineCellView = self.superview as? ProjectOutlineCellView else {
            assertionFailure("Error: superview is nil")
            return nil
        }

        guard let projectOutlineItem = projectOutlineCellView.projectOutlineItem else {
            assertionFailure("Error: projectOutlineItem is nil")
            return nil
        }
        
        return projectOutlineItem.id
    }
    
    private var initializedMenuItemsIds: Bool = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        createTrackingArea()
        self.alphaValue = 0.6
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createTrackingArea()
        self.alphaValue = 0.6
    }
    
    override func mouseEntered(with event: NSEvent) {
        self.alphaValue = 1.0
        if !initializedMenuItemsIds {
            self.populateIds(in: self.itemArray)
            initializedMenuItemsIds = true
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        self.alphaValue = 0.6
    }
    
    private func createTrackingArea() {
        
        let options = NSTrackingArea.Options.activeInActiveApp.union(.mouseEnteredAndExited).union(.inVisibleRect)
        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    private func populateIds(in items: [NSMenuItem]) {
        assert(!items.isEmpty, "Error: menu items array is empty")
        for item in items {
            if let outlineAddMenuItem = item as? OutlineAddMenuItem {
                outlineAddMenuItem.itemId = associatedItemId
            }
        }
    }
}
