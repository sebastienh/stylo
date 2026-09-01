//
//  ProjectTextEditorsListSplitViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-16.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import Common
import WriterCommon

enum ProjectTextEditorsPanel: Int {
    
    case editors
    case accessories
}

class ProjectTextEditorsListSplitViewController: NSSplitViewController {
    
    var documentManager: DocumentManager? {
        
        return self.representedFilesOutlineManager?.documentManager
    }
    
    var representedFilesOutlineManager: FilesOutlineManager? {
        return self.representedObject as? FilesOutlineManager
    }
    
    var textLeftSideViews: [EditorSideView]? {
        
        assert(self.editorsViewController != nil)
        return editorsViewController?.textLeftSideViews
    }
    
    var textRightSideViews: [EditorSideView]? {
        
        assert(self.editorsViewController != nil)
        return editorsViewController?.textRightSideViews
    }
    
    override var representedObject: Any? {
        willSet {
            #if DEBUG
            if representedObject != nil {
                assert(self.representedObject! is FilesOutlineManager)
            }
            #endif
            unsubscribeToFilesOutlinesSetManager()
        }
    }
    
    var visibleEditors: [EditableView]? {
        
        assert(self.editorsViewController != nil)
        return editorsViewController?.visibleEditors
    }
    
    var contentViews: [EditorContentView]? {
        
        assert(self.editorsViewController != nil)
        return editorsViewController?.contentViews
    }
    
    var editorsViewController: EditorsViewController? {
        
        return self.splitViewItems[§ProjectTextEditorsPanel.editors].viewController as? EditorsViewController
    }
    
    private var filesOutlinesSetManager: FilesOutlineSetManager? {
        
        return documentManager?.filesOutlineSetManager.value
    }
    
    private var initialized: Bool = false
    
    func disableScrolling() {
    
        self.editorsViewController?.disableScrolling()
    }
    
    func enableScrolling() {
        
        self.editorsViewController?.enableScrolling()
    }
    
    override func viewDidLoad() {
        
        if !initialized {
            
            initializeChildControllers()
            initialized = true
        }
        super.viewDidLoad()
    }
    
    private func initializeChildControllers() {
        
        guard let editorsViewController = self.editorsViewController else {
            assertionFailure("Error: self.editorsViewController is nil")
            return
        }
        
        guard let filesOutlineManager = self.representedObject as? FilesOutlineManager else {
            assertionFailure("Error: self.representedObject is nil or not of type \"FilesOutlineManager\"")
            return
        }
        
        editorsViewController.representedObject = filesOutlineManager
    }
    
    private func unsubscribeToFilesOutlinesSetManager() {
        
        if let filesOutlinesSetManager = self.filesOutlinesSetManager {
            filesOutlinesSetManager.filesOutlines.unsubscribe(observer: self)
        }
    }
    
    deinit {
        unsubscribeToFilesOutlinesSetManager()
    }
}

