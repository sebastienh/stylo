//
//  ProjectTextEditorsPanelsViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-18.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

public class ProjectTextEditorsPanelsViewController: NSSplitViewController, WorkingOverlayViewController, TextKeydownListener, WindowTopMouseListener {
    
    enum TitleState {
        case hidden
        case shown
    }
    
    var projectTextEditorsTableViewControllers: [ProjectTextEditorsTableViewController] {
        return projectTextEditorsTabViewControllers.compactMap { (projectTextEditorsTabViewController) -> ProjectTextEditorsTableViewController? in
            return projectTextEditorsTabViewController.tabViewItems.first?.viewController as? ProjectTextEditorsTableViewController
        }
    }
    
    
    var projectTextEditorsTabViewControllers: [ProjectTextEditorsTabViewController] {
        return projectTextEditorsLists.compactMap { (projectTextEditorsList) -> ProjectTextEditorsTabViewController? in
            return projectTextEditorsList.projectTextEditorsTabViewController
        }
    }

    var projectTextEditorsLists: [ProjectTextEditorsList] {
        return self.splitViewItems.compactMap { (splitViewItem) -> ProjectTextEditorsList? in
            return splitViewItem.viewController as? ProjectTextEditorsList
        }
    }
        
    var visibleEditors: [EditableView] {
        
        var editors = [EditableView]()
        for projectTextEditorsTableViewController in projectTextEditorsTableViewControllers {
            let visibleEditors = projectTextEditorsTableViewController.visibleEditors
            editors.append(contentsOf: visibleEditors)

        }
        return editors
    }
    
    lazy var leftSidebarButton: MacDisableableButton? = {
        
        guard let leftSidebarButtonImage = self.bundle.image(forResource: NSImage.Name("leftSidebarButtonImage")) else {
            assertionFailure("Error: unable to get image named: leftSidebarButtonImage")
            return nil
        }
        
        let leftSidebarButton = MacDisableableButton(image: leftSidebarButtonImage, target: self, action: #selector(ProjectTextEditorsPanelsViewController.toggleNavigator))
        
        
        leftSidebarButton.translatesAutoresizingMaskIntoConstraints = false
        leftSidebarButton.bezelStyle = .regularSquare
        leftSidebarButton.setButtonType(.toggle)
        leftSidebarButton.isBordered = false
        leftSidebarButton.toolTip = "Show/Hide left sidebar"
        leftSidebarButton.target = self
        leftSidebarButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        leftSidebarButton.heightAnchor.constraint(equalToConstant: 17.0).isActive = true
        leftSidebarButton.isEnabled = true
        leftSidebarButton.state = .on
        return leftSidebarButton
    }()
    
    lazy var rightSidebarButton: MacDisableableButton? = {
        
        guard let rightSidebarButtonImage = self.bundle.image(forResource: NSImage.Name("rightSidebarButtonImage")) else {
            assertionFailure("Error: unable to get image named: rightSidebarButtonImage")
            return nil
        }
        
        let rightSidebarButton = MacDisableableButton(image: rightSidebarButtonImage, target: self, action: #selector(ProjectTextEditorsPanelsViewController.toggleTools))
        
        
        rightSidebarButton.translatesAutoresizingMaskIntoConstraints = false
        rightSidebarButton.bezelStyle = .regularSquare
        rightSidebarButton.setButtonType(.toggle)
        rightSidebarButton.isBordered = false
        rightSidebarButton.toolTip = "Show/Hide right sidebar"
        rightSidebarButton.target = self
        rightSidebarButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rightSidebarButton.heightAnchor.constraint(equalToConstant: 17.0).isActive = true
        rightSidebarButton.isEnabled = true
        rightSidebarButton.state = .on
        return rightSidebarButton
    }()
    
    private var documentManager: DocumentManager? {
        
        return self.representedObject as? DocumentManager
    }
    
    private var filesOutlineSetManager: FilesOutlineSetManager? {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return nil
        }
        
        return documentManager.filesOutlineSetManager.value
    }
        
    private var filesOutlineSplitView: FilesOutlineSplitView? {
        
        return self.splitView as? FilesOutlineSplitView
    }
    
    private var initialized: Bool = false
    
    var sidebarsShown: Bool = false
    
    var toolsShown: Bool = false
    
    var projectToolsShown: Bool = false
    
    var sidebarsAreMoving: Bool = false
    
    var leftButtonsShown: Bool = true
    
    /// by default the title is shown
    private var titleState: TitleState = .shown
    
    lazy var markdownQuickFormattingToolsViewController: MarkdownQuickFormattingToolsViewController? = {
        
        let bundle = Bundle(for: StyloWindowController.self)
        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(string: "MarkdownFormatingTools"), bundle: bundle)
        
        guard let markdownQuickFormattingToolsViewController = mainStoryboard.instantiateInitialController() as? MarkdownQuickFormattingToolsViewController else {
            
            assert(false, "MarkdownQuickFormattingToolsViewController instantiateInitialController() returns nil.")
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("textStatisticsViewController is nil", log: Log.StyloCore.all, type: .error)
            #endif
            return nil
        }
        
        assert(self.documentManager != nil)
        markdownQuickFormattingToolsViewController.representedObject = self.documentManager
        return markdownQuickFormattingToolsViewController
    }()
    
    private var enableScrollingTimer: Timer?
    
    override public func viewWillAppear() {
        
        if !self.initialized {
            self.initializeChildControllers()
            self.subscribeToFilesOutlineSetManager()
            self.updateTextEditorsPanelsTopButtons()
            self.listenToLeftButtonsNotifications()
            self.listenToProjectToolsNotifications()
            self.listenToEditorsNotifications()
            self.initializeMarkdownQuickFormattingTool()
            self.initializeLeftSidebarButton()
            self.initializeRightSidebarButton()
            self.initializeSideTrackingAreas()
            self.initialized = true
        }
        super.viewWillAppear()
    }
    
    public override func viewDidAppear() {
        super.viewDidAppear()
        self.startListeningToKeydownEvents()
        self.subscribeToWindowTopMouseEventsNotifications()
    }
    
    public override func viewDidDisappear() {
        super.viewDidDisappear()
        self.stopListeningToKeydownEvents()
        self.unsubscribeFromWindowTopMouseEventsNotifications()
    }
    
    /// We dont want to collapse the titles while the user
    /// is interacting with the text.
    private var collapseTitlesTimer: Timer?
    
    func handleKeydownEvent(with event: NSEvent) {
        
        self.collapseTitlesTimer?.invalidate()
        self.collapseTitlesTimer = Timer.scheduledTimer(withTimeInterval: StyloConstants.EditorsPane.CollapseDelay, repeats: false, block: { [weak self](_) in
            self?.collapseTitles()
        })
    }
    
    func handleWindowTopMouseEvent() {
        
        self.uncollapseTitles()
    }
    
    func requestTitlesCollapseAndHidingFloatingSideButtons() {
    
        // we can only collapse if the titles are shown
        guard self.titleState == .shown else {
            return
        }
        
        self.collapseTitlesTimer?.invalidate()
        self.collapseTitlesTimer = Timer.scheduledTimer(withTimeInterval: StyloConstants.EditorsPane.CollapseDelay, repeats: false, block: { [weak self](_) in
            self?.collapseTitles()
            self?.hideFloatingSideButtons()
        })
    }
    
    private func collapseTitles() {
        
        // we can only collapse if the titles are shown
        guard self.titleState == .shown else {
            return
        }
        
        self.titleState = .hidden
        
        NSAnimationContext.runAnimationGroup({ context in
            
            // Customize the animation parameters.
            context.duration = StyloConstants.EditorsPane.CollapseAnimationTime
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            context.allowsImplicitAnimation = true
            
            for projectTextEditorsList in self.projectTextEditorsLists {
                projectTextEditorsList.collapseTitle()
            }
        })
    }
    
    func uncollapseTitles() {
        
        self.collapseTitlesTimer?.invalidate()
        self.collapseTitlesTimer = nil
        
        guard self.titleState == .hidden else {
            return
        }
        
        self.titleState = .shown
        
        NSAnimationContext.runAnimationGroup({ context in
            
            // Customize the animation parameters.
            context.duration = StyloConstants.EditorsPane.UncollapseAnimationTime
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            context.allowsImplicitAnimation = true
            
            for projectTextEditorsList in self.projectTextEditorsLists {
                projectTextEditorsList.uncollapseTitle()
            }
        })
    }
    
    @objc private func toggleTools(_ sender: AnyClass) {
        
        guard let windowController = self.view.window?.windowController as? StyloWindowController else {
            assertionFailure("Error: windowController is nil")
            return
        }
        
        self.disableEditorsPanelsScrolling()
        windowController.toggleTool(collapsed: false)
        self.startEnableScrollingTimer()
    }
    
    @objc private func toggleNavigator(_ sender: AnyClass) {
        
        guard let windowController = self.view.window?.windowController as? StyloWindowController else {
            assertionFailure("Error: windowController is nil")
            return
        }
        
        self.disableEditorsPanelsScrolling()
        windowController.showHideNavigator()
        self.startEnableScrollingTimer()
    }
    
    public override func splitViewDidResizeSubviews(_ notification: Notification) {
        super.splitViewDidResizeSubviews(notification)
        self.updateTableColumnsWidth()
        self.startEnableScrollingTimer()
    }
    
    private func updateTableColumnsWidth() {
        
        for splitViewItem in self.splitViewItems {
            
            guard let projectTextEditorsList = splitViewItem.viewController as? ProjectTextEditorsList else {
                assertionFailure("Error: splitViewItem.viewController is not ProjectTextEditorsList")
                continue
            }
            
            guard let projectTextEditorsTabViewController = projectTextEditorsList.projectTextEditorsTabViewController else {
                assertionFailure("Error: projectTextEditorsTabViewController is nil")
                continue
            }
            
            projectTextEditorsTabViewController.updateTableColumnWidth()
        }
    }
    
    private func disableEditorsPanelsScrolling() {
        
        for projectTextEditorList in projectTextEditorsLists {
            projectTextEditorList.disableScrolling()
        }
    }
    
    private func enableEditorsPanelsScrolling() {
        
        for projectTextEditorList in projectTextEditorsLists {
            
            projectTextEditorList.enableScrolling()
        }
    }
    
    private func initializeSideTrackingAreas() {
        
        guard let filesOutlineSplitView = self.filesOutlineSplitView else {
            assertionFailure("Error: self.filesOutlineSplitView is nil")
            return
        }
        
        filesOutlineSplitView.createSideTrackingAreas()
    }
    
    private func initializeMarkdownQuickFormattingTool() {
        
        guard let markdownQuickFormattingToolsViewController = self.markdownQuickFormattingToolsViewController else {
            assertionFailure("Error: self.markdownQuickFormattingToolsViewController is nil")
            return
        }
        
        let markdownQuickFormattingToolsView = markdownQuickFormattingToolsViewController.view
        markdownQuickFormattingToolsView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(markdownQuickFormattingToolsView, positioned: .above, relativeTo: nil)
        
        markdownQuickFormattingToolsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        markdownQuickFormattingToolsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        markdownQuickFormattingToolsView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        markdownQuickFormattingToolsView.heightAnchor.constraint(equalToConstant: 240).isActive = true
    }

    func hideFloatingSideButtons() {
        
        NSAnimationContext.runAnimationGroup({ context in
            
            // Customize the animation parameters.
            context.duration = StyloConstants.EditorsPane.UncollapseAnimationTime
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            context.allowsImplicitAnimation = true
            
            self.rightSidebarButton?.alphaValue = 0
            self.leftSidebarButton?.alphaValue = 0
            self.markdownQuickFormattingToolsViewController?.view.alphaValue = 0
        })
    }
    
    
    private func initializeRightSidebarButton() {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let pluginManager = documentManager.pluginManager else {
            assertionFailure("Error: pluginManager is nil")
            return
        }
        
        if pluginManager.containsToolsPanelPlugins {
        
            guard let rightSidebarButton = self.rightSidebarButton else {
                assertionFailure("Error: self.rightSidebarButton is nil")
                return
            }
            
            self.view.addSubview(rightSidebarButton, positioned: .above, relativeTo: nil)
            rightSidebarButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            rightSidebarButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        }
    }
    
    private func initializeLeftSidebarButton() {
        
        guard let leftSidebarButton = self.leftSidebarButton else {
            assertionFailure("Error: self.leftSidebarButton is nil")
            return
        }
        
        self.view.addSubview(leftSidebarButton, positioned: .above, relativeTo: nil)
        leftSidebarButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        leftSidebarButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
    }
    
    private func subscribeToFilesOutlineSetManager() {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        filesOutlineSetManager.filesOutlines.subscribe({ [weak self] change in
            
            assert(self != nil)
            self?.handleFilesOutlinesChange(change)
            
            // we do not allow an empty files outlines set manager
            assert(!filesOutlineSetManager.filesOutlines.isEmpty)
        }, observer: self)
    }
    
    private func handleFilesOutlinesChange(_ change: DynamicArray<FilesOutlineManager>.Change) {
        
        switch change {
        case .deletes(let indexes, _, _):
            // start with the last index
            for index in indexes.sorted().reversed() {
                removeTextEditorsPanel(atIndex: index)
            }
        case .insert(let newElement, let index, _):
            self.addTextEditorsPanel(with: newElement.id, atIndex: index)
        case .inserts:
            assertionFailure("Error: unsupported case")
            break
        case .move: fallthrough
        case .start: fallthrough
        case .end:
            break
        }
        
        updateTextEditorsPanelsTopButtons()
    }
    
    private func updateTextEditorsPanelsTopButtons() {
        
        // if there is only one we remove the close button on this one
        if self.splitViewItems.count == 1 {
            
            guard let splitViewItem  = self.splitViewItems.first else {
                assertionFailure("Error: self.splitViewItems.first is nil")
                return
            }
            
            guard let projectTextEditorsList = splitViewItem.viewController as? ProjectTextEditorsList else {
                assertionFailure("Error: splitViewItem.viewController is not ProjectTextEditorsList")
                return
            }
            
            projectTextEditorsList.hideTopCloseButtonIfNecessary()
        }
        else {
            for splitViewItem in self.splitViewItems {
                
                guard let projectTextEditorsList = splitViewItem.viewController as? ProjectTextEditorsList else {
                    assertionFailure("Error: splitViewItem.viewController is not ProjectTextEditorsList")
                    return
                }
                projectTextEditorsList.showTopCloseButtonIfNecessary()
            }
        }
    }
    
    private func unsubscribeToFilesOutlineSetManager() {
     
        self.filesOutlineSetManager?.filesOutlines.unsubscribe(observer: self)
    }
    
    private func appendTextEditorsPanel(with filesOutlineManagerId: String) {
         
        addTextEditorsPanel(with: filesOutlineManagerId, atIndex: self.splitViewItems.count)
    }
    
    private func removeTextEditorsPanel(atIndex index: Int) {
        
        let fullscreen: Bool = (self.view.window as? StyloWindow)?.fullScreen ?? false
        
        if index == 0 {
            // update the old first
            self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: false, leftButtonsShown: self.leftButtonsShown, sidebarsShow: self.sidebarsShown, projectToolsShown: self.projectToolsShown, animate: true, fullscreen: fullscreen)
        }
        
        guard index >= 0 && index < self.splitViewItems.count else {
            assertionFailure("Error: index is out of range")
            return
        }
        
        let splitViewItem = self.splitViewItems[index]
        self.removeSplitViewItem(splitViewItem)
        
        if index == 0 {
            // update the new first
            
            self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: self.leftButtonsShown, sidebarsShow: self.sidebarsShown, projectToolsShown: self.projectToolsShown, animate: true, fullscreen: fullscreen)
        }
        
        self.resetToEqualWidths()
    }
    
    private func addTextEditorsPanel(with filesOutlineManagerId: String, atIndex index: Int) {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        guard let filesOutlineManager = filesOutlineSetManager.filesOutlineManager(withId: filesOutlineManagerId) else {
            assertionFailure("Error: filesOutlineSetManager.filesOutlineManager(with: filesOutlineManagerId) returned nil")
            return
        }
        
        guard let storyboard = self.storyboard else {
            assertionFailure("Error: self.storyboard is nil")
            return
        }
        
        guard let controller = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "ProjectTextEditorsList")) as? ProjectTextEditorsList else {
            assertionFailure("Error: no controller with id: ProjectTextEditorsList")
            return
        }
        
        controller.representedObject = filesOutlineManager
        let splitViewItem = NSSplitViewItem(viewController: controller)

        
        
        self.insertSplitViewItem(splitViewItem, at: index)
        splitViewItem.minimumThickness = 340
        splitViewItem.holdingPriority = NSLayoutConstraint.Priority(rawValue: 256)
        
        let fullscreen: Bool = (self.view.window as? StyloWindow)?.fullScreen ?? false
        
        // we just added the first
        if self.splitViewItems.count == 1 {
            self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: self.leftButtonsShown, sidebarsShow: self.sidebarsShown, projectToolsShown: self.projectToolsShown, animate: false, fullscreen: fullscreen)
        }
  
        self.resetToEqualWidths()
        self.splitView.needsLayout = true
    }
    
    private func equalWidth(withNumberOfItems numberOfItems: Int) -> CGFloat {
        
        let dividersWidth = CGFloat(numberOfItems-1)*splitView.dividerThickness
        return (splitView.frame.width-dividersWidth)/CGFloat(numberOfItems)
    }
    
    func startEnableScrollingTimer() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("delayedTokenAttributesUpdate()", log: Log.WriterCommon.all, type: .info)
        #endif
        
        self.enableScrollingTimer?.invalidate()
        
        self.enableScrollingTimer = Timer.scheduledTimer(withTimeInterval: Constants.FilesOutline.ScrollingEnablingDelay, repeats: false, block: { [weak self](_) in
            self?.enableEditorsPanelsScrolling()
            self?.enableScrollingTimer = nil 
        })
    }
    
    /// stylo #995
    private func resetToEqualWidths() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("resetToEqualWidths()", log: Log.StyloCore.all, type: .info)
        #endif

        let splitView = self.splitView
        let splitViewItemsCount = self.splitViewItems.count

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("resetToEqualWidths -> splitViewItemsCount: %@", log: Log.StyloCore.all, type: .info, %%splitViewItemsCount)
        #endif

        let dividersWidth = CGFloat(splitViewItemsCount-1)*splitView.dividerThickness
        let splitViewItemDesiredWidth = (splitView.frame.width-dividersWidth)/CGFloat(splitViewItemsCount)

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("resetToEqualWidths -> splitViewItemDesiredWidth: %@", log: Log.StyloCore.all, type: .info, %%splitViewItemDesiredWidth)
        #endif

        var position: CGFloat = 0

        for i in 0..<splitViewItemsCount-1 {

            position += splitViewItemDesiredWidth
            
            // #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            // strange fix...
            // keep this log as it introduce the necessary delay
            // for all split view item to be effectively set to the same width
            os_log("resetToEqualWidths -> setPosition: %@ ofDividerAt: %@", log: Log.StyloCore.all, type: .info, %%position, %%i)
            // #endif
            
            splitView.setPosition(position, ofDividerAt: i)
            position += splitView.dividerThickness
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("resetToEqualWidths -> arrangedSubviews.count: %@", log: Log.StyloCore.all, type: .info, %%self.splitView.arrangedSubviews.count)
        #endif
    }
    
    private func initializeChildControllers() {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }

        guard let filesOutlineSetManager = documentManager.filesOutlineSetManager.value else {
            assertionFailure("Error: documentManager.filesOutlineSetManager.value is nil")
            return
        }

        for projectOutline in filesOutlineSetManager.filesOutlines.values {
            appendTextEditorsPanel(with: projectOutline.id)
        }
        
        for splitViewItem in self.splitViewItems {
         
            guard let projectTextEditorsList = splitViewItem.viewController as? ProjectTextEditorsList else {
                assertionFailure("Error: splitViewItem.viewController is not ProjectTextEditorsList")
                continue
            }
            projectTextEditorsList.updateSelectedState()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    //              MARK: WorkingOverlayViewController protocol implementation
    //////////////////////////////////////////////////////////////////////////////////
    
    lazy var documentWorkingViewController: NSViewController = {
        
        let bundle = Bundle(for: DocumentWorkingViewController.self)
        let storyboardStringName = "WorkingOverlay"
        let storyboardName = NSStoryboard.Name(string: storyboardStringName)
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "DocumentWorkingViewController")) as! NSViewController
    }()
    
    var documentWorkingOverlayTopConstraint: NSLayoutConstraint?
    
    var documentWorkingOverlayBottomConstraint: NSLayoutConstraint?
    
    var documentWorkingOverlayLeadingConstraint: NSLayoutConstraint?
    
    var documentWorkingOverlayTrailingConstraint: NSLayoutConstraint?
    
    var timer: CancellableTimer = CancellableTimer(delay: InterfaceConstants.Global.millisecondsWaitBeforeDisplayingWorkingWindow)
}
