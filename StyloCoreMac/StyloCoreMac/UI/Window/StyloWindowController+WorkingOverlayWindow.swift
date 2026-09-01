//
//  StyloWindowController+WorkingOverlayWindow.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-06-24.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os
import WriterCommon
import PromiseKit

extension StyloWindowController {

    public func displayWorkingOverlayWindow(delay: Int, disableCondition: @escaping () -> Bool) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("displayWorkingOverlayWindow(delay: %@, disableCondition: %@)", log: Log.StyloCore.all, type: .info, %%delay, %%disableCondition)
        #endif
        
        self.disableControls(after: delay, disableCondition: disableCondition)
        self.disableTextEditors(after: delay, disableCondition: disableCondition)
        
        self.contentViewController?.view.addSubview(self.documentWorkingViewController.view, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
        self.addDocumentWorkingOverlayConstraints()
    }
    
    func cancelCurrentDocumentOverlay() {
        
        timer.cancel()
    }
    
    public func removeDocumentWorkingOverlay() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("removeDocumentWorkingOverlay()", log: Log.StyloCore.all, type: .info)
        #endif
        
        cancelCurrentDocumentOverlay()
        
        removeDocumentWorkingOverlayConstraints()
        if documentWorkingViewController.view.window != nil {
            documentWorkingViewController.view.removeFromSuperview()
        }
        
        self.enableTextEditors()
        self.enableControls()
    }
    
    private func disableControls(after delay: Int, disableCondition: @escaping () -> Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            if disableCondition() {
                self.styloDocument?.documentWillDisableProjectPanel()
                self.documentManager?.pluginManager?.documentWillDisableProjectPanel()
                self.documentManager?.pluginManager?.disableStyleControls()
            }
        }
    }
    
    private func disableTextEditors(after delay: Int, disableCondition: @escaping () -> Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            if disableCondition() {
                self.disableEditors()
            }
        }
    }
    
    private func enableControls() {
        
        self.styloDocument?.documentWillEnableProjectPanel()
        self.documentManager?.pluginManager?.enableStyleControls()
        self.documentManager?.pluginManager?.documentWillEnableProjectPanel()
    }
    
    private func enableTextEditors() {
        
        self.enableEditors()
    }
    
    private func addDocumentWorkingOverlayConstraints() {
         
        guard let view = self.contentViewController?.view else {
            assertionFailure("Error: self.contentViewController?.view is nil")
            return
        }
        
         let topConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
         
         let bottomConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
         
         let leadingConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
         
         let trailingConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
         
         view.addConstraint(topConstraint)
         view.addConstraint(bottomConstraint)
         view.addConstraint(leadingConstraint)
         view.addConstraint(trailingConstraint)
         
         documentWorkingOverlayTopConstraint = topConstraint
         documentWorkingOverlayBottomConstraint = bottomConstraint
         documentWorkingOverlayLeadingConstraint = leadingConstraint
         documentWorkingOverlayTrailingConstraint = trailingConstraint
         
         view.needsUpdateConstraints = true
     }
     
     private func removeDocumentWorkingOverlayConstraints() {
     
        guard let view = self.contentViewController?.view else {
            assertionFailure("Error: self.contentViewController?.view is nil")
            return
        }
        
         if let documentWorkingOverlayTopConstraint = documentWorkingOverlayTopConstraint {
             view.removeConstraint(documentWorkingOverlayTopConstraint)
         }
         if let documentWorkingOverlayBottomConstraint = documentWorkingOverlayBottomConstraint {
             view.removeConstraint(documentWorkingOverlayBottomConstraint)
         }
         if let documentWorkingOverlayLeadingConstraint = documentWorkingOverlayLeadingConstraint {
             view.removeConstraint(documentWorkingOverlayLeadingConstraint)
         }
         if let documentWorkingOverlayTrailingConstraint = documentWorkingOverlayTrailingConstraint {
             view.removeConstraint(documentWorkingOverlayTrailingConstraint)
         }
         view.needsUpdateConstraints = true
     }
     
    
}
