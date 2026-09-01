//
//  EditorSynchronizedScrollView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-08-04.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import os

public class EditorSynchronizedScrollView: NSScrollView, SynchronizedScrollView {
    
    // don't retain the watched view, because we assume that it will
    // be retained by the view hierarchy for as long as we're around.
    fileprivate weak var leftSideSynchronizedScrollView: LineNumberingScrollView!
    fileprivate weak var rightSideSynchronizedScrollView: EditorSideScrollView!
    
    fileprivate var ongoingSelfScrollingProcess: Bool = false
    
    @IBOutlet var editorViewController: TextEditorViewController?
    
    override public var intrinsicContentSize: NSSize {
        
        return self.documentView!.intrinsicContentSize
    }
    
    override init(frame frameRect: NSRect) {
        
        self.ongoingSelfScrollingProcess = false
        
        super.init(frame: frameRect)
        listenToSelfScrollingNotifiations()
        
        #if DEBUG
        initializeBoundsChangedListening()
        #endif
    }

    required public init?(coder: NSCoder) {

        self.ongoingSelfScrollingProcess = false
        
        super.init(coder: coder)
        listenToSelfScrollingNotifiations()
        
        
        #if DEBUG
        initializeBoundsChangedListening()
        #endif
    }

    #if DEBUG
    public override func scrollPageDown(_ sender: Any?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollPageDown(...)", log: Log.StyloCore.all, type: .info)
        #endif
        
        super.scrollPageDown(sender)
    }
    
    public override func scrollPageUp(_ sender: Any?) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollPageUp(...)", log: Log.StyloCore.all, type: .info)
        #endif
                
        super.scrollPageUp(sender)
    }
    
    public override func scrollLineUp(_ sender: Any?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollLineUp(...)", log: Log.StyloCore.all, type: .info)
        #endif
                
        super.scrollLineUp(sender)
    }

    public override func scrollLineDown(_ sender: Any?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollLineDown(...)", log: Log.StyloCore.all, type: .info)
        #endif
                
        super.scrollLineDown(sender)
    }
    
    public override func scrollToEndOfDocument(_ sender: Any?) {
                        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollToEndOfDocument(...)", log: Log.StyloCore.all, type: .info)
        #endif
                
        super.scrollToEndOfDocument(sender)
    }
    
    public override func scrollToVisible(_ rect: NSRect) -> Bool {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollToVisible(...)", log: Log.StyloCore.all, type: .info)
        #endif
                        
        return super.scrollToVisible(rect)
    }
    
    public override func scroll(_ point: NSPoint) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scroll(...)", log: Log.StyloCore.all, type: .info)
        #endif
                        
        super.scroll(point)
    }
    
    public override func reflectScrolledClipView(_ cView: NSClipView) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("reflectScrolledClipView(...)", log: Log.StyloCore.all, type: .info)
        #endif
                        
        super.reflectScrolledClipView(cView)
    }
    
    public override func scroll(_ clipView: NSClipView, to point: NSPoint) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scroll(clipView:to:)", log: Log.StyloCore.all, type: .info)
        #endif
                        
        super.scroll(clipView, to: point)
    }
    #endif
    
    public func listentDidSelectMessageInIssuesReporter(from failable: Failable) {
        
        // a register for those notifications on the synchronized content view.
        let defaultCenter: NotificationCenter = NotificationCenter.default
        
        defaultCenter.addObserver(forName: NSNotification.Name(§StyloNotification.DidSelectMessageInIssuesReporter), object: failable, queue: nil) { [weak self](notification: Notification) in
            
            let userInfo = notification.userInfo as! [String: Any]
            let message = userInfo[WriterCommon.Constants.Notifications.Message] as! Message
            self?.handleMessageSelected(message: message)
        }
    }
    
    private func handleMessageSelected(message: Message) {
        
        // we need to give a way for the scroll view to know the rectangle to
        // the message. The scrollview reeiving the notifiction could just use
        // the document view to do this work. Yeah!!!
        guard let resourceEditorView = self.documentView as? ResourceEditorView else {
            assertionFailure("Error: self.documentView is not CssResourceEditorView")
            return
        }
            
        let messageRect = resourceEditorView.rect(from: message)
        
        assert(messageRect != nil)
        if let messageRect = messageRect {
            
            let origin = messageRect.origin
            
            if self.needToScroll(to: origin) {
                
                let newOrigin = self.originWhere(middleIs: origin)
                
                // hide the scroller before
                self.verticalScroller?.isHidden = true
                self.scroll(to: newOrigin)
                self.verticalScroller?.isHidden = false
            }
        }
    }
    
    
    /// We scroll only of we are outside the view or really
    /// not centered
    func needToScroll(to origin: NSPoint) -> Bool {
        
        let visibleRect = self.documentView!.visibleRect
        
        let lowerLimit = visibleRect.minY + visibleRect.height*0.2
        let upperLimit = visibleRect.maxY - visibleRect.height*0.2
        
        if origin.y >= lowerLimit && origin.y <= upperLimit {
        
            return false
        }
        return true
    }
    
    func scroll(to point: NSPoint) {
        
        self.documentView?.scroll(point)
        assert(Thread.isMainThread)
        self.documentView?.needsDisplay = true
    }
    
    /// TODO: need to put this scroll position in the middle
    /// of the visible document
    func originWhere(middleIs point: NSPoint) -> NSPoint {
        
        if let visibleRect = self.documentView?.visibleRect {
            
            let height = visibleRect.height
            
            let origin = NSMakePoint(point.x, point.y - height/2)
            
            return origin
        }
        
        // default we return the point itself
        return point
    }
    
    @objc func synchronizedViewContentBoundsDidChange(_ notification: Notification) {
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("synchronizing view bounds", log: Log.StyloCore.all, type: .info)
        #endif
        
        if !ongoingSelfScrollingProcess {
            
            // get the changed content view from the notification
            let changedContentView: NSClipView = notification.object as! NSClipView
    
            // get the origin of the NSClipView of the scroll view that
            // we're watching
            let changedBoundsOrigin: NSPoint = changedContentView.documentVisibleRect.origin
    
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
    
    func setLeftSideSynchronizedScrollView(_ scrollview: LineNumberingScrollView) {
        
        self.leftSideSynchronizedScrollView = scrollview
        setSynchronizedScrollView(scrollview)
    }
    
    func setRightSideSynchronizedScrollView(_ scrollview: EditorSideScrollView) {
        
        self.rightSideSynchronizedScrollView = scrollview
        setSynchronizedScrollView(scrollview)
    }
    
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
    
    /// Method that handle magnify notifications from the NSScrollView
    ///
    /// @param notification NSNotification received from the NSScrollView
    @objc func updateOngoingSelfScrollingProcessIndicator(_ notification: Notification) {
        
        if notification.name == NSScrollView.willStartLiveScrollNotification {
            
            ongoingSelfScrollingProcess = true
        }
        else if notification.name == NSScrollView.didLiveScrollNotification {
            
            ongoingSelfScrollingProcess = true
        }
            // NSScrollViewDidEndLiveScroll case
        else {
            
            ongoingSelfScrollingProcess = false
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func initializeBoundsChangedListening() {
        
        self.postsBoundsChangedNotifications = true
        
        NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: nil, queue: nil) { [weak self](notification) in
            self?.viewContentBoundsDidChange(notification)
        }
        
        self.postsFrameChangedNotifications = true
        
        NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: nil, queue: nil) { [weak self](notification) in
            self?.viewContentBoundsDidChange(notification)
        }
    }
    
    @objc func viewContentBoundsDidChange(_ notification: Notification) {
        
        logViewsInfo()
    }
    
    @objc func viewContentFrameDidChange(_ notification: Notification) {
        
        logViewsInfo()
    }
    
    private func logViewsInfo() {
        
        #if false
        os_log("START BackgroundSidebarScrollView ----------------------------------", log: Log.StyloCore.all, type: .info)
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("scrollview bounds: %@", log: Log.StyloCore.all, type: .info, %%self.bounds)
        #endif
        os_log("scrollview frame: %@", log: Log.StyloCore.all, type: .info, %%self.frame)
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("contentView bounds: %@", log: Log.StyloCore.all, type: .info, %%self.contentView.bounds)
        #endif
        os_log("contentView frame: %@", log: Log.StyloCore.all, type: .info, %%self.contentView.frame)
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("documentView bounds: %@", log: Log.StyloCore.all, type: .info, %%self.documentView!.bounds)
        #endif
        os_log("documentView frame: %@", log: Log.StyloCore.all, type: .info, %%self.documentView!.frame)
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("END BackgroundSidebarScrollView   ----------------------------------", log: Log.StyloCore.all, type: .info)
        #endif
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
