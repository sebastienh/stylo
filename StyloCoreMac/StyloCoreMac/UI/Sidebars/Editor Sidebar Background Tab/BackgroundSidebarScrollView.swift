//
//  BackgroundSidebarScrollView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os

final class BackgroundSidebarScrollView: EditorSideSynchronizedScrollView {
    
    override var backgroundColor: NSColor {
        didSet {
            print("Setting sidebar background color to: \(backgroundColor)")
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        
        #if DEBUG
        initializeBoundsChangedListening()
        #endif
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        
        #if DEBUG
        initializeBoundsChangedListening()
        #endif
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
            self?.viewContentFrameDidChange(notification)
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
