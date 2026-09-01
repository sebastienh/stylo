//
//  ProjectToolsViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import os

class ProjectToolsViewController: NSTabViewController {
    
    var selectedtProjectToolName: String? {
        for (name, index) in self.projectToolsTabIndexes {
            if index == self.selectedTabViewItemIndex {
                return name
            }
        }
        return nil
    }
    
    var selectedProjectOutlinesViewController: ProjectOutlineViewController? {
     
        if isTabItemSelected(withName: "StyloCore-ProjectOutline") {
            
            let tabViewItem = self.tabViewItems[self.selectedTabViewItemIndex]
            
            guard let viewController = tabViewItem.viewController else {
                assertionFailure("Error: viewController is nil")
                return nil
            }
            
            guard let projectOutlinesTabViewController = viewController as? ProjectOutlinesTabViewController else {
                assertionFailure("Error: viewController is not ProjectOutlinesTabViewController")
                return nil
            }
            
            return projectOutlinesTabViewController.selectedProjectOutlineViewController
        }
        return nil
    }
    
    private var initiated: Bool = false
    
    private var projectToolsTabIndexes: [String: Int] = [:]
    
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
        
        guard let projectToolTabIndex = projectToolsTabIndexes[name] else {
            assertionFailure("Error: no tab item with name: \(name)")
            return false
        }
        
        return self.selectedTabViewItemIndex == projectToolTabIndex
    }
    
    func selectProjectToolTab(withName name: String) {
        
        guard let projectToolTabIndex = projectToolsTabIndexes[name] else {
            assertionFailure("Error: no tab item with name: \(name)")
            return
        }
        
        self.selectedTabViewItemIndex = projectToolTabIndex
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
            
            guard let allProjectPanels = styloDocument.allNavigatorTools else {
                assertionFailure("Error: styloDocument.allProjectPanels is nil")
                return
            }
            
            for (name, projectPanel) in allProjectPanels {
                
                let viewController = projectPanel.viewController
                self.addMinimumWidthConstraint(to: viewController.view)
                assert(viewController.representedObject != nil)
                let tabViewItem = NSTabViewItem(viewController: viewController)
                let index = self.tabView.tabViewItems.count
                self.addTabViewItem(tabViewItem)
                self.projectToolsTabIndexes[name] = index
            }
            self.view.needsUpdateConstraints = true
            initiated = true
        }
    }
    
    private func addMinimumWidthConstraint(to view: NSView) {
        
        let constraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InterfaceConstants.ProjectSidebar.ProjectTabInitialMinimumWidth)
        
        view.addConstraint(constraint)
    }
    
}
