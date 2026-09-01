//
//  EditorSplitViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-12.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

/// This view controller is the entry point for all the editors in the application
/// Since each controller controls an editor with all it's editor dependencies (resource)
/// it should be populated with an ResourceModelManager
open class EditorSplitViewController: NSSplitViewController {
    
    public weak var resourceModelManager: AnyEditable!
    
    var toolsSplitViewItem: NSSplitViewItem {
     
        return splitViewItems[1]
    }
    
    var toolsSubview: NSView {
        
        return self.splitView.arrangedSubviews[1]
    }
    
    var toolsView: NSView {
        return self.splitView.subviews[1] as NSView
    }
    
    public var editorToolsCollapsed: Bool {
        
        return toolsSplitViewItem.isCollapsed
    }
    
    public var editorViewController: EditorViewController? {
        
        let editorSplitViewItem = self.splitViewItems[0]
        return editorSplitViewItem.viewController as? EditorViewController
    }
    
    public var resourceEditorView: ResourceEditorView? {
        
        self.editorViewController?.resourceEditorView
    }
    
    public var editorId: EditorId? {
        
        return resourceEditorView?.id
    }
    
    public var editorToolsMenuViewController: EditorToolsMenuViewController? {
        
        let splitViewController = self.splitViewItems[1]
        return splitViewController.viewController as? EditorToolsMenuViewController
    }

    var lastToolsHeight: CGFloat = 200
    
    var duration: TimeInterval = 0.2
    
    override open func viewWillAppear() {
        
        super.viewWillAppear()
        
        self.splitView.wantsLayer = true 
        assert(self.splitView.layer != nil)
        self.splitView.layer?.isOpaque = true
        
        editorViewController?.editableManager = resourceModelManager
        
        if let textEditorToolsMenuViewController = editorToolsMenuViewController as? TextEditorToolsMenuViewController {
            
            assert(resourceModelManager is TextManager)
            textEditorToolsMenuViewController.resourceModelManager = resourceModelManager as? TextManager
        }
    }
    
    @IBAction public func showDomTool(_ sender: Any?) {
        
        assert(sender != nil)
        if let sender = sender {
            
            if !(sender is NSButton) && !toolsSplitViewItem.isCollapsed {
                return
            }
            toggleEditorToolsPanel()
        }
    }
    
    public func toggleEditorToolsPanel() {

        if toolsSplitViewItem.isCollapsed {

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = duration
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                self.toolsSplitViewItem.isCollapsed = false
            }, completionHandler: {
                self.toolsSplitViewItem.isCollapsed = false
            })
        }
        else {

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = duration
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                self.toolsSplitViewItem.isCollapsed = true
            }, completionHandler: {
                self.toolsSplitViewItem.isCollapsed = true
                self.editorViewController?.resourceEditorView.needsDisplay = true
            })
        }
    }
    
    override open func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
        
        if splitView.isSubviewCollapsed(toolsView) {
            return true
        }
        return false
    }
}
