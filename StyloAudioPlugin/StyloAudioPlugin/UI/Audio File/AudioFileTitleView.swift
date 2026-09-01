//
//  AudioFileTitleView.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-13.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa

class AudioFileTitleView: NSView {
    
    @IBOutlet var audioTrashButton: NSButton! {
        didSet {
            audioTrashButton.isHidden = true
        }
    }
    
    var selected: Bool = false {
        didSet {
            self.updateAudioTrashButtonHiddenState()
        }
    }
    
    private var mouseInside: Bool = false {
        didSet {
            self.updateAudioTrashButtonHiddenState()
        }
    }
    
    private var audioOutlineView: AudioOutlineView? {
        
        var view: NSView? = self
        while view != nil {
            
            if let outlineView = view as? AudioOutlineView {
                return outlineView
            }
            view = view?.superview
        }
        return nil
    }
    
    override init(frame: NSRect) {
        
        super.init(frame: frame)
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
//    // Autolayout
//    override func mouseDown(with event: NSEvent) {
//        
//        // only if the text field is selected
//        if selected {
//            super.mouseDown(with: event)
//        }
//        else {
//            self.nextResponder?.mouseDown(with: event)
//        }
//    }
    
    // In the textfield subclass:
    override func mouseEntered(with event: NSEvent) {
        
        self.mouseInside = true
        super.mouseEntered(with: event)
    }
    
    // In the textfield subclass:
    override func mouseExited(with event: NSEvent) {
        
        self.mouseInside = false
        super.mouseExited(with: event)
    }
    
    private func updateAudioTrashButtonHiddenState() {
        
        if selected || mouseInside {
            audioTrashButton.animator().isHidden = false
        }
        else {
            audioTrashButton.animator().isHidden = true
        }
    }
    
}

