//
//  MarkdownQuickFormattingToolsViewController.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-09-12.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon

class MarkdownQuickFormattingToolsViewController: NSViewController {
    
    @IBOutlet weak var markdownFormattingButtonsStackView: MarkdownFormattingButtonsStackView!
    
    private var registered = false
    
    override var representedObject: Any? {
        didSet {
            subscribeToDocumentManager()
        }
    }
    
    private var documentManager: DocumentManager? {
        
        return self.representedObject as? DocumentManager
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        registerToIsEdited()
    }
    
    func hide() {
        
        self.markdownFormattingButtonsStackView?.isHidden = true
    }
    
    func show() {
        
        self.markdownFormattingButtonsStackView?.isHidden = false
    }
    
    private func disableUserInteractions() {
                
        self.markdownFormattingButtonsStackView?.disableUserInteractions()
    }
    
    private func enableUserInteractions() {
        
        self.markdownFormattingButtonsStackView?.enableUserInteractions()
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
    
    private func registerToIsEdited() {
        
        if !registered {

            guard let documentManager = styloDocument?.documentManager else {
                assertionFailure("Error: styloDocument?.documentManager is nil")
                return
            }

            self.markdownFormattingButtonsStackView.isEnabled = documentManager._editedTextManager.value != nil
            documentManager._editedTextManager.subscribe({ [weak self](textManager) in
                self?.markdownFormattingButtonsStackView.isEnabled = textManager != nil
            }, observer: self)
            
            registered = true
        }
    }
    
    deinit {
        self.unsubscribeFromDocumentManager()
    }
    
}

