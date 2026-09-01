//
//  StyleEditorPlugin+Styles.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-01-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon

extension StyleEditorPlugin {
    
    var toolsCollapsed: Bool {
        
        guard let styloCoreDocument = self.styloDocument as? StyloCoreDocument else {
            assertionFailure("Error: styloDocument is not StyloCoreDocument")
            return false 
        }
        
        return styloCoreDocument.toolsCollapsed
    }
    
    var editedStylesheetViewController: StylesheetViewController? {

        return cssViewController?.editedStyleViewController?.editedStylesheetViewController
    }

    var editedStyleViewController: StyleViewController? {
        
        return cssViewController?.editedStyleViewController
    }
    
    var currentlyEditingCssStylesheet: Bool {

        if let editedStylesheetViewController = editedStylesheetViewController,  editedStylesheetViewController.parent != nil {

            return true
        }
        return false
    }
    
    var stylesheetHasIssues: Bool? {
        
        if let editedStylesheetViewController = editedStylesheetViewController {
            
            return editedStylesheetViewController.hasIssues
        }
        return nil
    }
    
    var styleHasPendingChanges: Bool {
        guard let editedStyleViewController = self.editedStyleViewController else {
            return false
        }
        return editedStyleViewController.hasPendingChanges
    }
    
    var issuesPanelShown: Bool {
        
        if let editedStylesheetViewController = editedStylesheetViewController {
            
            return editedStylesheetViewController.errorsToolsShown
        }
        return false
    }

    var stylesToolsShown: Bool {
         
        return stylesListShown || styleShown || stylesheetEditorShown
    }
    
    var stylesListShown: Bool {

        return self.cssViewController?.view.window != nil && self.cssViewController?.view.visibleRect != .zero
    }
    
    var styleShown: Bool {
        
        return self.editedStyleViewController?.view.window != nil && self.editedStyleViewController?.view.visibleRect != .zero
    }
    
    var stylesheetEditorShown: Bool {
        
        return self.currentlyEditingCssStylesheet
    }
    
    @IBAction func addStyle(_ sender: AnyObject? = nil) {
        
        assert(cssViewController != nil)
        cssViewController?.addStyle(sender)
    }
    
    @IBAction func editStyle(_ sender: AnyObject? = nil) {
        
        assert(cssViewController != nil)
        let selectedStyleTableViewCell = cssViewController?.selectedStyleTableViewCell
        
        assert(selectedStyleTableViewCell != nil)
        if let selectedStyleTableViewCell = selectedStyleTableViewCell {
             cssViewController?.editStyleButtonClicked(selectedStyleTableViewCell.editButton)
        }
    }
    
    @IBAction func closeStyle(_ sender: AnyObject? = nil) {
        
        self.editedStyleViewController?.goBack()
    }
    
    @IBAction func dismissStyleEditor(_ sender: AnyObject? = nil) {
        
        self.editedStyleViewController?.goBack(sender)
    }
    
    @IBAction func dismissStylesheetEditor(_ sender: AnyObject? = nil) {
        
        self.editedStylesheetViewController?.goBack(sender)
    }
    
    @IBAction func toggleCssIssuesPanel(_ sender: AnyObject? = nil) {
        
        if issuesPanelShown {
            showIssues(sender)
        }
        else {
            dismissIssues(sender)
        }
    }
    
    @IBAction func showIssues(_ sender: AnyObject? = nil) {
        
        self.editedStylesheetViewController?.toggleEditorToolsPanel(sender)
    }
    
    @IBAction func dismissIssues(_ sender: AnyObject? = nil) {
        
        self.editedStylesheetViewController?.toggleEditorToolsPanel(sender)
    }
    
    @IBAction func applyPendingStyleChanges(_ sender: AnyObject? = nil) {
        
        self.updateTextStyleForSelectedStyleManagerIfPendingChanges(sender)
    }
    
    @IBAction func toggleStylesList(_ sender: AnyObject? = nil) {
         
         #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
         os_log("toggleStylesList", log: Log.MacWriterCommon.all, type: .info)
         #endif
         
        guard let styloCoreDocument = self.styloDocument as? StyloCoreDocument else {
            assertionFailure("Error: styloDocument is not StyloCoreDocument")
            return
        }
        
         if stylesToolsShown && !toolsCollapsed {
             closeStylesList(sender)
         }
         else {
            styloCoreDocument.openTools(sender)
         }
     }
     
     private func closeStylesList(_ sender: AnyObject? = nil) {
     
        precondition(stylesToolsShown && !toolsCollapsed)
        guard let styloCoreDocument = self.styloDocument as? StyloCoreDocument else {
            assertionFailure("Error: styloDocument is not StyloCoreDocument")
            return
        }
        styloCoreDocument.animateCloseEditorTools(sender)
     }
    
    @IBAction public func updateTextStyleForSelectedStyleManagerIfPendingChanges(_ sender: AnyObject? = nil) {
        
        self.updateTextStyleForSelectedStyleManager()
    }
    
    @IBAction public func updateTextStyleForSelectedStyleManager(_ sender: AnyObject? = nil) {
        
        assert(styleSetManager != nil)
        if let styleSetManager = styleSetManager {
            
            assert(styleSetManager.selectedStyleManager.value != nil)
            if let selectedStyleManager = styleSetManager.selectedStyleManager.value {
                
                selectedStyleManager.clearStyleAssemblies()
                windowController?.applyStyle(from: selectedStyleManager)
                selectedStyleManager.hasPendingChanges.setValue(false)
            }
        }
    }
    
    public func dismissStylesheetEditorIfShown() {
        
        if let editedStylesheetViewController = editedStylesheetViewController {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Dismissing editedStylesheetViewController", log: Log.MacWriterCommon.all, type: .info)
            #endif
            // editedStylesheetViewController.applyPendingChanges()
        }
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("editedStylesheetViewController is nil", log: Log.MacWriterCommon.all, type: .info)
            #endif
        }
    }
    
 
}
