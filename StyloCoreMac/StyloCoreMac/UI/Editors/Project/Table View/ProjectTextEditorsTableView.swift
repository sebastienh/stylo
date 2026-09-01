//
//  ProjectTextEditorsTableView.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import Common
import os

class ProjectTextEditorsTableView: NSTableView {
    
    override var preservesContentDuringLiveResize: Bool {
        return true
    }
    
    private var showingProjectTools: Bool = false
    
    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setFrameSize(%@)", log: Log.StyloCore.all, type: .debug, %%newSize)
        os_log("setFrameSize inLiveResize: %@", log: Log.StyloCore.all, type: .debug, %%inLiveResize)
        os_log("setFrameSize showingProjectTools: %@", log: Log.StyloCore.all, type: .debug, %%showingProjectTools)
        #endif

        if inLiveResize {

            self.setNeedsDisplay(self.rectPreservedDuringLiveResize)
        }
        else if showingProjectTools {

            self.setNeedsDisplay(self.visibleRect)
        }
    }
    
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
    
    override func viewDidEndLiveResize() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("viewDidEndLiveResize()", log: Log.StyloCore.all, type: .debug)
        #endif
        
        super.viewDidEndLiveResize()
        self.needsDisplay = true
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        assert(self.projectTextEditorsList != nil)
        projectTextEditorsList?.selectedCurrentFilesOutlineManager()
        projectTextEditorsList?.updateLastEdited(toTextId: nil)
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        guard let window = self.window else {
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willHideNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handlewillHideNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willShowNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handlewillShowNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didHideNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handledidHideNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didShowNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handledidShowNavigator()
        }
    }
    
    private func handlewillHideNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handlewillHideNavigator()", log: Log.StyloCore.all, type: .debug)
        #endif
        
        self.showingProjectTools = true
    }
    
    private func handlewillShowNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handlewillShowNavigator()", log: Log.StyloCore.all, type: .debug)
        #endif
        
        self.showingProjectTools = true
    }
    
    private func handledidHideNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handledidHideNavigator()", log: Log.StyloCore.all, type: .debug)
        #endif
        
        self.showingProjectTools = false
    }
    
    private func handledidShowNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handledidShowNavigator()", log: Log.StyloCore.all, type: .debug)
        #endif
        
        self.showingProjectTools = false
    }
    
}
