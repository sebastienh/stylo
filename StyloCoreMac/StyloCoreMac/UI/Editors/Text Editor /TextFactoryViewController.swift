//
//  TextFactoryViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-28.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import os

public class TextFactoryViewController: NSViewController, TextBackgroundColorListener {
    
    lazy var documentWorkingViewController: NSViewController = {
        
        let bundle = Bundle(for: DocumentWorkingViewController.self)
        let storyboardStringName = "WorkingOverlay"
        let storyboardName = NSStoryboard.Name(string: storyboardStringName)
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "DocumentWorkingViewController")) as! NSViewController
    }()
    
    @IBOutlet var containerView: NSView!
    
    var textEditorViewController: TextEditorViewController? {
        
        return editorSplitViewController?.editorViewController as? TextEditorViewController
    }
    
    var styloWindowController: StyloWindowController? {

        let styloWindowController = self.view.window?.windowController as? StyloWindowController

        assert(styloWindowController != nil)
        return styloWindowController
    }
    
    // we are not using this editor anymore 
    public var editorId: EditorId? {
        
        return nil
    }
    
    private var initialized: Bool = false
    
    private var editorSplitViewController: TextEditorSplitViewController? {
    
        return self.children.first as? TextEditorSplitViewController
    }
    
    private var textManager: TextManager? {
        
        return styloDocument?.textManager
    }
    
    private var underTitleView: WindowTitleBackgroundView?

    private var documentWorkingOverlayTopConstraint: NSLayoutConstraint?
    private var documentWorkingOverlayBottomConstraint: NSLayoutConstraint?
    private var documentWorkingOverlayLeadingConstraint: NSLayoutConstraint?
    private var documentWorkingOverlayTrailingConstraint: NSLayoutConstraint?
    
    func displayApplyStyleDocumentWorkingOverlay(after delay: Int) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            
            if let styloWindowController = self.styloWindowController, !styloWindowController.styleApplied {
            
                self.view.addSubview(self.documentWorkingViewController.view, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
                self.addDocumentWorkingOverlayConstraints()
            }
        }
    }
    
    var timer: CancellableTimer = CancellableTimer(delay: InterfaceConstants.Global.millisecondsWaitBeforeDisplayingWorkingWindow)
    
    func cancelCurrentDocumentOverlay() {
        
        timer.cancel()
    }
    
    func removeDocumentWorkingOverlay() {
        
        cancelCurrentDocumentOverlay()
        
        removeDocumentWorkingOverlayConstraints()
        if documentWorkingViewController.view.window != nil {
            documentWorkingViewController.view.removeFromSuperview()
        }
    }
    
    override public func viewWillAppear() {
        
        super.viewWillAppear()
        initialize()
    }
    
    func hideUnderTitleView() {
        
        self.underTitleView?.isHidden = true
    }
    
    func showUnderTitleView() {
        
        self.underTitleView?.isHidden = false
    }
    
    override public func mouseMoved(with event: NSEvent) {
        
        let styloWindowController = self.styloWindowController
        
        assert(styloWindowController != nil)
        if let styloWindowController = styloWindowController, styloWindowController.mouseInWindowTitle {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("TextFactoryViewController.mouseMoved -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
            #endif
            NSCursor.arrow.set()
        }
        else {
            super.mouseMoved(with: event)
        }
    }
    
    @IBAction public func showDomTool(_ sender: Any) {
        
        assert(editorSplitViewController != nil)
        editorSplitViewController?.showDomTool(sender)
    }
    
    private func addDocumentWorkingOverlayConstraints() {
        
        let topConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        
        self.view.addConstraint(topConstraint)
        self.view.addConstraint(bottomConstraint)
        self.view.addConstraint(leadingConstraint)
        self.view.addConstraint(trailingConstraint)
        
        documentWorkingOverlayTopConstraint = topConstraint
        documentWorkingOverlayBottomConstraint = bottomConstraint
        documentWorkingOverlayLeadingConstraint = leadingConstraint
        documentWorkingOverlayTrailingConstraint = trailingConstraint
        
        self.view.needsUpdateConstraints = true
    }
    
    private func removeDocumentWorkingOverlayConstraints() {
    
        if let documentWorkingOverlayTopConstraint = documentWorkingOverlayTopConstraint {
            self.view.removeConstraint(documentWorkingOverlayTopConstraint)
        }
        if let documentWorkingOverlayBottomConstraint = documentWorkingOverlayBottomConstraint {
            self.view.removeConstraint(documentWorkingOverlayBottomConstraint)
        }
        if let documentWorkingOverlayLeadingConstraint = documentWorkingOverlayLeadingConstraint {
            self.view.removeConstraint(documentWorkingOverlayLeadingConstraint)
        }
        if let documentWorkingOverlayTrailingConstraint = documentWorkingOverlayTrailingConstraint {
            self.view.removeConstraint(documentWorkingOverlayTrailingConstraint)
        }
        self.view.needsUpdateConstraints = true
    }
    
    private func initialize() {
        
        if !initialized {
            
            assert(textManager != nil)
            if let textManager = textManager {
            
                assert(editorSplitViewController != nil)
                editorSplitViewController?.resourceModelManager = textManager
                createUnderTitleView()
                bindBackgroundColor()
                initialized = true
            }
        }
    }
    
    private func bindBackgroundColor() {
        
        assert(textManager != nil)
        if let textManager = textManager {
            
            self.startListening(to: textManager)
        }
    }
    
    public func updateBackgroundColor(with color: NSColor) {
        
        self.underTitleView?.backgroundColor = color.cgColor
    }
    
    private func createUnderTitleView() {
        
        let frame = NSMakeRect(0, 0, self.view.frame.width, 22)
        let windowTitleBackgroundView = WindowTitleBackgroundView(frame: frame)
        windowTitleBackgroundView.autoresizingMask = .width
        windowTitleBackgroundView.backgroundColor = NSColor.blue.cgColor
        self.view.addSubview(windowTitleBackgroundView, positioned: .above, relativeTo: nil)
        self.underTitleView = windowTitleBackgroundView
    }
    
}
