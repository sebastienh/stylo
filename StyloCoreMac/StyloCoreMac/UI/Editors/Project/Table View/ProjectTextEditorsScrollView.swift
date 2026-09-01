//
//  ProjectTextEditorsScrollView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import Common
import os

fileprivate let showVerticalScrollIntervall: Double = 2

class ProjectTextEditorsScrollView: NSScrollView {
    
    private var oldIsEnabledValue: Bool?
    
    private var isEnabled: Bool = true
    
    override var horizontalScrollElasticity: NSScrollView.Elasticity {
        get {return .none}
        set {}
    }
    
    private var oldScrollPosition: CGPoint?
    
    private var clipViewFrameTimer: Timer?
    
    private var liveResizeTimer: Timer?
    
    private var projectTextEditorsList: ProjectTextEditorsList? {

        var responder = self.nextResponder
        while responder != nil {
            if let projectTextEditorsList = responder as? ProjectTextEditorsList {
                return projectTextEditorsList
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    private var projectTextEditorsTableViewController: ProjectTextEditorsTableViewController? {

        var responder = self.nextResponder
        while responder != nil {
            if let projectTextEditorsTableViewController = responder as? ProjectTextEditorsTableViewController {
                return projectTextEditorsTableViewController
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        listenToClipViewFrameChange()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        listenToClipViewFrameChange()
    }
    
    func disableScrolling(saveOldValue: Bool = true) {
        if saveOldValue && self.oldIsEnabledValue == nil {
            self.oldIsEnabledValue = self.isEnabled
        }
        self.isEnabled = false
    }
    
    func restoreScrolling() {
        if let oldIsEnabledValue = oldIsEnabledValue {
            self.isEnabled = oldIsEnabledValue
        }
        else {
            self.isEnabled = true
        }
        self.oldIsEnabledValue = nil
    }
    
    private var clipViewFrameObserver: NSObjectProtocol?
    
    private func listenToClipViewFrameChange() {
        
        self.contentView.postsFrameChangedNotifications = true
        self.contentView.postsBoundsChangedNotifications = true
        
        self.clipViewFrameObserver = NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: self.contentView, queue: nil, using: { [weak self](_) in
            self?.handleFrameDidChangeNotification()
        })
    }
    
    private func showVerticalScrollerIfPossible() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("showVerticalScrollerIfPossible in outline name: %@", log: Log.StyloCore.all, type: .info, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        guard let window = self.window else {
            assertionFailure("Error: self.window is nil")
            return
        }
        
        if !inLiveResize && !window.inLiveResize {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("inLiveResize: %@, in outline name: %@", log: Log.StyloCore.all, type: .info, %%inLiveResize, %%projectTextEditorsList?.filesOutlineManager?.name.value)
            os_log("window.inLiveResize: %@", log: Log.StyloCore.all, type: .info, %%window.inLiveResize)
            os_log("Showing vertical scroller", log: Log.StyloCore.all, type: .info)
            #endif
            
            removeBoundsObserver()
            self.clipViewFrameTimer?.invalidate()
            self.liveResizeTimer?.invalidate()
            _showVerticalScroller()
        }
    }
    override func scroll(_ point: NSPoint) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scroll(_ point: NSPoint), scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        // Stylo #505: Automatic scrolling when writing the first letter on the top left of the top editor
        if isEnabled {
            super.scroll(point)
        }
    }
    
    override func reflectScrolledClipView(_ cView: NSClipView) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("reflectScrolledClipView(...), scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        // Stylo #505: Automatic scrolling when writing the first letter on the top left of the top editor
        if isEnabled {
            super.reflectScrolledClipView(cView)
        }
    }

    override func scrollWheel(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollWheel(...) scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        if isEnabled {
        
            self.showVerticalScrollerIfPossible()
            
            // Stylo #505: Automatic scrolling when writing the first letter on the top left of the top editor
            super.scrollWheel(with: event)
            self.projectTextEditorsTableViewController?.filesOutlineManager?.handleScroll()
        }
    }
    
    override func scroll(_ clipView: NSClipView, to point: NSPoint) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scroll(_ clipView: NSClipView, to point: NSPoint), scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        if isEnabled {
            super.scroll(clipView, to: point)
        }
    }
    
    override func scrollToVisible(_ rect: NSRect) -> Bool {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollToVisible(...), scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        return super.scrollToVisible(rect)
    }
    
    private func handleFrameDidChangeNotification() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleFrameDidChangeNotification in outline name: %@", log: Log.StyloCore.all, type: .info, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        self.verticalScroller?.alphaValue = 0
        self.clipViewFrameTimer?.invalidate()
        self.clipViewFrameTimer = Timer.scheduledTimer(timeInterval: showVerticalScrollIntervall , target: self, selector: #selector(self.showVerticalScroller), userInfo: [:], repeats: false)
    }
    
    @objc private func showVerticalScroller(timer: Timer) {
        
        _showVerticalScroller()
    }
    
    
    private var observer: NSObjectProtocol?
    
    private var shouldHandleContentViewBoundsChange: Bool = true
    
    override func viewWillStartLiveResize() {
        super.viewWillStartLiveResize()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("viewWillStartLiveResize() in outline name: %@", log: Log.StyloCore.all, type: .info, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        self.oldScrollPosition = self.contentView.bounds.origin
        self.verticalScroller?.alphaValue = 0
        self.contentView.postsBoundsChangedNotifications = true
        if self.observer == nil {
            self.observer = NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: self.contentView, queue: nil) { [weak self](_) in
                self?.handleContentViewBoundsChange()
            }
        }
    }
    
    /// see https://stackoverflow.com/questions/27954538/nstableview-how-to-remove-the-spacebar-event-listener
    override func keyDown(with event: NSEvent) {
        if let key = event.charactersIgnoringModifiers?.charAt(0), key == §UnicodeCharacter.whitespace {
            return
        }
        super.keyDown(with: event)
    }
    
    private func handleContentViewBoundsChange() {
        
        guard let window = self.window else {
            assertionFailure("Error: self.window is nil")
            return
        }
        
        if inLiveResize {
        
            if window.inLiveResize {
                self.oldScrollPosition = self.contentView.bounds.origin
            }
            else {
                
                // avoid an infinite loop 
                if self.shouldHandleContentViewBoundsChange {
                    
                    guard let oldScrollPosition = self.oldScrollPosition else {
                        assertionFailure("Error: self.oldScrollPosition is nil")
                        return
                    }
                    self.shouldHandleContentViewBoundsChange = false
                    self.contentView.setBoundsOrigin(oldScrollPosition)
                    self.shouldHandleContentViewBoundsChange = true
                }
            }
        }
    }
    
    override func scrollPageDown(_ sender: Any?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollPageDown(...), scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        super.scrollPageDown(sender)
    }
    
    override func scrollPageUp(_ sender: Any?) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollPageUp(...), scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
                
        super.scrollPageUp(sender)
    }
    
    override func scrollLineUp(_ sender: Any?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollLineUp(...), scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
                
        super.scrollLineUp(sender)
        
    }

    override func scrollLineDown(_ sender: Any?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollLineDown(...), scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
                
        super.scrollLineDown(sender)
        
    }
    
    override func scrollToEndOfDocument(_ sender: Any?) {
                        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollToEndOfDocument(...), scrolling isEnabled: %@ in outline name: %@", log: Log.StyloCore.all, type: .info, %%isEnabled, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
                
        super.scrollToEndOfDocument(sender)
    }
    
    override func flashScrollers() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("flashScrollers()", log: Log.StyloCore.all, type: .info)
        #endif
        
        super.flashScrollers()
    }
    
    override func viewDidEndLiveResize() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("viewDidEndLiveResize() in outline with name %@", log: Log.StyloCore.all, type: .info, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        super.viewDidEndLiveResize()
        handleViewDidEndLiveResize()
    }
    
    private func handleViewDidEndLiveResize() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleViewDidEndLiveResize in outline name: %@", log: Log.StyloCore.all, type: .info, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        self.liveResizeTimer?.invalidate()
        self.liveResizeTimer = Timer.scheduledTimer(timeInterval: showVerticalScrollIntervall, target: self, selector: #selector(self.handleDidEndLiveResizeScrollingDisabledEnd), userInfo: [:], repeats: false)
    }
    
    @objc private func handleDidEndLiveResizeScrollingDisabledEnd() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleDidEndLiveResizeScrollingDisabledEnd in outline name: %@", log: Log.StyloCore.all, type: .info, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        _showVerticalScroller()
        self.removeBoundsObserver()
    }
    
    private func removeBoundsObserver() {
        
        if let observer = self.observer {
           NotificationCenter.default.removeObserver(observer, name: NSView.boundsDidChangeNotification, object: self.contentView)
        }
        self.observer = nil
    }
    
    private func _showVerticalScroller() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("showing scroller in outline name: %@", log: Log.StyloCore.all, type: .info, %%projectTextEditorsList?.filesOutlineManager?.name.value)
        #endif
        
        self.verticalScroller?.alphaValue = 1
    }
    
    deinit {
        
        guard let clipViewFrameObserver = self.clipViewFrameObserver else {
            assertionFailure("Error: self.clipViewFrameObserver is nil")
            return
        }
        
        NotificationCenter.default.removeObserver(clipViewFrameObserver)
    }
}
