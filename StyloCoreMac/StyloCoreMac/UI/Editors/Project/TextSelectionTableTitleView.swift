//
//  TextSelectionTableTitleView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import os

class TextSelectionTableTitleView: TitleView {
    
    enum ClickType {
        case single
        case double
    }
    
    @IBOutlet var editorPaneTitleTextField: FilesOutlineTitleTextField?
    
    private var projectTextEditorsList: ProjectTextEditorsList? {
        
        var responder = self.nextResponder
        while responder != nil {
            if let projectTextEditorsList = responder as? ProjectTextEditorsList {
                return projectTextEditorsList
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    private var dragged: Bool  {
        
        guard let oldWindowOrigin = self.windowOrigin else {
            return false
        }
            
        guard let windowOrigin = self.window?.frame.origin else {
            return false
        }
            
        return oldWindowOrigin != windowOrigin
    }
    
    private var windowOrigin: CGPoint?
    
    private var _doubleClickTimer: Timer?

    private var clickType: ClickType?
    
    // a way to ignore first click when listening for double click
    override func mouseDown(with event: NSEvent) {
        mouseUped = false
        self.windowOrigin = self.window?.frame.origin
        if event.clickCount > 1 {
            _doubleClickTimer!.invalidate()
            onDoubleClick(with: event)
        } else if event.clickCount == 1 { // can be 0 - if delay was big between down and up
            _doubleClickTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (_) in
                self.onDoubleClickTimeout(event: event)
            })
        }
    }
    
    func onDoubleClickTimeout(event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("onDoubleClickTimeout", log: Log.StyloCore.all, type: .info)
        #endif
        
        onClick(with: event)
    }

    func onClick(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("onClick", log: Log.StyloCore.all, type: .info)
        #endif
        
        clickType = .single
        
        if mouseUped && !dragged {
            assert(self.projectTextEditorsList != nil)
            projectTextEditorsList?.selectedCurrentFilesOutlineManager()
        }
    }

    func onDoubleClick(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("onDoubleClick", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard self.editorPaneTitleTextField?.isEditing != true else {
            // it's a editing double click so we should not resize the window
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("editorPaneTitleTextField is editing", log: Log.StyloCore.all, type: .info)
            #endif
            return
        }
        
        clickType = .double
        guard let screenSize = NSScreen.main?.visibleFrame.size else {
            assertionFailure("Error: NSScreen.main?.frame.size is nil")
            return
        }
        
        guard let windowFrame = self.window?.frame else {
            assertionFailure("Error: windowFrame is nil")
            return
        }
        
        guard let styloWindow = window as? StyloWindow else {
            assertionFailure("Error: window is not StyloWindow")
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("screenSize: %@", log: Log.StyloCore.all, type: .info, %%screenSize)
        os_log("windowFrame.size: %@", log: Log.StyloCore.all, type: .info, %%windowFrame.size)
        #endif
        
        if NSEqualSizes(screenSize, windowFrame.size) {
            if let oldFrame = styloWindow.oldFrame {
                self.window?.animator().setFrame(oldFrame, display: true)
            }
        }
        else {
            
            styloWindow.oldFrame = styloWindow.frame
            let screenFrameRect = NSMakeRect(0, 0, screenSize.width, screenSize.height)
            self.window?.animator().setFrame(screenFrameRect, display: true)
        }
    }
    
    var mouseUped: Bool = false
    
    override func mouseUp(with event: NSEvent) {
        
        super.mouseUp(with: event)
        mouseUped = true
    }
}
