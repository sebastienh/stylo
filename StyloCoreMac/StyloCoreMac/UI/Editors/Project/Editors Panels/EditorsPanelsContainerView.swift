//
//  EditorsPanelsContainerView.swift
//
//  Created by Sebastien Hamel on 2020-02-24.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import os

class EditorsPanelsContainerView: NSStackView {
    
    @IBOutlet weak var editorsPanelsCustomSplitView: EditorsPanelsCustomSplitView?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(.activeInKeyWindow).union(.mouseMoved), owner: self, userInfo: nil))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(.activeInKeyWindow).union(.mouseMoved), owner: self, userInfo: nil))
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("mouseDragged(with event: NSEvent) in EditorsPanelsContainerView", log: Log.StyloCore.all, type: .info)
        #endif
        
        assert(self.editorsPanelsCustomSplitView != nil)
        editorsPanelsCustomSplitView?.mouseMoved(with: event, in: nil)
        NSCursor.resizeLeftRight.set()
    }
    
    override func viewDidEndLiveResize() {
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("EditorsPanelsContainerView.viewDidEndLiveResize -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
        #endif
        // nothing to do
        NSCursor.arrow.set()
    }
    
    override func viewWillStartLiveResize() {
        
        // nothing to do
    }
    
}


