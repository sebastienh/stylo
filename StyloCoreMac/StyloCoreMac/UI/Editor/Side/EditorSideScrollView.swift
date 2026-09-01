//
//  EditorSideScrollView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-05.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os

final class EditorSideScrollView: EditorSideSynchronizedScrollView {

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
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("START EditorSideScrollView ----------------------------------", log: Log.StyloCore.all, type: .info)
        #endif
        
        os_log("scrollview bounds: %@", log: Log.StyloCore.all, type: .info, %%self.bounds)
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("scrollview frame: %@", log: Log.StyloCore.all, type: .info, %%self.frame)
        #endif
        
        
        os_log("contentView bounds: %@", log: Log.StyloCore.all, type: .info, %%self.contentView.bounds)
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("contentView frame: %@", log: Log.StyloCore.all, type: .info, %%self.contentView.frame)
        #endif
        
        os_log("documentView bounds: %@", log: Log.StyloCore.all, type: .info, %%self.documentView!.bounds)
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("documentView frame: %@", log: Log.StyloCore.all, type: .info, %%self.documentView!.frame)
        #endif
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("END EditorSideScrollView   ----------------------------------", log: Log.StyloCore.all, type: .info)
        #endif
        #endif 
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
