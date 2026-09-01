//
//  EditorContainerView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-06-23.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import os

class EditorContainerView: NSView {
    
    private var projectTextEditor: ProjectTextEditor? {
        for subview in self.subviews {
            if let projectEditorView = subview as? ProjectTextEditor {
                return projectEditorView
            }
        }
        return nil
    }
    
    private var allowsUpdatingEditorConstraints: Bool = true
    
    private var oldFrameSize: CGSize = .zero
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.addGlobalTrackingArea()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addGlobalTrackingArea()
    }
    
    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        
        self.oldFrameSize = self.frame.size
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        updateEditorHeightConstraintIfNeeded()
    }
    
    private func updateEditorHeightConstraintIfNeeded() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateEditorHeightConstraintIfNeeded called for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.projectTextEditor!.textManager!.name.value)
        os_log("updateEditorHeightConstraintIfNeeded self.frame.width: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.frame.width, %%self.projectTextEditor!.textManager!.name.value)
        os_log("updateEditorHeightConstraintIfNeeded self.oldFrameSize.width: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.oldFrameSize.width, %%self.projectTextEditor!.textManager!.name.value)
        os_log("updateEditorHeightConstraintIfNeeded allowsUpdatingEditorConstraints: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%allowsUpdatingEditorConstraints, %%self.projectTextEditor!.textManager!.name.value)
        #endif
        
        
        let frameWidthChanged = !self.frame.width.isEqual(to: self.oldFrameSize.width)
        
        if frameWidthChanged && self.allowsUpdatingEditorConstraints {
            
            guard let projectTextEditor = self.projectTextEditor else {
                assertionFailure("Error: self.projectTextEditor is nil")
                return
            }
            
            projectTextEditor.needsUpdateConstraints = true
        }
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        self.subscribeToSidebarsNotifications()
    }
    
    private func subscribeToSidebarsNotifications() {
        
        guard let window = self.window else {
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willHideSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsWillHide()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.showingSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsShowing()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.hidingSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsHiding()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didHideSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsDidHide()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willShowSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsWillShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didShowSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsDidShow()
        }
    }
    
    func handleSidebarsShowing() {
        
        self.allowsUpdatingEditorConstraints = false
    }
    
    func handleSidebarsHiding() {
        
        self.allowsUpdatingEditorConstraints = false
    }
    
    func handleSidebarsWillShow() {
        
        self.allowsUpdatingEditorConstraints = false
    }
    
    func handleSidebarsDidShow() {
        
        self.allowsUpdatingEditorConstraints = true
    }
    
    func handleSidebarsWillHide() {
        
        self.allowsUpdatingEditorConstraints = false
    }
    
    func handleSidebarsDidHide() {
        
        self.allowsUpdatingEditorConstraints = true
    }
    
    override func mouseEntered(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("EditorContainerView.mouseEntered -> NSCursor.iBeam.set()", log: Log.StyloCore.all, type: .info)
        #endif
        NSCursor.iBeam.set()
    }
}
