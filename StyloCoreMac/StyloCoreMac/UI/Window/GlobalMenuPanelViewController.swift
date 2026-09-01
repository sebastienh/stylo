//
//  GlobalMenuPanelViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-02.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import PromiseKit
import os

//finish this: the TextKeydownListener is there to catch the Keydown events
//and make the menu disappear.
//The StyloWindow will be responsible to let us know when to display the menu again,
//but all methods should be defined here.
public class GlobalMenuPanelViewController: NSViewController {

    weak var documentManager: DocumentManager?
    
    private var projectTextEditorsTableViewControllers: [ProjectTextEditorsTableViewController]? {
        
        guard let styloWindowController = self.view.window?.windowController as? StyloWindowController else {
            assertionFailure("Error: windowController is nil")
            return nil
        }
        
        return styloWindowController.projectTextEditorsTableViewControllers
    }
    
    private var projectTextEditorsPanelsViewController: ProjectTextEditorsPanelsViewController? {
        
        guard let styloWindowController = self.view.window?.windowController as? StyloWindowController else {
            assertionFailure("Error: windowController is nil")
            return nil
        }
        
        return styloWindowController.projectTextEditorsPanelsViewController
    }
    
    var projectTextEditorsTabViewControllers: [ProjectTextEditorsTabViewController]? {
        
        guard let styloWindowController = self.view.window?.windowController as? StyloWindowController else {
            assertionFailure("Error: windowController is nil")
            return nil
        }
        
        return styloWindowController.projectTextEditorsTabViewControllers
    }
    
    var projectTextEditorsLists: [ProjectTextEditorsList]? {
        
        guard let styloWindowController = self.view.window?.windowController as? StyloWindowController else {
            assertionFailure("Error: windowController is nil")
            return nil
        }
        
        return styloWindowController.projectTextEditorsLists
    }

    private var listeningToAppearance = false
    
    private var globalBackgroundView: GlobalBackgroundView? {
        
        return self.view as? GlobalBackgroundView
    }
    
    override public func viewWillAppear() {
        
        assert(documentManager != nil)
        globalBackgroundView?.createSideTrackingAreas()
        listenToGlobalAppearanceChange()
        super.viewWillAppear()
    }

    private func listenToGlobalAppearanceChange() {
        
        if !listeningToAppearance {

            assert(StyloApplication.shared.computedAppearance.value?.appearance != nil)
            self.view.appearance = StyloApplication.shared.computedAppearance.value?.appearance ?? AppearanceMode.dark.appearance
            
            StyloApplication.shared.computedAppearance.subscribe({ [weak self](appearanceMode) in
                assert(appearanceMode != nil)
                self?.view.appearance = appearanceMode?.appearance ?? AppearanceMode.dark.appearance
            }, observer: self)
            
            listeningToAppearance = true
        }
    }

    private func enableScrolling() {
        
        guard let projectTextEditorsTableViewControllers = self.projectTextEditorsTableViewControllers else {
            assertionFailure("Error: projectTextEditorsTableViewControllers is nil")
            return
        }
        
        for projectTextEditorsTableViewController in projectTextEditorsTableViewControllers {
            
            projectTextEditorsTableViewController.scrollView.restoreScrolling()
        }
    }
    
    private func disableScrolling() {
        
        guard let projectTextEditorsTableViewControllers = self.projectTextEditorsTableViewControllers else {
            assertionFailure("Error: projectTextEditorsTableViewControllers is nil")
            return
        }
        
        for projectTextEditorsTableViewController in projectTextEditorsTableViewControllers {
            
            projectTextEditorsTableViewController.scrollView.disableScrolling()
        }
    }
    
    deinit {
        self.documentManager?.effectiveAppearance.unsubscribe(observer: self)
    }
    
}
