//
//  GlobalBackgroundView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-22.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os

class GlobalBackgroundView: NSView {
    
    override var allowsVibrancy: Bool {
        
        return false
    }
    
    override var isOpaque: Bool {
        
        return true
    }
    
    override var isFlipped: Bool {
        
        return true
    }
    
    private var topTrackingRect: NSRect {
        
        return NSMakeRect(0, 0, self.bounds.size.width, InterfaceConstants.Global.TopMouseMovedTrackingHeight)
    }
    
    private var leftTrackingRect: NSRect {
        
        return NSMakeRect(0, 0, InterfaceConstants.Global.SidesMouseMovedTrackingWidth, self.bounds.size.height)
    }
    
    private var rightTrackingRect: NSRect {
        
        return NSMakeRect(self.bounds.size.width-InterfaceConstants.Global.SidesMouseMovedTrackingWidth, 0, InterfaceConstants.Global.SidesMouseMovedTrackingWidth, self.bounds.size.height)
    }
    
    private var topTrackingArea: NSTrackingArea?
    
    private var leftTrackingArea: NSTrackingArea?
    
    private var rightTrackingArea: NSTrackingArea?
    
    private var sideTrackingAreasPresent: Bool {
        
        return leftTrackingArea != nil && rightTrackingArea != nil
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    required init?(coder decoder: NSCoder) {
        
        super.init(coder: decoder)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    override func mouseMoved(with event: NSEvent) {

        StyloNotification.windowMouseMoved.sendNotification(self.window!)
        
        let point = self.convert(event.locationInWindow, from: nil)
        
        guard let styloWindow = self.window as? StyloWindow else {
            assertionFailure("Error: self.window is nil")
            return
        }
        
        if NSPointInRect(point, topTrackingRect) {
            styloWindow.showLeftButtons()
            StyloNotification.windowTopMouseMoved.sendNotification(styloWindow)
        }
        else if NSPointInRect(point, leftTrackingRect) || NSPointInRect(point, rightTrackingRect) {
            
            guard let globalMenuPanelViewController = styloWindow.styloWindowController.globalMenuPanelViewController else {
                assertionFailure("Error: styloWindow.styloWindowController.globalMenuPanelViewController is nil")
                return
            }
            
//            globalMenuPanelViewController.showSidebars()
        }
    }
    
    override func mouseEntered(with event: NSEvent) {

        let point = self.convert(event.locationInWindow, from: nil)
        
        guard let styloWindow = self.window as? StyloWindow else {
            assertionFailure("Error: self.window is nil")
            return
        }
        
        if NSPointInRect(point, topTrackingRect) {
            styloWindow.showLeftButtons()
            StyloNotification.windowTopMouseMoved.sendNotification(styloWindow)
        }
        else if NSPointInRect(point, leftTrackingRect) || NSPointInRect(point, rightTrackingRect) {
            
            guard let globalMenuPanelViewController = styloWindow.styloWindowController.globalMenuPanelViewController else {
                assertionFailure("Error: styloWindow.styloWindowController.globalMenuPanelViewController is nil")
                return
            }
            
//            globalMenuPanelViewController.showSidebars()
        }
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        self.updateTrackingAreas()
        
    }
    
    override func updateTrackingAreas() {
        
        super.updateTrackingAreas()
        
        if sideTrackingAreasPresent {
            removeSideTrackingAreas()
            createSideTrackingAreas()
        }
        removeTopTrackingAreas()
        createTopTrackingArea()
    }
    
    private func removeTopTrackingAreas() {
        
        if let topTrackingArea = self.topTrackingArea {
            self.removeTrackingArea(topTrackingArea)
        }
    }
    
    func removeSideTrackingAreas() {
        
        if let leftTrackingArea = self.leftTrackingArea {
            self.removeTrackingArea(leftTrackingArea)
        }
        if let rightTrackingArea = self.rightTrackingArea {
            self.removeTrackingArea(rightTrackingArea)
        }
    }
    
    private func createTopTrackingArea() {
    
        let options = NSTrackingArea.Options.activeInActiveApp.union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseMoved)
        
        let topTrackingArea = NSTrackingArea(rect: self.topTrackingRect, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(topTrackingArea)
        self.topTrackingArea = topTrackingArea
    }
    
    func createSideTrackingAreas() {
        
        let options = NSTrackingArea.Options.activeInActiveApp.union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.activeInKeyWindow)
        
        let leftTrackingRect = self.leftTrackingRect
        let leftTrackingArea = NSTrackingArea(rect: leftTrackingRect, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(leftTrackingArea)
        self.leftTrackingArea = leftTrackingArea
        
        let rightTrackingRect = self.rightTrackingRect
        let rightTrackingArea = NSTrackingArea(rect: rightTrackingRect, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(rightTrackingArea)
        self.rightTrackingArea = rightTrackingArea
    }
}
