//
//  CssEditorToolsMenuViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-29.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac

class CssEditorToolsMenuViewController: EditorToolsMenuViewController {
    
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
    
    @objc weak var stylesheetManager: StylesheetManager!
    
    @IBOutlet weak var domPanelButton: NSButton!
    
    @IBOutlet weak var errorMessagesPanelButton: NSButton!
    
    @IBOutlet weak var helpPanelButton: NSButton!
    
    @IBOutlet weak var editorToolsTitlePanelView: EditorToolsTitlePanelView!
    
    @objc dynamic var domToolsDisabled: Bool {
        
        return !StyloConstants.Configuration.CssDomToolsEnabled
    }
    
    @objc dynamic var helpDisabled: Bool {
        
        return !StyloConstants.Configuration.CssHelpEnabled
    }
    
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
    
    var editorSplitViewController: EditorSplitViewController? {
        
        var responder = self.nextResponder
        while responder != nil {
            if let editorSplitViewController = responder as? EditorSplitViewController {
                return editorSplitViewController
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    var editorId: EditorId? {
        
        return self.editorSplitViewController?.editorId
    }
    
    private var initialized: Bool = false
    
    weak var documentManager: DocumentManager?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        if !initialized {
            initialize()
        }
    }
    
    @IBAction func selectTool(_ sender: NSButton) {
        
        if let identifier = sender.identifier, let toolType = EditorToolType(rawValue: identifier.rawValue) {
            
            guard let editorId = self.editorId else {
                assertionFailure("Error: self.editorId is nil")
                return
            }
            
            switch toolType {   
            case .commands:
                stylesheetManager.clearErrorHighlight(forEditorWithId: editorId)
            case .dom:
                stylesheetManager.clearErrorHighlight(forEditorWithId: editorId)
            case .errors:
                stylesheetManager.highlightAllErrors(forEditorWithId: editorId)
            }
            selectEditorTool(type: toolType)
        }
    }
    
    private func initialize() {
        
        assert(documentManager != nil)
        assert(editorToolsTabViewController != nil)
        
        editorToolsTabViewController?.resourceModelManager = stylesheetManager
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
            
            stylesheetManager.presentingDom = 1
            stylesheetManager.presentingErrors = 0
            stylesheetManager.presentingHelp = 0
            
        case .errors:
            
            stylesheetManager.presentingDom = 0
            stylesheetManager.presentingErrors = 1
            stylesheetManager.presentingHelp = 0
            
        case .commands:
            
            stylesheetManager.presentingDom = 0
            stylesheetManager.presentingErrors = 0
            stylesheetManager.presentingHelp = 1
        }
    }
    
    
}
