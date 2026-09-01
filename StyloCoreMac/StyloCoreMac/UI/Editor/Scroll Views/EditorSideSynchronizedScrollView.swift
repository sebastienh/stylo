//
//  EditorSideSynchronizedScrollView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-08-04.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os

open class EditorSideSynchronizedScrollView: NSScrollView, SynchronizedScrollView {
    
    weak var editorScrollView: EditorSynchronizedScrollView?
    
    var ongoingTextScrollViewScrollingProcess: Bool = false
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        listenToSelfScrollingNotifiations()
    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        listenToSelfScrollingNotifiations()
    }
    
    /// This method is used to define a scroll view to which
    /// respond when the scrolling is done in the other scroll view.
    func setSynchronizedScrollView(_ scrollview: NSScrollView) {
        
        // don't retain the watched view, because we assume that it will
        // be retained by the view hierarchy for as long as we're around.
        let synchronizedScrollView: NSScrollView = scrollview
        
        // get the content view of the
        let synchronizedContentView: NSView = synchronizedScrollView.contentView
        
        // Make sure the watched view is sending bounds changed
        // notifications (which is probably does anyway, but calling
        // this again won't hurt).
        synchronizedContentView.postsBoundsChangedNotifications = true
        
        // a register for those notifications on the synchronized content view.
        NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: synchronizedContentView, queue: nil) { [weak self](notification) in
            self?.synchronizedViewContentBoundsDidChange(notification)
        }
    }
    
    @objc func synchronizedViewContentBoundsDidChange(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("synchronizing view bounds", log: Log.StyloCore.all, type: .info)
        #endif
        
        if !ongoingTextScrollViewScrollingProcess {
        
            var contentViewChanged = false
            
            // get the changed content view from the notification
            let changedContentView: NSClipView = notification.object as! NSClipView
        
            // get the origin of the NSClipView of the scroll view that
            // we're watching
            let changedBoundsOrigin: NSPoint = changedContentView.documentVisibleRect.origin
        
            // get our current origin
            let curOffset: NSPoint  = self.contentView.bounds.origin
            var newOffset: NSPoint = curOffset
        
            // scrolling is synchronized in the vertical plane
            // so only modify the y component of the offset
            newOffset.y = changedBoundsOrigin.y;
        
            // if our synced position is different from our current
            // position, reposition our content view
            if !NSEqualPoints(curOffset, changedBoundsOrigin) {
            
                // note that a scroll view watching this one will
                // get notified here
                contentView.scroll(to: newOffset)
                
                reflectScrolledClipView(contentView)
                
                contentViewChanged = true
            }
            
            if contentViewChanged {
                
                // we have to tell the NSScrollView to update its
                // scrollers
                reflectScrolledClipView(contentView)
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("not synchronizing view bounds, scrolling initiator.", log: Log.StyloCore.all, type: .info)
            #endif
        }
    }
    
    private func listenToSelfScrollingNotifiations() {
        
        NotificationCenter.default.addObserver(forName: NSScrollView.willStartLiveScrollNotification, object: self, queue: nil) { [weak self](notification) in
            self?.updateOngoingScrollingProcessIndicator(notification)
        }
        
        NotificationCenter.default.addObserver(forName: NSScrollView.didEndLiveScrollNotification, object: self, queue: nil) { [weak self](notification) in
            self?.updateOngoingScrollingProcessIndicator(notification)
        }
        
        NotificationCenter.default.addObserver(forName: NSScrollView.didLiveScrollNotification, object: self, queue: nil) { [weak self](notification) in
            self?.updateOngoingScrollingProcessIndicator(notification)
        }
    }
    
    /// Method that handle magnify notifications from the NSScrollView
    ///
    /// @param notification NSNotification received from the NSScrollView
    @objc private func updateOngoingScrollingProcessIndicator(_ notification: Notification) {
        
        if notification.name == NSScrollView.willStartLiveScrollNotification {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Setting ongoingTextScrollViewScrollingProcess to true", log: Log.StyloCore.all, type: .info)
            #endif
            ongoingTextScrollViewScrollingProcess = true
        }
        else if notification.name == NSScrollView.didLiveScrollNotification {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Setting ongoingTextScrollViewScrollingProcess to true", log: Log.StyloCore.all, type: .info)
            #endif
            ongoingTextScrollViewScrollingProcess = true
        }
            // NSScrollViewDidEndLiveScrollNotification case
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Setting ongoingTextScrollViewScrollingProcess to false", log: Log.StyloCore.all, type: .info)
            #endif
            ongoingTextScrollViewScrollingProcess = false
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
}
