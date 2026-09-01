//
//  JsonEditorToolsMenuViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-29.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac

class JsonEditorToolsMenuViewController: EditorToolsMenuViewController {
    
    enum EditorToolType: String {
        
        case dom
        case errors
        case commands
        
        var index: Int {
            
            switch self {
                
            case .dom:
                return 0
            case .errors:
                return 1
            case .commands:
                return 2
            }
        }
        
        static func from(index: Int) -> EditorToolType? {
            
            if index == 0 {
                return EditorToolType.dom
            }
            else if index == 1 {
                return EditorToolType.errors
            }
            else if index == 2 {
                return EditorToolType.commands
            }
            return nil
        }
        
    }
    
    weak var jsonManager: JsonManager!
    
    @IBOutlet weak var domPanelButton: NSButton!
    
    @IBOutlet weak var errorMessagesPanelButton: NSButton!
    
    @IBOutlet weak var helpPanelButton: NSButton!
    
    @IBOutlet weak var editorToolsTitlePanelView: EditorToolsTitlePanelView!
    
    var editorToolsTabViewController: EditorToolsTabViewController? {
        
        return children.first as? EditorToolsTabViewController
    }
    
    var selectedTool: EditorToolType? {
        
        if let editorToolsTabViewController = editorToolsTabViewController {
        
            if let selectedTabViewItem = editorToolsTabViewController.tabView.selectedTabViewItem {
                
                let index = editorToolsTabViewController.tabView.indexOfTabViewItem(selectedTabViewItem)
                    
                let editorToolType = EditorToolType.from(index: index)
                
                assert(editorToolType != nil)
                return editorToolType
            }
        }
        return nil
    }
    
    
    private var initialized: Bool = false
    
    var textManager: TextManager? {
        fatalError("missing implementation")
    }
    
    weak var documentManager: DocumentManager?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        if !initialized {
            initialize()
        }
    }
    
    @IBAction func selectTool(_ sender: NSButton) {
        
        if let identifier = sender.identifier, let toolType = EditorToolType(rawValue: identifier.rawValue) {
            
            switch toolType {
                
            case .commands:
                jsonManager.updateStoreState(state: FailableStoreState.source)
                
            case .dom:
                jsonManager.updateStoreState(state: FailableStoreState.source)
                
            case .errors:
                jsonManager.updateStoreState(state: FailableStoreState.allError)
            }
            
            selectEditorTool(type: toolType)
        }
    }
    
    private func initialize() {
        
        assert(textManager != nil)
        assert(editorToolsTabViewController != nil)
        
        editorToolsTabViewController?.resourceModelManager = jsonManager
        editorToolsTabViewController?.documentManager = documentManager
        selectEditorTool(type: EditorToolType.errors)
        
        #if !DEBUG
            hideDebugPanels()
        #endif
    }
    
    private func hideDebugPanels() {
    
//        domPanelButton.isHidden = true
//        helpPanelButton.isHidden = true
    }
    
    private func selectEditorTool(type: EditorToolType) {
        
        assert(editorToolsTabViewController != nil)
        editorToolsTabViewController?.selectedTabViewItemIndex = type.index
        
        switch type {
            
        case .dom:
            
            jsonManager.presentingDom = 1
            jsonManager.presentingErrors = 0
            jsonManager.presentingHelp = 0
            
        case .errors:
            
            jsonManager.presentingDom = 0
            jsonManager.presentingErrors = 1
            jsonManager.presentingHelp = 0
            
        case .commands:
            
            jsonManager.presentingDom = 0
            jsonManager.presentingErrors = 0
            jsonManager.presentingHelp = 1
        }
    }
    
    
}
