//
//  ProjectTextEditorsOutlineViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import os
import Common

class ProjectTextEditorsOutlineViewController: NSViewController, EditorsViewController {
    
    var filesOutlineTitleLeftButtonsMinimumLeadingConstraint: NSLayoutConstraint?
    
    @IBOutlet var projectTextEditorsOutlineView: ProjectTextEditorsOutlineView! {
        didSet {
            assert(projectTextEditorsOutlineView != nil)
            projectTextEditorsOutlineView.intercellSpacing = .zero
            projectTextEditorsOutlineView.gridStyleMask = []
            projectTextEditorsOutlineView.gridColor = NSColor.clear
        }
    }
    
    @IBOutlet var scrollView: ProjectTextEditorsScrollView!
    
    var documentManager: DocumentManager? {
        assert(self.filesOutlineManager != nil)
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
    
        return projectTextEditorViewControllers.map({ (arg0) -> EditableView in
            let (_, value) = arg0
            return value.resourceEditorView
        })
    }
    
    var textLeftSideViews: [EditorSideView] {
        return projectTextEditorViewControllers.map({ (arg0) -> EditorSideView in
            let (_, value) = arg0
            return value.leftView
        })
    }
    
    var textRightSideViews: [EditorSideView] {
        return projectTextEditorViewControllers.map({ (arg0) -> EditorSideView in
            let (_, value) = arg0
            return value.rightView
        })
    }
    
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
        
        guard let projectTextEditorsListSplitViewController = self.projectTextEditorsListSplitViewController else {
            assertionFailure("Error: self.projectTextEditorsListSplitViewController is nil")
            return false
        }
        
        guard let firstLeft = projectTextEditorsListSplitViewController.splitViewItems.first else {
            assertionFailure("Error: firstLeft is nil")
            return false
        }
        
        if firstLeft.viewController === self {
            return true
        }
        
        assertionFailure("Error: we are the left view (there is only one)")
        return false
    }
    
    var isRightSplitViewItem: Bool {
        
        guard let projectTextEditorsListSplitViewController = self.projectTextEditorsListSplitViewController else {
            assertionFailure("Error: self.projectTextEditorsListSplitViewController is nil")
            return false
        }
        
        guard let lastRight = projectTextEditorsListSplitViewController.splitViewItems.last else {
            assertionFailure("Error: lastRight is nil")
            return false
        }
        
        if lastRight.viewController === self {
            return true
        }
        assertionFailure("Error: we are the right view (there is only one)")
        return false
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
    
    var editorsOutlineCellViews: [String: EditorOutlineCellView] = [:]
    
    var titlesOutlineCellViews: [String: TitleOutlineCellView] = [:]
    
    private var editorsTitlesOutlineItems: [String: TextEditorsOutlineItem] = [:]
    
    private var initialized: Bool = false
    
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
    
    var projectTextEditorViewControllers: [String: ProjectTextEditorViewController] = [:]
    
    func disableScrolling() {
        
        fatalError("Error: missing implementation")
    }
    
    func enableScrolling() {
        
        fatalError("Error: missing implementation")
    }
    
    @IBAction func addTextManager(_ sender: Any?) {
        
        guard let button = sender as? NSButton else {
            assertionFailure("Error: sender is not NSButton")
            return
        }
        
        var textEditorsOutlineCellView: TextEditorsOutlineCellView?
        var view: NSView? = button.superview
        while view != nil {
            if let _textEditorsOutlineCellView = view as? TextEditorsOutlineCellView {
                textEditorsOutlineCellView = _textEditorsOutlineCellView
                break
            }
            view = view?.superview
        }
        
        guard textEditorsOutlineCellView != nil else {
            assertionFailure("Error: button.superview is not TextEditorsOutlineCellView")
            return
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let textEditorsOutlineItem = textEditorsOutlineCellView?.textEditorsOutlineItem else {
            assertionFailure("Error: textEditorsOutlineItem is nil")
            return
        }
        
        filesOutlineManager.addTextManager(afterItemWithId: textEditorsOutlineItem.id)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribeToFilesOutlineManager()
        self.subscribeToSourceSetManager()
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
    
    func titleEditorsOutlineItem(for id: String) -> TextEditorsOutlineItem? {
        
        if let editorTitleOutlineItem = editorsTitlesOutlineItems[id] {
            return editorTitleOutlineItem
        }
        
        guard let editorTitleOutlineItem = createEditorTitleOutlineItem(for: id) else {
            assertionFailure("Error: createEditorTitleOutlineItem(for id: String returned nil")
            return nil
        }
        
        self.editorsTitlesOutlineItems[id] = editorTitleOutlineItem
        return editorTitleOutlineItem
    }
    
    func createEditorTitleOutlineItem(for id: String) -> TextEditorsOutlineItem? {
    
        return TextEditorsOutlineItem(id: id, itemType: .title)
    }
    
    func titleOutlineCellView(for textEditorsOutlineItem: TextEditorsOutlineItem) -> TitleOutlineCellView? {
    
        if let titleOutlineCellView = titlesOutlineCellViews[textEditorsOutlineItem.id] {
            return titleOutlineCellView
        }
        
        guard let titleOutlineCellView = createTitleCellView(for: textEditorsOutlineItem) else {
            assertionFailure("Error: createProjectTextEditorCellView(for id: String returned nil")
            return nil
        }
        
        self.titlesOutlineCellViews[textEditorsOutlineItem.id] = titleOutlineCellView
        return titleOutlineCellView
    }
    
    private func createTitleCellView(for textEditorsOutlineItem: TextEditorsOutlineItem) -> TitleOutlineCellView? {
    
        guard let titleOutlineCellView = self.projectTextEditorsOutlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "title"), owner: self) as? TitleOutlineCellView else {
            assertionFailure("Error: titleOutlineCellView built view is nil")
            return nil
        }
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return nil
        }
        
        titleOutlineCellView.documentManager = self.documentManager
        titleOutlineCellView.textManagerId = textEditorsOutlineItem.id
        titleOutlineCellView.collapsed = filesOutlineManager.isTextManagerCollapsed(with: textEditorsOutlineItem.id)
        let editorId = filesOutlineManager.createOrGetEditorId(forTextId: textEditorsOutlineItem.id)
        
        // TextEditorToolbarPlugin
        if let textEditorControls = self.documentManager?.pluginsTextEditorControls(forTextId: textEditorsOutlineItem.id, andEditorId: editorId) {
            for textEditorControl in textEditorControls {
                titleOutlineCellView.editorControlsStackView.addArrangedSubview(textEditorControl)
            }
        }
        titleOutlineCellView.updateStackViewLeadingConstraint()
        titleOutlineCellView.identifier = nil
        return titleOutlineCellView
    }
    
    func textEditorCellView(for textEditorsOutlineItem: TextEditorsOutlineItem) -> EditorOutlineCellView? {
        
        if let editorOutlineCellView = editorsOutlineCellViews[textEditorsOutlineItem.id] {
            return editorOutlineCellView
        }
        
        guard let editorOutlineCellView = createProjectTextEditorCellView(for: textEditorsOutlineItem) else {
            assertionFailure("Error: createProjectTextEditorCellView(for id: String returned nil")
            return nil
        }
        
        self.editorsOutlineCellViews[textEditorsOutlineItem.id] = editorOutlineCellView
        return editorOutlineCellView
    }
    
    private func createProjectTextEditorCellView(for textEditorsOutlineItem: TextEditorsOutlineItem) -> EditorOutlineCellView? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil.")
            return nil
        }
        
        guard let projectTextEditorViewController: ProjectTextEditorViewController = {
           
            if let projectTextEditorViewController = self.projectTextEditorViewControllers[textEditorsOutlineItem.id] {
                
                return projectTextEditorViewController
            }
            else {
                
                guard let textManager = sourceSetManager.directoryItemManager(withId: textEditorsOutlineItem.id) as? TextManager else {
                    assertionFailure("Error: item with id: \(textEditorsOutlineItem.id) is nil or not a TextManager.")
                    return nil
                }
                
                let bundle = Bundle(for: ProjectTextEditorsOutlineViewController.self)
                let projectTextEditorStoryboard = NSStoryboard(name: NSStoryboard.Name("ProjectTextEditor"), bundle: bundle)
                
                guard let projectTextEditorViewController = projectTextEditorStoryboard.instantiateInitialController() as? ProjectTextEditorViewController else {
                    assertionFailure("Error: projectTextEditorStoryboard is nil")
                    return nil
                }
                
                projectTextEditorViewController.representedObject = textManager
                projectTextEditorViewController.editorsViewController = self
                let _ = projectTextEditorViewController.view
                self.projectTextEditorViewControllers[textEditorsOutlineItem.id] = projectTextEditorViewController
                return projectTextEditorViewController
            }
        }() else {
            assertionFailure("Error: unable to create projectTextEditorViewController")
            return nil
        }
        
        //projectTextEditorViewController.updateSidebarsWidthIfNeeded(sidebarsShown: self.sidebarsShown, isRightView: isRightSplitViewItem, isLeftView: isLeftSplitViewItem)
        
        let textEditorTableCellView = EditorOutlineCellView(frame: .zero)
        textEditorTableCellView.textEditorsOutlineItem = textEditorsOutlineItem
        textEditorTableCellView.translatesAutoresizingMaskIntoConstraints = false
    
        let projectTextEditorView = projectTextEditorViewController.view
        projectTextEditorView.translatesAutoresizingMaskIntoConstraints = false
        textEditorTableCellView.addSubview(projectTextEditorView)
        textEditorTableCellView.identifier = nil
        
        let bottomConstraint = NSLayoutConstraint(item: projectTextEditorView, attribute:NSLayoutConstraint.Attribute.bottom, relatedBy:NSLayoutConstraint.Relation.equal, toItem:textEditorTableCellView, attribute:NSLayoutConstraint.Attribute.bottom, multiplier:1, constant:0)
        
        let leadingConstraint = NSLayoutConstraint(item: projectTextEditorView, attribute:NSLayoutConstraint.Attribute.leading, relatedBy:NSLayoutConstraint.Relation.equal, toItem:textEditorTableCellView, attribute:NSLayoutConstraint.Attribute.leading, multiplier:1, constant:0)
        
        let trailingConstraint = NSLayoutConstraint(item: projectTextEditorView, attribute:NSLayoutConstraint.Attribute.trailing, relatedBy:NSLayoutConstraint.Relation.equal, toItem:textEditorTableCellView, attribute:NSLayoutConstraint.Attribute.trailing, multiplier:1, constant:0)
        
        let topConstraint = NSLayoutConstraint(item: projectTextEditorView, attribute:NSLayoutConstraint.Attribute.top, relatedBy:NSLayoutConstraint.Relation.equal, toItem:textEditorTableCellView, attribute:NSLayoutConstraint.Attribute.top, multiplier:1, constant:0)
        
        textEditorTableCellView.addConstraint(bottomConstraint)
        textEditorTableCellView.addConstraint(leadingConstraint)
        textEditorTableCellView.addConstraint(trailingConstraint)
        textEditorTableCellView.addConstraint(topConstraint)
        projectTextEditorView.identifier = nil
        projectTextEditorViewController.resourceEditorView.identifier = nil
        projectTextEditorViewController.resourceEditorView.needsLayout = true
        return textEditorTableCellView
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
                    if self?.projectTextEditorViewControllers[key] != nil {
                        self?.projectTextEditorViewControllers.removeValue(forKey: key)
                    }
                }
            case .move:
                assertionFailure("Error: unimplemented")
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
    
    private func subscribeToFilesOutlineManager() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        var animate = true
        
        filesOutlineManager.selectedTextItems.subscribe({ [weak self](change) in
            
            func shouldAnimateTextEditorsSelectionChange<C>(from sourceArray: C, to destinationArray: C) -> Bool where C: Collection, C.Element == String {
                
                if destinationArray.count == 1 || abs(sourceArray.count-destinationArray.count) > 1 {
                    return false
                }
                return true
            }
            
            switch change {
            case .deletes(let indexes, _, _):
                if animate {
                    self?.projectTextEditorsOutlineView.beginUpdates()
                    self?.projectTextEditorsOutlineView.removeItems(at: IndexSet(indexes), inParent: nil, withAnimation: NSTableView.AnimationOptions.effectFade)
                    self?.projectTextEditorsOutlineView.endUpdates()
                }
            case .insert(_, let index, _):
                if animate {
                    self?.projectTextEditorsOutlineView.beginUpdates()
                    self?.projectTextEditorsOutlineView.insertItems(at: [index], inParent: nil, withAnimation: NSTableView.AnimationOptions.effectGap)
                    self?.projectTextEditorsOutlineView.endUpdates()
                }
            case .inserts(_, let indexes, _):
                if animate {
                    self?.projectTextEditorsOutlineView.beginUpdates()
                    self?.projectTextEditorsOutlineView.insertItems(at: IndexSet(indexes), inParent: nil, withAnimation: NSTableView.AnimationOptions.effectGap)
                    self?.projectTextEditorsOutlineView.endUpdates()
                }
            case .move(_, let sourceIndex, let targetIndex, _):
                if animate {
                    self?.projectTextEditorsOutlineView.beginUpdates()
                    self?.projectTextEditorsOutlineView.moveItem(at: sourceIndex, inParent: nil, to: targetIndex, inParent: nil)
                    self?.projectTextEditorsOutlineView.endUpdates()
                }
            case .start(let sourceArray, let destinationArray):
                if !shouldAnimateTextEditorsSelectionChange(from: sourceArray, to: destinationArray) {
                    animate = false
                }
            case .end:
                if !animate {
                    self?.projectTextEditorsOutlineView.reloadData()
                    animate = true
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.restoreExpandedItems()
            }
        }, observer: self)
        
        filesOutlineManager.collapsedEditorItems.subscribe({ [weak self](change) in
            switch change {
            case .inserts(let values, _):
                for id in values {
                    self?.collapseEditor(withId: id)
                }
            case .deletes(let values, _):
                for id in values {
                    self?.expandEditor(withId: id)
                }
            }
        }, observer: self)
    }
    
    private func restoreExpandedItems() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager  is nil")
            return
        }

        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil.")
            return
        }
        
        for selectedItemId in filesOutlineManager.selectedTextItems {
        
            if !filesOutlineManager.collapsedEditorItems.contains(selectedItemId) {
                
                guard let directoryItemManager = sourceSetManager.directoryItemManager(withId: selectedItemId)  else {
                    assertionFailure("Error: item with id: \(selectedItemId) is nil.")
                    continue
                }
                
                guard directoryItemManager is TextManager else {
                    continue
                }
                
                expandEditor(withId: selectedItemId)
            }
        }
    }
    
    private func collapseEditor(withId id: String) {
        
        guard let titleEditorOutlineItem = self.titleEditorsOutlineItem(for: id) else {
            assertionFailure("Error: no EditorOutlineCellView for id:\(id)")
            return
        }
        
        let row = self.projectTextEditorsOutlineView.row(forItem: titleEditorOutlineItem)
        
        guard row >= 0 else {
            assertionFailure("Error: row for item is smaller than 0")
            return
        }
        
        guard let titleOutlineCellView = self.projectTextEditorsOutlineView.view(atColumn: 0, row: row, makeIfNecessary: true) as? TitleOutlineCellView else {
            assertionFailure("Error: titleOutlineCellView is nil")
            return
        }
        
        titleOutlineCellView.collapsed = true
        self.projectTextEditorsOutlineView.collapseItem(titleEditorOutlineItem)
    }
    
    private func expandEditor(withId id: String) {
        
        guard let titleEditorOutlineItem = self.titleEditorsOutlineItem(for: id) else {
            assertionFailure("Error: no EditorOutlineCellView for id:\(id)")
            return
        }
        
        let row = self.projectTextEditorsOutlineView.row(forItem: titleEditorOutlineItem)
        
        guard row >= 0 else {
//            assertionFailure("Error: row for item is smaller than 0")
            return
        }
        
        guard let titleOutlineCellView = self.projectTextEditorsOutlineView.view(atColumn: 0, row: row, makeIfNecessary: true) as? TitleOutlineCellView else {
            assertionFailure("Error: titleOutlineCellView is nil")
            return
        }
        
        titleOutlineCellView.collapsed = false
        self.projectTextEditorsOutlineView.expandItem(titleEditorOutlineItem)
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
        filesOutlineManager?.selectedTextItems.unsubscribe(observer: self)
        self.unsubscribeToSourceSetManager()
    }
}
