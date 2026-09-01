//
//  ProjectTextEditor.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-18.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

class ProjectTextEditor: MarkdownResourceEditorView {
    
    private var cachedHeightsForWidths: [CGFloat: CGFloat] = [:]
    
    override var preservesContentDuringLiveResize: Bool {
        return true
    }
    
    private var previousExtraLineSize: NSSize?
    
    private var lastUpdatedModificationId: Int = 0
    
    // we force the first computation
    private var currentModificationId: Int = 1
    
    private var cachedIntrinsictContentSize: [CGFloat: NSSize] = [:]
    
    private var tableCellView: NSTableCellView? {
        
        guard let tableCellView = superview?.superview?.superview as? NSTableCellView else {
            assertionFailure("Error: superview?.superview as? TextEditorTableCellView is nil")
            return nil
        }
        return tableCellView
    }
    
    var textManager: TextManager? {
        
        guard let textManager = self.editableManager as? TextManager else {
            assertionFailure("Error: self.editableManager is not TextManager")
            return nil
        }
        return textManager
    }
    
    private var editor: AnyEditor? {
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return nil
        }
        
        return textManager.editor(for: self.id)
    }
    
    var needsHeightConstraintUpdate: Bool {
        
        if let oldHeightConstraint = self.oldHeightConstraint {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("oldHeightConstraint.constant: %@", log: Log.StyloCore.all, type: .info, %%oldHeightConstraint.constant)
            #endif
            
            if !cachedIntrinsictContentSizeIsValid(forWidth: self.frame.width) {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("needsHeightConstraintUpdate is true", log: Log.StyloCore.all, type: .info)
                #endif
                return true
            }
            return false
        }
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("needsHeightConstraintUpdate is true", log: Log.StyloCore.all, type: .info)
        #endif
        return true
    }
    
    private var oldHeightConstraint: NSLayoutConstraint?
    
    private var oldFrameSize: NSSize = .zero
    
    private var inResize: Bool = false
    
    private var projectTextEditorTableViewController: ProjectTextEditorsTableViewController? {
        
        var responder = self.nextResponder
        while responder != nil {
            if let projectTextEditorTableViewController = responder as? ProjectTextEditorsTableViewController {
                return projectTextEditorTableViewController
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    private var filesOutlineManager: FilesOutlineManager? {
     
        guard let projectTextEditorTableViewController = self.projectTextEditorTableViewController else {
            assertionFailure("Error: projectTextEditorTableViewController is nil")
            return nil
        }
        
        return projectTextEditorTableViewController.filesOutlineManager
    }
    
    private var needEstimatedRectSizeDuringResize: Bool {
        
        return self.string.count > 7000
    }
    
    init(id: EditorId, frame frameRect: NSRect, editable: TextManager) {
        
        let _textStorage = editable.textStorage(forEditorWithId: id)
        let contentSize = frameRect.size
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("_textStorage size: %d", log: Log.StyloCore.all, type: .debug, _textStorage.length)
        os_log("_textStorage.delegate: %@", log: Log.StyloCore.all, type: .info, %%String(describing: _textStorage.delegate))
        #endif
        
        let layoutManager = ResourceLayoutManager()
        layoutManager.backgroundLayoutEnabled = true
        
        _textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(containerSize: NSMakeSize(frameRect.size.width, CGFloat.greatestFiniteMagnitude))
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = false
        
        layoutManager.addTextContainer(textContainer)
        
        self.backgroundTextStorage = NSTextStorage(string: editable.string)
        super.init(id: id,
                   frame: NSMakeRect(0,0, contentSize.width, contentSize.height),
                   textContainer: textContainer, editable: editable)
        
        layoutManager.delegate = self
        self.usesFindPanel = true
        layoutManager.allowsNonContiguousLayout = true
        
        assert(editableManager != nil)
        try? editable.registerEditor(withRenderer: self)
        
        self.alphaValue = 1.0
        self.isHorizontallyResizable = false
        self.maxSize = NSMakeSize(contentSize.width, CGFloat.greatestFiniteMagnitude)
        self.isAutomaticQuoteSubstitutionEnabled = false
        self.isAutomaticDashSubstitutionEnabled = false
        self.usesFontPanel = false
        self.allowsUndo = false
        self.autoresizingMask = .width
        self.listenToDidClikDomInspectableNodeNotifications(editable)
        if InterfaceConstants.Markdown.Editor.ShouldAddInsets {
            self.textContainerInset = InterfaceConstants.Markdown.Editor.Insets
        }
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: 140.0).isActive = true
        self.needsUpdateConstraints = true
        self.addTrackingArea(NSTrackingArea(rect: frameRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited), owner: self, userInfo: nil))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bindToEditable()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("missing implementation")
    }
    
    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setFrameSize(%@) for text with name: %@", log: Log.StyloCore.all, type: .debug, %%newSize,  %%self.textManager!.name.value)
        #endif
        
        if self.inLiveResize {
            
            self.setNeedsDisplay(self.rectPreservedDuringLiveResize)
        }
        else {
            self.oldFrameSize = newSize
            self.needsDisplay  = true
        }
    }
    
    public override func setUndoSelectedRange(_ charRange: NSRange) {
        
        self.mouseIsDown = false
        self.setSelectedRange(charRange)
        
        guard let wordRect = self.wordRect(in: charRange) else {
            assertionFailure("Error: rect is nil")
            return
        }
        
        if !NSPointInRect(wordRect.origin,  visibleRect) {
            
            guard let filesOutlineManager = self.filesOutlineManager else {
                assertionFailure("Error: self.filesOutlineManager is nil")
                return
            }
            
            guard let textManager = self.textManager else {
                assertionFailure("Error: self.textManager is nil")
                return
            }
            
            let filesOutlinePosition = FilesOutlinePosition(textId: textManager.id, range: charRange)
            let filesOutlineScrollPosition = FilesOutlineScrollPosition(position: filesOutlinePosition, flash: false)
            filesOutlineManager.filesOutlineDesiredScrollPosition.setValue(filesOutlineScrollPosition)
        }
    }
    
    override func updateConstraints() {
        
        self.updateHeightConstraint()
        super.updateConstraints()
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        guard let window = self.window else {
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willHideNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handlewillHideNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willShowNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handlewillShowNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didHideNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handledidHideNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didShowNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handledidShowNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willMoveDivider.name, object: window, queue: nil) { [weak self](_) in
            self?.handleWillMoveDivider()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didMoveDivider.name, object: window, queue: nil) { [weak self](_) in
            self?.handleDidMoveDivider()
        }
    }
    
    private func handlewillHideNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handlewillHideNavigator() for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.textManager!.name.value)
        #endif
        
        self.inResize = true
    }
    
    private func handlewillShowNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handlewillShowNavigator() for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.textManager!.name.value)
        #endif
        
        self.inResize = true
    }
    
    private func handledidHideNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handledidHideNavigator() for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.textManager!.name.value)
        #endif
        
        self.inResize = false
        self.needsUpdateConstraints = true
    }
    
    private func handledidShowNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handledidShowNavigator() for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.textManager!.name.value)
        #endif
        
        self.inResize = false
        self.needsUpdateConstraints = true
    }
    
    private func handleWillMoveDivider() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleWillMoveDivider() for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.textManager!.name.value)
        #endif
        
        self.inResize = true
    }
    
    private func handleDidMoveDivider() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleDidMoveDivider() for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.textManager!.name.value)
        #endif
        
        self.inResize = false
        self.needsUpdateConstraints = true
    }
    
    public func invalidateCachedIntrinsicContentSize() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("invalidateCachedIntrinsicContentSize() called for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.textManager!.name.value)
        #endif
        
        self.cachedIntrinsictContentSize.removeAll()
        self.lastUpdatedModificationId = 0
    }
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        self.needsUpdateConstraints = true
    }
    
    override public func ensureCompleteLayout() {
        
        self.invalidateCachedIntrinsicContentSize()
        
        // update constraints will make sure that the layout manager
        // update its layout for the current text container. If we dont
        // need to update the height constraint, then we still make sure
        // ensureLayout is called for the text container.
        if self.needsHeightConstraintUpdate {
            
            self.needsUpdateConstraints = true
        }
        else {
            
            guard let layoutManager = self.layoutManager else {
                assertionFailure("Error: self.layoutManager is nil")
                return
            }
            
            guard let textContainer = self.textContainer else {
                assertionFailure("Error: self.textContainer is nil")
                return
            }
            
            layoutManager.ensureLayout(for: textContainer)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("ProjectTextEditor.mouseEntered -> NSCursor.iBeam.set()", log: Log.StyloCore.all, type: .info)
        #endif
        NSCursor.iBeam.set()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("ProjectTextEditor.mouseExited -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
        #endif
        NSCursor.arrow.set()
    }
    
    override func resignFirstResponder() -> Bool {
        
        self.removeFilesOutlineEditor()
        return super.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        
        self.upateFilesOutlineEditor()
        return super.becomeFirstResponder()
    }
    
    private func removeFilesOutlineEditor() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        filesOutlineManager.currentEditorId.setValue(nil)
    }
    
    private func upateFilesOutlineEditor() {
    
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
    
        filesOutlineManager.currentEditorId.setValue(self.id)
    }
        
    public func resignFirstResponderWithoutRemovingAsLastEdited() {
        
        self.window?.makeFirstResponder(nil)
    }
    
    public func handleCompilationUnit(_ compilationUnit: CompilationUnit?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleCompilationUnit(%@) in text with name: %@, in files outline with name: %@", log: Log.StyloCore.all, type: .debug, %%compilationUnit, %%self.textManager?.name.value, %%self.filesOutlineManager?.name.value)
        #endif
        
        if let compilationUnit = compilationUnit {
            self.setNeedsAttributesUpdate()
            if let change = compilationUnit.change {
                self.updateCursorPositionIfNeeded(changeDescription: change)
            }
            self.setNeedsAttributesUpdate()
        }
    }
    
    func actualTextSize(withWidth width: CGFloat) -> CGSize {
        
        guard let textStorage = self.textStorage else {
            assertionFailure("Error: self.textStorage is nil")
            return NSMakeSize(width, 300)
        }
        
        return actualTextSize(withWidth: width, textStorage: textStorage)
    }
    
    override public func paste(_ sender: Any?) {
        
        let pboard = NSPasteboard.general
        
        if let string = pboard.string(forType: NSPasteboard.PasteboardType.string) {
            
            // when copying text, we should:
            // - clear focus if necessary
            // - reset focus to disabled
            // - paste the text
            // - set focus to application focus
            documentManager?.clearFocus()
            documentManager?.disableFocus()
            
            let range = self.selectedRange()
            self.insertText(string, replacementRange: range)
            
            documentManager?.restoreApplicationFocusMode()
            self.needsUpdateConstraints = true
        }
    }
    
    private var cutting: Bool = false
    
    override func cut(_ sender: Any?) {

        // cutting is two operations:
        // - copy
        // - delete
        cutting = true
        super.cut(sender)
    }
    
    override func copy(_ sender: Any?) {
        
        // when copying text, we should:
        // - clear focus if necessary
        // - reset focus to disabled
        // - paste the text
        // - set focus to application focus
        documentManager?.clearFocus()
        documentManager?.disableFocus()
        
        super.copy(sender)
        
        
        if !cutting {
            documentManager?.restoreApplicationFocusMode()
            self.needsUpdateConstraints = true
        }
        // else the restoration of focus will be done in delete
    }
    
    override func delete(_ sender: Any?) {
        
        if !cutting {
            documentManager?.clearFocus()
            documentManager?.disableFocus()
        }
        
        super.delete(sender)
        documentManager?.restoreApplicationFocusMode()
        self.needsUpdateConstraints = true
    }
    
    override func insertText(_ string: Any, replacementRange: NSRange) {
        self.currentModificationId += 1
        super.insertText(string, replacementRange: replacementRange)
    }
    
    private func updateHeightConstraint() {
        
        if asynchronousHeightConstraintComputationNecessary {
            
            if let cachedIntrinsictContentSize = self.cachedIntrinsictContentSizeIfValid(forWidth: self.frame.width) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("returning cached intrinsic content size: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%cachedIntrinsictContentSize, %%self.textManager!.name.value)
                #endif
                
                self.updateHeightConstraint(withHeight: cachedIntrinsictContentSize.height)
                self.udpateLayoutManagerLayout()
            }
            else {
                
                let requestedWidth = self.frame.width
                self.backgroundComputeTextHeight(withWidth: self.frame.width) { [weak self](height) in
                    DispatchQueue.main.async { [weak self] in
                        self?.updateConstraintIfWidthValid(withHeight: height, fromWidth: requestedWidth)
                    }
                }
            }
        }
        else {
            
            assert(Thread.isMainThread)
            let usedRectSize = self.usedRectSize(forWidth: self.frame.width)
            updateHeightConstraint(withHeight: usedRectSize.height)
        }
    }
    
    private func updateConstraintIfWidthValid(withHeight height: CGFloat, fromWidth width: CGFloat) {
        
        if self.frame.width.isEqual(to: width) {
            self.updateHeightConstraint(withHeight: height)
            self.udpateLayoutManagerLayout()
        }
    }
    
    private func udpateLayoutManagerLayout() {
        
        guard let layoutManager = self.layoutManager else {
            assertionFailure("Error: self.layoutManager is nil")
            return
        }

        guard let textContainer = self.textContainer else {
            assertionFailure("Error: self.textContainer is nil")
            return
        }

        layoutManager.ensureLayout(for: textContainer)
    }
    
    private func updateHeightConstraint(withHeight height: CGFloat) {
        
        assert(Thread.isMainThread)
        oldHeightConstraint?.isActive = false
        
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
        self.oldHeightConstraint = heightConstraint
        heightConstraint.isActive = true
        self.needsLayout = true
    }
    
    private var asynchronousHeightConstraintComputationNecessary: Bool {
        
        guard let textStorage = self.textStorage else {
            assertionFailure("Error: self.textStorage is nil")
            return false
        }
        
        let necessary = textStorage.length > 10000
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("asynchronousHeightConstraintComputationNecessary: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%necessary, %%self.textManager!.name.value)
        #endif
        
        return false
    }
    
    private func usedRectSize(forWidth width: CGFloat) -> NSSize {
        
        assert(Thread.isMainThread)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("usedRectSize(forWidth: %@) called for text with name: %@", log: Log.StyloCore.all, type: .debug, %%width, %%self.textManager!.name.value)
        os_log("inLiveResize: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%inLiveResize, %%self.textManager!.name.value)
        os_log("inResize: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%inResize, %%self.textManager!.name.value)
        #endif
        
        if inLiveResize || inResize {
            
            self.setNeedsDisplay(self.visibleRect, avoidAdditionalLayout: false)
            
            if self.needEstimatedRectSizeDuringResize {
            
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("returning estimatedRectSize %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%estimatedRectSize,  %%self.textManager!.name.value)
                #endif
                
                return estimatedRectSize(forWidth: width)
            }
            else {
                
                return self.cachedOrActualRectSize(forWidth: width)
            }
        }
        
        return self.cachedOrActualRectSize(forWidth: width)
    }
    
    private func cachedOrActualRectSize(forWidth width: CGFloat) -> NSSize {
        
        if let cachedIntrinsictContentSize = self.cachedIntrinsictContentSizeIfValid(forWidth: width) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("returning cached intrinsic content size: %@", log: Log.StyloCore.all, type: .debug, %%cachedIntrinsictContentSize)
            #endif
            
            return cachedIntrinsictContentSize
        }
        
        return self.actualUsedRectSize(forWidth: width)
    }
    
    private func estimatedRectSize(forWidth width: CGFloat) -> NSSize {
        
        assert(Thread.isMainThread)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("estimatedHeight(forWidth: %@) called for text with name: %@", log: Log.StyloCore.all, type: .debug, %%width, %%self.textManager!.name.value)
        #endif
        
        if let height = self.cachedHeightsForWidths[width] {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("returning cachedHeightsForWidths: %@ for width: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%height, %%self.frame.width, %%self.textManager!.name.value)
            #endif
            
            return NSSize(width: NSView.noIntrinsicMetric, height: height)
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self.frame.width: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.frame.width , %%self.textManager!.name.value)
        os_log("oldFrameSize.width: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%oldFrameSize.width, %%self.textManager!.name.value)
        #endif
        
        let widthDiff = width - oldFrameSize.width
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("widthDiff: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%widthDiff, %%self.textManager!.name.value)
        #endif
        
        // get a value between 0 and 0.05
        let multiplier: CGFloat = (1 - 1/(1+oldFrameSize.height))/20
        
        // a value between 0.1 and 0.15
        let factor: CGFloat = 0.1 + multiplier
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("factor: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%factor, %%self.textManager!.name.value)
        #endif
        
        let asjustedWidthDiff = widthDiff*factor
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("asjustedWidthDiff: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%asjustedWidthDiff, %%self.textManager!.name.value)
        #endif
        
        // the actual frame is smaller
        if asjustedWidthDiff < 0 {
            
            let widthDiffPercent = (-asjustedWidthDiff)/oldFrameSize.width
            let estimatedHeight = oldFrameSize.height + (widthDiffPercent*oldFrameSize.height)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("estimatedRectSize estimatedHeight: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%estimatedHeight,  %%self.textManager!.name.value)
            #endif
            
            return NSSize(width: NSView.noIntrinsicMetric, height: estimatedHeight)
        }
        else if widthDiff > 0 {
            
            let widthDiffPercent = asjustedWidthDiff/oldFrameSize.width
            let estimatedHeight = oldFrameSize.height - (widthDiffPercent*oldFrameSize.height)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("estimatedRectSize estimatedHeight: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%estimatedHeight,  %%self.textManager!.name.value)
            #endif
            
            return NSSize(width: NSView.noIntrinsicMetric, height: estimatedHeight)
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("estimatedRectSize oldFrameSize.height: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%oldFrameSize.height,  %%self.textManager!.name.value)
            #endif
            
            return NSSize(width: NSView.noIntrinsicMetric, height: oldFrameSize.height)
        }
    }
    
    private func actualUsedRectSize(forWidth width: CGFloat) -> NSSize {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("actualUsedRectSize(forWidth: %@) called for text with name: %@", log: Log.StyloCore.all, type: .debug, %%width, %%self.textManager!.name.value)
        os_log("actualUsedRectSize frame.width: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.frame.width, %%self.textManager!.name.value)
        os_log("actualUsedRectSize for filesOutlineManager with name: %@", log: Log.StyloCore.all, type: .debug, %%self.filesOutlineManager?.name.value)
        #endif
        
        let defaultSize = NSSize(width: NSView.noIntrinsicMetric, height: 300)
        
        guard let layoutManager = self.layoutManager else {
            assertionFailure("Error: self.layoutManager is nil")
            return defaultSize
        }
        
        guard let textContainer = self.textContainer else {
            assertionFailure("Error: self.textContainer is nil")
            return defaultSize
        }
        
        layoutManager.ensureLayout(for: textContainer)
        
        let usedRect = layoutManager.usedRect(for: textContainer)
        var answer: NSSize = NSSize(width: NSView.noIntrinsicMetric, height: usedRect.size.height)
        answer.height += InterfaceConstants.Markdown.Editor.Insets.height*2
        
        self.cachedIntrinsictContentSize[width] = answer
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("returning new intrinsic content size: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%answer, %%self.textManager!.name.value)
        os_log("cachedHeightsForWidths[%@] = %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%self.frame.width, %%answer.height, %%self.textManager!.name.value)
        #endif
        
        self.cachedHeightsForWidths[self.frame.width] = answer.height
        
        return answer
    }
    
    public func disableScrollingIfNotEditedTextView() {
        
        if self.filesOutlineManager?.selectionState.value == FilesOutlineManager.SelectionState.unselected {
            assert(self.containingScrollView != nil)
            self.containingScrollView?.disableScrolling()
        }
    }
    
    public func enableScrollingIfNotEditedTextView() {
        
        if self.filesOutlineManager?.selectionState.value == FilesOutlineManager.SelectionState.unselected {
            assert(self.containingScrollView != nil)
            self.containingScrollView?.restoreScrolling()
        }
    }
    
    private lazy var backgroundHeightCalculationQueue: DispatchQueue = {
       
        let queueIdentifier = ObjectIdentifier(self)
        var queue = DispatchQueue(label: "backgroundHeightCalculationQueue-\(queueIdentifier)", qos: .userInteractive)
        return queue
    }()
    
    private let backgroundTextStorage: NSTextStorage
    
    private func backgroundComputeTextHeight(withWidth width: CGFloat, callback: @escaping (CGFloat) -> Void) {
        
        assert(Thread.isMainThread)
        
        let attributedString = self.textStorage?.copy() as? NSAttributedString
        
        assert(attributedString != nil)
        if let attributedString = attributedString {
            backgroundHeightCalculationQueue.async { [weak self] in
                self?.backgroundTextStorage.setAttributedString(attributedString)
                self?.uddateBackgroundActualTextSize(withWidth: width, callback: callback)
            }
        }
    }
    
    private func uddateBackgroundActualTextSize(withWidth width: CGFloat, callback: (CGFloat) -> Void) {
        
        let actualTextSize = self.actualTextSize(withWidth: width, textStorage: self.backgroundTextStorage)
        callback(actualTextSize.height)
    }
    
    private func cachedIntrinsictContentSizeIsValid(forWidth width: CGFloat) -> Bool {

        if lastUpdatedModificationId == self.currentModificationId  {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("using cached intrinct content size", log: Log.StyloCore.all, type: .debug)
            #endif
            
            return self.cachedIntrinsictContentSize[width] != nil
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("not using cached intrinct content size", log: Log.StyloCore.all, type: .debug)
        #endif
        
        return false
    }
    
    private func cachedIntrinsictContentSizeIfValid(forWidth width: CGFloat) -> NSSize? {
        
        if cachedIntrinsictContentSizeIsValid(forWidth: width) {
            return cachedIntrinsictContentSize[width]
        }
        self.cachedIntrinsictContentSize.removeAll()
        return nil
    }
    
    private func actualTextSize(withWidth width: CGFloat, textStorage: NSTextStorage) -> CGSize {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("actualTextSize(forWidth: %@) called for text with name: %@", log: Log.StyloCore.all, type: .debug, %%width, %%self.textManager!.name.value)
        os_log("actualTextSize frame.width: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%width, %%self.textManager!.name.value)
        #endif
        
        
        let rect = NSMakeSize(width, CGFloat.greatestFiniteMagnitude)
        let boundingRect = textStorage.boundingRect(with: rect, options: NSString.DrawingOptions.usesLineFragmentOrigin)
        var answer: NSSize = NSSize(width: NSView.noIntrinsicMetric, height: boundingRect.size.height)
        answer.height += InterfaceConstants.Markdown.Editor.Insets.height*2
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("returning new intrinsic content size: %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%answer, %%self.textManager!.name.value)
        os_log("cachedHeightsForWidths[%@] = %@ for text with name: %@", log: Log.StyloCore.all, type: .debug, %%width, %%answer.height, %%self.textManager!.name.value)
        #endif
        
        self.updateCaches(forWidth: width, withHeight: answer.height)
        return answer
    }
    
    private func updateCaches(forWidth width: CGFloat, withHeight height: CGFloat) {
        
        DispatchQueue.main.async { [weak self] in
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("caching height: %@ for width: %@ in text with name: %@", log: Log.StyloCore.all, type: .debug, %%height, %%width, %%self!.textManager!.name.value)
            #endif
            
            self?.lastUpdatedModificationId = self!.currentModificationId
            self?.cachedIntrinsictContentSize[width] = NSMakeSize(width, height)
            self?.cachedHeightsForWidths[width] = height
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


