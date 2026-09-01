//
//  PreviewBackgroundSidebarViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-09-06.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import os

class PreviewBackgroundSidebarViewController: NSViewController {
    
    @IBOutlet weak var previewBackgroundSidebarView: PreviewBackgroundSidebarView!
    
    @IBOutlet weak var scrollView: PreviewBackgroundSidebarScrollView!
    
    private var staticHtmlPreviewable: StaticHtmlPreviewable? {
        
        return nil
    }
    
    private var htmlPreviewBackgroundColor: NSColor?
    
    override func viewWillAppear() {
        
        initialize()
        super.viewWillAppear()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private var initialized: Bool = false
    
    private func initialize() {
        
        if !initialized {
            
            initialized = true
        }
    }
    
    private func applyCurrentBackgroundColor() {
        
        if let htmlPreviewBackgroundColor = htmlPreviewBackgroundColor {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Applying new background-color to htmlPreviewBackgroundView: %@", log: Log.StyloCore.all, type: .info, %%htmlPreviewBackgroundColor)
            #endif
            
            scrollView.backgroundColor = htmlPreviewBackgroundColor
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Unable to apply background-color to htmlPreviewBackgroundView: htmlPreviewBackgroundColor is nil.", log: Log.StyloCore.all, type: .error)
            #endif
        }
    }
    
}
