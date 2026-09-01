//
//  ProjectTextEditorsTabView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-11-10.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import os

class ProjectTextEditorsTabView: NSTabView {
    
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
    
    private var filesOutlineManager: FilesOutlineManager? {
        
        return projectTextEditorsList?.filesOutlineManager
    }
    
    /// stylo #851: Implement two fingers navigation for editors panes
    override func wantsScrollEventsForSwipeTracking(on axis: NSEvent.GestureAxis) -> Bool {
     
        return axis == .horizontal
    }
    
    /// stylo #851: Implement two fingers navigation for editors panes
    override func scrollWheel(with event: NSEvent) {

        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: filesOutlineManager is nil")
            return
        }

        guard event.phase == .began else {
            return
        }
        
        if event.scrollingDeltaX < 0 {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("moveForwardInHistory", log: Log.StyloCore.all, type: .debug)
            #endif

            filesOutlineManager.moveForward()
        }
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("moveBackInHistory", log: Log.StyloCore.all, type: .debug)
            #endif
            filesOutlineManager.moveBackward()
        }
    }
    
}
