//
//  StylesheetViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-14.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import os
import StyloCoreMac

class ThemeViewController: NSViewController, Pushable {
    
    @objc dynamic var pendingContextChanges: Bool = false
    
    @IBOutlet var containerView: NSView!
    
    @IBOutlet weak var themeTitlePanelView: ThemeTitlePanelView!
    
    @IBOutlet weak var domButton: NSButton!
    
    @IBOutlet weak var headerStackView: NSStackView!
    
    @IBOutlet var issuesLabel: NSTextField!
    
    @IBOutlet weak var errorsButton: NSButton!
    
    @IBOutlet weak var backgroundView: ClearView!
    
    @IBOutlet var titleLable: NSTextField! {
        didSet {
            titleLable.backgroundColor = NSColor.clear
            titleLable.isBezeled = false
            titleLable.focusRingType = .none
        }
    }
    
    private var editorSplitViewController: JsonEditorSplitViewController! {
        
        for childViewController in children {
            
            if let _editorSplitViewController = childViewController as? EditorSplitViewController {
                
                return _editorSplitViewController
            }
        }
        return nil
    }
    
    var hasIssues: Bool {
        
        assert(themeManager != nil)
        if let themeManager = themeManager {
            
            return themeManager.issuesCount != 0
        }
        return false
    }
    
    var jsonEditorToolsViewController: JsonEditorToolsMenuViewController? {
        
        let jsonEditorToolsMenuViewController = editorSplitViewController.splitViewItems[1].viewController as? JsonEditorToolsMenuViewController
        
        assert(jsonEditorToolsMenuViewController != nil)
        return jsonEditorToolsMenuViewController
    }
    
    @objc dynamic var name: String {
        
        get {
            return themeManager.title
        }
        set {
            themeManager.title = newValue
        }
    }
    
    @objc dynamic var backButtonTitle: String = "Back"
    
    var themeManager: ThemeManager! {
        
        willSet {
            
            themeManager?.pendingContextChanges.unsubscribe(observer: self)
        }
        didSet {
            
            assert(themeManager != nil)
            themeManager?.pendingContextChanges.subscribe({ [weak self](pendingChanges) in
                self?.pendingContextChanges = pendingChanges
            }, observer: self)
        }
    }
    
    var errorsToolsShown: Bool {
        
        let selectedTool = jsonEditorToolsViewController?.selectedTool
        
        if let selectedTool = selectedTool {
            
            return selectedTool == JsonEditorToolsMenuViewController.EditorToolType.errors
        }
        return false
    }
    
    @IBAction func goBack(_ sender: NSButton){

        if let presentingViewController = self.presentingViewController {

            presentingViewController.dismiss(self)
        }
    }

    @IBAction func updateThemeFromContext(_ sender: AnyObject?) {
    
        assert(themeManager != nil)
        self.themeManager?.updateContext()
    }
    
    @IBAction func toggleEditorToolsPanel(_ sender: AnyObject?) {
        
        let collapsing = !editorSplitViewController.editorToolsCollapsed
        
        if editorSplitViewController.editorToolsCollapsed {
            
            if themeManager.presentingErrors == 1 {
                themeManager.updateStoreState(state: FailableStoreState.allError)
            }
        }
        else {
            
            if themeManager.presentingErrors == 1 {
                themeManager.updateStoreState(state: FailableStoreState.source)
            }
        }
        
        // uncolapse the tools
        editorSplitViewController.toggleEditorToolsPanel()
        
        if collapsing && themeManager.errors.isEmpty {
            
            // disable the button if we can
            disableErrorsButtonIfPossible()
        }
        NSApplication.shared.mainMenu?.update()
    }
    
    @IBAction func domButtonClicked(_ sender: NSButton?) {
        
        themeManager.updateStoreState(state: FailableStoreState.source)
        
        if domButton.state == NSControl.StateValue.on {
            
            if editorSplitViewController.editorToolsCollapsed {
                
                // uncolapse the tools
                editorSplitViewController.toggleEditorToolsPanel()
            }
            else {
                
                themeManager.presentingHelp = 0
                themeManager.presentingErrors = 0
            }
            
            // select the styles tool
            assert(jsonEditorToolsViewController != nil)
            jsonEditorToolsViewController?.selectTool(sender!)
        }
        else {
            
            // colapse the tools
            editorSplitViewController.toggleEditorToolsPanel()
        }
    }
    
    @IBAction func errorButtonClicked(_ sender: NSButton?) {
        
        if errorsButton.state == NSControl.StateValue.on {
            
            if editorSplitViewController.editorToolsCollapsed {
                
                themeManager.updateStoreState(state: FailableStoreState.allError)
                // uncolapse the tools
                editorSplitViewController.toggleEditorToolsPanel()
            }
            else {
                
                themeManager.updateStoreState(state: FailableStoreState.source)
                themeManager.presentingDom = 0
                themeManager.presentingHelp = 0
            }
            
            // select the styles tool
            assert(jsonEditorToolsViewController != nil)
            jsonEditorToolsViewController?.selectTool(sender!)
        }
        else {
            
            // colapse the tools
            editorSplitViewController.toggleEditorToolsPanel()
        }
    }
    
    @IBAction func showDomTool(_ sender: Any?) {
        
        editorSplitViewController.showDomTool(sender)
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        setManagersInTargetEditor()
        
        assert(themeManager != nil)
        if let themeManager = themeManager {
            
            updateHeaderState(from: themeManager.errors, failable: themeManager)
            listenToFailable(themeManager)
        }
    }
    
    private func setManagersInTargetEditor() {
    
        assert(editorSplitViewController is JsonEditorSplitViewController)
        if let editorSplitViewController = editorSplitViewController as? JsonEditorSplitViewController {
            
            if editorSplitViewController.resourceModelManager == nil {
            
                assert(themeManager != nil)
                if let themeManager = themeManager {
                
                    editorSplitViewController.resourceModelManager = themeManager
                }
            }
        }
        else {
            
            assert(false, "editorSplitViewController is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("editorSplitViewController is nil.", log: Log.ThemeEditor.all, type: .error)
            #endif
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Pushable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var contentView: NSView? {
        
        assert(containerView != nil)
        return containerView
    }
    
    func completeAfterPush() {
        
    }
    
    func beforeDismissal() {
        
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private var canDisableErrorsButton: Bool {
        
        // when the editor tools are not collapsed
        // we need to keep the errors button enable
        // to be able to close the editor tools
        if editorSplitViewController.editorToolsCollapsed {
            return true
        }
        return false
    }
    
    private func listenToFailable(_ failable: Failable) {
        
        failable.subscribeToMessages(observer: self) { [weak self](arrayChange) in
            
            switch arrayChange {
            case .deletes(_, _, let messagesArray):
                self?.updateHeaderState(from: messagesArray, failable: failable)
            case .inserts(_, _, let messagesArray):
                self?.updateHeaderState(from: messagesArray, failable: failable)
            case .insert(_, _, let messagesArray):
                self?.updateHeaderState(from: messagesArray, failable: failable)
            case .move(_, _, _, let messagesArray):
                self?.updateHeaderState(from: messagesArray, failable: failable)
            case .end: fallthrough
            case .start:
                break
            }
            NSApplication.shared.mainMenu?.update()
        }
    }
    
    private func updateHeaderState(from messagesArray: [Message], failable: Failable) {
    
        if messagesArray.isEmpty {
            
            // disable the button if we can
            disableErrorsButtonIfPossible()
            
            if headerStackView.views.count == 2 {
                
                NSAnimationContext.runAnimationGroup({context in
                    context.duration = 0.5
                    context.allowsImplicitAnimation = true

                    self.headerStackView.animator().removeView(self.issuesLabel)
                }, completionHandler: nil)
            }
        }
        else {
            
            errorsButton.isEnabled = true
            
            if headerStackView.views.count == 1 {
                
                NSAnimationContext.runAnimationGroup({context in
                    context.duration = 0.5
                    context.allowsImplicitAnimation = true
                    
                    self.headerStackView.addView(self.issuesLabel, in: NSStackView.Gravity.bottom)
                }, completionHandler: nil)
            }

            updateIssuesLabelString(using: failable)
        }
    }
 
    private func updateIssuesLabelString(using failable: Failable) {
        
        issuesLabel?.stringValue = Strings.shared.numberOfIssuesString(with: failable.issuesCount)
    }
    
    private func disableErrorsButtonIfPossible() {
        
        // disable the button if we can
        if canDisableErrorsButton {
            errorsButton.isEnabled = false
        }
    }
    
}
