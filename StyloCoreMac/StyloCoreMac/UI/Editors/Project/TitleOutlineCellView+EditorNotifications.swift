//
//  TitleOutlineCellView+EditorNotifications.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-09-18.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation

extension TitleOutlineCellView {

    func listenToEditorsNotifications() {
        
        NotificationCenter.default.removeObserver(self)
        
        guard let window = self.window else {
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
        
        self.hideInformationButton()
        
    }
    
    private func handleEditorKeyDown() {

        self.hideInformationButton()
    }
    
}
