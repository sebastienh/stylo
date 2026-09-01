//
//  WindowMouseListener.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-09-16.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

protocol WindowTopMouseListener {
    
    func subscribeToWindowTopMouseEventsNotifications()
    
    func unsubscribeFromWindowTopMouseEventsNotifications()
    
    func handleWindowTopMouseEvent()
}

extension WindowTopMouseListener where Self: NSViewController {
    
    func subscribeToWindowTopMouseEventsNotifications() {
        
        guard let window = self.view.window else {
            assertionFailure("Error: window is nil")
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.windowTopMouseMoved.name, object: window, queue: nil) { [weak self](_) in
            self?.handleWindowTopMouseEvent()
        }
    }
    
    func unsubscribeFromWindowTopMouseEventsNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
}
