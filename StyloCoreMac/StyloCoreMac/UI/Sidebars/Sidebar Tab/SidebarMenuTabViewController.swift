//
//  SidebarMenuTabViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-19.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import os

class SidebarMenuTabViewController: NSTabViewController {
    
    enum SidebarTab: Int, CaseIterable {
        
        case markdown
        case style
    }
    
    var previouslySelectedEditorToolTab: SidebarTab = .markdown {
        
        didSet {
            assert(previouslySelectedEditorToolTab == .markdown || previouslySelectedEditorToolTab == .style)
        }
    }
    
    var selectedTab: SidebarTab? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG  && DEBUG_LOGS_ENABLED
        os_log("selectedTabViewItemIndex: %@", log: Log.StyloCore.all, type: .error, %%selectedTabViewItemIndex)
        #endif
        
        return SidebarTab(rawValue: selectedTabViewItemIndex)
    }
    
    var stylesSidebarViewController: StylesSidebarViewController? {
        
        let stylesSidebarTabViewItem = tabViewItems[SidebarMenuTabViewController.SidebarTab.style.rawValue]
        return stylesSidebarTabViewItem.viewController as? StylesSidebarViewController
    }
    
    var markdownSidebarViewController: MarkdownSidebarViewController? {
        
        let markdownSidebarTabViewItem = tabViewItems[SidebarMenuTabViewController.SidebarTab.markdown.rawValue]
        return markdownSidebarTabViewItem.viewController as? MarkdownSidebarViewController
    }
    
    var documentManager: DocumentManager? {
        
        return self.representedObject as? DocumentManager
    }
    
    override var representedObject: Any? {
        didSet {
            assert(representedObject is DocumentManager)
            updateChildsRepresentedObject()
        }
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        self.transitionOptions = NSViewController.TransitionOptions.crossfade.union(NSViewController.TransitionOptions.allowUserInteraction)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        for sidebarTab in SidebarTab.allCases {
            prepareSidebarTab(sidebarTab)
        }
    }
    
    func prepareSidebarTab(_ sidebarTab: SidebarTab) {
        
        assert(self.styloDocument != nil)
        if let documentManager = self.documentManager {
        
            switch sidebarTab {
            case .style:
                prepareStyleTab(documentManager: documentManager)
            case .markdown:
                prepareMarkdownTab(document: styloDocument)
            }
        }
    }
    
    func selectOldTextTab() {
        
//        if isBackgroud {
//
//            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG  && DEBUG_LOGS_ENABLED
//            os_log("Selecting text background tab", log: Log.StyloCore.all, type: .info)
//            #endif
//
//            selectTab(sidebarTab: .background)
//        }
    }
    
    func selectTab(sidebarTab: SidebarTab) {
        
        // we prepare these tabs before because we need access to the
        // document, but in viewDidAppear it's too late to make the
        // change without being noticed.

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG  && DEBUG_LOGS_ENABLED
        os_log("Selecting sidebar tab index: %@", log: Log.StyloCore.all, type: .info, %%sidebarTab.rawValue)
        #endif        
        
        self.tabView.selectTabViewItem(at: §sidebarTab)
        self.transitionOptions = NSViewController.TransitionOptions.crossfade.union(NSViewController.TransitionOptions.allowUserInteraction)
    }
    
    private func prepareStyleTab(documentManager: DocumentManager) {
        
        let styleTabViewItem = self.tabViewItems[SidebarTab.style.rawValue]
        let stylesSidebarViewController = styleTabViewItem.viewController as? StylesSidebarViewController
        
        assert(stylesSidebarViewController != nil)
        if let stylesSidebarViewController = stylesSidebarViewController, stylesSidebarViewController.styleSetManager == nil {
            
            stylesSidebarViewController.documentManager = documentManager
        }
    }
    
    private func prepareMarkdownTab(document: TextDocument?) {
        
    }
    
    private func updateTransitionsOptions(for sidebarTab: SidebarTab) {
        
        switch sidebarTab {
            
        case .markdown:
            
            // NSViewController.TransitionOptions.slideRight
            self.transitionOptions = NSViewController.TransitionOptions.crossfade
            
        case .style:
            
            // NSViewController.TransitionOptions.slideLeft
            self.transitionOptions = NSViewController.TransitionOptions.crossfade
        }
    }
    
    private func updateChildsRepresentedObject() {
        
        stylesSidebarViewController?.representedObject = self.representedObject
        markdownSidebarViewController?.representedObject = self.representedObject
    }
    
}

