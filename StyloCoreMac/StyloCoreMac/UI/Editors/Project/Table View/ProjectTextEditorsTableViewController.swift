//
//  ProjectTextEditorsTableViewController.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import os
import Common

class ProjectTextEditorsTableViewController: NSViewController, EditorsViewController, TextKeydownListener {
    
    @IBOutlet var projectTextEditorsTableView: ProjectTextEditorsTableView! {
        didSet {
            assert(projectTextEditorsTableView != nil)
            projectTextEditorsTableView.intercellSpacing = NSMakeSize(0, 0)
            projectTextEditorsTableView.gridStyleMask = []
        }
    }
    
    @IBOutlet var scrollView: ProjectTextEditorsScrollView!
    
    var documentManager: DocumentManager? {
        
        return self.filesOutlineManager?.documentManager
    }
    
    var filesOutlineManager: FilesOutlineManager? {
        return self.representedObject as? FilesOutlineManager
    }
    
    var sourceSetManager: SourceSetManager? {
        return self.documentManager?._sourceSetManager.value
    }
    
    var contentViews: [EditorContentView] {
        return projectTextEditorViewControllers.compactMap({ (arg0) -> EditorContentView? in
            let (_, value) = arg0
            return value.editorContentView
        })
    }
    
    var visibleEditors: [EditableView] {
        return projectTextEditorViewControllers.compactMap({ (arg0) -> EditableView? in
            let (_, value) = arg0
            return value.resourceEditorView
        })
    }
    
    var textLeftSideViews: [EditorSideView] {
        return projectTextEditorViewControllers.compactMap({ (arg0) -> EditorSideView? in
            let (_, value) = arg0
            return value.leftView
        })
    }
    
    var textRightSideViews: [EditorSideView] {
        return projectTextEditorViewControllers.compactMap({ (arg0) -> EditorSideView? in
            let (_, value) = arg0
            return value.rightView
        })
    }
    
    var numberOfItems: Int {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return 0
        }
            
        let numberOfItems = filesOutlineManager.selectedTextItems.values.count
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("numberOfItems: %@", log: Log.StyloCore.all, type: .info, %%numberOfItems)
        #endif
        
        return numberOfItems
    }
    
    var firstTitleView: TitleOutlineCellView?
    
    var projectTextEditorsListSplitViewController: ProjectTextEditorsListSplitViewController? {
        
        var view: NSView? = self.view
        
        while view != nil {
            if view is NSSplitView {
                break
            }
            view = view?.superview
        }
        
        guard let splitView = view as? NSSplitView else {
            assertionFailure("Error: view is not NSSplitView")
            return nil
        }
        
        guard let projectTextEditorsListSplitViewController = splitView.delegate as? ProjectTextEditorsListSplitViewController else {
            assertionFailure("Error: superview.nextResponder is not ProjectTextEditorsListSplitViewController")
            return nil
        }
        return projectTextEditorsListSplitViewController
    }
    
    var isLeftSplitViewItem: Bool {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return false
        }
        
        return filesOutlineManager.isFirstFilesOutline
    }
    
    var isRightSplitViewItem: Bool {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return false
        }
        
        return filesOutlineManager.isLastFilesOutline
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
    
    var titlesOutlineCellViews: [TextId: TitleOutlineCellView] = [:]
    
    var editorItemsTableCellViews: [TextId: EditorItemTableCellView] = [:]
    
    var projectTextEditorViewControllers: [TextId: ProjectTextEditorViewController] {
        
        return editorItemsTableCellViews.mapValues { (editorItemTableCellView) -> ProjectTextEditorViewController in
            return editorItemTableCellView.projectTextEditorViewController!
        }
    }
    
    weak var previouslyFocusedEditor: AnyEditor?
    
    var styleAssemblyDescriptor: StyleAssemblyDescriptor?
    
    var tableUpdateSerialQueue = DispatchQueue(label: UUID().uuidString)
    
    private var pendingOpenDocumentTasks = Queue<Bool>()
    
    private var editorSelectingText: Bool = false
    
    private var initialized: Bool = false
    
    private var shouldHideEditorHeaders: Bool = false
    
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
    
    func disableScrolling() {
    
        assert(self.scrollView != nil)
        self.scrollView?.disableScrolling()
    }
    
    func enableScrolling() {
        
        assert(self.scrollView != nil)
        self.scrollView?.restoreScrolling()
    }
    
    @IBAction func toggleCollapseEditor(_ sender: Any?) {
        
        guard let button = sender as? NSButton else {
            assertionFailure("Error: sender is not NSButton")
            return
        }
        
        // we take into account the colored view which is in between
        guard let titleOutlineCellView = button.superview?.superview?.superview as? TitleOutlineCellView else {
            assertionFailure("Error: button.superview is not TextTitleTableCellView")
            return
        }
        
        guard let textManagerId = titleOutlineCellView.textManagerId else {
            assertionFailure("Error: textTitleTableCellView.textManagerId is nil")
            return
        }

        toggleCollapseTextManager(withId: textManagerId, titleOutlineCellView: titleOutlineCellView)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if !initialized {
            self.restoreExpandedItems()
            self.initialized = true
        }
        self.view.needsUpdateConstraints = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.startListeningToKeydownEvents()
        self.subscribeToEditorSelectionNotifications()
        self.subscribeToWindowMouseMovedNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribeToFilesOutlineManager()
        self.subscribeToSourceSetManager()
        self.subscribeToTableViewBoundsChange()
        self.projectTextEditorsTableView.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
    }
    
    func addPendingOpenTextManagerTask() {
        
        if self.pendingOpenDocumentTasks.isEmpty {
            self.documentManager?.userInteractionsEnabled.setValue(false, sameExecutionStack: true)
        }
        
        pendingOpenDocumentTasks.enqueue(true)
    }
    
    func removePendingOpenTextManagerTask() {
        
        pendingOpenDocumentTasks.dequeue()
        
        if self.pendingOpenDocumentTasks.isEmpty {
            self.documentManager?.userInteractionsEnabled.setValue(true, sameExecutionStack: true)
        }
    }
    
    func scrollTable(by value: CGFloat) {
        
        let contentView = self.scrollView.contentView
        let actualScrollPoint = contentView.bounds.origin
        
        guard actualScrollPoint.y != 0 else {
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("contentView.isFlipped: %@", log: Log.StyloCore.all, type: .info, %%contentView.isFlipped)
        os_log("actualScrollPoint: %@", log: Log.StyloCore.all, type: .info, %%actualScrollPoint)
        #endif
        
        let destinationPoint = NSMakePoint(actualScrollPoint.x, actualScrollPoint.y+value)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("destinationPoint: %@", log: Log.StyloCore.all, type: .info, %%destinationPoint)
        #endif
        
        self.scrollView.contentView.setBoundsOrigin(destinationPoint)
    }
    
    private func subscribeToTableViewBoundsChange() {
        
//        self.projectTextEditorsTableView.postsBoundsChangedNotifications = true
//        NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: self.scrollView.contentView, queue: nil, using: { [weak self](_) in
//            self?.filesOutlineManager?.handleScroll()
//        })
    }
    
    private func subscribeToWindowMouseMovedNotifications() {
        
        guard let window = self.view.window else {
            assertionFailure("Error: window is nil")
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.windowMouseMoved.name, object: window, queue: nil) { [weak self](_) in
            self?.handleWindowMouseMovedEvent()
        }
    }

    private func subscribeToEditorSelectionNotifications() {
        
        guard let window = self.view.window else {
            assertionFailure("Error: window is nil")
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.editorIsSelecting.name, object: window, queue: nil) { [weak self](_) in
            self?.editorSelectingText = true
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.editorIsNotSelecting.name, object: window, queue: nil) { [weak self](_) in
            self?.editorSelectingText = false
        }
    }
    
    private var dinkusHiddenState: Bool = true
    
    func handleWindowMouseMovedEvent() {
        
        if InterfaceConstants.Configuration.HideEditorsHeadersOnKeyPressed && !dinkusHiddenState {
            
            guard !editorSelectingText else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Editor is selecting text", log: Log.StyloCore.all, type: .info)
                #endif
                
                return
            }
            
            self.shouldHideEditorHeaders = false
        }
    }
    
    func handleKeydownEvent(with event: NSEvent) {
        
        if InterfaceConstants.Configuration.HideEditorsHeadersOnKeyPressed && dinkusHiddenState {
            
            self.shouldHideEditorHeaders = true
        }
    }
    
    func hideScroller() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Hiding editor scroller", log: Log.StyloCore.all, type: .info)
        #endif
        scrollView.hasVerticalScroller = false
    }
    
    func showScroller() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Showing editor scroller", log: Log.StyloCore.all, type: .info)
        #endif
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 10000)) {
            self.scrollView.hasVerticalScroller = true
        }
    }
    
    func removeTextEditorsIfNecessary(withIds textIds: [TextId]) {
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("removeTextEditors(withIds: %@) -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%textIds, %%self.filesOutlineManager!.name.value)
        os_log("removeTextEditors -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%self.filesOutlineManager!.name.value)
        #endif
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        for textId in textIds {
            // since items may have moved deleted items may have
            // added somewhere else so we need to make sure they
            // really have been deleted before removing them.
            if !filesOutlineManager.selectedTextItems.contains(textId) {
                removeTextEditor(withId: textId)
            }
        }
    }
    
    func removeTextEditor(withId textId: TextId) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("removeTextEditor(withId: %@) -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%textId, %%self.filesOutlineManager!.name.value)
        os_log("removeTextEditor -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%self.filesOutlineManager!.name.value)
        #endif
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        titlesOutlineCellViews.removeValue(forKey: textId)
        editorItemsTableCellViews.removeValue(forKey: textId)
        filesOutlineManager.unregisterEditor(forTextId: textId)
    }
    
    func textEditor(forTextId textId: TextId) -> ProjectTextEditor? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("textEditor(forTextId: %@)", log: Log.StyloCore.all, type: .info, %%textId)
        #endif
        
        guard let editorItemTableCellView = editorItemCellView(forId: textId) else {
            assertionFailure("Error: editorItemTableCellView is nil")
            return nil
        }
        
        guard let projectTextEditorView = editorItemTableCellView.resourceEditorView as? ProjectTextEditor else {
            assertionFailure("Error: projectTextEditorView is nil")
            return nil
        }
        
        return projectTextEditorView
    }
    
    func textItemId(at rowIndex: Int) -> String? {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return nil
        }
        
        guard !filesOutlineManager.selectedTextItems.values.isEmpty else {
            return nil
        }
        
        guard rowIndex >= 0 && rowIndex < filesOutlineManager.selectedTextItems.values.count else {
            return nil
        }
        
        return filesOutlineManager.selectedTextItems[safe: rowIndex]
    }
    
    func titleOutlineCellView(for textId: TextId) -> TitleOutlineCellView? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("request titleOutlineCellView for id: %@ in editors in table", log: Log.StyloCore.all, type: .info, %%textId)
        #endif
        
        if let titleOutlineCellView = titlesOutlineCellViews[textId] {
            titleOutlineCellView.updateAppearanceFromGlobalAttributes()
            return titleOutlineCellView
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return nil
        }
        
        let editorId: EditorId = filesOutlineManager.createOrGetEditorId(forTextId: textId)
        
        guard let titleOutlineCellView = createTitleCellView(forTexManagerId: textId, andEditorId: editorId) else {
            assertionFailure("Error: createProjectTextEditorCellView(for id: String returned nil")
            return nil
        }
        
        self.titlesOutlineCellViews[textId] = titleOutlineCellView
        return titleOutlineCellView
    }
     
    private func addTopView() {
        
        fatalError("missing implementation")
        
    }
    
    private func createTitleCellView(forTexManagerId textManagerId: String, andEditorId editorId: EditorId) -> TitleOutlineCellView? {
        
        guard let titleOutlineCellView = self.projectTextEditorsTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "title"), owner: self) as? TitleOutlineCellView else {
            assertionFailure("Error: titleOutlineCellView built view is nil")
            return nil
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return nil
        }
        
        titleOutlineCellView.documentManager = self.documentManager
        titleOutlineCellView.textManagerId = textManagerId
        titleOutlineCellView.editorId = editorId
        
        titleOutlineCellView.collapsed = filesOutlineManager.isTextManagerCollapsed(with: textManagerId)
        let editorId = filesOutlineManager.createOrGetEditorId(forTextId: textManagerId)
        
        // TextEditorToolbarPlugin
        if let textEditorControls = self.documentManager?.pluginsTextEditorControls(forTextId: textManagerId, andEditorId: editorId) {
            for textEditorControl in textEditorControls {
                titleOutlineCellView.editorControlsStackView.addArrangedSubview(textEditorControl)
            }
        }

        if InterfaceConstants.Configuration.HideEditorsHeadersOnKeyPressed && InterfaceConstants.Configuration.ShowTextEditorsPanelSeparators {
            titleOutlineCellView.separatorIsHidden = self.shouldHideEditorHeaders
        }
        else {
            titleOutlineCellView.separatorIsHidden = !InterfaceConstants.Configuration.ShowTextEditorsPanelSeparators
        }
        
        titleOutlineCellView.updateStackViewLeadingConstraint()
        titleOutlineCellView.identifier = nil
        return titleOutlineCellView
    }
    
    func editorItemCellView(forRow row: Int) -> EditorItemTableCellView? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("editorItemCellView(forRow: %@) in editors in table", log: Log.StyloCore.all, type: .info, %%row)
        #endif
        
        guard let textItemId = self.textItemId(at: row) else {
            assertionFailure("Error: self.textItemId(at: \(row)) is nil")
            return nil
        }
        
        guard let editorItemCellView = self.editorItemCellView(forId: textItemId) else {
            assertionFailure("Error: self.editorItemCellView(forId: \(textItemId)) is nil")
            return nil
        }
        
        return editorItemCellView
    }
    
    func editorItemCellView(forId id: TextId) -> EditorItemTableCellView? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("editorItemCellView(forId: %@) -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%id, %%self.filesOutlineManager!.name.value)
        os_log("editorItemCellView -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%self.filesOutlineManager!.name.value)
        os_log("editorItemCellView -> editorItemsTableCellViews[%@]: %@ files outline name: %@", log: Log.StyloCore.all, type: .info, %%id, %%editorItemsTableCellViews[id], %%self.filesOutlineManager!.name.value)
        #endif
        
        if let editorItemCellView = editorItemsTableCellViews[id] {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            guard let sourceSetManager = self.sourceSetManager else {
                assertionFailure("Error: self.sourceSetManager is nil.")
                return nil
            }
            
            guard let textManager = sourceSetManager.directoryItemManager(withId: id) as? TextManager else {
                assertionFailure("Error: item with id: \(id) is nil or not a TextManager.")
                return nil
            }
            
            os_log("editorItemCellView was found for id: %@ for text manager with name: %@", log: Log.StyloCore.all, type: .debug, %%id, %%textManager.name.value)
            #endif
            
            if editorItemCellView.window == nil {
                self.configureEditorItemCellView(editorItemCellView, forTextId: id)
            }
            return editorItemCellView
        }
        
        guard let editorItemCellView = createEditorItemCellView(forId: id) else {
            assertionFailure("Error: createProjectTextEditorCellView(for id: String returned nil")
            return nil
        }
        
        self.editorItemsTableCellViews[id] = editorItemCellView
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("editorItemCellView -> editorItemsTableCellViews[%@]: %@ -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%id, %%editorItemsTableCellViews[id], %%self.filesOutlineManager!.name.value)
        #endif
        
        configureEditorItemCellView(editorItemCellView, forTextId: id)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end editorItemCellView(forId: %@) -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%id, %%self.filesOutlineManager!.name.value)
        os_log("end editorItemCellView -> files outline name: %@", log: Log.StyloCore.all, type: .info, %%self.filesOutlineManager!.name.value)
        #endif
        
        return editorItemCellView
    }
    
    private func configureEditorItemCellView(_ editorItemCellView: EditorItemTableCellView, forTextId id: TextId) {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        self.projectTextEditorViewControllers[id]?.isLast = filesOutlineManager.isLastItemSelected(with: id)
        
        if filesOutlineManager.collapsedEditorItems.contains(id) {
            editorItemCellView.collapse()
        }
    
        editorItemCellView.projectTextEditorViewController?.updateStyleAssemblyFromFilesOutlineManager(visibleRange: nil)
    }
    
    private func createEditorItemCellView(forId id: String) -> EditorItemTableCellView? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start createEditorItemCellView(forId: %@)", log: Log.StyloCore.all, type: .debug, %%id)
        #endif
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil.")
            return nil
        }

        guard let textManager = sourceSetManager.directoryItemManager(withId: id) as? TextManager else {
            assertionFailure("Error: item with id: \(id) is nil or not a TextManager.")
            return nil
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("createEditorItemCellView for text manager with name: %@", log: Log.StyloCore.all, type: .debug, %%textManager.name.value)
        #endif
        
        let bundle = Bundle(for: ProjectTextEditorsTableViewController.self)
        let editorViewItemStoryboard = NSStoryboard(name: NSStoryboard.Name("EditorViewItem"), bundle: bundle)
                
        guard let editorViewItemViewController: EditorViewItemViewController = editorViewItemStoryboard.instantiateInitialController() as? EditorViewItemViewController else {
            assertionFailure("Error: editorViewItemViewController is nil")
            return nil
        }
        
        editorViewItemViewController.editorsViewController = self
        editorViewItemViewController.filesOutlineManager = self.filesOutlineManager
        editorViewItemViewController.documentManager = self.documentManager
        editorViewItemViewController.representedObject = textManager
        
        let _ = editorViewItemViewController.view
        
        let editorItemTableCellView = EditorItemTableCellView(frame: .zero)
        editorItemTableCellView.translatesAutoresizingMaskIntoConstraints = false
        editorItemTableCellView.editorViewItemViewController = editorViewItemViewController
        
        let editorView = editorViewItemViewController.view
        editorView.translatesAutoresizingMaskIntoConstraints = false
        editorItemTableCellView.addSubview(editorView)
        editorItemTableCellView.identifier = nil
        
        let bottomConstraint = NSLayoutConstraint(item: editorView, attribute: .bottom, relatedBy: .equal, toItem: editorItemTableCellView, attribute: .bottom, multiplier:1, constant:0)
        
        let topConstraint = NSLayoutConstraint(item: editorView, attribute: .top, relatedBy: .equal, toItem: editorItemTableCellView, attribute: .top, multiplier:1, constant:0)
        
        editorItemTableCellView.addConstraint(bottomConstraint)
        editorItemTableCellView.addConstraint(topConstraint)
        
        NSLayoutConstraint(item: editorView, attribute: .leading, relatedBy: .equal, toItem: editorItemTableCellView, attribute: .leading, multiplier:1, constant:0).isActive = true
        
        NSLayoutConstraint(item: editorView, attribute: .trailing, relatedBy: .equal, toItem: editorItemTableCellView, attribute: .trailing, multiplier:1, constant:0).isActive = true
        
        editorItemTableCellView.identifier = nil
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end createEditorItemCellView(forId: %@)", log: Log.StyloCore.all, type: .info, %%id)
        #endif
        
        return editorItemTableCellView
    }
    
    private func subscribeToSourceSetManager() {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil.")
            return
        }
        
        sourceSetManager.subscribeToDirectoryItemsManagers(observer: self) { [weak self](change) in
            
            switch change {
            case .deletes(let removedValues, _):
                for (key, _) in removedValues {
                    if self?.editorItemsTableCellViews[key] != nil {
                        self?.removeTextEditor(withId: key)
                    }
                }
                break
            case .move:
                // moves will reflect in selected texts ordered dictionary
                break
            case .insert: fallthrough
            case .updates:
                // in the dictionary we can get this update for directory
                break
            case .start: fallthrough
            case .end:
                break
            }
        }
    }
    
    private func unsubscribeToSourceSetManager() {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil.")
            return
        }
        
        sourceSetManager.unsubscribeFromDirectoryItemsManagers(observer: self)
    }
    
    func isItemCollapsed(withId id: String) -> Bool {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager  is nil")
            return false
        }
        
        return filesOutlineManager.collapsedEditorItems.contains(id)
    }
    
    func restoreExpandedItems() {
        
//        guard let filesOutlineManager = self.filesOutlineManager else {
//            assertionFailure("Error: self.filesOutlineManager  is nil")
//            return
//        }
//
//        guard let sourceSetManager = self.sourceSetManager else {
//            assertionFailure("Error: self.sourceSetManager is nil.")
//            return
//        }
//
//        for selectedItemId in filesOutlineManager.selectedTextItems {
//
//            if !filesOutlineManager.collapsedEditorItems.contains(selectedItemId) {
//
//                guard let directoryItemManager = sourceSetManager.directoryItemManager(withId: selectedItemId)  else {
//                    assertionFailure("Error: item with id: \(selectedItemId) is nil.")
//                    continue
//                }
//
//                guard directoryItemManager is TextManager else {
//                    continue
//                }
//
//                expandEditor(withId: selectedItemId)
//            }
//        }
    }
    
    private func toggleCollapseTextManager(withId id: String, titleOutlineCellView: TitleOutlineCellView) {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        do {
            if filesOutlineManager.isTextManagerCollapsed(with: id) {
                titleOutlineCellView.collapsed = false
                try filesOutlineManager.uncollapseTextEditor(with: id)
            }
            else {
                titleOutlineCellView.collapsed = true
                try filesOutlineManager.collapseTextEditor(with: id)
            }
        }
        catch let error {
            assertionFailure("Error: exception: \(error)")
        }
    }
    
    deinit {
        assert(self.filesOutlineManager != nil)
        self.unsubscribe(fromFilesOutlineManager: self.filesOutlineManager)
        self.unsubscribeToSourceSetManager()
        self.stopListeningToKeydownEvents()
        NotificationCenter.default.removeObserver(self)
    }
}

