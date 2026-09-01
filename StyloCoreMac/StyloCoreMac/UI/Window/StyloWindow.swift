//
//  StyloWindow.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-19.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import os

let TitleBarDisappearanceDuration = 0.75

extension NSWindow {
    
    func disableCloseButton() {
        
        let button: NSButton = standardWindowButton(NSWindow.ButtonType.closeButton)!
        button.isEnabled = false
    }
    
    func enableCloseButton() {
        
        let button: NSButton = standardWindowButton(NSWindow.ButtonType.closeButton)!
        button.isEnabled = true
    }
}

public final class StyloWindow: NSWindow, TextKeydownListener {
    
    public var titleBarHidden: Bool = false
    
    public var oldFrame: NSRect?
    
    var leftButtonsHidden: Bool {
        
        assert(closeButtonHidden != nil)
        if let closeButtonHidden = closeButtonHidden, let zoomButtonHidden = zoomButtonHidden, let miniaturizeButtonHidden = miniaturizeButtonHidden, closeButtonHidden && zoomButtonHidden && miniaturizeButtonHidden {
            
            return true
        }
        return false
    }
    
    /// see https://stackoverflow.com/questions/6815917/how-to-know-if-a-nswindow-is-fullscreen-in-mac-os-x-lion
    var fullScreen: Bool {
        
        return self.styleMask.contains(.fullScreen)
    }
    
    var closeButtonHidden: Bool? {
        
        let closeButton = self.standardWindowButton(NSWindow.ButtonType.closeButton)
        
        assert(closeButton != nil)
        if let closeButton = closeButton {
            
            return closeButton.isHidden
        }
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("closeButton is nil, in closeButtonHidden", log: Log.StyloCore.all, type: .error)
        #endif
        return nil
    }
    
    var zoomButtonHidden: Bool? {
        
        let zoomButton = self.standardWindowButton(NSWindow.ButtonType.zoomButton)
        
        assert(zoomButton != nil)
        if let zoomButton = zoomButton {
            
            return zoomButton.isHidden
        }
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("zoomButton is nil, in zoomButtonHidden", log: Log.StyloCore.all, type: .error)
        #endif
        return nil
    }
    
    var miniaturizeButtonHidden: Bool? {
        
        let miniaturizeButton = self.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)
        
        assert(miniaturizeButton != nil)
        if let miniaturizeButton = miniaturizeButton {
            
            return miniaturizeButton.isHidden
        }
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("miniaturizeButton is nil, in miniaturizeButtonHidden", log: Log.StyloCore.all, type: .error)
        #endif
        return nil
    }
    
    var toolsDisplayed: Bool = false

    /// We use this variable to know if we should send
    /// document is key value in DocumentManager. If window
    /// is closing, document is closing and a lot of objects
    /// are released that may lead to problems.
    private var closing: Bool = false
    
    private var themeFrame: NSView? {
        
        guard let superview = self.contentView?.superview else {
            assertionFailure("Error: subviews are nil")
            return nil
        }

        guard superview.className == "NSThemeFrame" else {
            assertionFailure("Error: superview is not NSThemeFrame")
            return nil
        }
        
        return superview
    }
    
    private var titlebarContainerView: NSView? {
        
        guard let themeFrame = self.themeFrame else {
            assertionFailure("Error: themeFrame is nil")
            return nil
        }
        
        for subview in themeFrame.subviews {
            if subview.className == "NSTitlebarContainerView" {
                return subview
            }
        }
        return nil
    }
    
    private var titlebarView: NSView? {
        
        guard let titlebarContainerView = self.titlebarContainerView else {
            assertionFailure("Error: titlebarContainerView is nil")
            return nil
        }
        
        for subview in titlebarContainerView.subviews {
            if subview.className == "NSTitlebarView" {
                return subview
            }
        }
        return nil
    }
    
    private var documentNameTextField: NSTextField? {
        
        guard let titlebarView = self.titlebarView else {
            assertionFailure("Error: titlebarView is nil")
            return nil
        }
        
        for subview in titlebarView.subviews {
            if let textField = subview as? NSTextField {
                return textField
            }
        }
        return nil
    }
    
    private var titleView: NSView? {
        
        if let themeFrame = self.contentView?.superview {
            
            return themeFrame.subviews[1]
        }
        return nil
    }
    
    var styloWindowController: StyloWindowController {
        
        return self.windowController as! StyloWindowController
    }
    
    var styloDocument: MacStyloDocument? {
        
        return styloWindowController.styloDocument
    }
    
    override public var backgroundColor: NSColor! {
        
        get {
            return NSColor.clear
        }
        set { }
    }
    
    override public var isOpaque: Bool {
        
        get {
            return false
        }
        set { }
    }
    
    override init(contentRect: NSRect, styleMask aStyle: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
        
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
        
        self.titlebarAppearsTransparent = true
        self.acceptsMouseMovedEvents = true
        self.allowsConcurrentViewDrawing = true
        
        if !StyloConstants.Configuration.LightModeEnabled {
            
            // NW-1100: we lock the appearance to dark mode for now
            self.appearance = NSAppearance(named: NSAppearance.Name.darkAqua)
        }
        
        startListeningToKeydownEvents()
//        addDocumentNameTextFieldConstraints()
    }
    
    var settingWindowFrameEnabled = true
    
    override public func setFrame(_ frameRect: NSRect, display displayFlag: Bool, animate animateFlag: Bool) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setFrame", log: Log.StyloCore.all, type: .info)
        #endif
        if settingWindowFrameEnabled {
            super.setFrame(frameRect, display: displayFlag, animate: animateFlag)
        }
    }
    
    func updateAutosaveFrame() {
        
        let frameId = self.styloDocument?.frameId
        
        // frameId can be nil if the url is nil...
        if let frameId = frameId {
            self.saveFrame(usingName: frameId)
        }
    }
    
    public func updateAppearance(from color: NSColor?) {
        
        let appearance = self.appearance(from: color)
        self.changeAppearance(appearance)
    }
    
    private func appearance(from color: NSColor?) -> AppearanceMode {
        
        if let color = color, !isLight(color: color) {
            return AppearanceMode.dark
        }
        return AppearanceMode.light
    }
    
    private func isLight(color: NSColor) -> Bool {
        
        if let color = DynamicColor(cgColor: color.cgColor) {
            
            return color.isLight()
        }
        return true
    }
    
    func changeAppearance(_ appearanceMode: AppearanceMode) {
        
        
        // see http://stackoverflow.com/questions/29952202/changing-the-background-color-of-the-unified-nstoolbar-in-yosemite
        // This method is called when the background color of the text change.
        switch appearanceMode {
        case .dark:
            
            let vibrantDarkAppearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
            // the title should take the right value
            self.appearance = vibrantDarkAppearance
            // the cursor in the editor should also take
//            assert(styloWindowController.textEditorViewController != nil)
            guard let projectTextEditorsPanelsViewController = styloWindowController.projectTextEditorsPanelsViewController else {
                assertionFailure("Error: projectTextEditorsPanelsViewController is nil")
                return
            }
            
            for projectTextEditorsTableViewController in projectTextEditorsPanelsViewController.projectTextEditorsTableViewControllers {
                
                for (_, editorViewController) in projectTextEditorsTableViewController.projectTextEditorViewControllers {
                    editorViewController.view.appearance = vibrantDarkAppearance
                }
            }

        case .light:
            
            let vibrantLightAppearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
            self.appearance = vibrantLightAppearance
            
            guard let projectTextEditorsPanelsViewController = styloWindowController.projectTextEditorsPanelsViewController else {
                assertionFailure("Error: projectTextEditorsPanelsViewController is nil")
                return
            }
            
            for projectTextEditorsTableViewController in projectTextEditorsPanelsViewController.projectTextEditorsTableViewControllers {
                
                for (_, editorViewController) in projectTextEditorsTableViewController.projectTextEditorViewControllers {
                    editorViewController.view.appearance = vibrantLightAppearance
                }
            }
        }
    }
    
    var allowCloseButtonButtonOriginReset: Bool = true
    var allowMiniaturizeButtonButtonOriginReset: Bool = true
    var allowZoomButtonButtonOriginReset: Bool = true
    
    public func setAllowButtonsOriginReset(_ value: Bool) {
        
        allowCloseButtonButtonOriginReset = value
        allowMiniaturizeButtonButtonOriginReset = value
        allowZoomButtonButtonOriginReset = value
    }
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()

        if !self.fullScreen {
            resetButtonsOriginsForNormalScreen()
        }
        else {
            resetButtonsOriginsForFullScreen()
        }
    }
    
    public override func becomeKey() {
        super.becomeKey()
        
        guard let documentManager = self.styloDocument?.documentManager else {
            assertionFailure("Error: documentManager is nil")
            return
        }
        
        documentManager.updateIsKeyDocument(to: true)
    }
    
    public override func resignKey() {
        super.resignKey()
        
        guard let documentManager = self.styloDocument?.documentManager else {
            assertionFailure("Error: documentManager is nil")
            return
        }
        
        if !closing {
            documentManager.updateIsKeyDocument(to: false)
        }
    }
    
    public override func close() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("close()", log: Log.StyloCore.all, type: .info)
        #endif
        
        self.closing = true
        super.close()
    }
    
    override public func standardWindowButton(_ b: NSWindow.ButtonType) -> NSButton? {
        
        guard let button = super.standardWindowButton(b) else {
            return nil
        }

        if !self.fullScreen {
            resetButtonsOriginsForNormalScreen()
        }
        else {
            resetButtonsOriginsForFullScreen()
        }
        return button
    }

    func resetButtonsOriginsForNormalScreen() {
    
        moveButtonDownIfNeeded(ofType: .closeButton)
        moveButtonDownIfNeeded(ofType: .miniaturizeButton)
        moveButtonDownIfNeeded(ofType: .zoomButton)
    }
    
    func resetButtonsOriginsForFullScreen() {
        
        moveButtonUpIfNeeded(ofType: .closeButton)
        moveButtonUpIfNeeded(ofType: .miniaturizeButton)
        moveButtonUpIfNeeded(ofType: .zoomButton)
    }
    
    func moveButtonDownIfNeeded(_ button: NSButton) {
        
        if button.frame.origin.y == StyloConstants.Window.StandardsButtonsVerticalOriginalPosition {
            moveButtonDown(button)
        }
    }
    
    func moveButtonDownIfNeeded(ofType type: NSWindow.ButtonType) {
        guard let button = super.standardWindowButton(type) else {
            return
        }
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("button.frame.origin.y: %@", log: Log.StyloCore.all, type: .info, %%button.frame.origin.y)
        os_log("StyloConstants.Window.StandardsButtonsVerticalOriginalPosition: %@", log: Log.StyloCore.all, type: .info, %%StyloConstants.Window.StandardsButtonsVerticalOriginalPosition)
        #endif
        
        if button.frame.origin.y == StyloConstants.Window.StandardsButtonsVerticalOriginalPosition {
            moveButtonDown(button)
        }
    }
    
    func moveButtonUpIfNeeded(ofType type: NSWindow.ButtonType) {

        guard let button = super.standardWindowButton(type) else {
            return
        }
        
        if button.frame.origin.y != StyloConstants.Window.StandardsButtonsVerticalOriginalPosition {
            self.moveButtonUp(button)
        }
    }

    private func moveButtonUp(_ button: NSView) {
     
        button.setFrameOrigin(NSMakePoint(button.frame.origin.x, button.frame.origin.y+StyloConstants.Window.StandardsButtonsVerticalDeviation))
    }
    
    private func moveButtonDown(_ button: NSView) {
        
        button.setFrameOrigin(NSMakePoint(button.frame.origin.x, button.frame.origin.y-StyloConstants.Window.StandardsButtonsVerticalDeviation))
    }

    public func showLeftButtons() {
        prepareShowingLeftButtons() { [weak self] in
            self?._showLeftButtons()
        }
    }
    
    public func hideLeftButtons() {
        prepareHidingLeftButtons() { [weak self] in
            self?._hideLeftButtons()
        }
    }

    /// Every window sends a notification to be handle anywhere when it detects
    /// a mouse moved event inside it. Every subview is responsible for registering
    /// to such events and to handle it properly for it's own purpose.
    override public func mouseMoved(with theEvent: NSEvent) {
        
        self.styloWindowController.allowHidingTitle = true
        super.mouseMoved(with: theEvent)
    }
    
    func handleKeydownEvent(with event: NSEvent) {
        
        self.styloWindowController.allowHidingTitle = true
        
        if self.styloWindowController.projectSidebarCollapsed {
            self.hideLeftButtons()
        }
        handleCopySelector(with: event)
    }

    override public func mouseDown(with theEvent: NSEvent) {

        self.styloWindowController.allowHidingTitle = true
        StyloNotification.WindowMouseDown.sendNotification(self)
        super.mouseDown(with: theEvent)
    }

    public func copySelector(from elementSelection: ElementSelection) {
        
        let selectorString = elementSelection.element.selector(for: elementSelection.charIndex)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("selectorString: %@", log: Log.StyloCore.all, type: .debug, %%selectorString)
        #endif
        NSPasteboard.general.clearContents()
        NSPasteboard.general.writeObjects([NSString(string: selectorString)])
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func _showLeftButtons() {
        if leftButtonsHidden {
            self.standardWindowButton(.closeButton)?.isHidden = false
            self.standardWindowButton(.zoomButton)?.isHidden = false
            self.standardWindowButton(.miniaturizeButton)?.isHidden = false
        }
    }
    
    private func _hideLeftButtons() {
        if !leftButtonsHidden && styloWindowController.allowHidingTitle {
            self.standardWindowButton(NSWindow.ButtonType.closeButton)?.isHidden = true
            self.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
            self.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
        }
    }
    
    private func prepareShowingLeftButtons(_ completion: @escaping () -> Void) {
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.1
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            StyloNotification.willShowLeftButtons.sendNotification(self)
        }) {
            completion()
            StyloNotification.didShowLeftButtons.sendNotification(self)
        }
    }
    
    private func prepareHidingLeftButtons(_ completion: @escaping () -> Void) {
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.1
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            StyloNotification.willHideLeftButtons.sendNotification(self)
        }) {
            completion()
            StyloNotification.didHideLeftButtons.sendNotification(self)
        }
    }
    
    private func handleCopySelector(with event: NSEvent) {
        
        if isCopySelectorEvent(with: event) {
            
            let styloWindowController = self.windowController as? StyloWindowController
            assert(styloWindowController != nil)
//            if let elementSelection = styloWindowController?.markdownResourceEditorView?.elementSelection {
//
//                copySelector(from: elementSelection)
//            }
        }
    }
    
    // Alt-Cmd-C
    private func isCopySelectorEvent(with theEvent: NSEvent) -> Bool {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("theEvent.keyCode: %@", log: Log.StyloCore.all, type: .debug, %%theEvent.keyCode)
        #endif
        if theEvent.keyCode == 8 {
            
            if let ch = theEvent.charactersIgnoringModifiers {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("ch: %@", log: Log.StyloCore.all, type: .debug, %%ch)
                #endif
                
                if ch == "c" && theEvent.modifierFlags.contains(.command) && theEvent.modifierFlags.contains(.option) {
                    return true
                }
            }
        }
        return false
    }
    
    deinit {
         
        stopListeningToKeydownEvents()
    }
}
