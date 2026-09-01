//
//  MacStyloDocument.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-10-16.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Cocoa
import Common
import PromiseKit
import WebKit
import os

open class MacStyloDocument: TextDocument {
    
    public var styloNavigatorTools: [(String, NavigatorTool)] = []
    
    public var allNavigatorTools: [(String, NavigatorTool)]? {
        
        var navigatorTools = [(String, NavigatorTool)]()
        
        assert(!styloNavigatorTools.isEmpty)
        navigatorTools.append(contentsOf: styloNavigatorTools)
        
        // we should also add a tab view item for each plugin which
        // define a navigator tool
        guard let pluginManager = self.pluginManager else {
            assertionFailure("Error: self.pluginManager is nil")
            return navigatorTools
        }
        
        navigatorTools.append(contentsOf: pluginManager.pluginsNavigatorTools)
        
        return navigatorTools
    }
    
    public var allToolsPanels: [(String, ToolPanel)]? {
        
        // we should also add a tab view item for each plugin which
        // define a project tool
        guard let pluginManager = self.pluginManager else {
            assertionFailure("Error: self.pluginManager is nil")
            return nil
        }
        
        return pluginManager.pluginsToolsPanels
    }
    
    public var pluginsMiddleToolsButtons: [DisableableButton]? {
     
        return pluginManager?.pluginsMiddleToolsButtons
    }
    
    public var windowController: StyloWindowController? {
        
        return self.windowControllers.first as? StyloWindowController
    }
    
    public override var documentManager: DocumentManager? {
        didSet {
            self.documentManager?.uiTransientState = MacUITransientState()
        }
    }
    
    private var loadingWindowController: NSWindowController?

    var globalMenuPanelViewController: GlobalMenuPanelViewController? {
        
        return windowController?.contentViewController as? GlobalMenuPanelViewController
    }

    public static var browsingVersions: Bool = false
    
    var frameId: String? {
        
        if var frameId = self.fileURL?.absoluteString {
        
            if frameId.endsWith("/") {
                frameId.removeLast()
            }
            return frameId
        }
        return nil
    }
    
    var urlChangedWhileInFullScreenMode: Bool = false
    
    open var _topToolsButtons: [DisableableButton]? {
        
        return [bigStylesButton]
    }
 
    open var _middleToolsButtons: [DisableableButton]? {
        
        var buttons = [DisableableButton]()
        
        guard let showPreviewButton = self.showPreviewButton else {
            assertionFailure("Error: self.showPreviewButton is nil")
            return nil
        }
        
        buttons.append(showPreviewButton)
        
        if let pluginsMiddleToolsButtons = self.pluginsMiddleToolsButtons {
            buttons.append(contentsOf: pluginsMiddleToolsButtons)
        }
        
        return buttons
    }
    
    public var styleMenuIdentifiersList: StyleMenuIdentifiersList?
    
    private var pluginManager: PluginManager? {
        
        return self.documentManager?.pluginManager
    }
    
    override open var fileURL: URL? {
        didSet {
            if let oldValue = oldValue, let fileURL = self.fileURL, fileURL != oldValue {
                self.handleUrlChange()
            }
        }
    }
    
    override open class func canConcurrentlyReadDocuments(ofType typeName: String) -> Bool {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("MacStyloDocument canConcurrentlyReadDocuments: %@, browsingVersions: %@", log: Log.StyloCore.all, type: .info, %%typeName, %%browsingVersions)
        #endif
        if browsingVersions {
            return false
        }
        
        // This value must stay true because otherwise is prevents the
        // document loading from ever appearing.
        return true
    }
    
    override open func makeWindowControllers() {
        
        if isInViewingMode {
           
            // Returns the Storyboard that contains your Document window.
            let bundle = Bundle(for: MacStyloDocument.self)
            let storyboard = NSStoryboard(name: NSStoryboard.Name(string: "VersionsDocument"), bundle: bundle)
            let windowController = storyboard.instantiateInitialController() as! VersionsStyloWindowController
            self.addWindowController(windowController)
            let versionsStyloWindow = windowController.window as! VersionsStyloWindow
            versionsStyloWindow.makeKeyAndOrderFront(self)
        }
        else {
            
            // Returns the Storyboard that contains your Document window.
            let bundle = Bundle(for: MacStyloDocument.self)
            let storyboard = NSStoryboard(name: NSStoryboard.Name(string: "Document"), bundle: bundle)
            let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "Document Window Controller")) as! StyloWindowController
            self.addWindowController(windowController)
            
            let styloWindow = windowController.window as! StyloWindow
            
            if let frameId = self.frameId {
                let windowFrameAutosaveName = NSWindow.FrameAutosaveName(string:frameId)
                windowController.windowFrameAutosaveName = windowFrameAutosaveName
            }
            loadProjectPanels()
            styloWindow.makeKeyAndOrderFront(self)
            assert(self.documentManager != nil)
            assert(self.documentManager?.pluginManager != nil)
            self.documentManager?.pluginManager?.documentDidLoad()
            assert(self.documentManager?.styleSetManager != nil)
            initializeMenu()
            initializeStyloWindow(styloWindow: styloWindow)
            listenToAppearance()
        }
    }
    
    /////////////////////////////////////////////////
    /// MARK: Public style management methods
    /////////////////////////////////////////////////
    
    private func listenToAppearance() {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        documentManager.appearanceMode.subscribe({ [weak self](appearanceMode) in
            self?.handleStyloApplicationAppearanceChange(appearanceMode)
        }, observer: self)
    }
     
     private func handleStyloApplicationAppearanceChange(_ appearanceMode: AppearanceMode) {
         
         windowController?.applyAppearance(appearanceMode)
     }
    
    override open func content(withId id: String, wasSelectedByPluginWithName pluginName: String) {
        
        self.scrollToContent(withId: id)
    }
    
    
    @IBAction override open func rename(_ sender: Any?) {
        
        super.rename(sender)
    }
    
    override open func save(to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType, completionHandler: @escaping (Error?) -> Void) {
        
        super.save(to: url, ofType: typeName, for: saveOperation) { (error) in
            completionHandler(error)
        }
    }
    
    override open func prepareSavePanel(_ savePanel: NSSavePanel) -> Bool {
        
        let value = super.prepareSavePanel(savePanel)
        savePanel.allowedFileTypes = [§DocumentType.stylo]
        return value
    }
    
    public override func showDocumentWindow() {
        
        let bundle = Bundle(for: MacStyloDocument.self)
        let storyboard = NSStoryboard(name: NSStoryboard.Name(string: "Document"), bundle: bundle)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "Document Window Controller")) as! StyloWindowController
        self.addWindowController(windowController)
        windowController.showWindow(self)
        windowController.window?.makeKeyAndOrderFront(self)
    }
    
    override open func showLoadingWindow(with filename: String?) {
        
        DispatchQueue.main.async {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Showing loading window.", log: Log.StyloCore.all, type: .info)
            #endif
            
            let bundle = Bundle(for: MacStyloDocument.self)
            let storyboard = NSStoryboard(name: NSStoryboard.Name(string: "DocumentLoadingActivity"), bundle: bundle)
            let documentLoadingWindowController = storyboard.instantiateInitialController() as! DocumentLoadingWindowController
            assert(documentLoadingWindowController.window != nil)
            self.loadingWindowController = documentLoadingWindowController
            documentLoadingWindowController.documentLoadViewController?.filename = filename
            documentLoadingWindowController.window?.center()
            documentLoadingWindowController.window?.isMovableByWindowBackground = true
            documentLoadingWindowController.window?.makeKeyAndOrderFront(self)
        }
    }
    
    override open func hideLoadingWindow() {
        
        DispatchQueue.main.async {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Hiding loading window.", log: Log.StyloCore.all, type: .info)
            #endif
            assert(self.loadingWindowController != nil)
            if let loadingWindowController = self.loadingWindowController {
                loadingWindowController.window?.orderOut(self)
            }
        }
    }
    
    override open func move(to url: URL, completionHandler: ((Error?) -> Void)? = nil) {
        
        // if we know we are moving the document, the old URL frame
        // won't be used anymore.
        if let fileURL = self.fileURL {
            NSWindow.removeFrame(usingName: NSWindow.FrameAutosaveName(string: fileURL.absoluteString))
        }
        super.move(to: url, completionHandler: completionHandler)
    }
    
    private func loadProjectPanels() {
        
        guard let projectPanels = self.projectPanels else {
            assertionFailure("Error: self.projectPanels is nil")
            return
        }
        
        for projectPanel in projectPanels {
            assert(projectPanel.viewController.representedObject != nil)
            styloNavigatorTools.append((self.name+"-"+projectPanel.originPluginName,projectPanel))
        }
    }
    
    private func initializeMenu() {
    
        self.populateStylesMenu()
        handleSelectedStyleManager()
        subscribeToSourceSetManager()
    }
    
    private func scrollToContent(withId id: TextId) {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let filesOutlineSetManager = documentManager.filesOutlineSetManager.value else {
            assertionFailure("Error: documentManager.filesOutlineSetManager.value is nil")
            return
        }
        
        guard let selectedFilesOutlineManager = filesOutlineSetManager.selectedFilesOutlineManager.value else {
            assertionFailure("Error: we should always have a selectedFilesOutlineManager")
            return
        }
        
        if selectedFilesOutlineManager.isItemSelected(with: id) {
            
            selectedFilesOutlineManager.scrolledItemId.setValue(id)
        }
    }
    
    private func initializeStyloWindow(styloWindow: StyloWindow) {
        
        // nothing to do
    }
    
    deinit {
        
        self.documentManager?.appearanceMode.unsubscribe(observer: self)
        unsubscribeToSourceSetManager()
    }
}

