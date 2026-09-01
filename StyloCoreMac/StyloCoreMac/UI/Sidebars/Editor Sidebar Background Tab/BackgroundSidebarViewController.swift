//
//  BackgroundSidebarViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-19.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import os

class BackgroundSidebarViewController: NSViewController {
    
    @IBOutlet weak var backgroundSidebarContentView: BackgroundSidebarContentView!
    
    @IBOutlet weak var scrollView: BackgroundSidebarScrollView!
    
    private var documentManager: DocumentManager? {
        
        return representedObject as? DocumentManager
    }
    
    override var representedObject: Any? {
        willSet {
            documentManager?.documentUnderPageBackgroundColor.unsubscribe(observer: self)
        }
        didSet {
            assert(self.representedObject != nil)
            assert(self.representedObject is DocumentManager)
            listenToDocumentUnderPageBackgroundColorChange()
        }
    }
    
    private var visibleScroller: NSScroller?
    
    override func viewWillAppear() {
        
        scrollView.scrollerStyle = .overlay
        assignSidebarBackgroundColor()
        super.viewWillAppear()
    }
    
    func hideScroller() {
        
        let verticalScroller = scrollView.verticalScroller
        
        assert(verticalScroller != nil)
        if let verticalScroller = verticalScroller {
            
            assert(visibleScroller == nil)
            self.visibleScroller = verticalScroller
            scrollView.verticalScroller = HiddenScroller(frame: verticalScroller.frame)
            scrollView.verticalScroller?.isHidden = true
            scrollView.verticalScroller?.isEnabled = false
        }
    }
    
    func showScroller() {
        
        if scrollView.verticalScroller is HiddenScroller {
            
            let scrollerFrame = scrollView.verticalScroller?.frame
            assert(scrollerFrame != nil)
            if let scrollerFrame = scrollerFrame {
                
                self.visibleScroller?.frame = scrollerFrame
                scrollView.verticalScroller = visibleScroller
            }
            else {
                scrollView.verticalScroller = NSScroller()
            }
            scrollView.scrollerStyle = .overlay
            scrollView.verticalScroller?.isHidden = false
            scrollView.verticalScroller?.isEnabled = true
            
        }
        visibleScroller = nil
    }
    
    private func listenToDocumentUnderPageBackgroundColorChange() {
        
        assert(self.documentManager != nil)
        documentManager?.documentUnderPageBackgroundColor.subscribe({ [weak self](documentUnderPageBackgroundColor) in
            self?.assignSidebarBackgroundColor()
        }, observer: self)
        
    }
    
    func assignSidebarBackgroundColor() {

        if let scrollView = scrollView {
            
            assert(self.documentManager != nil)
            
            if let backgroundColor = self.documentManager?.documentUnderPageBackgroundColor.value {
                
                scrollView.backgroundColor = NSColor(cgColor: backgroundColor) ?? NSColor.underPageBackgroundColor
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("backgroundSidebarContentView.appearance: %@", log: Log.StyloCore.all, type: .info, %%backgroundSidebarContentView.appearance)
                os_log("scrollView.appearance: %@", log: Log.StyloCore.all, type: .info, %%scrollView.appearance)
                #endif
            }
        }
    }
    
    deinit {
        documentManager?.documentUnderPageBackgroundColor.unsubscribe(observer: self)
    }
}
