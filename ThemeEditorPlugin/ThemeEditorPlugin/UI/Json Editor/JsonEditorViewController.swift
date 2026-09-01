//
//  JsonEditorViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-03.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import PromiseKit
import StyloCoreMac

final class JsonEditorViewController: EditorViewController, TextBackgroundColorListener {
    
    var listening: Bool = false
    
    var failable: Failable? {
        
        return self.editableManager as! Failable?
    }
    
    private var jsonManager: JsonManager? {
    
        return self.editableManager as! JsonManager?
    }

    override func viewWillAppear() {
        
        initEditorScrollViewScroller()
        initializeEditorView()
        self.bindBackgroundColor()
        assert(self.jsonManager != nil)
//        self.jsonManager?.handleThemeChange(forced: true)
        super.viewWillAppear()
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        listenToDidUpdateIssuesArray()
    }
    
    func bindBackgroundColor() {
        
//        if let jsonManager = jsonManager {
//
//            if let backgroundColor = jsonManager.backgroundColor.value {
//
//                updateBackgroundColor(with: backgroundColor)
//            }
//
//            self.startListening(to: stylesheetManager)
//        }
//        else {
//
//            self.resourceEditorView.backgroundColor = NSColor.gray
//        }
    }
    
    func updateBackgroundColor(with color: NSColor) {
        
        self.resourceEditorView.backgroundColor = color
    }
    
    override func initEditorScrollViewScroller() {
        
        resourceEditorScrollView.verticalScroller = JsonEditorScroller()
    }

    override func initializeEditorView() {

        if !editorViewInitialized {
            
            super.initializeEditorView()
            self.initialiseCssEditorView()
            self.editorViewInitialized = true
        }
    }
    
    override func createResourceEditorView(with size: NSSize, window: NSWindow?) {
        
        // create the resource editor view
        resourceEditorView =  JsonResourceEditorView.GetResourceEditorInstance(editableManager!, andContentSize: size)
        resourceEditorScrollView.documentView = resourceEditorView
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func initialiseCssEditorView() {
        
        self.resourceEditorView.drawsBackground = true
        self.resourceEditorView.needsDisplay = true
        
        assert(editableManager is Failable)
        if let failable = editableManager as? Failable {
            
            resourceEditorScrollView.listentDidSelectMessageInIssuesReporter(from: failable)
        }
        
        setTextContainerConstraints()
    }
    
    private func listenToDidUpdateIssuesArray() {
        
        if !listening {
            
            let jsonManager = editableManager as! JsonManager
            
            jsonManager.subscribeToMessages(observer: self) { [weak self](change: DynamicArray<Message>.Change) -> Void in

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
            
            self.updateSrollerMessages(messages: jsonManager.errors)
            listening = true
        }
    }
    
    private func updateSrollerMessages(messages: [Message]) {
        
        if let jsonEditorScroller = self.resourceEditorScrollView.verticalScroller as? JsonEditorScroller {
            
            if jsonEditorScroller.resourceEditorView == nil {
                jsonEditorScroller.resourceEditorView = self.resourceEditorView
            }
            jsonEditorScroller.messages = messages
            assert(Thread.isMainThread)
        }
    }
    
    private func setTextContainerConstraints() {
        
        textContainerView.addAllConstraints()
    }
}
