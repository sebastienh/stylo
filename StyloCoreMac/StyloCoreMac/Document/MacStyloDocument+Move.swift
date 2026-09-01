//
//  MacStyloDocument+Rename.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-02-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

extension MacStyloDocument {
    
    func handleUrlChange() {
    
        let window = self.windowController?.window as? StyloWindow
        
        assert(window != nil)
        if let window = window {
            
            /// when we are in full screen the window frame can not
            /// change... so, no need to save this.
            if !window.fullScreen {
                
                // update the id, in the case of text document and markdown document
                // the id is the url string of the document
                if let frameId = self.frameId {
                    
                    let frameAutosaveName = NSWindow.FrameAutosaveName(string: frameId)
                    let windowController = self.windowControllers.first
                    
                    assert(windowController != nil)
                    assert(windowController?.window != nil)
                    windowController?.windowFrameAutosaveName = frameAutosaveName
                    windowController?.window?.saveFrame(usingName: frameAutosaveName)
                }
            }
            else {
                
                self.urlChangedWhileInFullScreenMode = true
            }
        }
    }
    
}
