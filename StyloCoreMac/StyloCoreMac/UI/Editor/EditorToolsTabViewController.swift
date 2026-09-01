//
//  EditorToolsTabViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-12.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import os

open class EditorToolsTabViewController: NSTabViewController {
    
    public weak var resourceModelManager: ResourceModelManager!
    
    public weak var documentManager: DocumentManager?
    
    public var editorId: EditorId?
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.transitionOptions = NSViewController.TransitionOptions.allowUserInteraction
    }
    
    override public func viewWillAppear() {
        initChildControllers()
        super.viewWillAppear()
    }
    
    open func initChildControllers() {
        
        for tabViewItem in tabViewItems {
            
            if let viewController = tabViewItem.viewController {
                
                switch viewController {
                default:
                    assertionFailure("Error: unhandled")
                    break
                }
            }
            else {
                
                assert(false, "tabViewItem viewController is nil in HTMLPreviewToolsTabViewController")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("tabViewItem viewController is nil in HTMLPreviewToolsTabViewController", log: Log.StyloCore.all, type: .error)
                #endif
            }
        }
    }
    
    
}
