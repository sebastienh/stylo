//
//  TextKeydownListener.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-02-17.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common

protocol TextKeydownListener {
    
    func startListeningToKeydownEvents()
    
    func handleKeydownEvent(with event: NSEvent)
    
    func stopListeningToKeydownEvents()
}

extension TextKeydownListener where Self: NSWindowController {
    
    func startListeningToKeydownEvents() {
        
        NotificationCenter.default.addObserver(forName: StyloNotification.editorKeyDown.name, object: self.window!, queue: nil) { [weak self](notification) in
            
            let event = notification.userInfo?[WriterCommon.Constants.Notifications.Event] as! NSEvent
            self?.handleKeydownEvent(with: event)
        }
    }
    
    func stopListeningToKeydownEvents() {
        
        NotificationCenter.default.removeObserver(self, name: StyloNotification.editorKeyDown.name, object: self.window!)
    }
}

extension TextKeydownListener where Self: NSViewController {
    
    func startListeningToKeydownEvents() {
        
        guard let window = self.view.window else {
            assertionFailure("Error: window is nil")
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.editorKeyDown.name, object: window, queue: nil) { [weak self](notification) in
            
            let event = notification.userInfo?[WriterCommon.Constants.Notifications.Event] as! NSEvent
            self?.handleKeydownEvent(with: event)
        }
    }
    
    func stopListeningToKeydownEvents() {
        
        NotificationCenter.default.removeObserver(self, name: StyloNotification.editorKeyDown.name, object: self.view.window)
    }
}

extension TextKeydownListener where Self: NSWindow {
    
    func startListeningToKeydownEvents() {
        
        NotificationCenter.default.addObserver(forName: StyloNotification.editorKeyDown.name, object: self, queue: nil) { [weak self](notification) in
            
            let event = notification.userInfo?[WriterCommon.Constants.Notifications.Event] as! NSEvent
            self?.handleKeydownEvent(with: event)
        }
    }
    
    func stopListeningToKeydownEvents() {
        
        NotificationCenter.default.removeObserver(self, name: StyloNotification.editorKeyDown.name, object: self)
    }
}

extension TextKeydownListener where Self: NSView {
    
    func startListeningToKeydownEvents() {
        
        guard let window = self.window else {
            assertionFailure("Error: window is nil")
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.editorKeyDown.name, object: window, queue: nil) { [weak self](notification) in
            
            let event = notification.userInfo?[WriterCommon.Constants.Notifications.Event] as! NSEvent
            self?.handleKeydownEvent(with: event)
        }
    }
    
    func stopListeningToKeydownEvents() {
        
        NotificationCenter.default.removeObserver(self, name: StyloNotification.editorKeyDown.name, object: self.window)
    }
}
