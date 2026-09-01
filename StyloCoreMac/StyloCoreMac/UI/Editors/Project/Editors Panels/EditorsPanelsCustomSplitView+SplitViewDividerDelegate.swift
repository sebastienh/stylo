//
//  EditorsPanelsCustomSplitView+SplitViewDividerDelegate.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-24.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

extension EditorsPanelsCustomSplitView: SplitViewDividerDelegate {
    
    func mouseMoved(with event: NSEvent, in divider: EditorSplitViewDivider?) {

        if self.mouseIsDown {
            
            guard let mouseLocation = self.mouseLocation else {
                assertionFailure("Error: self.location is nil")
                return
            }
            
            let horizontalVariation = event.locationInWindow.x - mouseLocation.x
            self.movingDivider?.centerConstraint?.constant += horizontalVariation
            self.mouseLocation = event.locationInWindow
        }
    }
    
    func mouseDown(with event: NSEvent, in divider: EditorSplitViewDivider) {

        self.mouseLocation = event.locationInWindow
        self.movingDivider = divider
        self.dividerBeforeMovingDivider = self.splitViewDivider(before: divider)
        self.dividerAfterMovingDivider = self.splitViewDivider(after: divider)
        
        self.dividerBeforeMovingDivider?.fixLocation()
        self.dividerAfterMovingDivider?.fixLocation()
        movingDivider?.setDividerAbsolutePosition()
        
        self.movingDivider = divider
        self.mouseIsDown = true
        self.updateViewConstraints()
        sendWillMoveDividerNotification()
    }
    
    func mouseUp(with event: NSEvent, in divider: EditorSplitViewDivider) {
        
        self.mouseLocation = nil
        self.dividerBeforeMovingDivider?.unfixLocation()
        self.dividerAfterMovingDivider?.unfixLocation()
        
        assert(divider === self.movingDivider!)
        divider.setRelativeCenterConstraint()
        
        self.dividerBeforeMovingDivider = nil
        self.dividerAfterMovingDivider = nil
        self.movingDivider = nil
        self.mouseIsDown = false
        self.updateViewConstraints()
        sendDidMoveDividerNotification()
    }
    

    private func sendWillMoveDividerNotification() {
        
        guard let window = self.containerView.window else {
            assertionFailure("Error: self.containerView.window is nil")
            return
        }
        
        StyloNotification.willMoveDivider.sendNotification(window)
    }
    
    private func sendDidMoveDividerNotification() {
        
        guard let window = self.containerView.window else {
            assertionFailure("Error: self.containerView.window is nil")
            return
        }
        
        StyloNotification.didMoveDivider.sendNotification(window)
    }
    
    private func editorSplitViewItem(before divider: EditorSplitViewDivider) -> EditorSplitViewItem? {
        
        guard let index = self.index(of: divider) else {
            assertionFailure("Error: index of divider \(divider) is nil")
            return nil
        }
        
        return splitViewItems[index]
    }
    
    private func editorSplitViewItem(after divider: EditorSplitViewDivider) -> EditorSplitViewItem? {
        
        guard let index = self.index(of: divider) else {
            assertionFailure("Error: index of divider \(divider) is nil")
            return nil
        }
        
        return splitViewItems[index+1]
    }
    
    private func splitViewDivider(before divider: EditorSplitViewDivider) -> EditorSplitViewDivider? {
        
        guard let index = self.index(of: divider) else {
            assertionFailure("Error: index of divider \(divider) is nil")
            return nil
        }
        
        guard index > 0 else {
            return nil
        }
        
        return self.dividers[index-1]
    }
    
    private func splitViewDivider(after divider: EditorSplitViewDivider) -> EditorSplitViewDivider? {
        
        guard let index = self.index(of: divider) else {
            assertionFailure("Error: index of divider \(divider) is nil")
            return nil
        }
        
        guard index < self.dividers.count-2 else {
            return nil
        }
        
        return self.dividers[index+1]
    }
    
    private func index(of divider: EditorSplitViewDivider) -> Int? {
        
        for (index, _divider) in self.dividers.enumerated() {
            if _divider === divider {
                return index
            }
        }
        return nil
    }
    
}


