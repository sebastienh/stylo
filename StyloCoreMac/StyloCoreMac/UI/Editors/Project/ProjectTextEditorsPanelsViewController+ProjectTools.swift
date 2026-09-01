//
//  ProjectTextEditorsPanelsViewController+ProjectTools.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-09-18.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

extension ProjectTextEditorsPanelsViewController {
    
    func listenToProjectToolsNotifications() {
        
        guard let window = self.view.window else {
            assertionFailure("Error: window is nil")
            return
        }

        NotificationCenter.default.addObserver(forName: StyloNotification.willHideNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handlewillHideNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willShowNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handlewillShowNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didHideNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handledidHideNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didShowNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handledidShowNavigator()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willExitFullScreen.name, object: window, queue: nil) { [weak self](_) in
            self?.handleWillExitFullScreen()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willEnterFullScreen.name, object: window, queue: nil) { [weak self](_) in
            self?.handleWillEnterFullScreen()
        }
    }
    
    private func handleWillExitFullScreen() {
        
        self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: self.leftButtonsShown, sidebarsShow: self.sidebarsShown, projectToolsShown: self.projectToolsShown, animate: false, fullscreen: false)
    }
    
    private func handleWillEnterFullScreen() {
        
        self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: self.leftButtonsShown, sidebarsShow: self.sidebarsShown, projectToolsShown: self.projectToolsShown, animate: false, fullscreen: true)
    }
    
    private func handlewillHideNavigator() {
        
        self.projectToolsShown = false
        let fullscreen: Bool = (self.view.window as? StyloWindow)?.fullScreen ?? false
        
        self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: self.leftButtonsShown, sidebarsShow: self.sidebarsShown, projectToolsShown: false, animate: false, fullscreen: fullscreen)
    }
    
    private func handlewillShowNavigator() {
        
        self.projectToolsShown = true
        let fullscreen: Bool = (self.view.window as? StyloWindow)?.fullScreen ?? false
        
        self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: self.leftButtonsShown, sidebarsShow: self.sidebarsShown, projectToolsShown: true, animate: false, fullscreen: fullscreen)
    }
    
    private func handledidHideNavigator() {
        
        self.projectToolsShown = false
        let fullscreen: Bool = (self.view.window as? StyloWindow)?.fullScreen ?? false
        self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: self.leftButtonsShown, sidebarsShow: self.sidebarsShown, projectToolsShown: false, animate: false, fullscreen: fullscreen)
    }

    private func handledidShowNavigator() {
        
        self.projectToolsShown = true
        let fullscreen: Bool = (self.view.window as? StyloWindow)?.fullScreen ?? false
        self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: true, sidebarsShow: self.sidebarsShown, projectToolsShown: true, animate: false, fullscreen: fullscreen)
    }
    
    
}
