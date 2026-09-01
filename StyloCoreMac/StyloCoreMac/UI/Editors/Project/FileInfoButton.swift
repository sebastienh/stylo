//
//  FileInfoButton.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-10-29.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import os

class FileInfoButton: NSButton {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.addTrackingArea(NSTrackingArea(rect: frameRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited), owner: self, userInfo: nil))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTrackingArea(NSTrackingArea(rect: .zero, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited), owner: self, userInfo: nil))
    }
    
    override func mouseEntered(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("FileInfoButton.mouseEntered -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
        #endif
        NSCursor.arrow.set()
    }
    
}

