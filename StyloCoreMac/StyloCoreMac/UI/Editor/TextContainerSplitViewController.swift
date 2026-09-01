//
//  TextContainerSplitViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-09-01.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Web
import WriterCommon

public final class TextContainerSplitViewController: NSSplitViewController {
    
    var editableManager: AnyEditable!
    
    public override func viewWillAppear() {
        
        let splitViewItem = self.splitViewItems[0]
        
        let splitViewItemController = splitViewItem.viewController
        
        if let editorViewController = splitViewItemController as? EditorViewController {
            
            assert(editableManager != nil)
            editorViewController.editableManager = editableManager
        }
        
        super.viewWillAppear()
    }
    
}
