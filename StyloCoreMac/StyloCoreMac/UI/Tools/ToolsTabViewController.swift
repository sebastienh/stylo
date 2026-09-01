//
//  ToolsTabViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-10-17.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common

final class ToolsTabViewController: NSTabViewController {//, HorizontallyCollapsableViewController, Pushable {

    var selectedtToolName: String? {
        for (name, index) in self.toolsTabIndexes {
            if index == self.selectedTabViewItemIndex {
                return name
            }
        }
        return nil
    }
    
    private var initiated: Bool = false
    
    private var toolsTabIndexes: [String: Int] = [:]
    
    private var documentManager: DocumentManager? {
        assert(self.representedObject != nil)
        assert(self.representedObject! is DocumentManager)
        return self.representedObject as? DocumentManager
    }
    
    private var pluginManager: PluginManager? {
        
        return documentManager?.pluginManager
    }
    
    override func viewWillAppear() {
        
        initChildControllers()
        super.viewWillAppear()
    }
    
    func isTabItemSelected(withName name: String) -> Bool {
        
        guard let toolsTabIndex = toolsTabIndexes[name] else {
            assertionFailure("Error: no tab item with name: \(name)")
            return false
        }
        
        return self.selectedTabViewItemIndex == toolsTabIndex
    }
    
    func selectToolTab(withName name: String) {
        
        guard let toolsTabIndex = toolsTabIndexes[name] else {
            assertionFailure("Error: no tab item with name: \(name)")
            return
        }
        
        self.selectedTabViewItemIndex = toolsTabIndex
    }

    private func initChildControllers() {
         
         if !initiated {
         
             // We have only button for all the files outlines since we want to
             // highlight the selected one (when editing) only when the files outlines
             // button is selected in the left sidebar. If we had one button per outline
             // it would be difficult to know what to do in this case, so we would need
             // to let the user choose which is really no a good option: the user should not
             // have to play with this: we should always show him the outline he is in every time
             // he edit in a particular one if the outline button is selected, meaning that the user
             // has told us that it is what he wants to see.
             guard let documentManager = self.documentManager else {
                 assertionFailure("Error: self.documentManager is nil")
                 return
             }
             
             guard let styloDocument = documentManager.document as? MacStyloDocument else {
                 assertionFailure("Error: self.documentManager.document is not MacStyloDocument")
                 return
             }
             
             guard let allToolsPanels = styloDocument.allToolsPanels else {
                 assertionFailure("Error: styloDocument.allToolsPanels is nil")
                 return
             }
             
             for (name, toolPanel) in allToolsPanels {
                 
                 let viewController = toolPanel.viewController
                 self.addMinimumWidthConstraint(to: viewController.view)
                 assert(viewController.representedObject != nil)
                 let tabViewItem = NSTabViewItem(viewController: viewController)
                 let index = self.tabView.tabViewItems.count
                 self.addTabViewItem(tabViewItem)
                 self.toolsTabIndexes[name] = index
             }
             self.view.needsUpdateConstraints = true
             initiated = true
         }
     }
     
     private func addMinimumWidthConstraint(to view: NSView) {
         
         let constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: InterfaceConstants.ProjectSidebar.ProjectTabInitialMinimumWidth)
         
         view.addConstraint(constraint)
     }
}
