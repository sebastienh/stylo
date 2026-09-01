//
//  EditorSideView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-05.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import os

public class EditorSideView: NSView, BackgroundColorBindable {
    
    public override var isFlipped: Bool {
        return true
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        self.addGlobalTrackingArea()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        self.addGlobalTrackingArea()
    }
    
    public override func viewWillStartLiveResize() {
        
        super.viewWillStartLiveResize()
        self.enclosingScrollView?.hasVerticalScroller = false
    }
    
    public override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("EditorSideView.mouseEntered -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
        #endif
        NSCursor.arrow.set()
    }
}
