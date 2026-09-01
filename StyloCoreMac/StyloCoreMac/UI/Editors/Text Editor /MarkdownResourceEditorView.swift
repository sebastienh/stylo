//
//  MarkdownResourceEditorView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-03-18.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import Markdown
import Web
import os

class MarkdownResourceEditorView: ResourceEditorView, ProjectSrollableEditor {
    
    var textResourceEditorDelegate: TextResourceEditorDelegate?
    
    private var paragraphStyle: [NSAttributedString.Key: Any]? {
        
        guard let textManager = self.editableManager as? TextManager else {
            assertionFailure("Error: self.textManager is nil")
            return nil
        }
        
        guard let editorManager = textManager.editor(for: self.id) else {
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
    
    var elementSelection: ElementSelection? {
        
        let window = self.window
        
        assert(window != nil)
        if let window = window {
            
            if window.firstResponder === self {
                
                let location = selectedRange.location
                
                if let node = self.node(at: location) {
                    
                    if let element = node as? Element, !(element is HTMLBodyElement) {
                        
                        let elementSelection = ElementSelection(element: element, charIndex: location)
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
                        os_log("set element selection to: %@", log: Log.StyloCore.all, type: .info, %%String(describing: elementSelection))
                        #endif
                        return elementSelection
                    }
                }
            }
        }
        return nil
    }

    override var typingAttributes: [NSAttributedString.Key : Any] {
        
        get {
            assert(Thread.isMainThread)
            var filteredAttributes = super.typingAttributes
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("super.typingAttributes: %@", log: Log.StyloCore.all, type: .info, %%filteredAttributes)
            #endif
            
            filteredAttributes.removeValue(forKey: StyloAttribute.headingTagAfter.key)
            filteredAttributes.removeValue(forKey: StyloAttribute.headingTagBefore.key)
            filteredAttributes.removeValue(forKey: StyloAttribute.caretColor.key)
            return filteredAttributes
        }
        set(attributes) {

            func applyDefaultAttributes() {
                super.typingAttributes = attributes
            }
            
            assert(Thread.isMainThread)

            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("trying to set typing attributes to: %@", log: Log.StyloCore.all, type: .info, %%attributes)
            #endif
            
            let range = self.selectedRange()
            if let temporaryColorValue = self.layoutManager?.temporaryAttribute(.foregroundColor, atCharacterIndex: range.location, effectiveRange: nil) {
                
                var attributes = attributes
                attributes[.foregroundColor] = temporaryColorValue
                super.typingAttributes = attributes
            }
            else {
                applyDefaultAttributes()
            }
        }
    }
    
    var containingScrollView: ProjectTextEditorsScrollView? {
        
        var view: NSView? = self
        while view != nil {
            if let scrollView = view as? ProjectTextEditorsScrollView {
                return scrollView
            }
            view = view?.superview
        }
        return nil
    }
    
    var documentManager: DocumentManager? {
        
        return self.document?.documentManager
    }
    
    override init(id: EditorId, frame frameRect: NSRect, textContainer container: NSTextContainer?, editable: AnyEditable) {
        
        self.textResourceEditorDelegate = TextResourceEditorDelegate()
        super.init(id: id, frame: frameRect, textContainer: container, editable: editable)
        self.delegate = self.textResourceEditorDelegate
    }
    
    required init?(coder: NSCoder) {
        
        self.textResourceEditorDelegate = TextResourceEditorDelegate()
        super.init(coder: coder)
        self.delegate = self.textResourceEditorDelegate
    }
        
    override func resignFirstResponder() -> Bool {
        
        self.deselectCurrentSelection()
        
        if super.resignFirstResponder() {
            
            let windowController = window?.windowController as? StyloWindowController
            
            assert(windowController != nil)
            if let windowController = windowController {
                
                // reset the selection
                windowController.elementSelection = nil
            }
            
            return true
        }
        return false
    }
    
    private func deselectCurrentSelection() {
        
        let selectedRange = self.selectedRange()
        
        if selectedRange.length > 0 {
        
            guard let textStorage = self.textStorage else {
                assertionFailure("Error: self.textStorage is nil")
                self.setSelectedRange(selectedRange.zeroLengthRange)
                return
            }
            
            let location = selectedRange.location
            
            if textStorage.isCursorInsideHeaderTag(at: location) || textStorage.isHeaderTagStart(at: location) {
                textStorage.moveCursorToEndOfHiddenHeaderTag(from: selectedRange.location, in: self)
            }
            else {
                self.setSelectedRange(selectedRange.zeroLengthRange)
            }
        }
    }
    
    var mouseIsDown: Bool = false
    
    /// NW-1196
    override func mouseDown(with event: NSEvent) {
        
        self.lastKeyEvent = nil
        self.mouseIsDown = true
        
        let styloWindow = self.window as? StyloWindow
        let titleHidden = styloWindow?.titleBarHidden
        
        assert(titleHidden != nil)
        if mouseInTopRegion(with: event), let titleHidden = titleHidden, titleHidden {
            self.window?.performDrag(with: event)
        }
        else {
            super.mouseDown(with: event)
            ensureCursorPositionNotInHiddenHeaderTag(with: event)
        }
        
        self.updateFocusedEditorIdIfNecessary(withReason: .mouseDown)
        
        guard let window = self.window else {
            assertionFailure("Error: self.window is nil")
            return
        }
        
        StyloNotification.editorMouseDown.sendNotification(window)
    }
    
    override func mouseUp(with event: NSEvent) {
        
        self.mouseIsDown = false
        
        super.mouseUp(with: event)
        if mouseInTopRegion(with: event) {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("MarkdownResourceEditorView.mouseUp -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
            #endif
            NSCursor.arrow.set()
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        
        if self.mouseIsDown {
            StyloNotification.editorIsSelecting.sendNotification(self.window!)
        }
        else {
            StyloNotification.editorIsNotSelecting.sendNotification(self.window!)
        }
        
        let styloWindowController = self.window?.windowController as? StyloWindowController
        
        if let styloWindowController = styloWindowController {
            
            let styloWindow = self.window as? StyloWindow
            let titleHidden = styloWindow?.titleBarHidden
        
            if styloWindowController.mouseInWindowTitle {
            
                // avoid the flickering (between ibeam and arrow) of the
                // cursor inside the window title background view
                //        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("MarkdownResourceEditorView.mouseMoved -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
                //        #endif
                NSCursor.arrow.set()
            }
            else if mouseInTopRegion(with: event), let titleHidden = titleHidden, titleHidden {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("MarkdownResourceEditorView.mouseMoved -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
                #endif
                NSCursor.arrow.set()
            }
        }
        else {
            super.mouseMoved(with: event)
        }
    }
    
    private func updateFocusedEditorIdIfNecessary(withReason reason: FocusedEditorChangeEvent.Reason) {
        
        guard self.selectedRange().length == 0 else {
            return 
        }
        
        guard let textManager = self.editableManager as? TextManager else {
            assertionFailure("Error: textManager is nil")
            return
        }
        
        guard let documentManager = textManager.documentManager else {
            assertionFailure("Error: documentManager is nil")
            return
        }
        
        let editorSelectionChangeEvent = FocusedEditorChangeEvent(editorId: self.id, reason: reason)
        documentManager.setEditorSelectionChangeEvent(editorSelectionChangeEvent)
    }
    
    private var cursorWasAtEndOfHeaderStartTag = false
    
    var lastKeyEvent: NSEvent?
    
    override func keyDown(with event: NSEvent) {
        
        self.mouseIsDown = false
        self.lastKeyEvent = event
        self.cursorWasAtEndOfHeaderStartTag = false
        
        
        var shouldRestoreApplicationFocusMode = false
        if event.isDeleteKey && self.selectedRange().length > 0 {
            self.documentManager?.temporaryDisableFocus()
            shouldRestoreApplicationFocusMode = true
        }
        
        if !handleKeyboardFormattingShortcut(with: event) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("calling keydown with key event: %@", log: Log.StyloCore.all, type: .info, %%event)
            #endif
        
            if let textStorage = self.textStorage {

                let location = self.selectedRange().location
                if location > 0 && location != textStorage.length {
                    cursorWasAtEndOfHeaderStartTag = textStorage.isCursorAtHeaderTagEnd(at: location)

                    // we do this here because it seems the delegate is
                    // not called when return key is pressed.
                    if event.keyCode == 36 {

                        var longestEffectiveRange = NSMakeRange(0, 0)
                        if cursorWasAtEndOfHeaderStartTag {
                            textStorage.attribute(StyloAttribute.headingTagBefore.key, at: location-1, longestEffectiveRange: &longestEffectiveRange, in: NSMakeRange(0, textStorage.length))
                            self.setSelectedRange(NSMakeRange(longestEffectiveRange.location, 0))
                        }
                    }
                }
            }
            
            super.keyDown(with: event)
            if self.selectedRange().length == 0 {
                ensureCursorPositionNotInHiddenHeaderTag(with: event)
            }
        }
        
        if shouldRestoreApplicationFocusMode {
            self.documentManager?.restoreTemporaryDisabledFocus()
        }
        else if event.isArrowKey {
            self.updateFocusedEditorIdIfNecessary(withReason: .moveCursor)
            self.updateTypingAtttributes(fromLocation: self.selectedRange().location)
        }
        
        if event.isArrowKey {
            self.updateTypingAtttributes(fromLocation: self.selectedRange().location)
        }
        
        self.lastKeyEvent = nil
        
        guard let window = self.window else {
            assertionFailure("Error: self.window is nil")
            return
        }
        
        let userInfo = [WriterCommon.Constants.Notifications.Event: event]
        StyloNotification.editorKeyDown.sendNotification(window, userInfo: userInfo)
    }
    
    override func setSelectedRanges(_ ranges: [NSValue], affinity: NSSelectionAffinity, stillSelecting stillSelectingFlag: Bool) {
        super.setSelectedRanges(ranges, affinity: affinity, stillSelecting: stillSelectingFlag)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setSelectedRanges(%@, affinity: %@, stillSelecting: %@)", log: Log.StyloCore.all, type: .info, %%ranges, %%affinity, %%stillSelectingFlag)
        #endif
            
        if let lastKeyEvent = self.lastKeyEvent, !lastKeyEvent.isSelection {
            super.setSelectedRanges(ranges, affinity: affinity, stillSelecting: stillSelectingFlag)
            WriterNotification.didChangeTemporaryAttributes.sendNotification(self)
            return
        }
        
        guard self.mouseIsDown || self.lastKeyEvent != nil else {
            super.setSelectedRanges(ranges, affinity: affinity, stillSelecting: stillSelectingFlag)
            return
        }
        
        // if we just click somewhere we should not change the range
        if self.lastKeyEvent == nil && self.mouseIsDown {
            
            var length = 0
            for value in ranges {
                guard let range = value as? NSRange else {
                    assertionFailure("Error: value is not NSRange")
                    continue
                }
                length += range.length
            }
            if length == 0 {
                
                // stylo #844
                // make sure to remove any selection in the heading
                WriterNotification.didChangeTemporaryAttributes.sendNotification(self)
                super.setSelectedRanges(ranges, affinity: affinity, stillSelecting: stillSelectingFlag)
                return
            }
        }
        
        var rangesUnion: NSRange?
        
        for (index, value) in ranges.enumerated() {
            guard let range = value as? NSRange else {
                assertionFailure("Error: value is not NSRange")
                continue
            }
            
            if let selectableRange = self.updateToSelectableRange(range, rangeIndex: index) {
            
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("setSelectedRanges -> selectableRange: %@", log: Log.StyloCore.all, type: .info, %%selectableRange)
                #endif
                
                if rangesUnion != nil {
                    rangesUnion = rangesUnion!.union(selectableRange)
                }
                else {
                    rangesUnion = selectableRange
                }
            }
        }
            
        guard let rangesUnionFinalValue = rangesUnion else {
            assertionFailure("Error: rangesUnion is nil")
            super.setSelectedRanges(ranges, affinity: affinity, stillSelecting: stillSelectingFlag)
            return
        }
        
        let rangesUnionValue = NSValue(range: rangesUnionFinalValue)
            
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("super.setSelectedRanges(%@, affinity: %@, stillSelecting: %@)", log: Log.StyloCore.all, type: .info, %%[rangesUnionValue], %%affinity, %%stillSelectingFlag)
        #endif
            
        super.setSelectedRanges([rangesUnionValue], affinity: affinity, stillSelecting: stillSelectingFlag)
        WriterNotification.didChangeTemporaryAttributes.sendNotification(self)
    }

    private func updateToSelectableRange(_ range: NSRange, rangeIndex: Int) -> NSRange? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateToSelectableRange(%@)", log: Log.StyloCore.all, type: .info, %%range)
        os_log("updateToSelectableRange -> self.lastKeyEvent: %@", log: Log.StyloCore.all, type: .info, %%self.lastKeyEvent)
        #endif
        
        guard let textStorage = self.textStorage else {
            assertionFailure("Error: self.textStorage is nil")
            return range
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateToSelectableRange -> textStorage.length: %@", log: Log.StyloCore.all, type: .info, %%textStorage.length)
        #endif
        
        guard range.location >= 0 && range.upperBound <= textStorage.length else {
            assertionFailure("Error: range out of range of text storage...")
            return range
        }
        
        var headerEffectiveRange = NSMakeRange(0, 0)
        let lowerBoundAtHeaderTagStart = range.upperBound != textStorage.length && textStorage.attribute(StyloAttribute.headingTagBefore.key, at: range.location, effectiveRange: &headerEffectiveRange) != nil
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateToSelectableRange -> lowerBoundAtHeaderTagStart: %@", log: Log.StyloCore.all, type: .info, %%lowerBoundAtHeaderTagStart)
        os_log("updateToSelectableRange -> headerEffectiveRange: %@", log: Log.StyloCore.all, type: .info, %%headerEffectiveRange)
        #endif
        
        var selectableRange: NSRange? = range
        
        if let lastKeyEvent = self.lastKeyEvent, lastKeyEvent.modifierFlags.contains(.shift) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("updateToSelectableRange -> keySelection", log: Log.StyloCore.all, type: .info)
            #endif
            
            let upperBoundInsideHeaderTag = textStorage.isCursorInsideHeaderTag(at: range.upperBound)
            let upperBoundAtHeaderTagEnd = textStorage.isCursorAtHeaderTagEnd(at: range.upperBound)
                        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("updateToSelectableRange -> upperBoundInsideHeaderTag: %@", log: Log.StyloCore.all, type: .info, %%upperBoundInsideHeaderTag)
            os_log("updateToSelectableRange -> upperBoundAtHeaderTagEnd: %@", log: Log.StyloCore.all, type: .info, %%upperBoundAtHeaderTagEnd)
            #endif
            
            switch lastKeyEvent.keyCode {
            
            case 123: // left
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("updateToSelectableRange -> left", log: Log.StyloCore.all, type: .info)
                #endif
                
                if lowerBoundAtHeaderTagStart {
                
                    if upperBoundAtHeaderTagEnd {
                        selectableRange =  NSMakeRange(range.lowerBound-1, 0)
                    }
                    else if let length = textStorage.string.startWithNewLine(atPosition: range.lowerBound-1) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("updateToSelectableRange -> startWithNewLine with length: %@", log: Log.StyloCore.all, type: .info, %%length)
                        #endif
                        
                        selectableRange = NSMakeRange(range.lowerBound-length, range.length+length)
                    }
                    else {
                        selectableRange = NSMakeRange(range.lowerBound, range.length)
                    }
                }
                else if upperBoundInsideHeaderTag {
                    selectableRange = NSMakeRange(range.lowerBound, 0)
                }
                
            case 124: // right
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("updateToSelectableRange -> right", log: Log.StyloCore.all, type: .info)
                #endif
                
                if lowerBoundAtHeaderTagStart && upperBoundAtHeaderTagEnd {
                    if rangeIndex == 0 {
                        selectableRange = nil
                    }
                    else {
                        selectableRange = range
                    }
                }
                else if lowerBoundAtHeaderTagStart {
                
                    if range.upperBound == headerEffectiveRange.upperBound {
                        selectableRange = nil
                    }
                    else {
                        selectableRange = range
                    }
                }
                else if upperBoundInsideHeaderTag {
                    
                    selectableRange = NSMakeRange(range.upperBound, 0)
                }
                else if upperBoundAtHeaderTagEnd {
                    selectableRange = range
                }
                
                
            case 125: // down
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("updateToSelectableRange -> down", log: Log.StyloCore.all, type: .info)
                #endif
                break
                
            case 126:
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("updateToSelectableRange -> up", log: Log.StyloCore.all, type: .info)
                #endif
                break
                
            default:
                assertionFailure("Error: unhandled key code: \(lastKeyEvent.keyCode)")
                break
            }
        }
        // mouse selection
        else if self.mouseIsDown {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("updateToSelectableRange -> mouseSelection", log: Log.StyloCore.all, type: .info)
            #endif
            
            if lowerBoundAtHeaderTagStart {
                
                if range.location > 0 {
                    if range.upperBound+1 < textStorage.length {
                        selectableRange = NSMakeRange(range.location-1, range.length+1)
                    }
                    else {
                        selectableRange = NSMakeRange(range.location-1, range.length)
                    }
                }
                else {
                    if range.upperBound+1 < textStorage.length {
                        selectableRange = NSMakeRange(range.location, range.length+1)
                    }
                    else {
                        selectableRange = NSMakeRange(range.location, range.length)
                    }
                }
            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateToSelectableRange -> selectableRange: %@", log: Log.StyloCore.all, type: .info, %%selectableRange)
        if let selectableRange = selectableRange {
            let selectedText = textStorage.attributedSubstring(from: selectableRange)
            os_log("updateToSelectableRange -> selectedText: \"%@\"", log: Log.StyloCore.all, type: .info, %%selectedText.string)
        }
        else {
            os_log("updateToSelectableRange -> selectedText: nil", log: Log.StyloCore.all, type: .info)
        }
        #endif
        
        return selectableRange
    }
    
    private func ensureCursorPositionNotInHiddenHeaderTag(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("ensureCursorPositionNotInHiddenHeaderTag(with: %@)", log: Log.StyloCore.all, type: .info, %%event)
        #endif
        
        let location = self.selectedRange().location
        guard let textStorage = self.textStorage else {return}
        guard location != 0 && location != textStorage.length-2 else {return}

        switch event.type {
            
        case .keyDown:
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("key code: %@", log: Log.StyloCore.all, type: .info, %%event.keyCode)
            #endif
            
            switch event.keyCode {
                
            case 36: // return
                
                if textStorage.isCursorInsideHeaderTag(at: location) || textStorage.isHeaderTagStart(at: location) {
                    textStorage.moveCursorToEndOfHiddenHeaderTag(from: location, in: self)
                }
                
            case 51: // delete
                
                if textStorage.isCursorInsideHeaderTag(at: location) || textStorage.isHeaderTagStart(at: location) {
                    textStorage.moveCursorToEndOfHiddenHeaderTag(from: location, in: self)
                }
                
            case 123: // left
                
                if event.modifierFlags.contains(.shift) {
                    if textStorage.isCursorInsideHeaderTag(at: location) {
                        textStorage.moveCursorBeforeHiddenHeaderTag(from: location, in: self)
                    }
                }
                else {
                    if textStorage.isCursorInsideHeaderTag(at: location) {
                        textStorage.moveCursorBeforeHiddenHeaderTag(from: location, in: self)
                    }
                    else if textStorage.isHeaderTagStart(at: location) {
                        textStorage.moveCursorToEndOfHiddenHeaderTag(from: location, in: self)
                    }
                    else if cursorWasAtEndOfHeaderStartTag {
                        textStorage.moveCursorBeforeHiddenHeaderTag(from: location, in: self)
                    }
                }
                
            case 124: // right
                if textStorage.isCursorInsideHeaderTag(at: location) {
                    textStorage.moveCursorToEndOfHiddenHeaderTag(from: location, in: self)
                }
                else if textStorage.isHeaderTagStart(at: location) {
                    textStorage.moveCursorToEndOfHiddenHeaderTag(from: location, in: self)
                }
                
            case 125: fallthrough // down
            case 126: // up
                if textStorage.isCursorInsideHeaderTag(at: location) {
                    textStorage.moveCursorToEndOfHiddenHeaderTag(from: location, in: self)
                }
                else if textStorage.isHeaderTagStart(at: location) {
                    textStorage.moveCursorToEndOfHiddenHeaderTag(from: location, in: self)
                }
                
            default:
                break
            }
            
        case .leftMouseDown:
            
            if textStorage.isCursorInsideHeaderTag(at: location) || textStorage.isHeaderTagStart(at: location) {
                textStorage.moveCursorToEndOfHiddenHeaderTag(from: location, in: self)
            }
            
        default:
            break
        }
    }
    
    // Stylo #505: Automatic scrolling when writing the first letter on the top left of the top editor
    var oldClipViewBounds: NSRect?

    var dirtyRanges: [NSRange]?
    
    private func affectedRange(fromString string: NSString, replacementRange: NSRange) -> NSRange? {
        
        let length = max(string.length, replacementRange.length)
        return NSMakeRange(replacementRange.location, length)
    }
    
    private func updateDirtyRanges(fromString string: NSString, replacementRange: NSRange) {
        
        guard let affectedRange = self.affectedRange(fromString: string, replacementRange: replacementRange) else {
            assertionFailure("Error: affectedRange is nil")
            return
        }
        
        dirtyRanges = [affectedRange]
    }
    
    override func insertText(_ string: Any, replacementRange: NSRange) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        guard let textManager = self.editableManager as? TextManager else {
            assertionFailure("Error: textManager is nil")
            return
        }
        let range = replacementRange.asRange
        os_log("insertText(%@, replacementRange: %@)", log: Log.StyloCore.all, type: .info, %%string, %%range)
        os_log("insertText -> textManager: %@", log: Log.StyloCore.all, type: .info, %%textManager.name.value)
        #endif
        
        self.preventScrollingAndSaveBoundsIfNecessary(string, replacementRange: replacementRange)
        
        guard let nsString = string as? NSString else {
            assertionFailure("Error: string is nil")
            super.insertText(string, replacementRange: replacementRange)
            return
        }
        
        updateDirtyRanges(fromString: nsString, replacementRange: replacementRange)
        
        guard let textStorage = self.textStorage else {
            assertionFailure("Error: self.textStorage is nil")
            super.insertText(string, replacementRange: replacementRange)
            return
        }
        
        if handleInsert(of: nsString, in: textStorage, replacementRange: replacementRange) {
            return
        }
        else {
            super.insertText(string, replacementRange: replacementRange)
        }
        self.updateFocusedEditorIdIfNecessary(withReason: .edit)
    }
    
    func preventScrollingAndSaveBoundsIfNecessary(_ string: Any, replacementRange: NSRange) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Prevent scrolling with replacementRange: %@", log: Log.StyloCore.all, type: .info, %%replacementRange)
        os_log("disableScrolling", log: Log.StyloCore.all, type: .info, %%replacementRange)
        #endif
        
        // disable scrolling
        assert(self.containingScrollView != nil)
        containingScrollView?.disableScrolling()
        containingScrollView?.verticalScroller?.isHidden = true
        oldClipViewBounds = containingScrollView?.contentView.bounds
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("saving oldClipViewBounds: %@", log: Log.StyloCore.all, type: .info, %%oldClipViewBounds)
        #endif
    }
    
    func restoreScrollingPositionIfNeeeded() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("restoreScrollingPositionIfNeeeded()", log: Log.StyloCore.all, type: .info, %%oldClipViewBounds)
        #endif
        
        // Stylo #505: Automatic scrolling when writing the first letter on the top left of the top editor
        if let oldClipViewBounds = self.oldClipViewBounds {
            self.containingScrollView?.verticalScroller?.isHidden = false
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("restoring oldClipViewBounds: %@", log: Log.StyloCore.all, type: .info, %%oldClipViewBounds)
            os_log("current clipViewBounds: %@", log: Log.StyloCore.all, type: .info, %%containingScrollView!.contentView.bounds)
            #endif
            
            if let containingScrollView = containingScrollView, !NSEqualRects(containingScrollView.contentView.bounds, oldClipViewBounds) {
                self.containingScrollView?.contentView.bounds = oldClipViewBounds
            }
            self.oldClipViewBounds = nil
        }
        assert(self.containingScrollView != nil)
        containingScrollView?.restoreScrolling()
    }
    
    override func didChangeText() {
        super.didChangeText()
        self.restoreScrollingPositionIfNeeeded()
    }
    
    private func handleInsert(of string: NSString, in textStorage: NSTextStorage, replacementRange: NSRange) -> Bool {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        guard let textManager = self.editableManager as? TextManager else {
            assertionFailure("Error: textManager is nil")
            return false
        }
        
        let range = replacementRange.asRange
        os_log("handleInsert(of: %@, in: %@, replacementRange: %@)", log: Log.StyloCore.all, type: .info, %%string, %%textStorage.string, %%range)
        os_log("handleInsert -> textManager: %@", log: Log.StyloCore.all, type: .info, %%textManager.name.value)
        os_log("handleInsert -> typing attributes: %@", log: Log.StyloCore.all, type: .info, %%self.typingAttributes)
        
        #endif
        
        guard let paragraphStyle = self.paragraphStyle else {
            assertionFailure("Error: self.paragraphStyle is nil")
            return false
        }
        
        // deletion handling
        // the length is two because we change the replacement range to encompass
        // the space before the header string
        if replacementRange.length == 2 && string.length == 0 {
            
            if textStorage.isHeaderTagStart(at: replacementRange.location) {
                
                guard let headerTagValue = textStorage.headerTagValue(at: replacementRange.location) else {
                    assertionFailure("Error: headerTagValue is nil")
                    return false
                }
                
                if headerTagValue == 1 {
                    textStorage.replaceCharacters(in: replacementRange, with: string as String)
                    textStorage.addAttributes(paragraphStyle, range: NSMakeRange(replacementRange.location, 0))
                    didChangeText()
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
        else if replacementRange.length == 0 && string.length == 1 && string.character(at: 0) == §UnicodeCharacter.lineFeed {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("insertText (lineFeed): %@", log: Log.StyloCore.all, type: .info, %%string)
            #endif
            
            // inserting new-line at the end of the file
            if replacementRange.location == textStorage.length {
                
                textStorage.replaceCharacters(in: replacementRange, with: string as String)
                resetNewLineAttributesIfNecessary(NSMakeRange(replacementRange.location, 1), in: textStorage)
                self.typingAttributes = paragraphStyle
            }
            // inserting new-line at the start of the file
            else if replacementRange.location == 0 {
                
                if textStorage.isHeaderTagStart(at: 0) {
                    super.insertText(string, replacementRange: replacementRange)
                    textStorage.addAttributes(paragraphStyle, range: NSMakeRange(replacementRange.location, 1))
                    didChangeText()
                    return true
                }
                else {
                    textStorage.replaceCharacters(in: replacementRange, with: string as String)
                    textStorage.addAttributes(paragraphStyle, range: NSMakeRange(replacementRange.location, 1))
                }
            }
            // insert at the end of a line
            else if textStorage.mutableString.character(at: replacementRange.location) == §UnicodeCharacter.lineFeed {
                
                textStorage.replaceCharacters(in: replacementRange, with: string as String)
                
                // add the paragraph attributes to the new-line itself
                resetNewLineAttributesIfNecessary(NSMakeRange(replacementRange.location, 1), in: textStorage)
                
                // in case os header we know we need to reset to paragraph attributes
                // we are ending a header
                if replacementRange.location > 0 && textStorage.isHeader(inLineContainingRange: NSMakeRange(replacementRange.location-1, 0)) {

                    // add the paragraph attributes to the newly created line
                    let (result, spacesNumber) = textStorage.isOnlySpacesInSameLine(from: replacementRange.location+1)

                    if let spacesNumber = spacesNumber, result {

                        textStorage.addAttributes(paragraphStyle, range: NSMakeRange(replacementRange.location+1, spacesNumber))
                        self.typingAttributes = paragraphStyle
                    }
                }
                
                // stylo #988
                //
                // otherwise we dont know were we end up; it could be:
                // - list
                // - blockquote
                // - fenced code block
                // ...
                //
                // so it's better to let the normal typing attributes process
                // with compilation unit take care of this.
            }
            // return at the start of a non-empty string
            else if textStorage.mutableString.character(at: replacementRange.location-1) == §UnicodeCharacter.lineFeed {
                
                textStorage.replaceCharacters(in: replacementRange, with: string as String)
                
                // add the attributes to the new-line itself
                resetNewLineAttributesIfNecessary(NSMakeRange(replacementRange.location-1, 1), in: textStorage)
                
                let (result, spacesNumber) = textStorage.isOnlySpacesInSameLine(to: replacementRange.location-1)
                
                if let spacesNumber = spacesNumber, result {
                    
                    textStorage.addAttributes(paragraphStyle, range: NSMakeRange(replacementRange.location-spacesNumber, spacesNumber))
                    self.typingAttributes = paragraphStyle
                }
            }
            // we are in the middle of a string
            else {
                textStorage.replaceCharacters(in: replacementRange, with: string as String)
                
                // add the attributes to the new-line itself
                resetNewLineAttributesIfNecessary(NSMakeRange(replacementRange.location, 1), in: textStorage)
                
                let (result, spacesNumber) = textStorage.isOnlySpacesInSameLine(to: replacementRange.location-1)
                
                if let spacesNumber = spacesNumber, result {
                    
                    textStorage.addAttributes(paragraphStyle, range: NSMakeRange(replacementRange.location-spacesNumber, spacesNumber))
                    self.typingAttributes = paragraphStyle
                    
                }
            }
            
            // if the line only contains whitespaces we add the pararagraph
            // attributes everywhere
            if replacementRange.location+1 < textStorage.length {
                
                let (result, spacesNumber) = textStorage.isOnlySpacesInSameLine(from: replacementRange.location+1)
                
                if let spacesNumber = spacesNumber, result {
                    
                    textStorage.addAttributes(paragraphStyle, range: NSMakeRange(replacementRange.location+1, spacesNumber))
                    self.typingAttributes = paragraphStyle
                }
            }
            self.didChangeText()
            return true
        }
        return false
    }
    
    private func resetNewLineAttributesIfNecessary(_ newLineRange: NSRange, in textStorage: NSTextStorage) {
        
        guard let paragraphStyle = self.paragraphStyle else {
            assertionFailure("Error: self.paragraphStyle is nil")
            return
        }
        
        // add the attributes to the new-line itself
        textStorage.addAttributes(paragraphStyle, range: newLineRange)
    }
    
    private func lineHeaderLength(endingAt index: Int, in textStorage: NSTextStorage, removeLastNonWhitespace: Bool = false) -> (headerRange: NSRange, completeLineRange: NSRange)? {
        
        let range = NSMakeRange(index, 0)
        
        var lineRange: NSRange = (textStorage.string as NSString).lineRange(for: range)
        
        // we trim the linefeed to get the same behavior as the pure Markdown parser which
        // removes the line feeds before pasing.
        if textStorage.string.charAt(lineRange.upperBound-1) == §UnicodeCharacter.lineFeed {
            lineRange = NSMakeRange(lineRange.location, lineRange.length-1)
        }
        let completeLineRange: NSRange = lineRange
        if removeLastNonWhitespace {
            
            var lastIndex = lineRange.location + lineRange.length - 1
            var numberOfWhitespaces = 0
            while textStorage.string.charAt(lastIndex) == §UnicodeCharacter.whitespace {
                numberOfWhitespaces += 1
                lastIndex -= 1
            }
            lineRange = NSMakeRange(lineRange.location, lineRange.length-numberOfWhitespaces-1)
        }
        
        if let (range, string) = MarkdownParser.headingTagRange(in: textStorage.string, range: lineRange) {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("header tag: we have a header tag: %@", log: Log.StyloCore.all, type: .info, %%string)
            #endif
            return (range, completeLineRange)
        }
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("header tag: not a header tag", log: Log.StyloCore.all, type: .info)
        #endif
        return nil
    }
    
    private func mouseInTopRegion(with event: NSEvent) -> Bool {
        
        if let styloClipView = self.superview as? StyloClipView {
            
            // moving the window when the under title view is now visible
            let bounds = styloClipView.bounds
            let topRect = NSMakeRect(0, bounds.origin.y , bounds.size.width, InterfaceConstants.Global.TopMenuHeight)
            let locationInWindow = event.locationInWindow
            let location = styloClipView.convert(locationInWindow, from: nil)
            
            if NSPointInRect(location, topRect) {
                return true
            }
        }
        return false
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// Method to handle the Markdown keyboard shortcuts
    /// if the key event is not a markdown formatting event
    /// we return false, otherwise we return true
    private func handleKeyboardFormattingShortcut(with keyboardEvent: NSEvent) -> Bool {
        
        guard let markdownFormattingShortcut = MarkdownFormattingShortcut.from(keyboardEvent) else {
            return false
        }
        
        switch markdownFormattingShortcut {
            
        case .heading1:
            handleHeading(heading: Heading.h1)
        case .heading2:
            handleHeading(heading: Heading.h2)
        case .heading3:
            handleHeading(heading: Heading.h3)
        case .heading4:
            handleHeading(heading: Heading.h4)
        case .heading5:
            handleHeading(heading: Heading.h5)
        case .heading6:
            handleHeading(heading: Heading.h6)
        case .indentBlock:
            handleBlockQuote()
        case .unorderedList:
            handleBulletedList()
        case .orderedList:
            handleNumberedList()
        case .makeBold:
            handleBold()
        case .makeItalic:
            handleItalic()
        case .strikethrough:
            handleStrikethrough()
        case .addLink:
            handleLink()
        }
        return true
    }
}

