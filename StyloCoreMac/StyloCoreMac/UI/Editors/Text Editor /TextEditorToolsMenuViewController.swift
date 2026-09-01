//
//  TextEditorToolsMenuViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-29.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

fileprivate enum EditorToolType: String {
    
    case dom
    case errors
}

class TextEditorToolsMenuViewController: EditorToolsMenuViewController {
    
    @IBOutlet weak var editorToolsTitlePanelView: EditorToolsTitlePanelView!
    
    weak var resourceModelManager: ResourceModelManager!
    
    var editorToolsTabViewController: EditorToolsTabViewController {
        
        return children.first as! EditorToolsTabViewController
    }
    
    private var initialized: Bool = false
    
    private var textManager: TextManager? {
        
        return styloDocument?.textManager
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        if !initialized {
            editorToolsTabViewController.resourceModelManager = resourceModelManager
        }
    }
    
    @IBAction func selectTool(_ sender: NSButton) {
        
        if let identifier = sender.identifier, let toolType = EditorToolType(rawValue: identifier.rawValue) {
            
            switch toolType {
                
            case .dom:
                
                editorToolsTabViewController.selectedTabViewItemIndex = 0
                
            case .errors:
                
                editorToolsTabViewController.selectedTabViewItemIndex = 1
            }
        }
    }
}
