//
//  WorkingOverlayableView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-09-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common

protocol WorkingOverlayViewController: class {
    
    var styleApplied: Bool { get }
    
    var documentWorkingViewController: NSViewController { get }
    
    var styloWindowController: StyloWindowController? { get }
    
    var timer: CancellableTimer { get }
    
    var documentWorkingOverlayTopConstraint: NSLayoutConstraint? { get set }
    
    var documentWorkingOverlayBottomConstraint: NSLayoutConstraint? { get set }
    
    var documentWorkingOverlayLeadingConstraint: NSLayoutConstraint? { get set }
    
    var documentWorkingOverlayTrailingConstraint: NSLayoutConstraint? { get set }
    
    func displayApplyStyleDocumentWorkingOverlay(after delay: Int)
    
    func cancelCurrentDocumentOverlay()
    
}

extension WorkingOverlayViewController where Self: NSViewController {
    
    var styloWindowController: StyloWindowController? {
        
        return self.view.window?.windowController as? StyloWindowController
    }
    
    var styleApplied: Bool {
        
        guard let styloWindowController = self.styloWindowController else {
            assertionFailure("Error: self.styloWindowController is nil")
            return false
        }
        
        return styloWindowController.styleApplied
    }
    
    func displayApplyStyleDocumentWorkingOverlay(after delay: Int) {
        
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) { [weak self] in
                self?.addDocumentWorkingOverlayControllerViewIfStyleNotApplied()
            }
        }
        else {
            self.addDocumentWorkingOverlayControllerViewIfStyleNotApplied()
        }
    }
    
    private func addDocumentWorkingOverlayControllerViewIfStyleNotApplied() {
        
        if !self.styleApplied {
            
            self.view.addSubview(self.documentWorkingViewController.view, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
            self.addDocumentWorkingOverlayConstraints()
        }
    }
    
    func cancelCurrentDocumentOverlay() {
        
        timer.cancel()
    }
    
    func removeDocumentWorkingOverlay() {
        
        cancelCurrentDocumentOverlay()
        
        removeDocumentWorkingOverlayConstraints()
        if documentWorkingViewController.view.window != nil {
            documentWorkingViewController.view.removeFromSuperview()
        }
    }
    
    private func addDocumentWorkingOverlayConstraints() {
        
        let topConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: documentWorkingViewController.view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        
        self.view.addConstraint(topConstraint)
        self.view.addConstraint(bottomConstraint)
        self.view.addConstraint(leadingConstraint)
        self.view.addConstraint(trailingConstraint)
        
        documentWorkingOverlayTopConstraint = topConstraint
        documentWorkingOverlayBottomConstraint = bottomConstraint
        documentWorkingOverlayLeadingConstraint = leadingConstraint
        documentWorkingOverlayTrailingConstraint = trailingConstraint
        
        self.view.needsUpdateConstraints = true
    }
    
    private func removeDocumentWorkingOverlayConstraints() {
        
        if let documentWorkingOverlayTopConstraint = documentWorkingOverlayTopConstraint {
            self.view.removeConstraint(documentWorkingOverlayTopConstraint)
        }
        if let documentWorkingOverlayBottomConstraint = documentWorkingOverlayBottomConstraint {
            self.view.removeConstraint(documentWorkingOverlayBottomConstraint)
        }
        if let documentWorkingOverlayLeadingConstraint = documentWorkingOverlayLeadingConstraint {
            self.view.removeConstraint(documentWorkingOverlayLeadingConstraint)
        }
        if let documentWorkingOverlayTrailingConstraint = documentWorkingOverlayTrailingConstraint {
            self.view.removeConstraint(documentWorkingOverlayTrailingConstraint)
        }
        self.view.needsUpdateConstraints = true
    }
    
}
