//
//  StyloWindowController+HtmlPreview.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Web
import PromiseKit
import Common
import os

extension StyloWindowController: StaticHtmlPreviewer {
    
    @IBAction public func toggleHtmlPreview(_ sender: AnyObject? = nil) {
        
        showPreviewWindow(sender)
    }
    
    @IBAction func showPreviewWindow(_ sender: AnyObject? = nil) {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let document = self.document else {
            assertionFailure("Error: self.document is nil ")
            return
        }
        
        guard let styloDocument = document as? TextDocument else {
            assertionFailure("Error: document is not StyloDocument ")
            return
        }
        
        let bundle = Bundle(for: StyloWindowController.self)
        let storyboardName = NSStoryboard.Name(string: "Preview")
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        let windowController = storyboard.instantiateInitialController() as! PreviewWindowController
        windowController.documentManager = documentManager
        styloDocument.addWindowController(windowController)
        let previewWindow = windowController.window as! PreviewWindow
        previewWindow.appearance = StyloApplication.shared.computedAppearance.value?.appearance ?? AppearanceMode.dark.appearance
        previewWindow.makeKeyAndOrderFront(self)
    }
}

