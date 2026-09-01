//
//  ProjectTextEditorsPanelsViewController+LeftButtons.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-09-18.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation

extension ProjectTextEditorsPanelsViewController {

     func listenToLeftButtonsNotifications() {
         
         guard let window = self.view.window else {
             assertionFailure("Error: window is nil")
             return
         }
         
         NotificationCenter.default.addObserver(forName: StyloNotification.willShowLeftButtons.name, object: window, queue: nil) { [weak self](_) in
             self?.leftButtonsShown = true
             self?.handleWillShowLeftButtons()
         }
         
         NotificationCenter.default.addObserver(forName: StyloNotification.willHideLeftButtons.name, object: window, queue: nil) { [weak self](_) in
             self?.leftButtonsShown = false
         }
         
         NotificationCenter.default.addObserver(forName: StyloNotification.didShowLeftButtons.name, object: window, queue: nil) { [weak self](_) in
             self?.leftButtonsShown = true
         }
         
         NotificationCenter.default.addObserver(forName: StyloNotification.didHideLeftButtons.name, object: window, queue: nil) { [weak self](_) in
             self?.leftButtonsShown = false
             self?.handleDidHideLeftButtons()
         }
     }

     private func handleWillShowLeftButtons() {
         
         let fullscreen: Bool = (self.view.window as? StyloWindow)?.fullScreen ?? false
         self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: true, sidebarsShow: self.sidebarsShown, projectToolsShown: self.projectToolsShown, animate: true, fullscreen: fullscreen)
     }
     
     private func handleDidHideLeftButtons() {
         
         let fullscreen: Bool = (self.view.window as? StyloWindow)?.fullScreen ?? false
         self.projectTextEditorsLists.first?.updateTopButtonsLeftMargin(forFirstFilesOutlineManager: true, leftButtonsShown: false, sidebarsShow: self.sidebarsShown, projectToolsShown: self.projectToolsShown, animate: true, fullscreen: fullscreen)
     }
    
}
