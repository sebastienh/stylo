//
//  MarkdownSidebarViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-19.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import PromiseKit

class MarkdownSidebarViewController: NSViewController {
    
    @objc var bigStylesSidebarButton: BigStylesSidebarButton!
    
    @objc var stylesPanelButton: NSButton!
    
    @objc var previewButton: NSButton!
    
    @IBOutlet weak var verticalColorLine: ColoredLineView!
    
    @IBOutlet weak var controlsContainerStackView: NSStackView!
    
    @IBOutlet weak var topStackView: NSStackView!
    
    @objc dynamic var previewButtonState: NSControl.StateValue = NSControl.StateValue.off
    
    override var representedObject: Any? {
        didSet {
            subscribeToDocumentManager()
        }
    }
    
    private var documentManager: DocumentManager? {
        
        return self.representedObject as? DocumentManager
    }
    
    private var pluginManager: PluginManager? {
        
        return self.documentManager?.pluginManager
    }
    
    private var pluginsButtons: [String: NSButton] = [:]
    
    private var pluginsToolsButtons: [String: ToolButton] = [:]
    
    private var styloWindowController: StyloWindowController? {
        
        return self.view.window?.windowController as? StyloWindowController
    }
    
    private var staticHtmlPreviewer: StaticHtmlPreviewer? {
        
        assert(styloWindowController != nil)
        return styloWindowController
    }
    
    private var middleToolsButtonsAdded = false
    
    private var topToolsButtonsAdded = false
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.addTopToolsButtons()
        self.addMiddleToolsButtons()
        self.subscribeToDocumentManager()
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()   
        registerToIsEdited()
    }
    
    private func disableUserInteractions() {
                
        self.bigStylesSidebarButton?.disableUserInteractions()
        
        for button in self.controlsContainerStackView.views {
            guard let disableableButton = button as? DisableableButton else {
                assertionFailure("Error: button is not DisableableButton")
                continue
            }
            
            disableableButton.disableUserInteractions()
        }
    }
    
    private func enableUserInteractions() {
        
        self.bigStylesSidebarButton?.enableUserInteractions()
        
        for button in self.controlsContainerStackView.views {
            guard let disableableButton = button as? DisableableButton else {
                assertionFailure("Error: button is not DisableableButton")
                continue
            }
            
            disableableButton.enableUserInteractions()
        }
    }

    private func subscribeToDocumentManager() {
        
        if self.documentManager?.userInteractionsEnabled.subscribed(observer: self) == false {
        
            self.documentManager?.userInteractionsEnabled.subscribe({ [weak self](userInteractionsEnabled) in
                if userInteractionsEnabled {
                    self?.enableUserInteractions()
                }
                else {
                    self?.disableUserInteractions()
                }
            }, observer: self)
        }
    }
    
    private func unsubscribeFromDocumentManager() {
    
        self.documentManager?.userInteractionsEnabled.unsubscribe(observer: self)
    }
    
    private var registered = false
    
    private func registerToIsEdited() {
        
        if !registered {

            guard let documentManager = styloDocument?.documentManager else {
                assertionFailure("Error: styloDocument?.documentManager is nil")
                return
            }

            registered = true
        }
    }
    
    private func addTopToolsButtons() {
        
        if !topToolsButtonsAdded {
            
            guard let documentManager = self.documentManager else {
                assertionFailure("Error: self.documentManager is nil")
                return
            }
            
            guard let styloDocument = documentManager.document as? MacStyloDocument else {
                assertionFailure("Error: self.documentManager.document is not MacStyloDocument")
                return
            }
            
            guard let topToolsButtons = styloDocument.topToolsButtons else {
//                assertionFailure("Error: styloDocument.allProjectPanels is nil")
                return
            }
            
            for topToolsButton in topToolsButtons {
                
                guard let macDisableableButton = topToolsButton as? MacDisableableButton else {
                    assertionFailure("Error: topToolsButton is not MacDisableableButton")
                    continue
                }
                
                self.topStackView.addArrangedSubview(macDisableableButton)
                
                if let identifier = macDisableableButton.identifier?.rawValue, identifier == StyloConstants.ViewIdentifiers.ToolsBigStylesButton {
                    self.bigStylesSidebarButton = macDisableableButton as? BigStylesSidebarButton
                }
            }
            
            topToolsButtonsAdded = true
        }
    }
    
    private func addMiddleToolsButtons() {
        
        if !middleToolsButtonsAdded {
            
            guard let documentManager = self.documentManager else {
                assertionFailure("Error: self.documentManager is nil")
                return
            }
            
            guard let styloDocument = documentManager.document as? MacStyloDocument else {
                assertionFailure("Error: self.documentManager.document is not MacStyloDocument")
                return
            }
            
            guard let pluginsToolsButtons = styloDocument.middleToolsButtons else {
//                assertionFailure("Error: styloDocument.allProjectPanels is nil")
                return
            }
            
            for middleToolsButton in pluginsToolsButtons {
                
                guard let macDisableableButton = middleToolsButton as? MacDisableableButton else {
                    assertionFailure("Error: middleToolsButton is not MacDisableableButton")
                    continue
                }
                
                self.controlsContainerStackView.addArrangedSubview(macDisableableButton)
                                
                guard let identifier = macDisableableButton.identifier?.rawValue else {
                    assertionFailure("Error: no identifier on button")
                    continue
                }
                
                switch identifier {
                case StyloConstants.ViewIdentifiers.ToolsPreviewButton:
                    self.previewButton = macDisableableButton
                case StyloConstants.ViewIdentifiers.ToolsStylesButton:
                    self.stylesPanelButton = macDisableableButton
                default:
//                    assertionFailure("Error: unmanaged button identifier")
                    break
                }
            }
            middleToolsButtonsAdded = true
        }
    }
    
    deinit {
         styloDocument?.documentManager?._editedTextManager.unsubscribe(observer: self)
        self.unsubscribeFromDocumentManager()
    }
    
}
