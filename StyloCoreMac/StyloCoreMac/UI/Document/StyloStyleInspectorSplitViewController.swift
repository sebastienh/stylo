//
//  StyloStyleInspectorSplitViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-27.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import os

public final class StyloStyleInspectorSplitViewController: NSSplitViewController {
    
    enum SplitItem: Int {
        case navigator = 0
        case source = 1
        case tools = 2
    }
    
    var presentedPreview: Bool = false
    
    var toolsCollapsed: Bool {
        
        return self.splitViewItems[§SplitItem.tools].isCollapsed
    }
    
    var navigatorCollapsed: Bool {
        
        return self.splitViewItems[§SplitItem.navigator].isCollapsed
    }

    var allToolsCollapsed: Bool {
        return self.splitViewItems[§SplitItem.tools].isCollapsed && self.splitViewItems[§SplitItem.navigator].isCollapsed
    }
    
    var projectTextEditorsPanelsViewController: ProjectTextEditorsPanelsViewController? {
        
        let projectTextEditorsPanelsViewController = splitViewItems[§SplitItem.source].viewController as? ProjectTextEditorsPanelsViewController
        assert(projectTextEditorsPanelsViewController != nil)
        return projectTextEditorsPanelsViewController
    }
    
    var toolsTabViewController: ToolsTabViewController? {
        
        #if DEBUG
        assert(splitViewItems[§SplitItem.tools].viewController is ToolsTabViewController)
        #endif
        return splitViewItems[§SplitItem.tools].viewController as? ToolsTabViewController
    }
    
    var projectOutlineTitleViewController: NavigatorViewController? {
        
        assert(splitViewItems[§SplitItem.navigator].viewController is NavigatorViewController)
        return splitViewItems[§SplitItem.navigator].viewController as? NavigatorViewController
        
    }

    var projectToolsTabViewController: ProjectToolsViewController? {

        return projectOutlineTitleViewController?.projectToolsTabViewController
    }
    
    var lastToolsWidth: CGFloat = 300
    
    var lastThemesWidth: CGFloat = 300
    
    var duration: TimeInterval = 0.5
    
    var toolsTabView: NSView {
        return self.splitView.subviews[§SplitItem.tools] as NSView
    }
    
    var projectToolsTabView: NSView {
        return self.splitView.subviews[§SplitItem.navigator] as NSView
    }
    
    private var documentManager: DocumentManager? {
        return self.representedObject as? DocumentManager
    }
    
    private var initialized: Bool = false
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }

    override public func viewDidLoad() {
        
        if !initialized {
            
//            initializeChildControllers()
            initialized = true
        }
        super.viewDidLoad()
    }
    
    override public func viewWillAppear() {
        
        guard let projectTextEditorsPanelsViewController = self.projectTextEditorsPanelsViewController else {
            assertionFailure("Error: self.projectTextEditorsPanelsViewController is nil")
            super.viewWillAppear()
            return
        }
        
        projectTextEditorsPanelsViewController.representedObject = self.styloDocument?.documentManager
        let _ = projectTextEditorsPanelsViewController.view
        
        super.viewWillAppear()
    }
    
    override public func viewDidAppear() {
        super.viewDidAppear()
        
        let documentManager = self.styloDocument?.documentManager
        
        assert(documentManager != nil)
        if let documentManager = documentManager {
        
//            assert(self.toolsTabViewController?.cssViewController != nil)
//            self.toolsTabViewController?.cssViewController?.prepare(with: documentManager)
            self.projectOutlineTitleViewController?.representedObject = documentManager
        }
        
//        assert(self.toolsTabViewController != nil)
//        self.toolsTabViewController?.view.frame = NSMakeRect(0, 0, 350, 2000)
//        let _ = self.toolsTabViewController?.view
    }
    
    override public func splitViewWillResizeSubviews(_ notification: Notification) {

        guard let window = self.splitView.window else {
            return
        }
        
        StyloNotification.willMoveDivider.sendNotification(window)
    }
    
    override public func splitViewDidResizeSubviews(_ notification: Notification) {

        // the user collapsed the panel manually 
        if let lastItem = self.splitViewItems.last, lastItem.isCollapsed {
            
            if let pluginManager = self.documentManager?.pluginManager {   
                pluginManager.toolsPanelDidCollapsed()
            }
            windowController?.hideTools(toggle: false)
        }
        
        requestSendDidMoveDividerNotification()
    }
    
    private var didMoveDividerTimer: Timer?
    
    private func requestSendDidMoveDividerNotification() {
        
        self.didMoveDividerTimer?.invalidate()
        self.didMoveDividerTimer = Timer.scheduledTimer(withTimeInterval: StyloConstants.StyleSplitView.DividerDidMoveUpdateDelay, repeats: false, block: { [weak self](_) in
            self?.sendDidMoveDividerNotification()
        })
    }
    
    private func sendDidMoveDividerNotification() {
        
        guard let window = self.splitView.window else {
            assertionFailure("Error: self.splitView.window is nil")
            return
        }
        
        StyloNotification.didMoveDivider.sendNotification(window)
    }
    
    override public func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
        
        if dividerIndex == 0 {
            if splitView.isSubviewCollapsed(projectToolsTabView) {
                return true
            }
            return false
        }
        else {
            if splitView.isSubviewCollapsed(toolsTabView) {
                return true
            }
            return false
        }
    }
    
    private func initializeChildControllers() {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        for splitViewItem in self.splitViewItems {
            splitViewItem.viewController.representedObject = documentManager
        }
    }
    
}
