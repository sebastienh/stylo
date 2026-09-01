//
//  CssEditorSplitViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac

final class CssEditorSplitViewController: EditorSplitViewController {
    
    weak var documentManager: DocumentManager?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        // one of the two will be non-nil
        if let cssEditorToolsMenuViewController = editorToolsMenuViewController as? CssEditorToolsMenuViewController {
            
            assert(resourceModelManager is StylesheetManager)
            cssEditorToolsMenuViewController.stylesheetManager = resourceModelManager as? StylesheetManager
            cssEditorToolsMenuViewController.documentManager = documentManager
        }
    }
}
