//
//  ProjectTextEditorsPanelsViewController+EditorNotifications.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-09-18.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation

extension ProjectTextEditorsPanelsViewController {

    func listenToEditorsNotifications() {
        
        guard let window = self.view.window else {
            assertionFailure("Error: window is nil")
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.editorMouseDown.name, object: window, queue: nil) { [weak self](_) in
            self?.handleEditorMouseDown()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.editorKeyDown.name, object: window, queue: nil) { [weak self](_) in
            self?.handleEditorKeyDown()
        }
    }
    
    private func handleEditorMouseDown() {
        
        self.requestTitlesCollapseAndHidingFloatingSideButtons()
    }
    
    private func handleEditorKeyDown() {
        
        self.hideFloatingSideButtons()
    }
    
}
