//
//  PreviewTabViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-09-20.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import PromiseKit
import WriterCommon
import Common
import os

class PreviewTabViewController: NSTabViewController {
    
    /// This dictionnary of Promises is used to
    /// keep the current preview data promises.
    var pendingPreviewDataLoadingPromises: [String: Promise<String>] = [:]
    
    private var previewWindowController: PreviewWindowController? {
        
        return self.view.window?.windowController as? PreviewWindowController
    }
    
    private var selectedTextManagers: [TextManager]? {
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return nil
        }
     
        guard let selectedFilesOutlineManager = documentManager.selectedFilesOutlineManager else {
            assertionFailure("Error: documentManager.selectedFilesOutlineManager is nil")
            return nil
        }
        
        return selectedFilesOutlineManager.selectedTextManagers
    }
    
    private var documentManager: DocumentManager? {
        return self.representedObject as? DocumentManager
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        guard let previewWindowController = self.previewWindowController else {
            assertionFailure("Error: self.previewWindowController is nil")
            return
        }
        
        previewWindowController.previewModePopupButton.isEnabled = false
        self.selectedTabViewItemIndex = 0
        loadPreviewData()
    }
    
    private func loadPreviewData() {
        
        guard let previewWindowController = self.previewWindowController else {
            assertionFailure("Error: self.previewWindowController is nil")
            return
        }
        
        guard let exportPlugins = previewWindowController.exportPlugins else {
            assertionFailure("Error: exportPlugins is nil")
            return
        }
        
        guard let selectedTextManagers = self.selectedTextManagers else {
            assertionFailure("Errors: nil selectedTextManagers")
            return
        }
        
        guard !selectedTextManagers.isEmpty else {
            self.selectNoDataViewController()
            return
        }
        
        self.pendingPreviewDataLoadingPromises.removeAll(keepingCapacity: true)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            var dataPromises = [Promise<String>]()
            
            for exportPlugin in exportPlugins {

                guard let styloPlugin = exportPlugin as? StyloPlugin else {
                    assertionFailure("Error: exportPlugin is not StyloPlugin")
                    continue
                }
                
                let dataPromise = exportPlugin.prepareData(for: selectedTextManagers)
                dataPromises.append(dataPromise)
                
                self?.pendingPreviewDataLoadingPromises[styloPlugin.name] = dataPromise
            }
            
            
            
            if let selectedPreviewPluginName = StyloApplication.shared.selectedPreviewPluginName {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectedPreviewPluginName: %@", log: Log.StyloCore.all, type: .info, %%selectedPreviewPluginName)
                #endif
                
                DispatchQueue.main.async {
                    
                    guard let pluginIndex = self?.pluginIndex(forPluginName: selectedPreviewPluginName) else {
                        assertionFailure("Error: pluginIndex is nil")
                        return
                    }

                    previewWindowController.previewModePopupButton.selectItem(at: pluginIndex-2)
                    previewWindowController.previewModePopupButton.isEnabled = false
                    
                    when(resolved: dataPromises).then { pluginName -> Void in
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("successfully loaded all previews", log: Log.StyloCore.all, type: .info)
                        #endif
                        // nothing to do: mainly avoiding the warning and making sure
                        // there is no error
                        self?.selectedTabViewItemIndex = pluginIndex
                        previewWindowController.previewModePopupButton.isEnabled = true
                        
                    }.catch { error in
                        assertionFailure("Error: error while loading preview data. ")
                    }
                }
            }
            else {
                race(promises: dataPromises).then { pluginName -> Void in
                    
                    DispatchQueue.main.async {    
                        guard let pluginIndex = self?.pluginIndex(forPluginName: pluginName) else {
                            assertionFailure("Error: pluginIndex is nil")
                            return
                        }
                    
                        self?.selectedTabViewItemIndex = pluginIndex
                        previewWindowController.previewModePopupButton.selectItem(at: pluginIndex-2)
                        previewWindowController.previewModePopupButton.isEnabled = true
                    }
                }.catch { error in
                    assertionFailure("Error: error while loading preview data. ")
                }
            }
        }
    }
    
    private func pluginIndex(forPluginName name: String) -> Int? {
        
        guard let previewWindowController = self.previewWindowController else {
            assertionFailure("Error: self.previewWindowController is nil")
            return nil
        }
        
        for (tabName, index) in previewWindowController.exportTabsIndex {
            
            if tabName.hasPrefix(name) {
                return index
            }
        }
        return nil
    }
    
    private func selectNoDataViewController() {
        
        self.selectedTabViewItemIndex = 1
    }
    
    
}
