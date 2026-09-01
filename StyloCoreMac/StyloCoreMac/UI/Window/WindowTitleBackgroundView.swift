//
//  WindowTitleBackgroundView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2018-10-30.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import os

public class WindowTitleBackgroundView: NSView, BackgroundColorBindable {
        
    public override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.addTrackingArea(NSTrackingArea(rect: frameRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited), owner: self, userInfo: nil))
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited), owner: self, userInfo: nil))
    }
    
    override public func mouseDown(with event: NSEvent) {
        
        self.window?.performDrag(with: event)
    }
    
    override public func mouseUp(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("WindowTitleBackgroundView.mouseUp -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
        #endif
        NSCursor.arrow.set()
        super.mouseUp(with: event)
    }
    
    override public func mouseEntered(with event: NSEvent) {
        
        let styloWindowController = self.window?.windowController as? StyloWindowController
        
        assert(styloWindowController != nil)
        if let styloWindowController = styloWindowController {
            styloWindowController.mouseInWindowTitle = true
        }
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("WindowTitleBackgroundView.mouseEntered -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
        #endif
        NSCursor.arrow.set()
        super.mouseEntered(with: event)
    }
    
//    override func mouseExited(with event: NSEvent) {
//        
//        let styloWindowController = self.window?.windowController as? StyloWindowController
//        
//        assert(styloWindowController != nil)
//        if let styloWindowController = styloWindowController {
//            styloWindowController.mouseInWindowTitle = false
//            
//            let markdownResourceEditorView = styloWindowController.markdownResourceEditorView
//            
//            assert(markdownResourceEditorView != nil)
//            if let markdownResourceEditorView = markdownResourceEditorView {
//            
//                let point = markdownResourceEditorView.convert(event.locationInWindow, from: nil)
//                
//                if NSPointInRect(point, markdownResourceEditorView.frame) {
//                    NSCursor.iBeam.set()
//                }
//                else {
//                    NSCursor.arrow.set()
//                }
//            }
//        }
//        super.mouseExited(with: event)
//    }
    
    // provide an intrinsic content size, to make our view prefer to be the same height
    // as the title bar.
    override public var intrinsicContentSize: NSSize {
        
        guard let window = self.window, let contentView = window.contentView else {
            return super.intrinsicContentSize
        }
        
        // contentView.frame is the entire frame, contentLayoutRect is the part not
        // overlapping the title bar. The difference will therefore be the height
        // of the title bar.
        let height = NSHeight(contentView.frame) - NSHeight(window.contentLayoutRect)
        
        // I just return noIntrinsicMetric for the width since the edge constraints we set
        // up in IB will override whatever we put here anyway
        return NSSize(width: NSView.noIntrinsicMetric, height: height)
    }
    
    
}
