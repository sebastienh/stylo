//
//  PluginManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-29.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import SwiftProtobuf
import Common
import os

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

#if os(OSX)
public typealias PlateformButtonType = NSButton
#else
public typealias PlateformButtonType = UIButton
#endif

public class PluginManager {
    
    /// This property keeps all the plugins data that is not supported
    /// by the current software (Stylo, Studio, ...) and save it
    /// locally for passing it over, unmodified, again when saving.
    var pluginsData: Dictionary<String,FileWrapper>
    
    /// Dictionary containing the name of the constructed panel
    /// name from the (plugin.name + MacOSProjectPanel.name) pointing to
    /// the MacOSProjectPanel struct.
    public var pluginsNavigatorTools: [(String, NavigatorTool)]
    
    /// Dictionary containing the name of the constructed panel
    /// name from the (plugin.name + MacOSProjectPanel.name) pointing to
    /// the MacOSProjectPanel struct.
    public var pluginsToolsPanels: [(String, ToolPanel)]
    
    public var exportPlugins: [ExportPlugin]
    
    public var isEdited: Bool {
        
        for (_, plugin) in registry {
            if plugin.isEdited {
                return true
            }
        }
        return false
    }
    
    var isDraft: Bool {
        for (_, plugin) in registry {
            if plugin.isDraft {
                return true
            }
        }
        return false
    }
    
    /// Property to know if there is any plugin that needs
    /// to be displayed on the right sidebar. Mainly used
    /// to know if we should display the right sidebar open
    /// button or not.
    public var containsToolsPanelPlugins: Bool {
        for (name, plugin) in registry {
            if let toolsPanelPlugin = plugin as? ToolsPanelPlugin {
                if self.isDocumentPluginEnabled(withName: name) && toolsPanelPlugin.mode == .write {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("containsToolsPanelPlugins: %@", log: Log.WriterCommon.all, type: .debug, %%name)
                    #endif
                    
                    return true
                }
            }
        }
        return false
    }
    
    public var pluginsMiddleToolsButtons: [DisableableButton] {
        
        var buttons = [DisableableButton]()
        
        for (_, plugin) in registry {
            
            if let EdiorToolsSidebarPlugin = plugin as? EdiorToolsSidebarPlugin {
                
                if let middleToolsButtons = EdiorToolsSidebarPlugin.middleToolsButtons {
                    
                    for middleToolsButton in middleToolsButtons {
                        buttons.append(middleToolsButton)
                    }
                }
            }
        }
        return buttons
    }
    
    internal private(set) var registry: [String: StyloPlugin&DocumentPlugin]
    
    var pluginsFileWrapper: FileWrapper?
    
    unowned let documentManager: DocumentManager

    static var pluginsFolderUrl: URL? {
        let mainBundleUrl = Bundle.main.bundleURL
        return mainBundleUrl.appendingPathComponent("Contents").appendingPathComponent("PlugIns")
    }
    
    init(documentManager: DocumentManager) {
        
        self.documentManager = documentManager
        self.registry = [String: StyloPlugin&DocumentPlugin]()
        self.pluginsNavigatorTools = [(String, NavigatorTool)]()
        self.pluginsToolsPanels = [(String, ToolPanel)]()
        self.exportPlugins = [ExportPlugin]()
        self.pluginsData = Dictionary<String,FileWrapper>()
    }
    
    public func toolsPanelDidCollapsed() {
        for (_, plugin) in registry {
            if let toolsPlugin = plugin as? ToolsPanelPlugin {
                toolsPlugin.toolsPanelDidCollapsed()
            }
        }
    }
    
    public func pluginsTextEditorControls(forTextId textId: String, andEditorId editorId: String) -> [NSView]? {
        
        var editorToolbarControls = [NSView]()

        for (_, plugin) in registry {
            if let textEditorToolbarPlugin = plugin as? TextEditorToolbarPlugin {
                if let editorControls = textEditorToolbarPlugin.editorControlsForTextManager(withId: textId, andEditorId: editorId) {
                    for editorControl in editorControls {
                        guard let editorControlView = editorControl as? NSView else {
                            assertionFailure("Error: editorControl is NSView")
                            continue
                        }
                        editorToolbarControls.append(editorControlView)
                    }
                }
            }
        }
        return editorToolbarControls.isEmpty ? nil : editorToolbarControls
    }
    
    public func loadToolsPanels() {
        
        func _loadToolPanels() {
            for (name, plugin) in registry {
                
                if let toolsPlugin = plugin as? ToolsPanelPlugin {
                
                    if let toolPanels = toolsPlugin.toolPanels {
                        
                        for toolPanel in toolPanels {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Load tool panel %@ for plugin: %@", log: Log.WriterCommon.all, type: .debug, %%toolPanel.name, %%name)
                            #endif
                            
                            pluginsToolsPanels.append((plugin.name+"-"+toolPanel.name, toolPanel))
                        }
                    }
                }
            }
        }
        
        if Thread.isMainThread {
            _loadToolPanels()
        }
        else {
            DispatchQueue.main.sync {
                _loadToolPanels()
            }
        }
    }
    
    public func loadProjectPanels() {
        
        func _loadProjectPanels() {
            
            var pluginsNavigatorTools: [(String, String, NavigatorTool)] = []
            
            for (name, plugin) in registry {
                
                if let projectPanelPlugin = plugin as? ProjectPanelPlugin {
                
                    if let projectPanels = projectPanelPlugin.projectPanels {
                        
                        for projectPanel in projectPanels {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Load projet panel %@ for plugin: %@", log: Log.WriterCommon.all, type: .debug, %%projectPanel.name, %%name)
                            #endif
                            
                            pluginsNavigatorTools.append((plugin.name, projectPanel.originPluginName, projectPanel))
                        }
                    }
                }
            }
            
            self.pluginsNavigatorTools = pluginsNavigatorTools.sorted(by: { (first, second) -> Bool in
                return first.1 < second.1
            }).map({ (arg0) -> (String, NavigatorTool) in
                let (pluginName, panelName, panel) = arg0
                return (pluginName+"-"+panelName, panel)
            })
        }
        
        if Thread.isMainThread {
            _loadProjectPanels()
        }
        else {
            DispatchQueue.main.sync {
                _loadProjectPanels()
            }
        }
    }
    
    func loadPlugins() {
        
        if Thread.isMainThread {
            self._loadPlugins()
        }
        else {
            DispatchQueue.main.sync { [weak self] in
                self?._loadPlugins()
            }
        }
    }
    
    private func _loadPlugins() {
        
        assert(Thread.isMainThread)
        guard let pluginsClasses = PluginManager.PluginsClasses else {
            return
        }
        
        for pluginClass in pluginsClasses {
            
            // the plugin may be an application plugin...
            if let StyloCommonPrincipalClass = pluginClass as? (StyloPlugin&DocumentPlugin).Type {
                
                let styloPlugin: StyloPlugin&DocumentPlugin = StyloCommonPrincipalClass.init(documentManager: self.documentManager)
                
                if isDocumentPluginEnabled(withName: styloPlugin.name) {
                    register(styloPlugin: styloPlugin)
                }
            }
        }
    }
    
    private func isDocumentPluginEnabled(withName name: String) -> Bool {
     
        return StyloApplication.shared.isPluginEnabled(withName: name)
    }
        
    func initPluginsData() {
        
        for (name, plugin) in registry {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Init plugin data: %@", log: Log.WriterCommon.all, type: .info, %%name)
            #endif
            if let dataPlugin = plugin as? DataPlugin {
                dataPlugin.initData()
            }
        }
        loadProjectPanels()
        loadToolsPanels()
    }
    
    public func documentWillDisableProjectPanel() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("PluginManager.documentWillDisableProjectPanel()", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        for (_, plugin) in registry {
            if let projectPanelPlugin = plugin as? ProjectPanelPlugin {
                projectPanelPlugin.documentWillDisableProjectPanel()
            }
        }
    }
    
    public func documentWillEnableProjectPanel() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("PluginManager.documentWillEnableProjectPanel()", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        for (_, plugin) in registry {
            if let projectPanelPlugin = plugin as? ProjectPanelPlugin {
                projectPanelPlugin.documentWillEnableProjectPanel()
            }
        }
    }
    
    func documentWillClose() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("PluginManager.prepareForClosing()", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        for (_, plugin) in registry {
            plugin.documentWillClose()
        }
    }
    
    func documentWillSave() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("PluginManager.documentWillSave()", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        for (_, plugin) in registry {
            plugin.documentWillSave()
        }
    }
    
    func documentDidSave() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("PluginManager.documentDidSave()", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        for (_, plugin) in registry {
            plugin.documentDidSave()
        }
    }
    
    /// This method reads the data for all plugins. It needs
    /// the plugins filewrapper and the plugins metadata
    func readPluginsData(from pluginsFileWrapper: FileWrapper?) throws {
        
        self.pluginsFileWrapper = pluginsFileWrapper
        
        guard let pluginsFileWrapper = self.pluginsFileWrapper else {
            assertionFailure("Error: self.pluginsFileWrapper is nil")
            return
        }
        
        for (pluginName, plugin) in registry {
            
            if let dataPlugin = plugin as? DataPlugin {
                
                let pluginFileWrapper = pluginsFileWrapper.fileWrapper(at: pluginName)
                try dataPlugin.readData(from: pluginFileWrapper)
            }
        }
        
        loadProjectPanels()
        loadToolsPanels()
    }
    
    public func documentDidLoad() {
        
        for (_, plugin) in registry {
            plugin.documentDidLoad()
        }
        
        // at this point all controllerss should have been
        // created and ready to be used
        for (name, plugin) in registry {
            if let exportPlugin = plugin as? ExportPlugin {
                #if DEBUG
                if name == "HtmlExportPlugin" {
                    continue
                }
                #endif
                self.exportPlugins.append(exportPlugin)
            }
            if let applicationMenuPlugin = plugin as? ApplicationMenuPlugin {
                
                let document = self.documentManager.document
                
                if let responderPlugin = applicationMenuPlugin as? NSResponder {
                    
                    guard let windowController = document?.windowControllers.first else {
                        assertionFailure("Error: windowController is nil")
                        return
                    }
                    
                    // insert the plugin in the responder chain
                    let nextResponder = windowController.nextResponder
                    
                    windowController.nextResponder = responderPlugin
                    responderPlugin.nextResponder = nextResponder
                }
            }
        }
    }
    
    private func register(styloPlugin: StyloPlugin&DocumentPlugin) {
        
        registry[styloPlugin.name] = styloPlugin
        styloPlugin.pluginDidLoad()
    }
    
}
