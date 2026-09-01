//
//  FilesOutlineSplitView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-28.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class FilesOutlineSplitView: NSSplitView {
    
    override var dividerThickness: CGFloat {
        
        return InterfaceConstants.EditorsPanel.DividerWidth
    }

    override var dividerColor: NSColor {
        
        return nsColor(named: "EditorsPaneSeparatorColor", bundle: Bundle(for: type(of: self)))
    }
    
    private var leftTrackingRect: NSRect {
        
        return NSMakeRect(0, 0, InterfaceConstants.Global.SidesMouseMovedTrackingWidth, self.bounds.size.height)
    }
    
    private var rightTrackingRect: NSRect {
        
        return NSMakeRect(self.bounds.size.width-InterfaceConstants.Global.SidesMouseMovedTrackingWidth, 0, InterfaceConstants.Global.SidesMouseMovedTrackingWidth, self.bounds.size.height)
    }
    
    private var leftTrackingArea: NSTrackingArea?
    
    private var rightTrackingArea: NSTrackingArea?
    
    private var sideTrackingAreasPresent: Bool {
        
        return self.leftTrackingArea != nil && self.rightTrackingArea != nil
    }
    
    private var projectTextEditorsPanelsViewController: ProjectTextEditorsPanelsViewController? {
        var responder = self.nextResponder
        while responder != nil {
            if let projectTextEditorsPanelsViewController = responder as? ProjectTextEditorsPanelsViewController {
                return projectTextEditorsPanelsViewController
            }
            responder = responder?.nextResponder
        }
        return nil
    }

    override func mouseMoved(with event: NSEvent) {
        
        self.handleMouse(with: event)
    }
    
    override func mouseEntered(with event: NSEvent) {

        self.handleMouse(with: event)
    }

    private func handleMouse(with event: NSEvent) {
        
        let point = self.convert(event.locationInWindow, from: nil)
        
        guard let projectTextEditorsPanelsViewController = self.projectTextEditorsPanelsViewController else {
            assertionFailure("Error: self.projectTextEditorsPanelsViewController is nil")
            return
        }
        
        if NSPointInRect(point, leftTrackingRect) || NSPointInRect(point, rightTrackingRect) {
            
            // editor mouse move on the right or left side show:
            // - Markdown Quick Formatting Tools
            // - Disclose Right Sidebar Button
            // - Disclose Left Sidebar Button
            NSAnimationContext.runAnimationGroup({ context in
                
                // Customize the animation parameters.
                context.duration = StyloConstants.EditorsPane.UncollapseAnimationTime
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                context.allowsImplicitAnimation = true
                
                projectTextEditorsPanelsViewController.markdownQuickFormattingToolsViewController?.view.alphaValue = 1
                projectTextEditorsPanelsViewController.leftSidebarButton?.alphaValue = 1
                projectTextEditorsPanelsViewController.rightSidebarButton?.alphaValue = 1
                
            })
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
    }

    private func removeSideTrackingAreas() {
        
        if let leftTrackingArea = self.leftTrackingArea {
            self.removeTrackingArea(leftTrackingArea)
        }
        if let rightTrackingArea = self.rightTrackingArea {
            self.removeTrackingArea(rightTrackingArea)
        }
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
