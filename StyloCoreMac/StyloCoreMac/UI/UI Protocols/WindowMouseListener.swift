//
//  WindowMouseListener.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-09-16.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

protocol WindowTopMouseListener {
    
    func subscribeToWindowMouseMovedNotifications()
    
    func unsubscribeFromWindowMouseMovedNotifications()
    
    func handleWindowWindowTopMouseMovedEvent()
}

extension WindowTopMouseListener where Self: NSViewController {
    
    func subscribeToWindowMouseMovedNotifications() {
        
        guard let window = self.view.window else {
            assertionFailure("Error: window is nil")
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.windowTopMouseMoved.name, object: window, queue: nil) { [weak self](_) in
            self?.handleWindowWindowTopMouseMovedEvent()
        }
    }
    
    func unsubscribeFromWindowMouseMovedNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
}
