//
//  TextEditorView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-08-04.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Web
import Common
import Igloo
import os

open class ResourceEditorView: NSTextView, Autocompletable, FormattableInput, SourceStringAttributesRenderer, EditableView {
    
    public let id: EditorId
    
    public var address: Int {
        return unsafeBitCast(self, to: Int.self)
    }
    
    override public var allowsVibrancy: Bool {
        return false
    }

    public var forceSetTypingAttributes: Bool = false
    
    public var document: TextDocument? {
        
        return self.superview?.window?.windowController?.document as? TextDocument
    }
    
    var editorScrollView: EditorSynchronizedScrollView {
        
        return self.superview!.superview as! EditorSynchronizedScrollView
    }
    
    override open var isOpaque: Bool {
        
        return true
    }
    
    public var isFirstResponder: Bool {
        
        guard let window = self.window else {
            return false
        }
        
        guard let firstResponder = window.firstResponder else {
            return false
        }
        
        if firstResponder === self {
            return true
        }
        
        guard let text = firstResponder as? NSText else {
            return false
        }
        
        guard let textDelegate = text.delegate else {
            return false
        }
        
        guard let delegateResourceEditor = textDelegate as? NSTextView else {
            return false
        }
        
        guard delegateResourceEditor === self else {
            return false
        }
        
        return true
    }

    private var textEditorsListViewController: ProjectTextEditorsList? {
        var responder = self.nextResponder
        while responder != nil {
            if let projectTextEditorsList = responder as? ProjectTextEditorsList {
                return projectTextEditorsList
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    weak public var editableManager: AnyEditable?
    
    var substring: String!
    
    public var currentlyWritting: Bool = false
    
    public let WORD_BOUNDARY_CHARS: NSMutableCharacterSet
    
    /// Normally, when there is no completions we don't show the
    /// autocompletion window. But the user has the possibility
    /// to force the showing of the autocompletion window. In this case,
    /// we need to know it since if there is no completions we will still
    /// display the window bu with "No Completions" text.
    public var shouldCompleteEmpty = false
    
    public var caretColor: NSColor?
    
    public init(id: EditorId, frame frameRect: NSRect, textContainer container: NSTextContainer?, editable: AnyEditable) {
        
        self.id = id
        self.editableManager = editable
        
        WORD_BOUNDARY_CHARS = NSMutableCharacterSet.alphanumeric()
        WORD_BOUNDARY_CHARS.addCharacters(in: "-_")
        
        super.init(frame: frameRect, textContainer: container)
    }
    
    required public init?(coder: NSCoder) {
        
        self.id = UUID().uuidString
        WORD_BOUNDARY_CHARS = NSMutableCharacterSet.alphanumeric()
        WORD_BOUNDARY_CHARS.addCharacters(in: "-_")
        
        super.init(coder: coder)
    }
    
    open override func setNeedsDisplay(_ rect: NSRect, avoidAdditionalLayout flag: Bool) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setNeedsDisplay in rect: %@, avoidAdditionalLayout: %@", log: Log.StyloCore.all, type: .debug, %%rect, %%flag)
        #endif
        
        let newY: CGFloat = {
            if rect.origin.y > 0 {
                return rect.origin.y-1
            }
            return rect.origin.y
        }()
        
        let newHeight: CGFloat = {
            if rect.maxY+1 <= self.bounds.maxY {
                return rect.height+2
            }
            if rect.maxY+1 <= self.bounds.maxY {
                return rect.height+1
            }
            return rect.height
        }()
        
        // we do this to avoid the line artifacts on the bottom
        // and top of the text rect
        let extendedRect = NSMakeRect(rect.origin.x, newY, rect.width, newHeight)
        super.setNeedsDisplay(extendedRect, avoidAdditionalLayout: flag)
    }
    
    public func setUndoSelectedRange(_ charRange: NSRange) {
        
        self.setSelectedRange(charRange)
        
        guard let wordRect = self.wordRect(in: charRange) else {
            assertionFailure("Error: rect is nil")
            return
        }
        
        let visibleRect = self.visibleRect

        if !NSPointInRect(wordRect.origin,  visibleRect) {
            let origin = self.origin(forMiddlePoint: wordRect.origin, inRect: visibleRect)
            self.scroll(origin)
        }
    }    
    
    func origin(forMiddlePoint middlePoint: NSPoint, inRect rect: NSRect) -> NSPoint {
        
        let halfRectHeight = self.visibleRect.height/2
        return NSMakePoint(0, max(0, middlePoint.y - halfRectHeight))
    }
    
    public func ensureCompleteLayout() {
        
        guard let textContainer = self.textContainer else {
            assertionFailure("Error: self.textContainer is nil")
            return
        }
        
        guard let layoutManager = self.layoutManager else {
            assertionFailure("Error: self.layoutManager is nil")
            return
        }
        
        layoutManager.ensureLayout(for: textContainer)
    }
    
    override public func paste(_ sender: Any?) {
        
        let pboard = NSPasteboard.general
        
        if let string = pboard.string(forType: NSPasteboard.PasteboardType.string) {
            
            let range = self.selectedRange()
            self.insertText(string, replacementRange: range)
        }
    }
    
    override public func updateInsertionPointStateAndRestartTimer(_ restartFlag: Bool) {

        if currentlyWritting {
            super.updateInsertionPointStateAndRestartTimer(true)
        }
        else {
            super.updateInsertionPointStateAndRestartTimer(restartFlag)
        }
    }

    override public func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {

        let rect = insertionRect(from: rect)

        let color = self.caretColor ?? color 
        
        if currentlyWritting {

            super.drawInsertionPoint(in: rect, color: color, turnedOn: true)
        }
        else {
            super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
        }
    }

    override public func setNeedsDisplay(_ invalidRect: NSRect) {

        let invalidRect = self.insertionRect(from: invalidRect)
        super.setNeedsDisplay(invalidRect)
    }
    
    private func insertionRect(from rect: NSRect) -> NSRect {

        if rect.origin.x > 0 {
            return NSMakeRect(rect.origin.x - 0.75, rect.origin.y, rect.size.width + 1.5, rect.size.height)
        }
        else {
            return NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width + 1.5, rect.size.height)
        }
    }

    public func handleGlobalAttributes(_ globalAttributes: GlobalAttributes?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleGlobalAttributes(%@)", log: Log.StyloCore.all, type: .info, %%globalAttributes)
        #endif
        
        guard let globalAttributes = globalAttributes else {
            assertionFailure("Error: globalAttributes is nil")
            return
        }
        
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleGlobalAttributes -> selectedTextAttributes: %@", log: Log.StyloCore.all, type: .info, %%globalAttributes.selectedTextAttributes)
                #endif
        
        self.selectedTextAttributes = globalAttributes.selectedTextAttributes
        
        guard let backgroundColor = globalAttributes.backgroundColor else {
            assertionFailure("Error: backgroundColor is nil")
            return
        }
        
        self.backgroundColor = backgroundColor
        self.caretColor = globalAttributes.caretColor
    }

    override public func preferredPasteboardType(from availableTypes: [NSPasteboard.PasteboardType], restrictedToTypesFrom allowedTypes: [NSPasteboard.PasteboardType]?) -> NSPasteboard.PasteboardType? {
        
        if availableTypes.contains(NSPasteboard.PasteboardType.string) {
            return NSPasteboard.PasteboardType.string
        }
        return super.preferredPasteboardType(from: availableTypes, restrictedToTypesFrom: allowedTypes)
    }
    
    func characterRange(for rect: NSRect) -> NSRange? {
        
        if let layoutManager = self.layoutManager, let textContainer = self.textContainer  {
            
            let textContainerRect = convertCoordinates(rect: rect, to: textContainer)
            let glyphRange = layoutManager.glyphRange(forBoundingRect: textContainerRect, in: textContainer)
            return layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        }
        return nil
    }
    
    private func convertCoordinates(rect: NSRect, to textContainer: NSTextContainer) -> NSRect {
        
        return NSMakeRect(rect.origin.x - textContainerOrigin.x, rect.origin.y - textContainerOrigin.y, rect.size.width - textContainerOrigin.x, rect.size.height - textContainerOrigin.y)
    }
    
    public func makeFirstResponder() {
        
        if self.acceptsFirstResponder {
            self.window?.makeFirstResponder(self)
        }
    }
    
    open override func setSelectedRange(_ charRange: NSRange) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setSelectedRange(%@)", log: Log.StyloCore.all, type: .info, %%charRange)
        #endif
        
        super.setSelectedRange(charRange)
        self.updateEditorManagerSelectedRange(withRange: charRange)
    }
    
    override public func resignFirstResponder() -> Bool {
        
        if super.resignFirstResponder() {
        
            guard let editableManager = self.editableManager else {
                assertionFailure("Error: editableManager is nil")
                return true
            }
        
            editableManager.isEdited.setValue(false)
            
            guard let editorManager = editableManager.editor(for: self.id) else {
                assertionFailure("Error: editorManager is nil")
                return true
            }
            
            editorManager.isFirstResponder = false
            
            if let textManager = editableManager as? TextManager {
                
                guard let documentManager = textManager.textDocument?.documentManager else {
                    assertionFailure("Error: documentManager is nil")
                    return true
                }
                
                documentManager._editedTextManager.setValue(nil)
            }
            
            return true
        }
        return false
    }

    override public func becomeFirstResponder() -> Bool {
        
        if super.becomeFirstResponder() {
            
            guard let editableManager = self.editableManager else {
                assertionFailure("Error: editableManager is nil")
                return true
            }
                
            editableManager.isEdited.setValue(true)
            
            guard let editorManager = editableManager.editor(for: self.id) else {
                assertionFailure("Error: editorManager is nil")
                return true
            }
            
            editorManager.isFirstResponder = true
            
            if let textManager = editableManager as? TextManager {
            
                guard let documentManager = textManager.textDocument?.documentManager else {
                    assertionFailure("Error: documentManager is nil")
                    return true
                }
                
                documentManager._editedTextManager.setValue(textManager)
                textEditorsListViewController?.updateLastEdited(toTextId: textManager.id)
                DispatchQueue.main.async { [weak self] in
                    self?.textEditorsListViewController?.selectedCurrentFilesOutlineManager()
                }
            }
                
                
                
            return true
        }
        return false
    }
    
    public func relativeVerticalPosition(for message: Message) -> CGFloat? {
        
        if let messageRect = rect(from: message) {
            
            return messageRect.origin.y/self.frame.height
        }
        return nil
    }
    
    override public func viewWillStartLiveResize() {
        super.viewWillStartLiveResize()
        self.enclosingScrollView?.hasVerticalScroller = false
    }
    
    override public func viewDidEndLiveResize() {
        let originalInset = self.textContainerInset
        self.textContainerInset = NSMakeSize(0, 0)
        super.viewDidEndLiveResize()
        self.textContainerInset = originalInset
        self.enclosingScrollView?.hasVerticalScroller = true
    }
    
    public func rect(from message: Message) -> NSRect? {
        
        if var segment = message.fragment as? SourceStringSegment {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("message segment: %@", log: Log.StyloCore.all, type: .info, %%segment)
            #endif
            
            let string = self.textStorage?.string
            
            assert(string != nil)
            if let string = string {
            
                do {
                    let trimmedSegment = segment.trimmed(withString: string)
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("message trimmed segment: %@", log: Log.StyloCore.all, type: .info, %%trimmedSegment)
                    #endif
                    let range = trimmedSegment.range
                    
                    assert(range != nil)
                    if let range = range {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("message range: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromRange(range))
                        #endif
                        
                        if let rect = wordRect(in: range) {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("message rect: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromRect(rect))
                            #endif
                            return rect
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func wordRect(in range: NSRange) -> NSRect? {
        
        if let layoutManager = layoutManager {
            if let textContainer = layoutManager.textContainers.first {
                if let glyphRange = convertCharacterRangeToGlyphRange(range: range) {
                    var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                    rect.origin.y += self.textContainerOrigin.y
                    rect.origin.x += self.textContainerOrigin.x
                    return rect
                }
            }
        }
        return nil
    }
    
    func node(at index: Int) -> Node? {
        
        if let domRenderable = self.editableManager as? DomRenderable {
            return domRenderable.node(at:index)
        }
        return nil
    }
    
    func convertCharacterRangeToGlyphRange(range: NSRange) -> NSRange? {
        
        if let layoutManager = layoutManager {
            
            let start = range.location
            
            let firstGlyphIndex = layoutManager.glyphIndexForCharacter(at: start)
            let lastGlyphIndex = layoutManager.glyphIndexForCharacter(at: start + range.length)
            
            return NSMakeRange(firstGlyphIndex, lastGlyphIndex - firstGlyphIndex)
        }
        return nil
    }
    
    public func listenToDidClikDomInspectableNodeNotifications(_ editableManager: AnyEditable) {
        
        let defaultCenter: NotificationCenter = NotificationCenter.default
        
        defaultCenter.addObserver(forName: NSNotification.Name(rawValue: §StyloNotification.DidClickDomInspectableNode), object: editableManager, queue: nil) { [weak self](notification) -> Void in
            
            let userInfo = notification.userInfo
            
            let domInspectable = userInfo![WriterCommon.Constants.Notifications.DomInspectableNode] as! DomInspectable
            
            if let range = domInspectable.range {
                
                if let rect = self?.wordRect(in: range) {
                 
                    self?.editorScrollView.scroll(to: rect.origin)
                }
            }
        }
    }
    
    override public func complete(_ sender: Any?) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Calling handleComplete...", log: Log.StyloCore.all, type: .info)
        #endif
        handleComplete(sender)
    }
    
    override public func mouseDown(with theEvent: NSEvent) {

        StyloNotification.WindowMouseDown.sendNotification(self.window!)
        removeFlash()
        super.mouseDown(with: theEvent)
        updateEditorManagerSelectedRange()
    }
    
    private func updateEditorManagerSelectedRange(withRange range: NSRange? = nil) {
        
        guard let editableManager = self.editableManager else {
            assertionFailure("Error: editableManager is nil")
            return
        }
        
        guard let editorManager = editableManager.editor(for: self.id) else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        editorManager.selectedRange = range ?? self.selectedRange()
    }
    
    open override func keyDown(with theEvent: NSEvent) {
        removeFlash()
        super.keyDown(with: theEvent)
    }
    
    private var previousFlashedRange: NSRange?
    private var previousFlashedOriginalAttributes: [NSAttributedString.Key : Any]?
    private var removeFlashTimer: Timer?

    public func flashText(withRange range: NSRange) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Flashing range: %@", log: Log.StyloCore.all, type: .info, %%range)
        #endif

        removeFlash()
        saveAttributesState(forRange: range)
        applyFlashAttributes(toRange: range)

        let flashDelayMilliseconds = StyloConstants.Tags.FlashDelaySeconds
        self.removeFlashTimer = Timer.scheduledTimer(withTimeInterval: flashDelayMilliseconds, repeats: false, block: { [weak self](_) in
            self?.removeFlash()
        })
    }

    private func saveAttributesState(forRange range: NSRange) {

        self.previousFlashedRange = range
    }

    private func applyFlashAttributes(toRange range: NSRange) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyFlashAttributes(toRange: %@)", log: Log.StyloCore.all, type: .info, %%range)
        #endif

        guard let editableManager = self.editableManager else {
            assertionFailure("Error: self.editableManager is nil")
            return
        }

        guard let resourceLayoutManager = self.layoutManager as? ResourceLayoutManager else {
            assertionFailure("Error: self.layoutManager is not ResourceLayoutManager")
            return
        }

        guard let flashAttributes = editableManager.flashAttributes(forEditorWithId: self.id, inRange: range) else {
            assertionFailure("Error: focusAttributes is nil")
            return
        }

        let editor = self.editableManager?.editor(for: self.id)
        
        flashAttributes.forEach { (flashAttribute) in

            let temporaryAttributes: [NSAttributedString.Key: Any] = flashAttribute.attributes.reduce([:]) { (result, arg) -> [NSAttributedString.Key: Any] in
                if arg.key.isTemporary {
                    let res = Dictionary<NSAttributedString.Key, Any>(dictionaryLiteral: arg)
                    return res.merging(result, uniquingKeysWith: { (first, _) -> Any in
                        return first
                    })
                }
                return result
            }
            editor?.updateTemporaryAttributedRange(from: StringAction.flash(range: flashAttribute.range))
            resourceLayoutManager.addTemporaryAttributes(temporaryAttributes, forCharacterRange: flashAttribute.range)
        }

        WriterNotification.didChangeTemporaryAttributes.sendNotification(self)
    }
    
    public func removeFlash() {
        DispatchQueue.syncOnMain { [weak self] in
            self?._removeFlash()
        }
    }

    private func _removeFlash() {

        guard self.removeFlashTimer != nil else {
            assert(self.previousFlashedOriginalAttributes == nil)
            assert(self.previousFlashedRange == nil)
            return
        }

        self.removeFlashTimer?.invalidate()
        self.removeFlashTimer = nil

        guard let resourceLayoutManager = self.layoutManager as? ResourceLayoutManager else {
            assertionFailure("Error: self.layoutManager is not ResourceLayoutManager")
            return
        }

        // Remove current flash if any
        guard let previousFlashedRange = self.previousFlashedRange else {
            // it's possible that we have not flashed any range yet
            return
        }
        
        self.removeTemporaryAttributes(forCharacterRange: previousFlashedRange)

        let temporaryAttributes = resourceLayoutManager.temporaryAttributes(atCharacterIndex: previousFlashedRange.location, effectiveRange: nil)
        for (key, _) in temporaryAttributes {
            resourceLayoutManager.removeTemporaryAttribute(key, forCharacterRange: previousFlashedRange)
        }

        WriterNotification.didChangeTemporaryAttributes.sendNotification(self)
        self.previousFlashedOriginalAttributes = nil
        self.previousFlashedRange = nil
    }
    
    public func removeTemporaryAttributes(forCharacterRange characterRange: NSRange) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("removeTemporaryAttributes(forCharacterRange: %@)", log: Log.StyloCore.all, type: .info, %%characterRange)
        #endif
        
        DispatchQueue.syncOnMain {
            
            guard let resourceLayoutManager = self.layoutManager else {
                assertionFailure("Error: self.layoutManager is not ResourceLayoutManager")
                return
            }
            
            for key in NSAttributedString.Key.temporaryAttributesKeys {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Removing temporary attribute: %@ in range: %@", log: Log.StyloCore.all, type: .info, %%key, %%characterRange)
                #endif
                resourceLayoutManager.removeTemporaryAttribute(key, forCharacterRange: characterRange)
            }
            
            WriterNotification.didChangeTemporaryAttributes.sendNotification(self)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: FormattableInput protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var lastCharacterInserted: UInt16?
    
    public var lastCharacterWhichCausedInsertion: UInt16?
    
    public var insertingText: Bool = false
    
    public var justInsertedBrace: Bool = false
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: TextViewDelegate protocol implementation
    //                                  FIXME: This implementation should move somewhere else
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    
    public var completionDelegate: AutocompleteDelegate? {
        
        didSet {
            
            // register to the DoubleClickedAutocompletionItem
            let defaultCenter: NotificationCenter = NotificationCenter.default
            
            defaultCenter.addObserver(forName: NSNotification.Name(rawValue: §StyloNotification.DoubleClickedAutocompletionItem), object: completionDelegate!, queue: nil) { [weak self](notification) -> Void in
                
                self?.insert(self)
            }
        }
    }
    
    var lastPos: Int = -1
    
    func didChangeSelection(_ notification: Notification) {
        
        if labs(self.selectedRange.location - self.lastPos) > 1 {
            
            // If selection moves by more than just one character, hide autocomplete
            completionDelegate?.close()
        }
    }
    
    func updateBackgroundColor(with color: NSColor) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setting background in text container color to %@", log: Log.StyloCore.all, type: .info, %%color)
        #endif
        self.backgroundColor = color
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}




