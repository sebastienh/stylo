//
//  CssResourceEditorView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-03-18.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac
import Common
import os

final class CssResourceEditorView: ResourceEditorView {
    
    let cssResourceEditorDelegate: CSSResourceEditorDelegate
    
    var mouseOverTimer: Timer?
    
    let tooltipDelegate: TooltipDelegate

    override var isOpaque: Bool {
        
        return true
    }
    
    static var autocompleteWindowController: AutocompleteWindowController = {
        
        // Autocompletion initialization
        let bundle = Bundle(for: AutocompleteWindowController.self)
        let storyboardName = NSStoryboard.Name(string: "Autocomplete")
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        
        let autocompleteWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "Autocomplete")) as! AutocompleteWindowController
        
        autocompleteWindowController.targetLanguage = .CSS
        autocompleteWindowController.load()
        return autocompleteWindowController
    }()
    
    private var paragraphStyle: NSParagraphStyle? {
        
        guard let stylesheetManager = self.editableManager as? StylesheetManager else {
            assertionFailure("Error: self.stylesheetManager is nil")
            return nil
        }
        
        guard let editorManager = stylesheetManager.editor(for: self.id) else {
            assertionFailure("Error: editorManager is nil")
            return nil
        }
        
        guard let globalAttributes = editorManager.globalAttributes.value else {
            assertionFailure("Error: globalAttributes is nil")
            return nil
        }
        
        guard let cssStylePreview = globalAttributes.stylePreview as? CssStylePreview else {
            assertionFailure("Error: textStylePreview is nil")
            return nil
        }
        
        return cssStylePreview.paragraphStyle
    }
    
    override var typingAttributes: [NSAttributedString.Key : Any] {
        
        get {
            return super.typingAttributes
        }
        set(attributes) {
        
//            if let paragraphStyle = self.paragraphStyle {
//
//                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//                os_log("trying to set typing attributes to: %@", log: Log.StyleEditor.all, type: .info, %%paragraphStyle)
//                #endif
//
//                var extendableAttributes = attributes
//                extendableAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
//                super.typingAttributes = extendableAttributes
//            }
//            else {
//
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("trying to set typing attributes to: %@", log: Log.StyleEditor.all, type: .info, %%attributes)
            #endif
            super.typingAttributes = attributes
//            }
        }
    }
    
    override init(id: EditorId, frame frameRect: NSRect, textContainer container: NSTextContainer?, editable: AnyEditable) {
        
        self.tooltipDelegate = MessagesTooltipDelegate(editable: editable)
        self.cssResourceEditorDelegate = CSSResourceEditorDelegate()
        super.init(id: id, frame: frameRect, textContainer: container, editable: editable)
        
        assert(editableManager != nil)
        try? editable.registerEditor(withRenderer: self)
        
        self.textContainerInset = Constants.CSS.Editor.Insets
        self.delegate = self.cssResourceEditorDelegate
        initializeBoundsChangedListening()
        self.bindToEditable()
    }
    
    required init?(coder: NSCoder) {
        
        self.tooltipDelegate = MessagesTooltipDelegate(editable: nil)
        self.cssResourceEditorDelegate = CSSResourceEditorDelegate()
        super.init(coder: coder)
        self.textContainerInset = Constants.CSS.Editor.Insets
        self.delegate = self.cssResourceEditorDelegate
        initializeBoundsChangedListening()
        self.bindToEditable()
    }
    
    func addAutocompletionSupport(for language: Language, window: NSWindow?) {
        
        self.completionDelegate = CssResourceEditorView.autocompleteWindowController

        if let document = document {
            
            switch document.documentAppearanceMode! {
            case .dark:
                self.window!.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
            case .light:
                self.window!.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
            }
        }
        
        // set the parent window of the AutocompleteDelegate
        // the completetionDelegate will add it's window as a child of the
        // current window.
        if completionDelegate?.parentWindow == nil {
            completionDelegate?.parentWindow = window!
            completionDelegate?.close()
        }
    }
    
    override func keyDown(with theEvent: NSEvent) {
        
        // the call here return true if we should forward
        // to super.
        let (superHandling, shouldAutocomplete) = handleKeyDownAutocomplete(with: theEvent)
        
        if superHandling {
            super.keyDown(with: theEvent)
        }
        if shouldAutocomplete {
            self.tooltipDelegate.removeDisplayedMessageTooltip()
            self.complete(self)
        }
        
        let styloWindow = self.window as? StyloWindow
        assert(styloWindow != nil)
        styloWindow?.hideLeftButtons()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func initializeBoundsChangedListening() {
        
        self.postsBoundsChangedNotifications = true

        NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: self, queue: nil) { [weak self](notification) in
            self?.viewContentBoundsDidChange(notification)
        }
    }
    
    @objc func viewContentBoundsDidChange(_ notification: Notification) {
        
        self.tooltipDelegate.removeDisplayedMessageTooltip()
        self.closeAutocomplete()
    }
    
    private func replaceCurrentOver(with theEvent: NSEvent) {
        
        let localMousePosition = extractMousePosition(from: theEvent)
        
        if let mouseOverTimer = mouseOverTimer {
            
            mouseOverTimer.invalidate()
        }
        
        self.mouseOverTimer = Timer.scheduledTimer(timeInterval: StyloConstants.MessageTooltips.MouseIdleShowTime, target: self, selector: #selector(self.showMouseOverInformationIfMessage), userInfo: ["cursorPosition": localMousePosition], repeats: false)
    }
    
    @objc private func showMouseOverInformationIfMessage(timer: Timer) {
        
        if !isAutocompleteShown {
        
            let userInfo = timer.userInfo as! Dictionary<String, Any>
            let cursorPosition = userInfo["cursorPosition"] as! NSPoint
            let insetX = cursorPosition.x - Constants.CSS.Editor.Insets.height
            let insetY = cursorPosition.y - Constants.CSS.Editor.Insets.width
            let insetsPosition = NSMakePoint(insetX, insetY)
            
            if let _messages = messages(at: insetsPosition) {
            
                displayInformationPopup(messages: _messages)
            }
        }
    }
    
    /// Function that returns any Message that is present
    /// at the cursor position.
    private func messages(at cursorPosition: NSPoint) -> [Message]? {
        
        // get the position from which we are on top of...
        let _stringIndex = stringIndex(from: cursorPosition)

        if let _stringIndex = _stringIndex {
        
            return (editableManager as? Failable)?.messages(at: _stringIndex)
        }
        return nil
    }
    
    private func displayInformationPopup(messages: [Message]) {
        
        let message = messages.first!
        
        if let messageRect = rect(from: message) {
        
            let insetX = messageRect.minX + Constants.CSS.Editor.Insets.width
            let insetY = messageRect.maxY - Constants.CSS.Editor.Insets.height
            let insetRect = NSMakeRect(insetX, insetY, messageRect.width, messageRect.height)
            
            tooltipDelegate.showMessageTooltip(with: message, relativeTo: insetRect, in: self)
        }
    
        for message in messages {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Messsage: %@", log: Log.StyleEditor.all, type: .info, %%message.localizedMessage)
            #endif
        }
    }
    
    private func stringIndex(from cursorPosition: NSPoint) -> Int? {
        
        let layoutManager = textStorage?.layoutManagers.first
        
        if let layoutManager = layoutManager {
            
            if let textContainer = layoutManager.textContainers.first {
                
                return layoutManager.glyphIndex(for: cursorPosition, in: textContainer)
            }
        }
        return nil
    }
    
    private func extractMousePosition(from theEvent: NSEvent) -> NSPoint {
        
        return convert(theEvent.locationInWindow, from: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}










