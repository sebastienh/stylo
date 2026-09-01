//
//  AddTextButton.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-12-24.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class ToolbarButtonBackground: ColoredView {
    
    @objc dynamic var isEnabled: Bool = false
    
    private var mouseInside: Bool = false {
        didSet {
            self.updateBackground()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(.activeInKeyWindow).union(.mouseEnteredAndExited).union(.mouseMoved), owner: self, userInfo: nil))
        self.backgroundColor = NSColor.clear
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.mouseInside = true
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.mouseInside = false
    }
    
    private func updateBackground() {
        if isEnabled && self.mouseInside {
            self.backgroundColor = nsColor(named: "toolbarMouseOverBackgroundColor", bundle: self.bundle)
        }
        else {
            self.backgroundColor = NSColor.clear
        }
    }
}
