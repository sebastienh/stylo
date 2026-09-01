//
//  CssEditorViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-03.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac
import Common
import PromiseKit

final class CssEditorViewController: EditorViewController, TextBackgroundColorListener {
    
    @IBOutlet var leftView: EditorSideView!
    
    var editorId: EditorId? {
        
        return self.resourceEditorView.id
    }

    var listening: Bool = false
    
    var failable: Failable? {
        
        return self.editableManager as! Failable?
    }
    
    private var stylesheetManager: StylesheetManager? {
    
        return self.editableManager as? StylesheetManager
    }
    
    var messagesViewController: MessagesViewController? {
        
        for childController in self.children {
            if let _messagesViewController = childController as? MessagesViewController {
                return _messagesViewController
            }
        }
        return nil
    }

    override func viewWillAppear() {
        
        super.viewWillAppear()
        hideEditorVerticalScroller()
    }

    override func viewDidAppear() {
        
        super.viewDidAppear()
        listenToDidUpdateIssuesArray()
        showEditorVerticalScroller()
    }
    
    func prepareViewController(window: NSWindow) {
        
        initEditorScrollViewScroller()
        initializeEditorView(window: window)
        self.bindBackgroundColor()
        assert(self.stylesheetManager != nil)
    }
    
    
    func bindBackgroundColor() {
        
        if let stylesheetManager = stylesheetManager {
            
            if let backgroundColor = stylesheetManager.backgroundColor.value {
                updateBackgroundColor(with: backgroundColor)
            }
            
            self.startListening(to: stylesheetManager)
        }
        else {
            assert(false, "stylesheetManager was nil")
            self.resourceEditorView.backgroundColor = NSColor.gray
        }
    }
    
    func updateBackgroundColor(with color: NSColor) {
        
        self.resourceEditorView.backgroundColor = color
        self.leftView.backgroundColor = color.cgColor
    }
    
    override func initEditorScrollViewScroller() {
        
        resourceEditorScrollView.verticalScroller = CssEditorScroller()
    }

    func initializeEditorView(window: NSWindow?) {

        if !editorViewInitialized {
            
            // no need to compute the height, the NSLayoutManager along with the NSTextContainer
            // will set it properly
            self.createResourceEditorView(with: resourceEditorScrollView.contentSize, window: window)
            self.initialiseCssEditorView()
            self.editorViewInitialized = true
        }
    }
    
    func createResourceEditorView(with size: NSSize, window: NSWindow?) {

        guard let stylesheetManager = self.stylesheetManager else {
            assertionFailure("Error: self.stylesheetManager is nil")
            return
        }
        
        assert(self.stylesheetManager?.styleManager != nil)
        
        // create the resource editor view
        resourceEditorView = CssResourceEditorView.GetResourceEditorInstance(stylesheetManager, andContentSize: size, window: window)
        resourceEditorScrollView.documentView = resourceEditorView
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func initialiseCssEditorView() {
        
        self.resourceEditorView.drawsBackground = true
        self.resourceEditorView.needsDisplay = true
        
        guard let stylesheetManager = self.stylesheetManager else {
            assertionFailure("Error: self.stylesheetManager is nil")
            return
        }
        
        guard let styleManager = stylesheetManager.styleManager.value else {
            assertionFailure("Error: stylesheetManager.styleManager.value is nil")
            return
        }
        
        try? stylesheetManager.registerEditor(withRenderer: resourceEditorView)
        stylesheetManager.setStyleAssemblyDescriptor(styleManager.currentAppearanceSourceDescriptor, forEditorId: self.resourceEditorView.id, visibleRange: nil)
        
        // make sure we have the right attributes
        self.resourceEditorView.typingAttributes = [:]
        
        assert(editableManager is Failable)
        if let failable = editableManager as? Failable {
            
            resourceEditorScrollView.listentDidSelectMessageInIssuesReporter(from: failable)
        }
        
        setTextContainerConstraints()
    }
    
    private func listenToDidUpdateIssuesArray() {
        
        if !listening {
            
            let stylesheetManager = editableManager as! StylesheetManager
            
            stylesheetManager.subscribeToMessages(observer: self) { [weak self](change: DynamicArray<Message>.Change) -> Void in
                
                switch change {
                case .deletes(_, _, let messagesArray):
                    self?.updateSrollerMessages(messages: messagesArray)
                case .inserts(_, _, let messagesArray):
                    self?.updateSrollerMessages(messages: messagesArray)
                case .insert(_, _, let messagesArray):
                    self?.updateSrollerMessages(messages: messagesArray)
                case .move(_, _, _, let messagesArray):
                    self?.updateSrollerMessages(messages: messagesArray)
                case .end: fallthrough
                case .start:
                    break
                }
            }
            
            self.updateSrollerMessages(messages: stylesheetManager.errorMessages)
            
            listening = true
        }
    }
    
    private func updateSrollerMessages(messages: [Message]) {
        
        if let cssEditorScroller = self.resourceEditorScrollView.verticalScroller as? CssEditorScroller {
            
            if cssEditorScroller.resourceEditorView == nil {
                
                cssEditorScroller.resourceEditorView = self.resourceEditorView
            }
            cssEditorScroller.messages = messages
            assert(Thread.isMainThread)
        }
    }
    
    private func setTextContainerConstraints() {
        
        textContainerView.addAllConstraints()
    }
}
