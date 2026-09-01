//
//  ProjectTextEditorsEmptySelectionViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-11-14.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon

class ProjectTextEditorsEmptySelectionViewController: NSViewController {
    
    @IBOutlet var verticalCenterConstraint: NSLayoutConstraint?
    
    @IBOutlet var noTextsView: NoTextsView!
    
    func moveText(by value: CGFloat) {
        
        guard let verticalCenterConstraint = self.verticalCenterConstraint else {
            assertionFailure("Error: self.verticalCenterConstraint is nil")
            return
        }
        
        verticalCenterConstraint.constant += value
    }
    
    func resetCenterPosition() {
        
        guard let verticalCenterConstraint = self.verticalCenterConstraint else {
            assertionFailure("Error: self.verticalCenterConstraint is nil")
            return
        }
        
        verticalCenterConstraint.constant = 0
    }
}
