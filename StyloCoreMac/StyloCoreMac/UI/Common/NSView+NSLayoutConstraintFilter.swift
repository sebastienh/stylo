//
//  NSView+NSLayoutConstraintFilter.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-02-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

extension NSView {

    ///
    /// Functions that returns an array of all the constraints affecting a 
    /// certain NSLayoutAttribute.
    ///
    func constraintsForAttribute(_ attribute: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
        
        return constraints.filter { (constraint) -> Bool in
            
            return constraint.firstAttribute == attribute
        }
    }
    
    ///
    /// Return the first constraint affecting a certain NSLayoutAttribute. 
    ///
    func constraintForAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {

        let constraints = constraintsForAttribute(attribute)
        
        if let first = constraints.first {
            
            return first
        }
        
        return nil
    }
    
}
