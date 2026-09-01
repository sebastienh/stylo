//
//  ProjectSidebarMenu.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-23.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon

class ProjectSidebarMenuViewController: NSViewController {
    
    @IBOutlet var buttonsStackView: NSStackView!
    
    var backgroundSidebarContentView: BackgroundSidebarContentView? {
        
        return self.view as? BackgroundSidebarContentView
    }
    
    private var documentManager: DocumentManager? {
        
        return self.representedObject as? DocumentManager
    }
 
    private var pluginManager: PluginManager? {
    
        return self.documentManager?.pluginManager
    }
    
    private var pluginsButtons: [String: NSButton]
    
    private var projectSidebarCollapsed: Bool {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return true
        }
        
        return windowController.projectSidebarCollapsed
    }
    
    private var projectButtonsAdded = false
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        
        self.pluginsButtons = [String: NSButton]()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
        
    required init?(coder: NSCoder) {
        
        self.pluginsButtons = [String: NSButton]()
        super.init(coder: coder)
    }
    
    override func viewWillAppear() {
        
        assert(self.representedObject != nil)
        addProjectButtons()
        super.viewWillAppear()
        
    }
    
    @IBAction func toggleProjectPanel(_ sender: AnyObject?) {
        
        guard let button = sender as? NSButton else {
            assertionFailure("Error: sender is not button")
            return
        }
        
        guard let identifier = button.identifier else {
            assertionFailure("Error: Project button must have an identifier.")
            return
        }
        
        let identifierString = identifier.rawValue
        
        if projectSidebarCollapsed {
            toggleProjectToolsPanel()
            selectProjectTabItem(withName: identifierString)
        }
        else {
            
            if projectToolsItemShown(withName: identifierString) {
                toggleProjectToolsPanel()
            }
            else {
                selectProjectTabItem(withName: identifierString)
            }
        }
        updateProjectSidebarState(sender)
    }

    func disableControls() {
        
        for subview in self.buttonsStackView.arrangedSubviews {
            guard let button = subview as? NSButton else {
                assertionFailure("Error:  subview is not NSButton")
                continue
            }
            button.isEnabled = false
        }
    }
    
    func enableControls() {
        
        for subview in self.buttonsStackView.arrangedSubviews {
            guard let button = subview as? NSButton else {
                assertionFailure("Error:  subview is not NSButton")
                continue
            }
            button.isEnabled = true
        }
    }
    
    func updateProjectSidebarState(_ sender: AnyObject? = nil) {

        // we could have just uncollapsed an item
        // or select another one
        // in both cases the sender is active
        if !projectSidebarCollapsed {
            for (_, button) in self.pluginsButtons {
                button.state = .off
            }
            
            guard let selectedButtonName = self.selectedButtonName else {
                assertionFailure("Error: self.selectedButtonName is nil")
                return
            }
            
            guard let button = self.pluginsButtons[selectedButtonName] else {
                assertionFailure("Error: no button for name: \(selectedButtonName)")
                return
            }
            button.state = .on
        }
        else {
            for (_, button) in self.pluginsButtons {
                button.state = .off
            }
        }
    }
    
    private var selectedButtonName: String? {
        
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
    
    private func addProjectButtons() {
        
        if !projectButtonsAdded {
            
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
            
            for (name, projectPanel) in sortedProjectPanels {
                addProjectButton(image: projectPanel.buttonImage, identifier: name, tooltip: projectPanel.buttonTooltip)
            }
            projectButtonsAdded = true
        }
    }
    
    private func addProjectButton(image: NSImage, identifier: String, tooltip: String?) {
        
        let projectButton = ProjectToolsButton(image: image, target: self, action: #selector(self.toggleProjectPanel(_:)))
        projectButton.bezelStyle = .regularSquare
        projectButton.isBordered = false
        projectButton.setButtonType(NSButton.ButtonType.toggle)
        projectButton.state = .off
        projectButton.toolTip = tooltip
        projectButton.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier)
        projectButton.setContentHuggingPriority(.required, for: .vertical)
        self.pluginsButtons[identifier] = projectButton
        self.buttonsStackView.addArrangedSubview(projectButton)
    }
    
    private func selectProjectTabItem(withName name: String) {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return
        }
        
        windowController.selectProjectTabItem(withName: name)
    }
    
    private func projectToolsItemShown(withName name: String) -> Bool {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return false
        }
        
        return windowController.projectToolsItemShown(withName: name)
    }
    
    private func toggleProjectToolsPanel() {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return
        }
        
        windowController.toggleNavigator()
    }
    
}


