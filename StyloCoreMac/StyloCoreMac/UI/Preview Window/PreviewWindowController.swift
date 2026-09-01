//
//  PreviewWindowController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-09-20.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import PromiseKit
import Common
import os

class PreviewWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet var toolbar: NSToolbar!
    
    @IBOutlet var previewModePopupButton: NSPopUpButton! {
        didSet {
            self.previewModePopupButton?.widthAnchor.constraint(equalToConstant: 120).isActive = true
        }
    }
    
    @IBOutlet var saveButton: NSButton?
    
    var documentManager: DocumentManager? {
        didSet {
            guard let initialTabsCount = self.previewTabViewController?.tabViewItems.count else {
                assertionFailure("Error: self.previewTabViewController is nil")
                return
            }
            self.initialTabsCount = initialTabsCount
            self.initializeExportPlugins()
        }
    }
    
    private var styloDocument: TextDocument? {
        
        return self.documentManager?.document
    }
    
    let previewModeToolbarItemIdentifierString = "PreviewMode"
    let previewModeToolbarItemIdentifier = NSToolbarItem.Identifier(rawValue: "PreviewMode")
    
    let previewModeTitleToolbarItemIdentifierString = "PreviewModeTitle"
    let previewModeTitleToolbarItemIdentifier = NSToolbarItem.Identifier(rawValue: "PreviewModeTitle")
    
    private var initialTabsCount: Int = 0
    
    private var pluginManager: PluginManager? {
        
        assert(self.documentManager != nil)
        return documentManager?.pluginManager
    }
    
    var exportPlugins: [ExportPlugin]? {
        
        assert(self.pluginManager != nil)
        return pluginManager?.exportPlugins
    }
    
    private var previewTabViewController: PreviewTabViewController? {
    
        guard let contentViewController = self.contentViewController else {
            assertionFailure("Error: self.contentViewController is nil")
            return nil
        }
        
        guard let previewTabViewController = contentViewController as? PreviewTabViewController else {
            assertionFailure("Error: contentViewController is not PreviewTabViewController")
            return nil
        }
        
        return previewTabViewController
    }
    
    var exportTabsIndex: [String: Int] = [:]
    
    @IBAction func selectPreviewMode(_ sender: AnyObject? = nil) {
        
        guard let previewTabViewController = self.previewTabViewController else {
            assertionFailure("Error: self.previewTabViewController is nil")
            return
        }
        
        guard let selectedItem = previewModePopupButton.selectedItem else {
            assertionFailure("Error: previewModePopupButton.selectedItem is nil")
            return
        }
        
        guard let menuItemIdentifier = selectedItem.identifier else {
            assertionFailure("Error: selectedItem.identifier is nil")
            return
        }
        
        guard let index = self.exportTabsIndex[menuItemIdentifier.rawValue] else {
            assertionFailure("Error: no index for identifier: \(menuItemIdentifier.rawValue)")
            return
        }
    
        guard let exportPlugin = self.exportPlugin(atIndex: index) else {
            assertionFailure("Error: no plugin at index: \(index)")
            return
        }
        
        guard let styloPlugin = exportPlugin as? StyloPlugin else {
            assertionFailure("Error: exportPlugin is not StyloPlugin")
            return
        }
        
        guard let promise = previewTabViewController.pendingPreviewDataLoadingPromises[styloPlugin.name] else {
            assertionFailure("Error: promise for plugin named: \(styloPlugin.name) is nil")
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("selectPreviewMode to: %@", log: Log.StyloCore.all, type: .info, %%styloPlugin.name)
        #endif
        
        StyloApplication.shared.updateSelectedPreviewPluginName(to: styloPlugin.name)
        
        if !promise.isFulfilled {
            
            previewTabViewController.selectedTabViewItemIndex = 0
            assert(self.saveButton != nil, "saveButton is nil")
            self.saveButton?.isEnabled = false
            
            promise.then { pluginName -> Void in
                self.saveButton?.isEnabled = true
                assert(pluginName == styloPlugin.name, "Wrong promise ended")
                previewTabViewController.selectedTabViewItemIndex = index
            }.catch { error in
                assertionFailure("Error: \(error)")
            }
        }
        else {
            self.saveButton?.isEnabled = true
            previewTabViewController.selectedTabViewItemIndex = index
        }

    }
    
    @IBAction func savePreview(_ sender: AnyObject? = nil) {

        guard let previewTabViewController = self.previewTabViewController else {
            assertionFailure("Error: self.previewTabViewController is nil")
            return
        }
        
        guard let exportPlugin = self.exportPlugin(atIndex: previewTabViewController.selectedTabViewItemIndex) else {
            assertionFailure("Error: no export plugin at index: \(previewTabViewController.selectedTabViewItemIndex)")
            return
        }
        
        guard let data = exportPlugin.previewData else {
            assertionFailure("Error: preview data is nil")
            return
        }
        
        firstly {
            self.exportDocument(toType: exportPlugin.uti, content: data)
        }.catch { error in
            // error handling
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Export error: %@", log: Log.StyloCore.all, type: .error, %%error)
            #endif
        }
    }
    
    override func awakeFromNib() {
        
        assert(self.window != nil)
        NotificationCenter.default.addObserver(forName: NSWindow.didResignMainNotification, object: self.window, queue: nil) { [weak self](notification) in
            
            self?.window?.close()
        }
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        
        if let previewWindowSize = self.styloDocument?.previewWindowSize {
            self.window?.setContentSize(previewWindowSize)
        }
        
        if let previewWindowOrigin = self.styloDocument?.previewWindowOrigin {
            self.window?.setFrameOrigin(previewWindowOrigin)
        }
    }
    
    func windowDidEndLiveResize(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowDidEndLiveResize(_ notification: Notification) to: %@.", log: Log.StyloCore.all, type: .info, %%self.window?.frame.size)
        #endif
        
        assert(self.styloDocument != nil)
        self.styloDocument?.previewWindowSize = self.window?.frame.size
        self.styloDocument?.previewWindowOrigin = self.window?.frame.origin
    }
    
    func windowDidMove(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("windowDidMove(_ notification: Notification) to: %@.", log: Log.StyloCore.all, type: .info, %%self.window?.frame.origin)
        #endif
        
        assert(self.styloDocument != nil)
        self.styloDocument?.previewWindowOrigin = self.window?.frame.origin
    }
    
    private func initializeExportPlugins() {
        
        guard let previewTabViewController = self.previewTabViewController else {
            assertionFailure("Error: self.previewTabViewController is nil")
            return
        }
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let exportPlugins = self.exportPlugins else {
            assertionFailure("Error: no export plugin defined")
            return
        }
        
        previewTabViewController.representedObject = documentManager

        assert(self.initialTabsCount == 2, "We expect 2 initial tabs")
        let initialTabsCount = self.initialTabsCount
        for (pluginIndex, exportPlugin) in exportPlugins.enumerated() {
            let exportPluginTabIndex = initialTabsCount+pluginIndex
            addExport(exportPlugin: exportPlugin, atIndex: exportPluginTabIndex)
        }
    }
    
    private func addExport(exportPlugin: ExportPlugin, atIndex index: Int) {
        
        guard let previewTabViewController = self.previewTabViewController else {
            assertionFailure("Error: self.previewTabViewController is nil")
            return
        }
        
        guard let previewModePopupButton = self.previewModePopupButton else {
            assertionFailure("Error: self.previewModePopupButton is nil")
            return
        }
        
        guard let menu = previewModePopupButton.menu else {
            assertionFailure("Error: previewModePopupButton.menu is nil")
            return
        }
        
        guard let exportPanelId = self.exportPanelId(from: exportPlugin) else {
            // it's possible the html export is disabled in debug
            return
        }
        
        guard let exportPanel = exportPlugin.exportPanel else {
            assertionFailure("Error: exportPlugin.exportPanel is nil")
            return
        }
        
        let menuItemSelector = #selector(PreviewWindowController.selectPreviewMode(_:))
        let menuItem = NSMenuItem(title: exportPanel.name, action: menuItemSelector, keyEquivalent: "")
        
        menuItem.identifier = NSUserInterfaceItemIdentifier(rawValue: exportPanelId)
        menu.addItem(menuItem)
        
        let tabViewItem = NSTabViewItem(viewController: exportPanel.panelViewController)
        previewTabViewController.addTabViewItem(tabViewItem)
        
        self.exportTabsIndex[exportPanelId] = index
    }
    
    private func exportPanelId(from exportPlugin: ExportPlugin) -> String? {
        
        guard let styloPlugin = exportPlugin as? StyloPlugin else {
            assertionFailure("Error: exportPlugin is not StyloPlugin")
            return nil
        }
        
        guard let exportPanel = exportPlugin.exportPanel else {
            assertionFailure("Error: exportPlugin.exportPanel is nil")
            return nil
        }
        
        return styloPlugin.name + "-" + exportPanel.name
    }
    
    private func exportPlugin(atIndex index: Int) -> ExportPlugin? {
        
        guard let exportPlugins = self.exportPlugins else {
            assertionFailure("Error: self.exportPlugins is nil")
            return nil
        }
        
        let exportPluginIndex = index - self.initialTabsCount
        
        guard exportPluginIndex >= 0 && exportPluginIndex < exportPlugins.count else {
            assertionFailure("Error: invalid export plugin index: \(index)")
            return nil
        }
        
        return exportPlugins[exportPluginIndex]
    }
    
    private func exportDocument(toType typeUTI: String, content: Data) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let name = self.styloDocument?.displayName
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("exporting document with name: %@", log: Log.StyloCore.all, type: .info, %%String(describing: name))
            #endif
            
            assert(name != nil)
            if let window = self.window {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("opening save panel for document type: %@.", log: Log.StyloCore.all, type: .info, %%typeUTI)
                #endif
                let panel = NSSavePanel()
                
                if let name = name {
                    
                    var newName = removeExtension(from: name)
                    newName = newName.appending(".").appending(typeUTI)
                    
                    panel.nameFieldStringValue = newName as String
                    panel.beginSheetModal(for: window, completionHandler: { (result) in
                        
                        if result == NSApplication.ModalResponse.OK, panel.url != nil {
                            
                            // The extension has to come from the user because we can't
                            // change the URL without getting an 513 error.
                            // NW-37
                            do {
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                os_log("writing content to %@", log: Log.StyloCore.all, type: .info, %%String(describing: panel.url))
                                #endif
                                try content.write(to: panel.url!)
                                fulfill(())
                            }
                            catch let exception {
                                /* error handling here */
                                reject(NWError.custom(message: "error exporting file: \(String(describing: name)), exception: \(exception)"))
                            }
                        }
                        else {
                            reject(NWError.custom(message: "error exporting file: \(String(describing: name)), result is nil or not OK"))
                        }
                    })
                }
                else {
                    reject(NWError.custom(message: "error exporting file: \(String(describing: name)), name is nil."))
                }
            }
            else {
                reject(NWError.custom(message: "error exporting file: \(String(describing: name)), window is nil."))
            }
        }
    }
    
    private func removeExtension(from filename: String) -> String {
        
        if filename.endsWith(WriterCommon.Constants.FileExtension.stylo) {
            return filename.substringWithoutNamedFileExtension(WriterCommon.Constants.FileExtension.stylo)
        }
        else if filename.endsWith(WriterCommon.Constants.FileExtension.markdown) {
            return filename.substringWithoutNamedFileExtension(WriterCommon.Constants.FileExtension.markdown)
        }
        else if filename.endsWith(WriterCommon.Constants.FileExtension.plainText) {
            return filename.substringWithoutNamedFileExtension(WriterCommon.Constants.FileExtension.plainText)
        }
        return filename
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

