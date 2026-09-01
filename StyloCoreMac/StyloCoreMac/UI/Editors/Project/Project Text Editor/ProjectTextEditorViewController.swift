//
//  ProjectTextEditorViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-17.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os
import PromiseKit
import Combine

class ProjectTextEditorViewController: NSViewController, TextBackgroundColorListener {
    
    @IBOutlet var leftView: ProjectLineNumberingView!
    
    @IBOutlet var rightView: RightEditorSideView!
    
    @IBOutlet var editorContentView: EditorContentView!
    
    @IBOutlet var editorContainerView: NSView!
    
    @IBOutlet var centerEditorSeparator: EditorSeparator!
    
    @IBOutlet var leftEditorSeparator: EditorSideSeparator!
    
    @IBOutlet var rightEditorSeparator: EditorSideSeparator!
    
    weak var filesOutlineManager: FilesOutlineManager?
    
    var isLast: Bool = false {
        didSet {
            self.centerEditorSeparator.isLast = self.isLast
        }
    }
    
    var resourceEditorView: ProjectTextEditor!
    
    var editorId: EditorId? {
        
        return self.resourceEditorView.id
    }
    
    override var representedObject: Any? {
        didSet {
            guard let textManager = representedObject as? TextManager else {
                assertionFailure("Error: representedObject is not TextManager")
                return
            }
            self.subscribe(toTextManager: textManager)
        }
    }
    
    private var textManager: TextManager? {
        
        return self.representedObject as? TextManager
    }
    
    private var documentManager: DocumentManager? {
        
        return textManager?.documentManager
    }
    
    private var filesOutlineSetManager: FilesOutlineSetManager? {
        
        return documentManager?.filesOutlineSetManager.value
    }
    
    private var editorOutlineCellView: EditorOutlineCellView? {
        
        return self.view.superview as? EditorOutlineCellView
    }

    private var outlineView: ProjectTextEditorsOutlineView? {
        
        var view: NSView? = self.view
        
        while view != nil {
            
            if let outlineView = view as? ProjectTextEditorsOutlineView {
                return outlineView
            }
            view = view?.superview
        }
        return nil
    }
    
    weak var editorsViewController: EditorsViewController?
    
    private var projectTextEditorsListSplitViewController: ProjectTextEditorsListSplitViewController? {
        
        guard let editorsViewController = self.editorsViewController else {
            assertionFailure("Error: self.editorsViewController is nil")
            return nil
        }
        
        guard let projectTextEditorsListSplitViewController = editorsViewController.projectTextEditorsListSplitViewController else {
            assertionFailure("Error: projectTextEditorsListSplitViewController is nil")
            return nil
        }
        
        return projectTextEditorsListSplitViewController
    }
    
    private var initialized: Bool = false
    
    private var paragraphStyle: [NSAttributedString.Key: Any]? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("request for paragraphStyle", log: Log.StyloCore.all, type: .debug)
        #endif
        
        guard let textManager = self.textManager else {
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
        
        if let globalAttributes = editorManager.globalAttributes.value {
            
            guard let textStylePreview = globalAttributes.stylePreview as? TextStylePreview else {
                assertionFailure("Error: textStylePreview is nil")
                return nil
            }
            
            return textStylePreview.pAttributes
        }
        
        return nil
    }
    
    private var globalMenuPanelViewController: GlobalMenuPanelViewController? {
        
        guard let window = self.view.window else {
            return nil
        }
        
        guard let styloWindowController = window.windowController as? StyloWindowController else {
            assertionFailure("Error: styloWindowController is nil")
            return nil
        }
        
        return styloWindowController.globalMenuPanelViewController
    }
    
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        initializeIfNecessary()
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        
        defer {

            let textStorage = self.resourceEditorView.textStorage
            
            assert(textStorage != nil)
            if let textStorage = textStorage {
                
                assert(self.paragraphStyle != nil)
                if let paragraphStyle = paragraphStyle {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("paragraphStyle: %@", log: Log.StyloCore.all, type: .debug, %%paragraphAttributes)
                    #endif
                    
                    if textStorage.length == 0 {
                        textStorage.addAttributes(paragraphStyle, range: NSMakeRange(0, 0))
                        self.resourceEditorView?.typingAttributes = paragraphStyle
                    }
                    else {
                        let cursorLocation = resourceEditorView.selectedRange().location
                        
                        if cursorLocation == 0 || textStorage.string.charAt(cursorLocation-1, isEqualTo: §UnicodeCharacter.lineFeed) {
                            self.resourceEditorView?.typingAttributes = paragraphStyle
                        }
                    }
                }
            }
            
            // TODO: remove this if we se that it is not necessary
            // because we already do this work in SourceStringAttributesRenderer
            self.ensureCompleteLayout()
            textManager?.styleManager.subscribe({ [weak self](_) in
                self?.ensureCompleteLayout()
            }, observer: self)
        }
        
        guard let editorsViewController = self.editorsViewController else {
            assertionFailure("Error: self.editorsViewController is nil")
            return
        }
        
        let contentView = editorsViewController.scrollView.contentView
        
        assert(leftView != nil)
        leftView?.setContentView(contentView)
        leftView?.startListening()
        leftView?.updateLines()
    }
    
    override func viewWillDisappear() {
        
        assert(leftView != nil)
        leftView?.stopListening()
        super.viewWillDisappear()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        subscribe(toFilesOutlineSetManager: filesOutlineSetManager)
        guard let activeEditors = filesOutlineSetManager.activeEditors.values[textManager.id] else {
            // if it is not yet available the subscribe method will handle it
            // no need to crash on this
            return
        }
        updateNonContiguousLayoutAllowed(fromActiveEditors: activeEditors)
    }
    
    private func initializeIfNecessary() {
        
        if !initialized {
            assert(Thread.isMainThread)
            initializeEditorView()
            self.initialized = true
        }
    }

    private func initializeEditorView() {
        
        // no need to compute the height, the NSLayoutManager along with the NSTextContainer
        // will set it properly
        self.createResourceEditorView(with: self.view.frame, window: nil)
        self.view.needsUpdateConstraints = true
        self.view.postsFrameChangedNotifications = true

        NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: self.view, queue: nil) { [weak self](_) in
                self?.resourceEditorView?.needsUpdateConstraints = true
        }
        leftView.setClientWiew(self.resourceEditorView)
    }
    
    func updateBackgroundColor(with color: NSColor) {
        
        assert(leftView != nil)
        assert(rightView != nil)
        self.resourceEditorView.updateBackgroundColor(with: color)
        self.leftView.layer?.backgroundColor = color.cgColor
        self.leftView.needsDisplay = true
        self.rightView.layer?.backgroundColor = color.cgColor
        self.rightView.needsDisplay = true
        self.leftEditorSeparator.baseColor = color
        self.centerEditorSeparator.baseColor = color
        self.rightEditorSeparator.baseColor = color
        
        self.updateAppearance(from: color)
        
        guard let editorContentView = self.editorContentView else {
            assertionFailure("Error: self.view is not ColoredView")
            return
        }
        
        editorContentView.backgroundColor = color
        editorContentView.needsDisplay = true
    }
    
    func bindBackgroundColor() {
        
        assert(textManager != nil)
        if let textManager = textManager {
        
            self.startListening(to: textManager)
        }
    }
    
    private func createResourceEditorView(with frame: NSRect, window: NSWindow? = nil) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start createResourceEditorView(with: %@, window: %@)", log: Log.StyloCore.all, type: .info, %%frame, %%window)
        #endif
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        let textId = textManager.id
        
        let editorId: EditorId = filesOutlineManager.createOrGetEditorId(forTextId: textId)
        
        // create the resource editor view
        self.resourceEditorView = ProjectTextEditor(id: editorId, frame: frame, editable: textManager)
        updateStyleAssemblyFromFilesOutlineManager(visibleRange: nil)
        self.bindBackgroundColor()
        
        guard let editorView = self.resourceEditorView else {
            assertionFailure("Error: self.resourceEditorView is nil")
            return
        }
        
        self.editorContainerView.addSubview(editorView, positioned: .below, relativeTo: centerEditorSeparator)
        editorView.leadingAnchor.constraint(equalTo: self.editorContainerView.leadingAnchor).isActive = true
        editorView.trailingAnchor.constraint(equalTo: self.editorContainerView.trailingAnchor).isActive = true
        editorView.topAnchor.constraint(equalTo: self.editorContainerView.topAnchor).isActive = true
        editorView.bottomAnchor.constraint(equalTo: self.editorContainerView.bottomAnchor).isActive = true
        self.view.needsUpdateConstraints = true
        self.resourceEditorView.needsUpdateConstraints = true
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end createResourceEditorView(with: %@, window: %@)", log: Log.StyloCore.all, type: .info, %%frame, %%window)
        #endif
    }
    
    func updateAppearance(from color: NSColor?) {
        
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
    
    private func subscribe(toTextManager textManager: TextManager) {
        self.cancellable = textManager.editedRangeValueDidChange.sink { [weak self](editedRange) in
            guard let resourceEditorView = self?.resourceEditorView  else {
                assertionFailure("Error: resourceEditorView is nil")
                return
            }
            if let editedRange = editedRange, !resourceEditorView.isFirstResponder {
                resourceEditorView.dirtyRanges = [editedRange]
                resourceEditorView.needsUpdateConstraints = true
            }
        }
    }
    
    private func subscribe(toFilesOutlineSetManager filesOutlineSetManager: FilesOutlineSetManager) {
        
        filesOutlineSetManager.activeEditors.subscribe({ [weak self](change) in
            self?.handleActiveEditorsChange(change)
        }, observer: self)
    }

    func updateStyleAssemblyFromFilesOutlineManager(visibleRange: NSRange?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start updateStyleAssemblyFromFilesOutlineManager()", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        guard let document = textManager.document.value else {
            assertionFailure("Error: document is nil")
            return 
        }
        
        guard let resourceEditorView = self.resourceEditorView else {
            assertionFailure("Error: self.resourceEditorView is nil")
            return
        }
        
        guard let editor = textManager.editor(for: resourceEditorView.id) else {
            assertionFailure("Error: editor is nil")
            return
        }
        
        if editor.styleAssemblyDescriptor != filesOutlineManager.styleAssemblyDescriptor.value {
            assertionFailure("Error: we should create the editor with the right styleAssemblyDescriptor")
            setStyleAssemblyDescriptor(to: filesOutlineManager.styleAssemblyDescriptor.value, visibleRange: nil)
        }
        
        // make sure the editor is higlighted as the current files outline is.
        if let selectorString = filesOutlineManager.selectorString.value {
            editor.highlight(with: selectorString, visibleTopElements: nil, document: document, selectedRange: nil)
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start updateStyleAssemblyFromFilesOutlineManager()", log: Log.StyloCore.all, type: .info)
        #endif
    }
    
    private func setStyleAssemblyDescriptor(to styleAssemblyDescriptor: StyleAssemblyDescriptor?, visibleRange: NSRange?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start setStyleAssemblyDescriptor(to: %@)", log: Log.StyloCore.all, type: .info, %%styleAssemblyDescriptor)
        #endif
        
        
        // This part doesn work because we are always in sync mode
        // since this is called in viewDidLoad which means that at
        // this stage we dont have a window yet...
//        if let window = self.view.window, window.windowController != nil {
//            setStyleAssemblyDescriptorAsync(to: styleAssemblyDescriptor)
//        }
//        else {
        
        setStyleAssemblyDescriptorSync(to: styleAssemblyDescriptor, visibleRange: visibleRange)

//        }

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end setStyleAssemblyDescriptor(to: %@)", log: Log.StyloCore.all, type: .info, %%styleAssemblyDescriptor)
        #endif
    }    
    
    private func setStyleAssemblyDescriptorAsync(to styleAssemblyDescriptor: StyleAssemblyDescriptor?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start setStyleAssemblyDescriptorAsync(to: %@)", log: Log.StyloCore.all, type: .info, %%styleAssemblyDescriptor)
        #endif
        
        self.resourceEditorView.removeFlash()
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        guard let styleAssemblyDescriptor = styleAssemblyDescriptor else {
            assertionFailure("Error: styleAssemblyDescriptor is nil")
            return
        }
        
        firstly {
            textManager.setStyleAssemblyDescriptorAsync(styleAssemblyDescriptor, forEditorId: self.resourceEditorView.id)
        }.then {
            self.updateBackgroundColor()
        }.catch { error in
            assertionFailure("Error: \(error)")
        }

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end setStyleAssemblyDescriptorAsync(to: %@)", log: Log.StyloCore.all, type: .info, %%styleAssemblyDescriptor)
        #endif
    }
    
    
    private func setStyleAssemblyDescriptorSync(to styleAssemblyDescriptor: StyleAssemblyDescriptor?, visibleRange: NSRange?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start setStyleAssemblyDescriptorSync(to: %@)", log: Log.StyloCore.all, type: .info, %%styleAssemblyDescriptor)
        #endif
        
        self.resourceEditorView.removeFlash()
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        guard let styleAssemblyDescriptor = styleAssemblyDescriptor else {
            assertionFailure("Error: styleAssemblyDescriptor is nil")
            return
        }
        
        textManager.setStyleAssemblyDescriptor(styleAssemblyDescriptor, forEditorId: self.resourceEditorView.id, visibleRange: visibleRange)
        
        guard let editorManager = textManager.editor(for: self.resourceEditorView.id) else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        editorManager.applyGlobalAttributes()
        updateBackgroundColor()

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end setStyleAssemblyDescriptorSync(to: %@)", log: Log.StyloCore.all, type: .info, %%styleAssemblyDescriptor)
        #endif
    }
    
    private func updateBackgroundColor() {
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        guard let editorId = self.editorId else {
            assertionFailure("Error: self.editorId is nil")
            return
        }
        
        guard let editorManager = textManager.editor(for: editorId) else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        guard let globalAttributes = editorManager.globalAttributes.value else {
            assertionFailure("Error: globalAttributes is nil")
            return
        }
        
        guard let backgroundColor = globalAttributes.backgroundColor else {
            assertionFailure("Error: backgroundColor is nil")
            return
        }
        
        self.updateBackgroundColor(with: backgroundColor)
    }
    
    private func handleActiveEditorsChange(_ change: DynamicDictionary<TextId, Set<EditorId>>.DictionaryChange) {
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        switch change {
        case .deletes(let removedValues, _):
            assert(!removedValues.keys.contains(textManager.id), "we wrongly removed a textId while there is stil; an editor for it.")
            break
        case .updates( _, let udpatedValues):
            if udpatedValues.keys.contains(textManager.id) {
                guard let activeEditors: Set<EditorId> = udpatedValues[textManager.id] else {
                    assertionFailure("Error: editorsIds is nil")
                    return
                }
                updateNonContiguousLayoutAllowed(fromActiveEditors: activeEditors)
            }
        case .start: fallthrough
        case .end:
            assertionFailure("Error: unsupported case")
            break
        }
    }
    
    private func updateNonContiguousLayoutAllowed(fromActiveEditors activeEditors: Set<EditorId>) {
        
        guard let layoutManager = self.resourceEditorView.layoutManager else {
            assertionFailure("Error: layoutManager is nil")
            return
        }
        
        if activeEditors.count <= 1 {
            self.resourceEditorView.layoutManager?.allowsNonContiguousLayout = true
        }
        else {
            self.resourceEditorView.layoutManager?.allowsNonContiguousLayout = false
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        os_log("updated allowsNonContiguousLayout to %@ for text with name %@", log: Log.StyloCore.all, type: .debug, %%layoutManager.allowsNonContiguousLayout, textManager.name.value)
        #endif
    }
    
    private func unsubscribe(fromFilesOutlineSetManager filesOutlineSetManager: FilesOutlineSetManager?) {
        
        filesOutlineSetManager?.activeEditors.unsubscribe(observer: self)
    }
    
    private func ensureCompleteLayout() {

        guard let resourceEditorView = self.resourceEditorView else {
            assertionFailure("Error: self.resourceEditorView is nil")
            return
        }
        guard let textContainer = resourceEditorView.textContainer else {
            assertionFailure("Error: self?.resourceEditorView?.textContainer is nil")
            return
        }
        guard let textStorage = resourceEditorView.textStorage else {
            assertionFailure("Error: resourceEditorView.textStorage is nil")
            return
        }
        
        let completeRange = NSMakeRange(0, textStorage.length)
        
        resourceEditorView.dirtyRanges = [completeRange]
        self.resourceEditorView?.layoutManager?.ensureLayout(for: textContainer)
    }
    
    func changeAppearance(_ appearanceMode: AppearanceMode) {
        
        // see http://stackoverflow.com/questions/29952202/changing-the-background-color-of-the-unified-nstoolbar-in-yosemite
        // This method is called when the background color of the text change.
        switch appearanceMode {
        case .dark:
            self.view.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        case .light:
            self.view.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
        }
    }
    
    deinit {
        self.cancellable?.cancel()
    }
}
