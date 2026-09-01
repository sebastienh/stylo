//
//  FileListViewController.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-24.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

class ProjectTextEditorsList: NSViewController {
    
    @IBOutlet var titleView: NSView?
    
    @IBOutlet var titleTopConstraint: NSLayoutConstraint?
    
    @IBOutlet var titleSeparatorHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet var selectorLineHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet var containerView: NSView! {
        didSet {
            containerView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet var topAddTextButon: MacDisableableButton? {
        didSet {
            self.topAddTextButon?.isEnabled = false
        }
    }
    
    @IBOutlet var topAddTextButonBackground: ToolbarButtonBackground? {
        didSet {
            self.topAddTextButonBackground?.isEnabled = false
        }
    }

    @IBOutlet var topAddFilesOutlineBackground: ToolbarButtonBackground? {
        didSet {
            self.topAddFilesOutlineBackground?.isEnabled = true
        }
    }
    
    @IBOutlet var addFilesOutlineButton: AddFilesOutlineButton?
    
    @IBOutlet var topButtonsStackView: NSStackView?
    
    @IBOutlet var closePanelButton: MacDisableableButton?
    
    @IBOutlet var closePanelButtonContainerView: CloseButtonContainerView?
    
    @IBOutlet var selectedLineView: TextEditorsPanelHighlightView?
    
    @IBOutlet var titleLabel: FilesOutlineTitleTextField? {
        didSet {
            titleLabel?.refusesFirstResponder = true
            titleLabel?.isBezeled = false
            titleLabel?.focusRingType = .none
            if let titleLabel = titleLabel {
                
                NotificationCenter.default.addObserver(forName: NSControl.textDidChangeNotification, object: titleLabel, queue: nil) { [weak self](notification) in
                    self?.controlTextDidChange(notification)
                }
                
                NotificationCenter.default.addObserver(forName: NSControl.textDidEndEditingNotification, object: titleLabel, queue: nil) { [weak self](notification) in
                    self?.controlTextDidEndEditing(notification)
                }
            }
        }
    }
    
    @IBOutlet var backInHistory: MacDisableableButton?
    
    @IBOutlet var backInHistoryToolbarBackground: ToolbarButtonBackground?
    
    @IBOutlet var forwardInHistory: MacDisableableButton?
    
    @IBOutlet var forwardInHistoryToolbarBackground: ToolbarButtonBackground?
    
    @IBOutlet var filesOutlineTitleLeftButtonsMinimumLeadingConstraint: NSLayoutConstraint?
    
    @objc dynamic var addEditorsPanelEnabled: Bool = true
    
    var projectTextEditorsTabViewController: ProjectTextEditorsTabViewController? {
        for child in self.children {
            if let projectTextEditorsTabViewController = child as? ProjectTextEditorsTabViewController {
                return projectTextEditorsTabViewController
            }
        }
        return nil
    }
    
    var filesOutlineManager: FilesOutlineManager? {
        return self.representedObject as? FilesOutlineManager
    }

    var documentManager: DocumentManager? {
        return self.filesOutlineManager?.documentManager
    }
    
    private var filesOutlineSetManager: FilesOutlineSetManager? {
        
        return documentManager?.filesOutlineSetManager.value
    }
    
    private var sidebarsShown: Bool {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return false
        }
        
        guard let macUITransientState = documentManager.uiTransientState as? MacUITransientState else {
            assertionFailure("Error: macUITransientState is nil")
            return false
        }
        
        return macUITransientState.sidebarsShow.value
    }
    
    private var filesOutlineManagerIndex: Int? {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return nil
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return nil
        }
        
        return filesOutlineSetManager.index(ofFilesOutlineManager: filesOutlineManager)
    }
    
    var isFirstFilesOutlineManager: Bool {
        
        guard let filesOutlineManagerIndex = self.filesOutlineManagerIndex else {
            assertionFailure("Error: self.firstFilesOutlineManagerIndex is nil")
            return true
        }
        
        return filesOutlineManagerIndex == 0
    }

    var isLastFilesOutlineManager: Bool {
        
        guard let filesOutlineManagerIndex = self.filesOutlineManagerIndex else {
            assertionFailure("Error: self.firstFilesOutlineManagerIndex is nil")
            return false
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return false
        }
        
        return filesOutlineManagerIndex == filesOutlineSetManager.filesOutlines.count-1
    }
    
    override var representedObject: Any? {
        willSet {
            #if DEBUG
            if representedObject != nil {
                assert(self.representedObject! is FilesOutlineManager)
            }
            #endif
        }
    }
    
    var selectedTab: ProjectTextEditorsTabViewController.Tab? {
        
        return self.projectTextEditorsTabViewController?.selectedTab
    }
    
    private var projectTextEditorsTableViewController: ProjectTextEditorsTableViewController? {
        
        return self.projectTextEditorsTabViewController?.projectTextEditorsTableViewController
    }
    
    private var projectTextEditorsEmptySelectionViewController: ProjectTextEditorsEmptySelectionViewController? {
        
        return self.projectTextEditorsTabViewController?.projectTextEditorsEmptySelectionViewController
    }
    
    func disableScrolling() {
    
        self.projectTextEditorsTabViewController?.disableScrolling()
    }
    
    func enableScrolling() {
        
        self.projectTextEditorsTabViewController?.enableScrolling()
    }
    
    @IBAction func closeFilesPanel(_ sender: AnyObject?) {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let filesOutlineSetManager = documentManager.filesOutlineSetManager.value else {
            assertionFailure("Error: filesOutlineSetManager is nil")
            return
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let index = filesOutlineSetManager.index(ofFilesOutlineManager: filesOutlineManager) else {
            assertionFailure("Error: index returned is nil")
            return
        }
        documentManager.removeFilesOutlineManager(atIndex: index)
    }
    
    @IBAction func addTextUnderFirstResponder(_ sender: AnyObject?) {

        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let lastEditedContentManagerId = filesOutlineManager.lastEditedContentManagerId.value else {
            assertionFailure("Error: filesOutlineManager.lastEditedContentManagerId is nil")
            return
        }

        filesOutlineManager.addTextManagerAndSelectIt(afterItemWithId: lastEditedContentManagerId)
    }
    
    @IBAction func addProjectTextEditorList(_ sender: AnyObject?) {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let filesOutlineSetManager = documentManager.filesOutlineSetManager.value else {
            assertionFailure("Error: filesOutlineSetManager is nil")
            return
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let index = filesOutlineSetManager.index(ofFilesOutlineManager: filesOutlineManager) else {
            assertionFailure("Error: index returned is nil")
            return
        }
        
        documentManager.addNewEmptyFilesOutlineManager(atIndex: index+1)
    }
    
    @IBAction func moveBackInHistory(_ sender: Any?) {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        filesOutlineManager.moveBackward()
    }
    
    @IBAction func moveForwardInHistory(_ sender: Any?) {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        filesOutlineManager.moveForward()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.subscribeToFilesOutlineManager()
        self.subscribeToFilesOutlineSetManager()
        self.subscribeToDocumentManager()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.updateSelectedState()
        
        // We need to call the handler for selection update since
        // the textIds are initialized but we didn't receive
        // any notifications. 
        self.handleSelectionUpdate(self.filesOutlineManager!.textIds)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
    }
    
    func handleKeydownEvent(with event: NSEvent) {
        
        self.collapseTitle()
    }
    
    func handleWindowMouseMovedEvent() {
        
        self.uncollapseTitle()
    }
    
    private var titleHeight: CGFloat? {
        
        return self.titleView?.frame.height
    }
    
    private var collapseHeight: CGFloat? {
        
        guard let titleHeight = self.titleHeight else {
            assertionFailure("Error: titleHeight is nil")
            return nil
        }
        
        return titleHeight-4
    }
    
    /// Function to collapse the title. It make everything
    /// possible to not move the text.
    func collapseTitle() {
        
        defer {
            self.view.layoutSubtreeIfNeeded()
        }
        
        assert(self.titleTopConstraint != nil)
        
        guard let collapseHeight = self.collapseHeight else {
            assertionFailure("Error: self.titleHeight is nil")
            return
        }
        
        self.selectedLineView?.collapsed = true
        self.selectedLineView?.updateBackgroundColor()
        
        self.titleTopConstraint?.constant = -collapseHeight
        self.titleSeparatorHeightConstraint?.constant = 0
        self.selectorLineHeightConstraint?.constant = 4
        
        guard let selectedTab = self.selectedTab else {
            assertionFailure("Error: selectedTab is nil")
            return
        }

        switch selectedTab {
        case .editors:
            // if editors are show we should move their origin
            // down to avoid the text to move.
            projectTextEditorsTableViewController?.scrollTable(by: -collapseHeight)
        case .emptySelection:
            projectTextEditorsEmptySelectionViewController?.moveText(by: CGFloat(collapseHeight/2))
        }
    }
    
    func uncollapseTitle() {
        
        defer {
            self.view.layoutSubtreeIfNeeded()
        }
        
        self.titleTopConstraint?.constant = 0
        self.titleSeparatorHeightConstraint?.constant = 1
        self.selectorLineHeightConstraint?.constant = 2
        
        self.selectedLineView?.collapsed = false
        self.selectedLineView?.updateBackgroundColor()
        
        guard let collapseHeight = self.collapseHeight else {
            assertionFailure("Error: self.titleHeight is nil")
            return
        }
        
        guard let selectedTab = self.selectedTab else {
            assertionFailure("Error: selectedTab is nil")
            return
        }
        
        switch selectedTab {
        case .editors:
            // if editors are show we should move their origin
            // down to avoid the text to move.
            projectTextEditorsTableViewController?.scrollTable(by: collapseHeight)
        case .emptySelection:
            projectTextEditorsEmptySelectionViewController?.resetCenterPosition()
        }
        
    }
    
    private func disableUserInteractions() {
        
        self.addFilesOutlineButton?.disableUserInteractions()
        self.topAddTextButon?.disableUserInteractions()
        self.closePanelButton?.disableUserInteractions()

        self.titleLabel?.isEditable = false
        self.titleLabel?.isEnabled = false
        
        self.backInHistory?.disableUserInteractions()
        self.forwardInHistory?.disableUserInteractions()
        
        self.backInHistoryToolbarBackground?.isEnabled = false
        self.forwardInHistoryToolbarBackground?.isEnabled = false
    }
    
    private func enableUserInteractions() {
        
        self.addFilesOutlineButton?.enableUserInteractions()
        self.topAddTextButon?.enableUserInteractions()
        self.closePanelButton?.enableUserInteractions()

        self.titleLabel?.isEditable = true
        self.titleLabel?.isEnabled = true
        
        self.backInHistory?.enableUserInteractions()
        self.forwardInHistory?.enableUserInteractions()
        
        self.backInHistoryToolbarBackground?.isEnabled = true
        self.forwardInHistoryToolbarBackground?.isEnabled = true
    }
    
    func updateLastEdited(toTextId textId: TextId?) {
        
        assert(self.filesOutlineManager != nil)
        filesOutlineManager?.lastEditedContentManagerId.setValue(textId)
    }
    
    func selectedCurrentFilesOutlineManager() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: filesOutlineManager is nil")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.filesOutlineSetManager?.filesOutlineManagerSelected(withId: filesOutlineManager.id)
        }
    }
    
    func updateTopButtonsLeftMargin(forFirstFilesOutlineManager isFirstFilesOutlineManager: Bool, leftButtonsShown: Bool, sidebarsShow: Bool, projectToolsShown: Bool, animate: Bool = false, fullscreen: Bool) {
        
        var constant: CGFloat = 8
        
        if fullscreen {
            // nothing to do 
        }
        else if isFirstFilesOutlineManager && !projectToolsShown {
            if leftButtonsShown {
                if sidebarsShow {
                    constant = 29
                }
                else {
                    constant = 74
                }
            }
        }
        
        if animate {
            filesOutlineTitleLeftButtonsMinimumLeadingConstraint?.animator().constant = constant
        }
        else {
            filesOutlineTitleLeftButtonsMinimumLeadingConstraint?.constant = constant
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "embedProjectTextEditorsTab" {
            if let projectTextEditorsTabViewController = segue.destinationController as? ProjectTextEditorsTabViewController {
                
                guard let filesOutlineManager = self.filesOutlineManager else {
                    assertionFailure("Error: self.filesOutlineManager is nil")
                    return
                }
                
                projectTextEditorsTabViewController.representedObject = filesOutlineManager
            }
        }
    }
    
    func hideTopCloseButtonIfNecessary() {
        
        guard let topButtonsStackView = self.topButtonsStackView else {
            assertionFailure("Error: self.topButtonsStackView is nil")
            return
        }
        
        guard let closePanelButtonContainerView = self.closePanelButtonContainerView else {
            assertionFailure("Error: self.closePanelButtonContainerView is nil")
            return
        }
        
        if let _ = topButtonsStackView.arrangedSubviews.first as? CloseButtonContainerView {
            topButtonsStackView.removeArrangedSubview(closePanelButtonContainerView)
            closePanelButtonContainerView.isHidden = true
        }
    }
    
    private func makeLastEditedTextViewResignFirstResponder() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        if let lastEditedContentManagerId = filesOutlineManager.lastEditedContentManagerId.value {
        
            guard let contentEditor = self.contentEditor(forContentId: lastEditedContentManagerId) else {
                
                // it's possible that the contentEditor is not openened anymore
                return
            }
            
            if contentEditor.isFirstResponder {
                contentEditor.resignFirstResponderWithoutRemovingAsLastEdited()
            }
        }
    }
    
    private func makeLastEditedTextViewBecomesFirstResponder() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        guard let selectedFilesOutlineID = filesOutlineSetManager.selectedFilesOutlineID.value else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return
        }
        
        if filesOutlineManager.id == selectedFilesOutlineID {
            if let lastEditedContentManagerId = filesOutlineManager.lastEditedContentManagerId.value {
            
                // content editor may have been deleted
                // stylo #1121: the project editor needs to still
                // be visible to set it as first responder
                if let contentEditor = self.contentEditor(forContentId: lastEditedContentManagerId), let window = contentEditor.window {
                    if contentEditor.acceptsFirstResponder {
                        window.makeFirstResponder(contentEditor)
                    }
                }
            }
        }
    }
    
    private func contentEditor(forContentId contentId: ContentId) -> ProjectTextEditor? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("contentEditor(forContentId: %@) -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%contentId, %%self.filesOutlineManager!.name.value)
        os_log("contentEditor -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%self.filesOutlineManager!.name.value)
        #endif
        
        guard let projectTextEditorsTabViewController = self.projectTextEditorsTabViewController else {
            assertionFailure("Error: self.projectTextEditorsTabViewController is nil")
            return nil
        }
        
        guard let editorsViewController = projectTextEditorsTabViewController.editorsViewController else {
            assertionFailure("Error: editorsViewController is nil")
            return nil
        }
        
        guard let projectTextEditorViewController = editorsViewController.projectTextEditorViewControllers[contentId] else {
            // it may have been deleted
            return nil
        }
        
        guard let projectTextEditor = projectTextEditorViewController.resourceEditorView else {
            assertionFailure("Error: projectTextEditor is nil")
            return nil
        }
        
        return projectTextEditor
    }
    
    func updateSelectedState() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }

        filesOutlineManager.updateSelectedState()
    }
    
    func showTopCloseButtonIfNecessary() {
        
        guard let topButtonsStackView = self.topButtonsStackView else {
            assertionFailure("Error: self.topButtonsStackView is nil")
            return
        }
        
        guard let closePanelButtonContainerView = self.closePanelButtonContainerView else {
            assertionFailure("Error: self.closePanelButtonContainerView is nil")
            return
        }
        if let _ = topButtonsStackView.arrangedSubviews.first as? CloseButtonContainerView {
            // nothing
        }
        else {
            topButtonsStackView.insertArrangedSubview(closePanelButtonContainerView, at: 0)
            closePanelButtonContainerView.isHidden = false
        }
    }
    
    private func subscribeToFilesOutlineSetManager() {
    
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        self.updateAddEditorsPanelButtonEnabled()
        filesOutlineSetManager.filesOutlines.subscribe({ [weak self](_) in
            self?.updateSelectedState()
            self?.updateAddEditorsPanelButtonEnabled()
        }, observer: self)
        
        filesOutlineSetManager.selectedFilesOutlineID.subscribe({ [weak self](_) in
            self?.updateSelectedState()
        }, observer: self)
    }
    
    private func unsubscribeToFilesOutlineSetManager() {
    
        self.filesOutlineSetManager?.filesOutlines.unsubscribe(observer: self)
        self.filesOutlineSetManager?.selectedFilesOutlineID.unsubscribe(observer: self)
    }
        
    private func updateAddEditorsPanelButtonEnabled() {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            self.addEditorsPanelEnabled = false
            return
        }
        
        guard let mainScreen = NSScreen.main else {
            assertionFailure("Error: mainScreen is nil")
            self.addEditorsPanelEnabled = false
            return
        }
        
        self.addEditorsPanelEnabled = mainScreen.allowsAddingOtherEditorsPanel(forFilesOutlinesCount: filesOutlineSetManager.filesOutlines.count)
    }
    
    private func subscribeToFilesOutlineManager() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        self.filesOutlineManager?.historyBackEnabled.unsubscribe(observer: self)
        self.filesOutlineManager?.historyForwardEnabled.unsubscribe(observer: self)
        
        self.backInHistory?.isEnabled = filesOutlineManager.historyBackEnabled.value
        self.backInHistoryToolbarBackground?.isEnabled = filesOutlineManager.historyBackEnabled.value
        
        filesOutlineManager.historyBackEnabled.subscribe({ [weak self](enabled) in
            self?.backInHistory?.isEnabled = enabled
            self?.backInHistoryToolbarBackground?.isEnabled = enabled
        }, observer: self)
        
        assert(self.filesOutlineManager != nil)
        if let filesOutlineManager = self.filesOutlineManager {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Assigning name: %@ to files outline", log: Log.StyloCore.all, type: .info, %%filesOutlineManager.name.value)
            #endif
            self.titleLabel?.stringValue = filesOutlineManager.name.value
            filesOutlineManager.name.subscribe({ [weak self](newName) in
                self?.titleLabel?.stringValue = newName
            }, observer: self)
        }
        
        self.forwardInHistory?.isEnabled = filesOutlineManager.historyForwardEnabled.value
        self.forwardInHistoryToolbarBackground?.isEnabled = filesOutlineManager.historyForwardEnabled.value
        filesOutlineManager.historyForwardEnabled.subscribe({ [weak self](enabled) in
            self?.forwardInHistory?.isEnabled = enabled
            self?.forwardInHistoryToolbarBackground?.isEnabled = enabled
        }, observer: self)
        
        filesOutlineManager.selectionState.subscribe({ [weak self](selectionState) in
            self?.handleSelectedStateDidChange(selectionState)
        }, observer: self)
        
        filesOutlineManager.currentEditorId.subscribe({ [weak self](_) in
            self?.updateAddTextButtonEnabledState()
        }, observer: self)
        
        filesOutlineManager.selectedTextItems.subscribe( { [weak self](change) in
            switch change {
            case .deletes: fallthrough
            case .insert: fallthrough
            case .inserts: fallthrough
            case .start: fallthrough
            case .move:
                break
            case .end(let updatedArray):
                self?.handleSelectionUpdate(updatedArray)
            }
        }, observer: self)
    }
    
    private func handleSelectedStateDidChange(_ selectionState: FilesOutlineManager.SelectionState) {
        
        self.selectedLineView?.selected = selectionState
        
        switch selectionState {
        case .selected:
            self.makeLastEditedTextViewBecomesFirstResponder()
        case .unselected:
            self.makeLastEditedTextViewResignFirstResponder()
        case .single:
            self.makeLastEditedTextViewBecomesFirstResponder()
        }
        
        updateAddTextButtonEnabledState()
    }
    
    private func updateAddTextButtonEnabledState() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        if filesOutlineManager.currentEditorId.value != nil {
            self.topAddTextButon?.isEnabled = true
            self.topAddTextButonBackground?.isEnabled = true
        }
        else {
            self.topAddTextButon?.isEnabled = false
            self.topAddTextButonBackground?.isEnabled = false
        }
    }
    
    private func unsubscribeToFilesOutlineManager() {
        
        self.filesOutlineManager?.name.unsubscribe(observer: self)
        self.filesOutlineManager?.historyBackEnabled.unsubscribe(observer: self)
        self.filesOutlineManager?.historyForwardEnabled.unsubscribe(observer: self)
        self.filesOutlineManager?.selectionState.unsubscribe(observer: self)
        self.filesOutlineManager?.selectedTextItems.unsubscribe(observer: self)
    }
    
    func subscribeToDocumentManager() {

        documentManager?.userInteractionsEnabled.subscribe({ [self](userInteractionsEnabled) in
            if userInteractionsEnabled {
                self.enableUserInteractions()
            }
            else {
                self.disableUserInteractions()
            }
        }, observer: self)
    }
    
    func unsubscribeToDocumentManager() {
        
        documentManager?.userInteractionsEnabled.unsubscribe(observer: self)
        documentManager?.name.unsubscribe(observer: self)
    }
    
    private weak var subscribedTextManager: TextManager?
    
    private weak var subscribedEditor: AnyEditor?
    
    private func handleSelectionUpdate<C>(_ updatedCollection: C) where C: Collection, C.Element == String {
        
        self.unsubscribe(fromTextManager: self.subscribedTextManager)
        self.unsubscribe(fromEditor: self.subscribedEditor)
        if !updatedCollection.isEmpty {
            self.subscribeToFirstTextManager()
        }
        else {
            self.updateSelectedLineUnselectedColor()
        }
    }
    
    private func subscribeToFirstTextManager() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let firstTextManager = filesOutlineManager.selectedTextManagers.first else {
            assertionFailure("Error: firstTextManager is nil")
            return
        }
        
        let editorId = filesOutlineManager.createOrGetEditorId(forTextId: firstTextManager.id)
        
        if let editorManager = firstTextManager.editor(for: editorId) {
            subscribeToEditor(editor: editorManager)
        }
        else {
            firstTextManager.editorManagers.subscribe({ [weak self](change) in
                
                self?.unsubscribe(fromEditor: self?.subscribedEditor)
                
                switch change {
                case .deletes: fallthrough
                case .start:
                    break
                case .end(let updatedDict):
                    if let editor = updatedDict[editorId] {
                        self?.subscribeToEditor(editor: editor)
                    }
                case .updates(_, let updatedValues):
                    if let editor = updatedValues[editorId] {
                        self?.subscribeToEditor(editor: editor)
                    }
                }
            }, observer: self)
            self.subscribedTextManager = firstTextManager
        }
    }
    
    private func subscribeToEditor(editor: AnyEditor) {
        
        guard let globalAttributes = editor.globalAttributes.value else {
            assertionFailure("Error: globalAttributes is nil")
            return
        }
        
        self.handleGlobalAttributes(globalAttributes)
        
        editor.globalAttributes.subscribe({ [weak self](globalAttributes) in
            self?.handleGlobalAttributes(globalAttributes)
        }, observer: self)
        
        self.subscribedEditor = editor
    }
    
    private func unsubscribe(fromTextManager textManager: TextManager?) {
        
        guard let textManager = textManager else {
            return
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        let editorId = filesOutlineManager.createOrGetEditorId(forTextId: textManager.id)

        guard let editorManager = textManager.editor(for: editorId) else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        editorManager.globalAttributes.unsubscribe(observer: self)
        self.subscribedTextManager = nil
    }
    
    private func unsubscribe(fromEditor editor: AnyEditor?) {
    
        editor?.globalAttributes.unsubscribe(observer: self)
        self.subscribedEditor = nil
    }
    
    private func handleGlobalAttributes(_ globalAttributes: GlobalAttributes?) {
        
        guard let backgroundColor = globalAttributes?.backgroundColor else {
            assertionFailure("Error: background color is nil")
            return
        }
            
        self.selectedLineView?.firstTextBackgroundColor = backgroundColor
    }
    
    private func updateSelectedLineUnselectedColor() {
        
        self.selectedLineView?.firstTextBackgroundColor = nsColor(named: "ScrollViewBackgroundColor")
    }
    
    deinit {
        
        self.unsubscribeToFilesOutlineManager()
        self.unsubscribeToFilesOutlineSetManager()
        self.unsubscribeToDocumentManager()
    }
}
