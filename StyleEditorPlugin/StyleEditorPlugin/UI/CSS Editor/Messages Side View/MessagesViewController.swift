//
//  MessagesViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-03.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac
import Common

class MessagesViewController: NSViewController {
    
    var failable: Failable! {
        
        return self.representedObject as! Failable
    }
    
    @IBOutlet var messagesScrollView: MessageScrollView!
    
    var messagesView: MessageView!
    
    weak var resourceEditorView: ResourceEditorView! {
        
        didSet {
            messagesView.resourceEditorView = resourceEditorView
        }
    }
    
    var listening: Bool = false
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        listenToDidUpdateIssuesArray()
    }
    
    func addMessageViewHeigthContraint(to rootView: NSView, equalTo otherView: NSView) {
        
        let equalHeightsConstraint = NSLayoutConstraint(item: self.messagesView, attribute:NSLayoutConstraint.Attribute.height, relatedBy:NSLayoutConstraint.Relation.equal, toItem: otherView, attribute:NSLayoutConstraint.Attribute.height, multiplier:1, constant:0)
        
        rootView.addConstraint(equalHeightsConstraint)
    }
    
    
    func initializeViews() {
        
        if let messagesScrollView = messagesScrollView {
            
            let contentSize: NSSize = messagesScrollView.contentSize
            let messagesView = MessageView(frame: NSMakeRect(0, 0, contentSize.width, contentSize.height))
            
            messagesScrollView.borderType = NSBorderType.noBorder
            messagesScrollView.hasVerticalScroller = false
            messagesScrollView.hasHorizontalScroller = false
            messagesScrollView.documentView = messagesView
            assert(Thread.isMainThread)
            messagesScrollView.needsDisplay = true
            messagesScrollView.verticalScroller = HiddenScroller()
            messagesScrollView.drawsBackground = true
            
            self.messagesView = messagesView
        }
    }
    
    fileprivate func listenToDidUpdateIssuesArray() {
        
        assert(self.representedObject != nil)
        
        if !listening {
            
            let stylesheetManager = failable as! StylesheetManager
            
            stylesheetManager.subscribeToMessages(observer: self) { [weak self](change: DynamicArray<Message>.Change) -> Void in
                
                switch change {
                case .deletes(_, _, let messagesArray):
                    self?.updateErrors(messagesArray: messagesArray)
                case .inserts(_, _, let messagesArray):
                    self?.updateErrors(messagesArray: messagesArray)
                case .insert(_, _, let messagesArray):
                    self?.updateErrors(messagesArray: messagesArray)
                case .move(_, _, _, let messagesArray):
                    self?.updateErrors(messagesArray: messagesArray)
                case .end: fallthrough
                case .start:
                    break
                }
            }
            
            listening = true
        }
    }
    
    private func updateErrors(messagesArray: [Message]) {
        self.messagesView.updateLeftIndicators(messages: messagesArray)
        if let cssEditorScroller = self.messagesScrollView.verticalScroller as? CssEditorScroller {
            
            cssEditorScroller.messages = messagesArray
        }
    }
    
    override func viewWillLayout() {
        
        super.viewWillLayout()
        
        if let messagesView = messagesView {
            
            messagesView.updateVisibleLeftIndicators()
        }
    }

    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
}
