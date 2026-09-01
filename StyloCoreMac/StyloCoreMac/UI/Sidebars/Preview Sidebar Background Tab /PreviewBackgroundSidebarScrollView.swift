//
//  PreviewBackgroundSidebarScrollView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-09-06.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import os

class PreviewBackgroundSidebarScrollView: NSScrollView {
    
    var ongoingSelfScrollingProcess: Bool = false
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        listenToSelfScrollingNotifiations()
    }
    
    func synchronizeScrollPosition(changedBoundsOrigin: NSPoint) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("synchronizing view bounds", log: Log.StyloCore.all, type: .info)
        #endif
        
        if !ongoingSelfScrollingProcess {
            
            // get our current origin
            let curOffset: NSPoint = self.contentView.bounds.origin
            var newOffset: NSPoint = curOffset
            
            // scrolling is synchronized in the vertical plane
            // so only modify the y component of the offset
            newOffset.y = changedBoundsOrigin.y
            
            // if our synced position is different from our current
            // position, reposition our content view
            if !NSEqualPoints(curOffset, changedBoundsOrigin) {
                
                // note that a scroll view watching this one will
                // get notified here
                contentView.scroll(to: newOffset)
                
                // we have to tell the NSScrollView to update its
                // scrollers
                reflectScrolledClipView(contentView)
            }
        }
    }
    
    /// Method that handle magnify notifications from the NSScrollView
    ///
    /// @param notification NSNotification received from the NSScrollView
    @objc func updateOngoingSelfScrollingProcessIndicator(_ notification: Notification) {
        
        if notification.name == NSScrollView.willStartLiveScrollNotification {
            
            ongoingSelfScrollingProcess = true
            synchronizeStaticWebView()
        }
        else if notification.name == NSScrollView.didLiveScrollNotification {
            
            ongoingSelfScrollingProcess = true
            synchronizeStaticWebView()
        }
        else {
            
            ongoingSelfScrollingProcess = false
        }
    }
    
    private func synchronizeStaticWebView() {
        
    }
    
    private func listenToSelfScrollingNotifiations() {
        
        NotificationCenter.default.addObserver(forName: NSScrollView.willStartLiveScrollNotification, object: self, queue: nil) { [weak self](notification) in
            self?.updateOngoingSelfScrollingProcessIndicator(notification)
        }
        
        NotificationCenter.default.addObserver(forName: NSScrollView.didEndLiveScrollNotification, object: self, queue: nil) { [weak self](notification) in
            self?.updateOngoingSelfScrollingProcessIndicator(notification)
        }
        
        NotificationCenter.default.addObserver(forName: NSScrollView.didLiveScrollNotification, object: self, queue: nil) { [weak self](notification) in
            self?.updateOngoingSelfScrollingProcessIndicator(notification)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
