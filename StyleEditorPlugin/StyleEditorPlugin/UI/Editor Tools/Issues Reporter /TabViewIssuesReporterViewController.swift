//
//  TabViewIssuesReporterViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-26.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import os

/// Controller responsible for managing the
class TabViewIssuesReporterViewController: NSTabViewController {
    
    private var listening: Bool = false
    
    var failable: Failable! {
        
        return representedObject as! Failable?
    }
    
    weak var documentManager: DocumentManager?
    
    override var representedObject: Any? {
        didSet {
            listenToDidUpdateIssuesArray()
            selectedFirstTabViewItemIndex()
        }
    }
    
    override func viewWillAppear() {
        
        initializeSubControllersResourceManagers()
        super.viewWillAppear()
    }

    fileprivate func selectedFirstTabViewItemIndex() {
        if failable.issuesCount == 0 {
            self.selectedTabViewItemIndex = 1
        }
        else {
            self.selectedTabViewItemIndex = 0
        }
    }
    
    fileprivate func listenToDidUpdateIssuesArray() {
        
        assert(self.representedObject != nil)
        
        if !listening {
            
            failable.subscribeToMessages(observer: self) { [weak self](change: DynamicArray<Message>.Change) -> Void in
                
                switch change {
                case .deletes(_, _, let messagesArray):
                    self?.selectTab(messagesCount: messagesArray.count)
                case .inserts(_, _, let messagesArray):
                    self?.selectTab(messagesCount: messagesArray.count)
                case .insert(_, _, let messagesArray):
                    self?.selectTab(messagesCount: messagesArray.count)
                case .move(_, _, _, let messagesArray):
                    self?.selectTab(messagesCount: messagesArray.count)
                case .end: fallthrough
                case .start:
                    break
                }
            }
            listening = true
        }
    }
    
    private func selectTab(messagesCount: Int) {
        
        if messagesCount == 0 {
            self.selectedTabViewItemIndex = 1
        }
        else {
            self.selectedTabViewItemIndex = 0
        }
    }
    
    private func initializeSubControllersResourceManagers() {
        
        for tabViewItem in self.tabViewItems {
            
            if let viewController = tabViewItem.viewController {
                
                switch viewController {
                    
                case let issueReporterViewController as IssuesReporterViewController:
                    
                    issueReporterViewController.documentManager = self.documentManager
                    issueReporterViewController.representedObject = representedObject as? Failable
                    
                case _ as NoIssuesViewController:
                    
                    break
                    
                default:
                    
                    assert(false, "Unsupported viewController in HTMLPreviewToolsTabViewController: \(viewController)")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Unsupported viewController in HTMLPreviewToolsTabViewController: %@", log: Log.StyleEditor.all, type: .error, %%viewController)
                    #endif
                }
            }
        }
    }
    
    deinit {
        

    }
    
}
