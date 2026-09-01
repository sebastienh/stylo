//
//  StylesheetBox.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-12-10.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class StylesheetBox: NSBox {
    
    @IBOutlet var deleteStylesheetButton: NSButton!
    
    @IBOutlet var editStylesheetButton: NSButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    override func mouseEntered(with event: NSEvent) {
        
        handleMouseOver(true)
    }
    
    override func mouseExited(with event: NSEvent) {
        
        handleMouseOver(false)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func handleMouseOver(_ over: Bool) {
        
        self.deleteStylesheetButton.isHidden = !over
        self.editStylesheetButton.isHidden = !over
    }
}
