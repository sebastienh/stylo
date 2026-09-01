//
//  StyloWindowController+Fullscreen.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-01-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import os
import Common

extension StyloWindowController {
    
    public func windowWillEnterFullScreen(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowWillEnterFullScreen", log: Log.StyloCore.all, type: .info)
        #endif
        fullscreenMode = true
        self.styloWindow.setAllowButtonsOriginReset(false)
        
        if let window = self.window {
            StyloNotification.willEnterFullScreen.sendNotification(window)
        }
    }
    
    public func windowDidEnterFullScreen(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowDidEnterFullScreen", log: Log.StyloCore.all, type: .info)
        #endif
        
        if let window = self.window {
            StyloNotification.didEnterFullScreen.sendNotification(window)
        }
    }
    
    public func windowWillExitFullScreen(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowWillExitFullScreen", log: Log.StyloCore.all, type: .info)
        #endif
        fullscreenMode = false
        
        self.styloWindow.setAllowButtonsOriginReset(true)
        if let window = self.window {
            StyloNotification.willExitFullScreen.sendNotification(window)
        }
    }
        
    public func windowDidExitFullScreen(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowDidExitFullScreen", log: Log.StyloCore.all, type: .info)
        #endif
        
        if let styloDocument = self.styloDocument, styloDocument.urlChangedWhileInFullScreenMode {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("url changed while in fullScreen mode", log: Log.StyloCore.all, type: .info)
            #endif
            self.styloDocument?.handleUrlChange()
        }
        
        if let window = self.window {
            StyloNotification.didExitFullScreen.sendNotification(window)
        }
    }
    
}
