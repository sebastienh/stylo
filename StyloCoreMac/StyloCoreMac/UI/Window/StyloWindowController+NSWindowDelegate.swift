//
//  StyloWindowController+NSWindowDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-09-23.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import PromiseKit
import Common
import WriterCommon
import os

extension StyloWindowController: NSWindowDelegate {
    
    public func windowDidBecomeKey(_ notification: Notification) {
        
        self.styloDocument?.populateStylesMenu()
        self.styloDocument?.handleSelectedStyleManager()
    }
    
    public func windowWillStartLiveResize(_ notification: Notification) {
        
        styloWindow.allowCloseButtonButtonOriginReset = true
        styloWindow.allowZoomButtonButtonOriginReset = true
        styloWindow.allowMiniaturizeButtonButtonOriginReset = true
    }

    public func windowDidResize(_ notification: Notification) {
        
    }
    
    public func windowDidEndLiveResize(_ notification: Notification) {
        
        styloWindow.updateAutosaveFrame()
    }
    
    public func windowDidMove(_ notification: Notification) {
        
        styloWindow.updateAutosaveFrame()
    }
    
    public func windowDidExpose(_ notification: Notification) {
        
        styloWindow.updateAutosaveFrame()
    }
    
    private func applyViewingStyle() {
        
//        let textManager = self.styloDocument?.textManager
//
//        assert(textManager != nil)
//        textManager?.backupAttributes()
//        textManager?.applyViewingStyle(for: NSApp.effectiveAppearance)
    }
    
    private func restoreEditingState() {
        
//        let textManager = self.styloDocument?.textManager
//
//        assert(textManager != nil)
//        textManager?.restoreAttributes()
    }
    
//    private func prepareTextView() {
//        
//        if stylesListShown && !toolsCollapsed {    
//            // if a style editor is present we should discard it.
//            if let editedStylesheetViewController = self.editedStylesheetViewController {
//                editedStylesheetViewController.goBack()
//            }
//            closeStylesList(self)
//        }
//        if !textBackgroundSidebarTabVisible {
//            self.hideSidebar()
//        }
//    }
    
}
