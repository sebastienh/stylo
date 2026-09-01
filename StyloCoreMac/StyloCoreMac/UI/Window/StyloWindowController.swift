//
//  StyloWindowController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-19.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Web
import PromiseKit
import WebKit
import Common
import os

public final class StyloWindowController: NSWindowController, TextKeydownListener, Observer {
    
    public var priority: ObserverPriority {
        return .ui
    }
    
    var activityCompletionBlock: (() -> Void)?
    
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
    
    lazy var progressViewController: ProgressIndicatorViewController = {
        return self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "ExportProgressIndicatorSheet"))
            as! ProgressIndicatorViewController
    }()

    var lastHtmlPreviewScrollPosition: ScrollPosition?
    
    var oldPseudoCssInspectorPanelWidth: CGFloat?
    
    var oldCssInspectorPanelWidth: CGFloat?
    
    var oldProjectInspectorPanelWidth: CGFloat?
    
    var cssConstraintCopy: NSLayoutConstraint?
    
    var themeChooserPopover = NSPopover()
    
    var tabSwitching = false
    
    var allowHidingTitle = false
    
    var mouseInWindowTitle: Bool = false
    
    var isStatisticsSessionControlsHidden: Bool = false
    
    var styleApplied = false
    
    var disabledApplyButton: Bool = false
    
    var htmlPreviewBackgroundColor: NSColor?
    
    public var elementSelection: ElementSelection? {
        didSet {
            
            let copySelectorMenuItem = NSApplication.shared.copySelectorMenuItem
            copySelectorMenuItem?.isEnabled = elementSelection != nil
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("copySelectorMenuItem is enabled: %@", log: Log.StyloCore.all, type: .info, %%String(describing: copySelectorMenuItem?.isEnabled))
            #endif
        }
    }
    
    var visibleEditors: [EditableView]? {
        
        return self.projectTextEditorsPanelsViewController?.visibleEditors
    }
    
    let titlebarAccesoryViewController = NSTitlebarAccessoryViewController()
    
    private var filesOutlineSetManager: FilesOutlineSetManager? {
    
        return self.documentManager?.filesOutlineSetManager.value
    }
    
    @objc dynamic public var styloDocument: MacStyloDocument? {
        
        return self.document as? MacStyloDocument
    }
    
    var windowFrame: NSRect?
    
    override public var document: AnyObject? {
        didSet {
            if document != nil {
                
                assert(documentManager != nil)
                assert(globalMenuPanelViewController != nil)
                globalMenuPanelViewController?.documentManager = documentManager
                
                if let styloDocument = document as? TextDocument {

                    styloDocument.htmlPreviewBackgroundColor.subscribe({ [weak self] (colorValue: NSColor?) in
                        
                        assert(colorValue != nil)
                        if let colorValue = colorValue {
                            self?.htmlPreviewBackgroundColor = colorValue
                        }
                    }, observer: self)
                }
                subscribeToDocumenManager()
                subscribeToFilesOutlinesSetManager()
            }
        }
    }
    
    public var styloWindow: StyloWindow {
        
        return self.window as! StyloWindow
    }
    
    var toolsCollapsed: Bool {
        
        if let styloStyleInspectorSplitViewController = styloStyleInspectorSplitViewController {
            
            return styloStyleInspectorSplitViewController.toolsCollapsed
        }
        return true
    }
    
    var allToolsCollapsed: Bool {
        
        if let styloStyleInspectorSplitViewController = styloStyleInspectorSplitViewController {
            
            return styloStyleInspectorSplitViewController.allToolsCollapsed
        }
        return true
    }
    
    var projectSidebarCollapsed: Bool {
        
        if let styloStyleInspectorSplitViewController = styloStyleInspectorSplitViewController {
            
            return styloStyleInspectorSplitViewController.navigatorCollapsed
        }
        return true
    }
    
    var themesCollapsed: Bool {
        
        return true
    }
    
    var documentManager: DocumentManager? {
        
        return self.styloDocument?.documentManager
    }

    var projectTextEditorsTableViewControllers: [ProjectTextEditorsTableViewController]? {
        
        return styloStyleInspectorSplitViewController?.projectTextEditorsPanelsViewController?.projectTextEditorsTableViewControllers
    }
    
    
    var projectTextEditorsTabViewControllers: [ProjectTextEditorsTabViewController]? {
        
        return styloStyleInspectorSplitViewController?.projectTextEditorsPanelsViewController?.projectTextEditorsTabViewControllers
    }
    
    var projectTextEditorsLists: [ProjectTextEditorsList]? {
    
        return styloStyleInspectorSplitViewController?.projectTextEditorsPanelsViewController?.projectTextEditorsLists
    }
        
    var projectTextEditorsPanelsViewController: ProjectTextEditorsPanelsViewController? {
        
        return styloStyleInspectorSplitViewController?.projectTextEditorsPanelsViewController
    }
    
    var toolsTabViewController: ToolsTabViewController? {
        
        return styloStyleInspectorSplitViewController?.toolsTabViewController
    }
    
    public var globalMenuPanelViewController: GlobalMenuPanelViewController? {
        
        return self.contentViewController as? GlobalMenuPanelViewController
    }
    
    init() {
        
        self.init(windowNibName: NSNib.Name(string: "Document"))
        shouldCascadeWindows = false
    }
    
    override init(window: NSWindow?) {
        
        super.init(window: window)
        shouldCascadeWindows = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shouldCascadeWindows = false
    }
    
    override public func windowTitle(forDocumentDisplayName displayName: String) -> String {
        
        return (displayName as NSString).deletingPathExtension as String
    }
    
    func handleKeydownEvent(with event: NSEvent) {
        
        // nothing to do 
    }
    
    override public func windowDidLoad() {
        
        super.windowDidLoad()
        startListeningToKeydownEvents()
    }
    
    public var fullscreenMode: Bool = false

    public func windowDidFailToExitFullScreen(_ window: NSWindow) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowDidFailToExitFullScreen", log: Log.StyloCore.all, type: .error)
        #endif
    }
    
    public func windowDidChangeBackingProperties(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowDidChangeBackingProperties", log: Log.StyloCore.all, type: .info)
        #endif
    }
    
    public func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowWillResize", log: Log.StyloCore.all, type: .info)
        #endif
        return frameSize
    }
    
    public func windowWillUseStandardFrame(_ window: NSWindow, defaultFrame newFrame: NSRect) -> NSRect {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowWillUseStandardFrame", log: Log.StyloCore.all, type: .info)
        #endif
        return newFrame
    }
    
    func hideTools(toggle: Bool = true) {
        
        // colapse the tools
        if toggle {
            toggleTool(collapsed: false)
        }
        
        styloWindow.toolsDisplayed = false
    }
    
    private var projectSidebarMenuTabViewControllerSelectedIndex: Int?
    
    private var sidebarMenuTabViewControllerSelectedIndex: Int?
    
    @IBAction func windowShowTextEditor(_ sender: AnyObject? = nil) {
        
        
    }
    
    // see http://stackoverflow.com/questions/32264008/themeChooserPopover-segue-cocoa-storyboard-changing-position-in-xcode-7-beta-6-on-el-capitan
    @IBAction func showThemeChooserPopover(_ sender: AnyObject?) {
//  
//        let bundle = Bundle(for: StyloWindowController.self)
//        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(string: "Document"), bundle: bundle)
//        guard let ccssStylePopoverViewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "CCSSStylePopover")) as? ThemePopoverViewController else { return }
//
//        ccssStylePopoverViewController.privateStyloDocument = styloDocument
//
//        themeChooserPopover.contentViewController = ccssStylePopoverViewController
//        themeChooserPopover.behavior = .transient
//
//        let ccssStyleSegueButton = sender as! NSButton
//
//        themeChooserPopover.show(relativeTo: ccssStyleSegueButton.bounds, of: sender as! NSView, preferredEdge: .maxY)
    }
    
    func disableEditors() {
        
        if let visibleEditors = visibleEditors {
            for visibleEditor in visibleEditors {
                visibleEditor.isEditable = false
            }
        }
    }
   
    func enableEditors() {
    
        if let visibleEditors = visibleEditors {
            for visibleEditor in visibleEditors {
                visibleEditor.isEditable = true
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StaticHtmlPreviewer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var previewShown: Bool {
        
        return false
    }
    
    var cancelWorkingOverlay = false
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StylePicker protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
//    public var stylePickerShown: Bool {
//
//        guard let globalMenuPanelViewController = self.globalMenuPanelViewController else {
//            assertionFailure("Error: globalMenuPanelViewController is nil")
//            return false
//        }
//
//        return stylePickerSelected && globalMenuPanelViewController.sidebarsShown
//    }
//
//    public var markdownToolsShown: Bool {
//
//        guard let globalMenuPanelViewController = self.globalMenuPanelViewController else {
//            assertionFailure("Error: globalMenuPanelViewController is nil")
//            return false
//        }
//
//        return markdownToolsSelected && globalMenuPanelViewController.sidebarsShown
//    }
    
    var themesShown: Bool {
        
        return !themesCollapsed
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Project sidebar
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var navigatorShown: Bool {
        
        return self.styloStyleInspectorSplitViewController?.navigatorCollapsed != true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StylesList
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    
//    private func updateMarkdownTextViewPosition(from webViewScrollPosition: ScrollPosition?) -> Promise<Void> {
//
//        return Promise<Void> { fulfill, reject in
//            if let webViewScrollPosition = webViewScrollPosition, let markdownResourceEditorView = self.markdownResourceEditorView  {
//                firstly {
//
//                    return markdownResourceEditorView.scrollToCorrespondingScrollPosition(otherScrollPosition: webViewScrollPosition)
//                }.then {
//                    fulfill(())
//                }.catch { error in
//                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                    os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%error)
//                    #endif
//                }
//            }
//            else {
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Error: currentScrollPosition received from staticWebView is nil", log: Log.StyloCore.all, type: .error)
//                #endif
//                fulfill(())
//            }
//        }
//    }
    
    private var oldToolsWitdh: CGFloat {
        
        return oldCssInspectorPanelWidth ?? InterfaceConstants.ToolsSidebar.ToolsTabInitialWidth
    }
    
    func toggleTool(collapsed: Bool) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("toggleCSSPanel", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard let styloStyleInspectorSplitViewController = self.styloStyleInspectorSplitViewController else {
            assertionFailure("Error: styloStyleInspectorSplitViewController is nil")
            return
        }
  
        let inspectorSplitViewControllerSplitViewItem = styloStyleInspectorSplitViewController.splitViewItems[§StyloStyleInspectorSplitViewController.SplitItem.tools]

        guard let toolsTabViewController = inspectorSplitViewControllerSplitViewItem.viewController as? ToolsTabViewController else {
            assertionFailure("Error: viewController is not ToolsTabViewController")
            return
        }
        
        if toolsTabViewController.representedObject == nil {
            
            assert(self.documentManager != nil)
            toolsTabViewController.representedObject = self.documentManager
        }
        
        if inspectorSplitViewControllerSplitViewItem.isCollapsed {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("inspectorSplitViewControllerSplitViewItem.isCollapsed", log: Log.StyloCore.all, type: .info)
            #endif

            StyloNotification.willShowTools.sendNotification(self.window!)

            styloStyleInspectorSplitViewController.view.needsLayout = true
            inspectorSplitViewControllerSplitViewItem.isCollapsed = false
            
            StyloNotification.didShowTools.sendNotification(self.window!)
        }
        else {

            StyloNotification.willHideTools.sendNotification(self.window!)
            
            oldCssInspectorPanelWidth = toolsTabViewController.view.frame.size.width
            inspectorSplitViewControllerSplitViewItem.isCollapsed = true
            
            StyloNotification.didHideTools.sendNotification(self.window!)
        }
    }
    
    private func subscribeToDocumenManager() {
    
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        documentManager.userInteractionsEnabled.subscribe({ [weak self](userInteractionsEnabled) in
            if userInteractionsEnabled {
                self?.windowController?.removeDocumentWorkingOverlay()
            }
            else {
                self?.displayWorkingOverlayWindow(delay: 0, disableCondition: { () -> Bool in
                    return true
                })
            }
            
        }, observer: self)
    }
    
    private func unsubscribeFromDocumenManager() {
    
        documentManager?.userInteractionsEnabled.unsubscribe(observer: self)
    }
    
    private func subscribeToFilesOutlinesSetManager() {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        self.updateMinimumFullScreenContentSize(forEditorsPanelCount: filesOutlineSetManager.filesOutlines.count)
        filesOutlineSetManager.filesOutlines.subscribe({ [weak self](arrayChange) in
            switch arrayChange {
            case .deletes(_, _, let updatedArray):
                self?.updateMinimumFullScreenContentSize(forEditorsPanelCount: updatedArray.count)
            case .inserts(_, _, let updatedArray):
                self?.updateMinimumFullScreenContentSize(forEditorsPanelCount: updatedArray.count)
            case .insert(_, _, let updatedArray):
                self?.updateMinimumFullScreenContentSize(forEditorsPanelCount: updatedArray.count)
            default:
                break
            }
        }, observer: self)
    }
    
    private func updateMinimumFullScreenContentSize(forEditorsPanelCount editorsPanelCount: Int) {
        
//        let minimumWidth = editorsPanelCount*Int(InterfaceConstants.EditorsPanel.MinimumWidth) + Int(2*InterfaceConstants.Sidebar.Width) + (Int(InterfaceConstants.EditorsPanel.DividerWidth)*(editorsPanelCount-1))
//
//        self.window?.minFullScreenContentSize = NSMakeSize(CGFloat(minimumWidth), NSView.noIntrinsicMetric)
    }
    
    private func unsubscribeToFilesOutlinesSetManager() {
     
        self.filesOutlineSetManager?.filesOutlines.unsubscribe(observer: self)
    }
    
    deinit {
        
        unsubscribeFromDocumenManager()
        unsubscribeToFilesOutlinesSetManager()
        stopListeningToKeydownEvents()
    }
}

