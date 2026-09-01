//
//  ProjectOutlineTitleViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os


class NavigatorViewController: NSViewController {

    enum Tab {
        case files
        case tags
    }
    
    @IBOutlet var arrayController: NSArrayController?

    @IBOutlet var titleBackgroundView: NSVisualEffectView!
    
    @IBOutlet var outlinesButton: OutlineSelectorPopUpButton?
    
    @IBOutlet var navigatorToolSelectorButton: NSPopUpButton?
    
    private var navigatorToolSelectorButtonMenu: NSMenu? {
        
        return navigatorToolSelectorButton?.menu
    }
    
    private var pluginsMenuItems: [String: NSMenuItem] = [:]
    
    @objc dynamic var documentManager: DocumentManager? {
        if Thread.isMainThread {
            return self.representedObject as? DocumentManager
        }
        else {
            return DispatchQueue.main.sync { [weak self] in
                return self?.representedObject as? DocumentManager
            }
        }
    }
    
    private var initialized = false
    
    private var pluginManager: PluginManager? {
    
        return self.documentManager?.pluginManager
    }
    
    private var filesOutlineSetManager: FilesOutlineSetManager? {
        
        return self.documentManager?.filesOutlineSetManager.value
    }
    
    private var filesOutlineManagers: [FilesOutlineManager]? {
        
        return self.arrayController?.arrangedObjects as? [FilesOutlineManager]
    }
    
    var projectToolsTabViewController: ProjectToolsViewController? {
        
        for childViewController in self.children {
            if let projectToolsTabViewController = childViewController as? ProjectToolsViewController {
                return projectToolsTabViewController
            }
        }
        return nil
    }
    
    private var selfOriginatedSelectedFilesOutlineChange: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToArrayController()
    }
    
    override func viewWillAppear() {
        
        initializeIfNecessary()
        super.viewWillAppear()
    }
    
    private func initializeIfNecessary() {
        
        if !self.initialized {
            self.initializeChildViewControllers()
            self.initializeOutlinesButton()
            self.initializeToolsPopupButton()
            self.subscribeToFilesOutlineSetManager()
            
            #if DEBUG
            self.validateFilesOutlineManagers()
            #endif
            
            self.initialized = true
        }
    }
    
    private func initializeToolsPopupButton() {
        
        navigatorToolSelectorButton?.imagePosition = .imageOnly
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let styloDocument = documentManager.document as? MacStyloDocument else {
            assertionFailure("Error: self.documentManager.document is not MacStyloDocument")
            return
        }
        
        guard let allProjectPanels = styloDocument.allNavigatorTools else {
            assertionFailure("Error: styloDocument.allProjectPanels is nil")
            return
        }
        
        let sortedProjectPanels = allProjectPanels.sorted { (first, second) -> Bool in
            return first.1.order.rawValue < second.1.order.rawValue
        }
        
        for (identifier, projectPanel) in sortedProjectPanels {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("projectPanel name: %@", log: Log.StyloCore.all, type: .info, %%projectPanel.originPluginName)
            #endif
            
            addProjectToolsMenuItem(image: projectPanel.buttonImage, title: projectPanel.title, identifier: identifier, tooltip: projectPanel.buttonTooltip)
        }
    }
    
    private func addProjectToolsMenuItem(image: NSImage, title: String, identifier: String, tooltip: String?) {
        
        guard let projectToolsPopupUpButtonMenu = self.navigatorToolSelectorButtonMenu else {
            assertionFailure("Error: self.projectToolsPopupUpButtonMenu is nil")
            return
        }

        let projectToolMenuItem = NSMenuItem()
        projectToolMenuItem.title = title
        projectToolMenuItem.image = image
        
        projectToolMenuItem.toolTip = tooltip
        projectToolMenuItem.action = #selector(NavigatorViewController.selectProjectTool(_:))
        projectToolMenuItem.target = self
        projectToolMenuItem.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier)
        self.pluginsMenuItems[identifier] = projectToolMenuItem
        projectToolsPopupUpButtonMenu.addItem(projectToolMenuItem)
    }
    
    private var selectedProjectToolsButtonName: String? {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return nil
        }
        
        guard let projectToolsViewController = windowController.projectToolsViewController else {
            assertionFailure("Error: windowController.projectToolsViewController is nil")
            return nil
        }
        
        return projectToolsViewController.selectedtProjectToolName
    }
    
    private func projectToolsItemShown(withName name: String) -> Bool {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return false
        }
        
        return windowController.projectToolsItemShown(withName: name)
    }
    
    @IBAction func selectProjectTool(_ sender: AnyObject) {
        
        guard let menuItem = sender as? NSMenuItem else {
            assertionFailure("Error: sender is not NSMenuItem")
            return
        }
        
        guard let identifier = menuItem.identifier?.rawValue else {
            assertionFailure("Error: identifier is nil")
            return
        }
        
        self.selectProjectTabItem(withName: identifier)
    }
    
    private func selectProjectTabItem(withName name: String) {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return
        }
        
        windowController.selectProjectTabItem(withName: name)
    }
    
    private func initializeChildViewControllers() {
        
        assert(self.representedObject != nil)
        assert(self.projectToolsTabViewController != nil)
        self.projectToolsTabViewController?.representedObject = representedObject
    }
    
    private func initializeOutlinesButton() {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        self.handlingUserChange = false
        for (index, filesOutlineManager) in filesOutlineSetManager.filesOutlines.values.enumerated() {
            arrayController?.insert(filesOutlineManager, atArrangedObjectIndex: index)
            subscribeToFilesOutlineManager(filesOutlineManager)
        }
        self.handlingUserChange = true
    }
    
    private var selectedFilesOutlineManagerInitiator = false
    
    private func subscribeToArrayController() {
        
        assert(arrayController != nil)
        arrayController?.addObserver(self, forKeyPath: "selectedObjects", options: .new, context: nil)
    }
    
    /// We only handle the array controller changes when they are
    /// initiated by the user manipulating the selection using the button
    private var handlingUserChange: Bool = true
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if handlingUserChange {
            
            guard let keyPath = keyPath else { return }
            
            guard let arrayController = self.arrayController else {
                assertionFailure("Error: self.arrayController is nil")
                return
            }
            
            guard let arrangedObjects = arrayController.arrangedObjects as? Array<FilesOutlineManager> else {
                assertionFailure("Error: arrayController.arrangedObjects is not Array<String>")
                return
            }
            
            guard let filesOutlineSetManager = self.filesOutlineSetManager else {
                assertionFailure("Error: self.filesOutlineSetManager is nil")
                return
            }
            
            switch keyPath {
            case "selectedObjects":
                if selfOriginatedSelectedFilesOutlineChange {
                    let filesOutlineManager = arrangedObjects[arrayController.selectionIndex]
                    filesOutlineSetManager.filesOutlineManagerSelected(withId: filesOutlineManager.id)
                }
            default:
                break
            }
        }
    }
    
    private func subscribeToFilesOutlineSetManager() {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        filesOutlineSetManager.filesOutlines.subscribe({ [weak self] change in
            self?.selfOriginatedSelectedFilesOutlineChange = false
            self?.handleFilesOutlinesChange(change)
            self?.selfOriginatedSelectedFilesOutlineChange = true
        }, observer: self)
        
        self.handleSelectedFilesOutlineManagerChange(filesOutlineSetManager.selectedFilesOutlineManager.value)
        filesOutlineSetManager.selectedFilesOutlineManager.subscribe({ [weak self](filesOutlineManager) in
            self?.handleSelectedFilesOutlineManagerChange(filesOutlineManager)
        }, observer: self)
    }
    
    private func handleSelectedFilesOutlineManagerChange(_ filesOutlineManager: FilesOutlineManager?) {
        
        guard let filesOutlineManager = filesOutlineManager else {
            assertionFailure("Error: filesOutlineManager parameter is nil")
            return
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        guard let arrayController = self.arrayController else {
            assertionFailure("Error: self.arrayController is nil")
            return
        }
        
        self.handlingUserChange = false
        guard let index = filesOutlineSetManager.index(ofFilesOutlineManager: filesOutlineManager) else {
            assertionFailure("Error: no index for files outline manager with id: \(filesOutlineManager.id)")
            return
        }
        arrayController.setSelectionIndex(index)
        self.handlingUserChange = true
        
        #if DEBUG
        self.validateSelectedFilesOutlineManager()
        #endif
    }
    
    private func handleFilesOutlinesChange(_ change: DynamicArray<FilesOutlineManager>.Change) {
        switch change {
        case .deletes(let indexes, let deletedValues, _):
            for index in indexes.sorted().reversed() {
                arrayController?.remove(atArrangedObjectIndex: index)
            }
            for filesOutlineManager in deletedValues {
                unsubscribeToFilesOutlineManager(filesOutlineManager)
            }
        case .insert(let filesOutlineManager, let index, _):
            arrayController?.insert(filesOutlineManager, atArrangedObjectIndex: index)
            subscribeToFilesOutlineManager(filesOutlineManager)
        case .inserts(let newElements, let indexes, _):
            assert(newElements.count == indexes.count)
            for i in 0..<newElements.count {
                let filesOutlineManager = newElements[i]
                arrayController?.insert(filesOutlineManager, atArrangedObjectIndex: indexes[i])
                subscribeToFilesOutlineManager(filesOutlineManager)
            }
        case .move:
            assertionFailure("Error: unhandled move")
            break
        case .start:
            break
        case .end:
            break
        }
        
        #if DEBUG
        self.validateFilesOutlineManagers()
        #endif
    }
    
    private func subscribeToFilesOutlineManager(_ filesOutlineManager: FilesOutlineManager) {
    
        filesOutlineManager.name.subscribe({ [weak self](newName) in
            self?.handleFilesOutlineManagerNameChanged(filesOutlineManager)
        }, observer: self)
    }
    
    private func handleFilesOutlineManagerNameChanged(_ filesOutlineManager: FilesOutlineManager) {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        guard let index = filesOutlineSetManager.index(ofFilesOutlineManager: filesOutlineManager) else {
            assertionFailure("Error: index returned is nil")
            return
        }
        
        guard let item = outlinesButton?.item(at: index) else {
            assertionFailure("Error: no item at index: \(index)")
            return
        }
        
        item.title = filesOutlineManager.name.value
    }
    
    private func unsubscribeToFilesOutlineManager(_ filesOutlineManager: FilesOutlineManager) {
    
        filesOutlineManager.name.unsubscribe(observer: self)
    }
    
    private func unsubscribeToFilesOutlineSetManager() {
    
        self.filesOutlineSetManager?.filesOutlines.unsubscribe(observer: self)
        self.filesOutlineSetManager?.selectedFilesOutlineManager.unsubscribe(observer: self)
    }
    
    func unsubscribeToDocumentManager() {
        
        documentManager?.name.unsubscribe(observer: self)
        documentManager?.allowsAddingDirectoryAndTexts.unsubscribe(observer: self)
    }
    
    deinit {
        
        unsubscribeToDocumentManager()
        unsubscribeToFilesOutlineSetManager()
    }
}

extension NavigatorViewController {
    
    #if DEBUG
    private func validateFilesOutlineManagers() {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil.")
            return
        }
        
        guard let filesOutlineManagers = self.filesOutlineManagers else {
            assertionFailure("Error: self.filesOutlineManagers is nil")
            return
        }
        
        assert(filesOutlineSetManager.filesOutlines.count == filesOutlineManagers.count)
        for (index, filesOutline) in filesOutlineSetManager.filesOutlines.enumerated() {
            
            let filesOutlineManager = filesOutlineManagers[index]
            assert(filesOutlineManager.id == filesOutline.id, "Wrong files outline at index: \(index)")
        }
    }
    
    private func validateSelectedFilesOutlineManager() {
    
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil.")
            return
        }
        
        guard let filesOutlineManagers = self.filesOutlineManagers else {
            assertionFailure("Error: self.filesOutlineManagers is nil")
            return
        }
        
        guard let selectedFilesOutlineManager = filesOutlineSetManager.selectedFilesOutlineManager.value else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self.arrayController!.selectionIndex: %@", log: Log.StyloCore.all, type: .info, %%self.arrayController!.selectionIndex)
        
        os_log("self.arrayController!.arrangedObjects.count: %@", log: Log.StyloCore.all, type: .info, %%(self.arrayController!.arrangedObjects as! [FilesOutlineManager]).count)
        #endif
        
        let arrayControllerSelectedFilesOutlineManager = filesOutlineManagers[self.arrayController!.selectionIndex]
        assert(arrayControllerSelectedFilesOutlineManager.id == selectedFilesOutlineManager.id)
    }
    #endif
}
