//
//  VersionsTextEditorViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-02-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common

class VersionsTextEditorViewController: TextEditorViewController {
    
    var versionsWindowController: VersionsStyloWindowController? {
        
        let window = self.view.window
        return window?.windowController as? VersionsStyloWindowController
    }
    
    var styloDocument: MacStyloDocument? {
        
        return versionsWindowController?.document as? MacStyloDocument
    }
    
    override func initializeEditorView() {
        
//        assert(editableManager != nil)
//        if let editableManager = editableManager {
//            
//            // no need to compute the height, the NSLayoutManager along with the NSTextContainer
//            // will set it properly
//            self.createResourceEditorView(with: resourceEditorScrollView.contentSize)
//            if let textManager = editableManager as? TextManager {
//                
//                assert(self.styloDocument != nil)
//                if let styloDocument = self.styloDocument, styloDocument.isInViewingMode {
//                    textManager.applyViewingStyle(for: NSApp.effectiveAppearance)
//                }
//            }
//        }
    }
    
}
