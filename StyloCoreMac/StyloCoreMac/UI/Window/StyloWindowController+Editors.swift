//
//  StyloWindowController+Editors.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-03-12.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import os
import Common

extension StyloWindowController {
    
    private var filesOutlineSetManager: FilesOutlineSetManager? {
        
        return self.documentManager?.filesOutlineSetManager.value
    }
    
    private var selectedFilesOutlineManager: FilesOutlineManager? {
        
        return filesOutlineSetManager?.selectedFilesOutlineManager.value
    }
    
    var allowsCloseCurrentEditorsPane: Bool {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return false
        }
        
        return filesOutlineSetManager.filesOutlines.count > 1
    }
    
    var allowsAddEditorsPane: Bool {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return false
        }
        
        guard let mainScreen = NSScreen.main else {
            assertionFailure("Error: mainScreen is nil")
            return false
        }
        
        return mainScreen.allowsAddingOtherEditorsPanel(forFilesOutlinesCount: filesOutlineSetManager.filesOutlines.count)
    }
    
    var allowsGoBack: Bool {
                   
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager else {
            return false
        }
            
        return selectedFilesOutlineManager.historyBackEnabled.value
    }
               
    var allowsGoForward: Bool {
     
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager else {
            return false
        }
            
        return selectedFilesOutlineManager.historyForwardEnabled.value
    }
    
    var allowsAddingTextInCurrentEditorsPane: Bool {
        
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager else {
            return false
        }
        
        return selectedFilesOutlineManager.lastEditedContentManagerId.value != nil
    }
    
    @IBAction func closeCurrentEditorsPane(_ sender: AnyObject?) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("closeCurrentEditorsPane(...)", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil")
            return
        }
        
        guard let filesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let index = filesOutlineSetManager.index(ofFilesOutlineManager: filesOutlineManager) else {
            assertionFailure("Error: index returned is nil")
            return
        }
        
        documentManager.removeFilesOutlineManager(atIndex: index)
    }

    @IBAction func addEditorsPane(_ sender: AnyObject?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("addEditorsPane(...)", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil")
            return
        }
        
        guard let filesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let index = filesOutlineSetManager.index(ofFilesOutlineManager: filesOutlineManager) else {
            assertionFailure("Error: index returned is nil")
            return
        }
        
        documentManager.addNewEmptyFilesOutlineManager(atIndex: index+1)
    }
    
    @IBAction func addTextInCurrentEditorsPane(_ sender: AnyObject?) {

        guard let filesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let lastEditedContentManagerId = filesOutlineManager.lastEditedContentManagerId.value else {
            assertionFailure("Error: filesOutlineManager.lastEditedContentManagerId is nil")
            return
        }

        filesOutlineManager.addTextManagerAndSelectIt(afterItemWithId: lastEditedContentManagerId)
    }
    
    @IBAction func goBackInHistory(_ sender: AnyObject?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("goBackInHistory(...)", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: self.selectedFilesOutlineManager is nil")
            return
        }
        
        selectedFilesOutlineManager.moveBackward()
    }
    
    @IBAction func goForwardInHistory(_sender: AnyObject?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("goForwardInHistory(...)", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: self.selectedFilesOutlineManager is nil")
            return
        }
        
        selectedFilesOutlineManager.moveForward()
    }
    

}
