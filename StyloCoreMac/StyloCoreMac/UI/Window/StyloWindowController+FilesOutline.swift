//
//  StyloWindowController+FilesOutline.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-06.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension StyloWindowController {
    
    var allowsAddingDirectoryAndTexts: Bool {
        
        if self.navigatorShown && self.selectedProjectOutlineViewController?.view.window != nil {
        
            guard let documentManager = self.documentManager else {
                assertionFailure("Error: self.documentManager is nil")
                return false
            }
            return documentManager.allowsAddingDirectoryAndTexts.value
        }
        return false
    }
    
    var allowsAddingGroups: Bool {
        
        return self.navigatorShown && self.selectedProjectOutlineViewController?.view.window != nil
    }
    
    private var selectedProjectOutlineViewController: ProjectOutlineViewController? {
        
        guard let projectToolsViewController = self.projectToolsViewController else {
            assertionFailure("Error: self.projectToolsViewController is nil")
            return nil
        }
        
        return projectToolsViewController.selectedProjectOutlinesViewController
    }
    
    @IBAction func addSelectedOutlineFile(_ sender: AnyObject? = nil) {
        
        guard let selectedProjectOutlineViewController = self.selectedProjectOutlineViewController else {
            assertionFailure("Error: self.projectOutlineViewController is nil")
            return
        }
        
        selectedProjectOutlineViewController.addText(sender)
    }
    
    @IBAction func addSelectedOutlineDirectory(_ sender: AnyObject? = nil) {
        
        guard let selectedProjectOutlineViewController = self.selectedProjectOutlineViewController else {
            assertionFailure("Error: self.projectOutlineViewController is nil")
            return
        }
        
        selectedProjectOutlineViewController.addDirectory(sender)
    }
    
    @IBAction func addSelectedOutlineGroup(_ sender: AnyObject? = nil) {
        
        guard let selectedProjectOutlineViewController = self.selectedProjectOutlineViewController else {
            assertionFailure("Error: self.projectOutlineViewController is nil")
            return
        }
        
        selectedProjectOutlineViewController.addGroup(sender)
    }
}
