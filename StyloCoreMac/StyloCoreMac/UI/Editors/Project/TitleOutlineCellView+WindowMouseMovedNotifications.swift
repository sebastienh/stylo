//
//  TitleOutlineCellView+WindowMouseMovedNotifications.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-09-18.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation

extension TitleOutlineCellView {

    func listenToWindowMouseMoveNotifications() {
        
        NotificationCenter.default.removeObserver(self)
        
        guard let window = self.window else {
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.windowMouseMoved.name, object: window, queue: nil) { [weak self](_) in
            self?.handleWindowMouseMove()
        }
    }
    
    private func handleWindowMouseMove() {
        
        self.showInformationButton()
        
    }
    
}
