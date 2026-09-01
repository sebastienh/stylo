//
//  StylesheetViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-14.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Cocoa
import Common
import WriterCommon
import StyloCoreMac
import os

class StylesheetViewController: NSViewController, Pushable {
    
    @objc dynamic var listBackTitle: String = "None"
    
    @objc dynamic weak var stylesheetManager: StylesheetManager!
    
    @objc dynamic weak var parentStyleManager: StyleManager?
    
    weak var documentManager: DocumentManager?
    
    @IBOutlet weak var applyButton: NSButton!
    
    @IBOutlet weak var styleTitlePanelView: StyleTitlePanelView!
    
    @IBOutlet weak var domButton: NSButton!
    
    @IBOutlet weak var headerStackView: NSStackView!
    
    @IBOutlet var containerView: NSView!
    
    @IBOutlet weak var errorsButton: NSButton!
    
    @IBOutlet weak var backgroundView: ClearView!
    
    @IBOutlet var titleLable: NSTextField! {
        didSet {
            titleLable.backgroundColor = NSColor.clear
            titleLable.isBezeled = false
            titleLable.focusRingType = .none
        }
    }
    
    private var editorSplitViewController: CssEditorSplitViewController! {
        
        for childViewController in children {
            
            if let editorSplitViewController = childViewController as? CssEditorSplitViewController {
                return editorSplitViewController
            }
        }
        return nil
    }
    
    var hasIssues: Bool {
        
        return !stylesheetManager.errorMessages.isEmpty
    }
    
    var cssEditorToolsViewController: CssEditorToolsMenuViewController? {
        
        let cssEditorToolsMenuViewController = editorSplitViewController.splitViewItems[1].viewController as? CssEditorToolsMenuViewController
        
        assert(cssEditorToolsMenuViewController != nil)
        return cssEditorToolsMenuViewController
    }

    var cssEditorViewController: CssEditorViewController? {
        
        assert(editorSplitViewController != nil)
        guard !editorSplitViewController.splitViewItems.isEmpty else {
            return nil
        }
        let splitViewItem = editorSplitViewController.splitViewItems[0]
        let cssEditorViewController = splitViewItem.viewController as? CssEditorViewController
        assert(cssEditorViewController != nil)
        return cssEditorViewController
    }
    
    var resourceEditorView: ResourceEditorView? {
        
        return self.cssEditorViewController?.resourceEditorView
    }
    
    var editorId: EditorId? {
        
        return self.resourceEditorView?.id
    }
    
    var errorsToolsShown: Bool {
        
        let selectedTool = cssEditorToolsViewController?.selectedTool
        
        if let selectedTool = selectedTool {
            
            return selectedTool == CssEditorToolsMenuViewController.EditorToolType.errors
        }
        return false
    }
    
    var captureViewTag = 99

    var segue: TransitionSegue?

    weak var styleViewController: StyleViewController?
    
    var styleEditorPlugin: StyleEditorPlugin? {
        
        return styleViewController?.cssViewController?.styleEditorPlugin
    }
    
    var hasPendingChanges: Bool {
        
        return stylesheetManager.hasPendingChanges.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.wantsLayer = true
        
        if StyloConstants.CSS.editorPresentationAnimationMode == .transition {
            self.view.autoresizingMask = [.height, .width]
            assert(self.styleViewController != nil)
            segue = TransitionSegue(identifier: "previous", source: self, destination: self.styleViewController as Any, performHandler: { () -> Void in })
        }
    }
    
    override func viewWillDisappear() {
        
        super.viewWillDisappear()
    }
    
    @IBAction func toggleEditorToolsPanel(_ sender: AnyObject?) {
        
        let collapsing = !editorSplitViewController.editorToolsCollapsed
        
        guard let editorId = self.editorId else {
            assertionFailure("Error: self.editorId is nil")
            return
        }
        
        if editorSplitViewController.editorToolsCollapsed {
            if stylesheetManager.presentingErrors == 1 {
                stylesheetManager.highlightAllErrors(forEditorWithId: editorId)
            }
        }
        else {
            if stylesheetManager.presentingErrors == 1 {
                stylesheetManager.clearErrorHighlight(forEditorWithId: editorId)
            }
        }
        
        // uncolapse the tools
        editorSplitViewController.toggleEditorToolsPanel()
        
        if collapsing && stylesheetManager.errorMessages.isEmpty {
            
            // disable the button if we can
            disableErrorsButtonIfPossible()
        }
        NSApplication.shared.mainMenu?.update()
    }
    
    @IBAction func domButtonClicked(_ sender: NSButton?) {
        
        guard let editorId = self.editorId else {
            assertionFailure("Error: self.editorId is nil")
            return
        }
        
        stylesheetManager.clearErrorHighlight(forEditorWithId: editorId)
        
        if domButton.state == NSControl.StateValue.on {
            
            if editorSplitViewController.editorToolsCollapsed {
                
                // uncolapse the tools
                editorSplitViewController.toggleEditorToolsPanel()
            }
            else {
                
                stylesheetManager.presentingHelp = 0
                stylesheetManager.presentingErrors = 0
            }
            
            // select the styles tool
            assert(cssEditorToolsViewController != nil)
            cssEditorToolsViewController?.selectTool(sender!)
        }
        else {
            
            // colapse the tools
            editorSplitViewController.toggleEditorToolsPanel()
        }
    }
    
    @IBAction func errorButtonClicked(_ sender: NSButton?) {
        
        if errorsButton.state == NSControl.StateValue.on {
            
            if editorSplitViewController.editorToolsCollapsed {
                
                guard let editorId = self.editorId else {
                    assertionFailure("Error: self.editorId is nil")
                    return
                }
                
                stylesheetManager.highlightAllErrors(forEditorWithId: editorId)
                // uncolapse the tools
                editorSplitViewController.toggleEditorToolsPanel()
            }
            else {
                
                guard let editorId = self.editorId else {
                    assertionFailure("Error: self.editorId is nil")
                    return
                }
                
                stylesheetManager.clearErrorHighlight(forEditorWithId: editorId)
                stylesheetManager.presentingDom = 0
                stylesheetManager.presentingHelp = 0
            }
            
            // select the styles tool
            assert(cssEditorToolsViewController != nil)
            cssEditorToolsViewController?.selectTool(sender!)
        }
        else {
            
            // colapse the tools
            editorSplitViewController.toggleEditorToolsPanel()
        }
    }
    
    @IBAction func showDomTool(_ sender: Any?) {
        
        editorSplitViewController.showDomTool(sender)
    }
    
    @IBAction func goBack(_ sender: Any? = nil) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self.parent: %@", %%self.parent)
        #endif
        
        switch StyloConstants.CSS.editorPresentationAnimationMode {
        case .present:
            
            guard let styleViewController = self.styleViewController else {
                assertionFailure("Error: styleViewController is nil")
                return
            }
            
            styleViewController.editedStylesheetViewController = nil
            styleViewController.dismiss(self)
        
        case .transition:
            
            guard let styleViewController = self.styleViewController else {
                assertionFailure("Error: styleViewController is nil")
                return
            }
            
            styleViewController.editedStylesheetViewController = nil
            
            if let capture = self.viewImageView {
                capture.frame = view.frame
                capture.tag = captureViewTag
                view.addSubview(capture, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
            }
            segue?.perform()
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self.hasPendingChanges: %@", %%self.hasPendingChanges)
        os_log("stylesheetManager.hasPendingChanges.value: %@", %%stylesheetManager.hasPendingChanges.value)
        #endif
        
        self.styleViewController?.hasPendingChanges = self.hasPendingChanges
    }
    
    func applyPendingChanges() {
        
        assert(self.styleEditorPlugin != nil)
        self.styleEditorPlugin?.updateTextStyleForSelectedStyleManagerIfPendingChanges()
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        if StyloConstants.CSS.editorPresentationAnimationMode == .transition {
            if let capture = view.viewWithTag(captureViewTag) {
                capture.removeFromSuperview()
            }
        }
        
        setManagersInTargetEditor()
        
        guard let stylesheetManager = self.stylesheetManager else {
            assertionFailure("Error: self.stylesheetManager is nil")
            return
        }
            
        NSApplication.shared.mainMenu?.update()
        updateHeaderState(from: stylesheetManager.errorMessages, stylesheetManager: stylesheetManager)
        listenToFailable(stylesheetManager)
    }
    
    func applyAppearanceMode(_ appearanceMode: AppearanceMode) {

        guard let stylesheetManager = self.stylesheetManager else {
            assertionFailure("Error: stylesheetManager is nil")
            return
        }
        
        stylesheetManager.applyAppearanceMode(appearanceMode)
    }
    
    private func setManagersInTargetEditor() {
    
        if editorSplitViewController.resourceModelManager == nil {
        
            editorSplitViewController.resourceModelManager = stylesheetManager
            editorSplitViewController.documentManager = documentManager
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Pushable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var contentView: NSView? {
        
        return containerView
    }
    
    func completeAfterPush() {
        
    }
    
    func beforeDismissal() {
        
        let editor = cssEditorViewController!.resourceEditorView as! CssResourceEditorView
        editor.needsDisplay = true
        editor.display()
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
    
    private func listenToFailable(_ stylesheetManager: StylesheetManager) {
        
        stylesheetManager.subscribeToMessages(observer: self) { [weak self](arrayChange) in
            
            switch arrayChange {
            case .insert(_, _, let messagesArray):
                self?.updateHeaderState(from: messagesArray, stylesheetManager: stylesheetManager)
            case .deletes(_, _, let messagesArray):
                self?.updateHeaderState(from: messagesArray, stylesheetManager: stylesheetManager)
            case .inserts(_, _, let messagesArray):
                self?.updateHeaderState(from: messagesArray, stylesheetManager: stylesheetManager)
            case .move(_, _, _, let messagesArray):
                self?.updateHeaderState(from: messagesArray, stylesheetManager: stylesheetManager)
            case .end: fallthrough
            case .start:
                break
            }
            NSApplication.shared.mainMenu?.update()
        }
    }
    
    private func updateHeaderState(from messagesArray: [Message], stylesheetManager: StylesheetManager) {
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Update CSS Editor header state", log: Log.StyleEditor.all, type: .info)
        #endif
        
        if messagesArray.isEmpty {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("CSS Errors is empty removing errors label", log: Log.StyleEditor.all, type: .info)
            #endif
            
            disableErrorsButtonIfPossible()
        }
        else {
            
            errorsButton.isEnabled = true
        }
        
        updateIssuesLabelString(from: messagesArray)
    }
 
    private func updateIssuesLabelString(from messagesArray: [Message]) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Obtaing number of issues from errors array: %@", log: Log.StyleEditor.all, type: .info, %%messagesArray)
        #endif
        
        errorsButton?.title = Strings.shared.numberOfIssuesString(with: messagesArray.count)
    }
    
    private func disableErrorsButtonIfPossible() {
        
        // disable the button if we can
        if canDisableErrorsButton {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Disabling errors button", log: Log.StyleEditor.all, type: .info)
            #endif
            
            errorsButton.isEnabled = false
        }
    }
}

