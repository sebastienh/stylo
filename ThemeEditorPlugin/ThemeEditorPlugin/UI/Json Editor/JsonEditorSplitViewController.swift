//
//  JsonEditorSplitViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac

final class JsonEditorSplitViewController: EditorSplitViewController<JsonManager> {
    
    weak var documentManager: DocumentManager?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        // one of the two will be non-nil
        if let jsonEditorToolsMenuViewController = editorToolsMenuViewController as? JsonEditorToolsMenuViewController {
            
            assert(resourceModelManager is JsonManager)
            jsonEditorToolsMenuViewController.jsonManager = resourceModelManager as? JsonManager
            jsonEditorToolsMenuViewController.documentManager = documentManager
        }
    }
}
