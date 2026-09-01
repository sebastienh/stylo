//
//  TextEditorViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-04.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import PromiseKit
import os

class TextEditorViewController: EditorViewController, TextBackgroundColorListener {
    
    var leftView: EditorSideView!
    var rightView: EditorSideView!
    
    @IBOutlet var rightScrollView: EditorSideScrollView!
    
    @IBOutlet var leftScrollView: EditorSideScrollView!
    
    private var initialized: Bool = false
    
    var paragraphStyle: [NSAttributedString.Key: Any]? {
        
        guard let textManager = self.editableManager as? TextManager else {
            assertionFailure("Error: self.textManager is nil")
            return nil
        }
        
        guard let editorId = self.editorId else {
            assertionFailure("Error: self.editorId is nil")
            return nil
        }
        
        guard let editorManager = textManager.editor(for: editorId) else {
            assertionFailure("Error: editorManager is nil")
            return nil
        }
        
        guard let globalAttributes = editorManager.globalAttributes.value else {
            assertionFailure("Error: globalAttributes is nil")
            return nil
        }
        
        guard let textStylePreview = globalAttributes.stylePreview as? TextStylePreview else {
            assertionFailure("Error: textStylePreview is nil")
            return nil
        }
        
        return textStylePreview.pAttributes
    }
    
    var editorId: EditorId? {
        
        return self.resourceEditorView.id
    }
    
    override weak var editableManager: AnyEditable? {
        didSet {
            if editableManager != nil {
                self.bindBackgroundColor()
            }
            else {
                assert(false,"editableManager is nil")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("editableManager is nil", log: Log.StyloCore.all, type: .error)
                #endif
            }
        }
    }

    override func viewWillAppear() {
        
        initializeIfNecessary()
        super.viewWillAppear()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        assert(resourceEditorView != nil)
        self.resourceEditorView?.ensureCompleteLayout()
        
        if let document = self.styloDocument, document.isInViewingMode {
            hideScroller()
        }
        
        let textStorage = self.resourceEditorView.textStorage
        
        assert(textStorage != nil)
        if let textStorage = textStorage, textStorage.length == 0 {
         
            assert(self.paragraphStyle != nil)
            if let paragraphStyle = paragraphStyle {
            
                textStorage.addAttributes(paragraphStyle, range: NSMakeRange(0, 0))
                self.resourceEditorView?.typingAttributes = paragraphStyle
            }
        }
    }
    
    func hideScroller() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Hiding editor scroller", log: Log.StyloCore.all, type: .info)
        #endif
        rightScrollView.hasVerticalScroller = false
    }
    
    func showScroller() {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Showing editor scroller", log: Log.StyloCore.all, type: .info)
        #endif
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 10000)) {
            self.rightScrollView.hasVerticalScroller = true
        }
    }
    
    func scrollToElement(withIndex index: Int) {
        
        assert(self.editableManager is StaticHtmlPreviewable)
        if let staticHtmlPreviewable = self.editableManager as? StaticHtmlPreviewable {
            
            let range = staticHtmlPreviewable.rangeOfElement(at: index)
            
            assert(range != nil)
            if let range = range {
                
                if let rect = resourceEditorView.wordRect(in: range) {
                    self.resourceEditorView.scroll(rect.origin)
                }
            }
        }
    }
    
    func bindBackgroundColor() {
        guard let editableManager = self.editableManager else {
            assertionFailure("Error: self.editableManager is nil")
            return
        }
        self.startListening(to: editableManager)
    }
    
    func updateBackgroundColor(with color: NSColor) {
        
        self.textContainerView.updateBackgroundColor(with: color)
        self.resourceEditorView.updateBackgroundColor(with: color)
        self.leftView.layer?.backgroundColor = color.cgColor
        self.leftView.needsDisplay = true
        self.rightView.layer?.backgroundColor = color.cgColor
        self.rightView.needsDisplay = true
    }
    
    override func initializeEditorView() {
        
        if !editorViewInitialized {
            super.initializeEditorView()
            self.initialiseTextEditorView()
            self.view.needsUpdateConstraints = true 
            (leftView! as! LineNumberingView).setClientWiew(self.resourceEditorView)
            self.editorViewInitialized = true
        }
    }
    
    private func initializeIfNecessary() {
        
        if !initialized {
            
            assert(Thread.isMainThread)
            initializeSideViews()
            initEditorScrollViewScroller()
            initializeEditorView()
            
            #if ALPHA_COLOR_ENABLED
            self.resourceEditorView.drawsBackground = false
            #endif
            self.resourceEditorView.enclosingScrollView?.drawsBackground = false
            self.resourceEditorView.enclosingScrollView?.contentView.drawsBackground = false
            self.resourceEditorView.needsDisplay = true
            
            self.leftView?.enclosingScrollView?.drawsBackground = false
            self.leftView?.enclosingScrollView?.contentView.drawsBackground = false
            
            self.rightView?.enclosingScrollView?.drawsBackground = false
            self.rightView?.enclosingScrollView?.contentView.drawsBackground = false
            self.initialized = true
        }
    }
    
    override func initEditorScrollViewScroller() {
        
        super.initEditorScrollViewScroller()
        
        let contentView = self.resourceEditorScrollView.contentView
        
        contentView.postsBoundsChangedNotifications = true
        
        NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: contentView, queue: nil) { [weak self](notification) in
            self?.viewContentBoundsDidChange(notification)
        }
    }
    
    private func initialiseTextEditorView() {
        
        // here we should make the sroll view listening to scroll
        // notifications about editable sent by the ErrorREporter
        if let failable = editableManager as? Failable {
            resourceEditorScrollView.listentDidSelectMessageInIssuesReporter(from: failable)
        }
        
        setTextContainerConstraints()
        synchronizeScrollViews()
    }
    
    private func initializeSideViews() {
        
        if let leftScrollView = leftScrollView, let rightScrollView = rightScrollView {
            
            let leftContentSize: NSSize = leftScrollView.contentSize
            let rightContentSize: NSSize = rightScrollView.contentSize
            
            let rightView = EditorSideView(frame: NSMakeRect(0, 0, InterfaceConstants.Markdown.Editor.RightSideMinimumWidth, rightContentSize.height))
            let leftView = LineNumberingView(frame: NSMakeRect(0, 0, InterfaceConstants.Markdown.Editor.LeftSideMinimumWidth, leftContentSize.height))

            leftScrollView.borderType = NSBorderType.noBorder
            leftScrollView.hasVerticalScroller = false
            leftScrollView.hasHorizontalScroller = false
            leftScrollView.documentView = leftView
            assert(Thread.isMainThread)
            leftScrollView.needsDisplay = true
            leftScrollView.verticalScroller = HiddenScroller()
            
            rightScrollView.borderType = NSBorderType.noBorder
            rightScrollView.hasVerticalScroller = true
            rightScrollView.hasHorizontalScroller = false
            rightScrollView.documentView = rightView
            assert(Thread.isMainThread)
            rightScrollView.needsDisplay = true
            
            self.rightView = rightView
            self.leftView = leftView
        }
    }
    
    @objc func viewContentBoundsDidChange(_ notification: Notification) {
        
        viewContentBoundsDidChange()
    }
    
    private func synchronizeScrollViews() {
        
        assert(leftScrollView != nil)
        assert(rightScrollView != nil)
        
        if let leftScrollView = leftScrollView, let rightScrollView = rightScrollView {
            
            leftScrollView.setSynchronizedScrollView(resourceEditorScrollView)
            rightScrollView.setSynchronizedScrollView(resourceEditorScrollView)
            resourceEditorScrollView.setSynchronizedScrollView(leftScrollView)
            resourceEditorScrollView.setSynchronizedScrollView(rightScrollView)
        }
    }
    
    private func setTextContainerConstraints() {
        
        textContainerView.rightScrollView = rightScrollView
        textContainerView.leftScrollView = leftScrollView
        textContainerView.rightView = rightView
        textContainerView.leftView = leftView
        textContainerView.addAllConstraints()
    }
    
    private func viewContentBoundsDidChange() {
        
        // if we come from the preview we don't need to
        // do that.
        if let windowController = self.windowController {
            
            windowController.styloWindow.hideLeftButtons()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


