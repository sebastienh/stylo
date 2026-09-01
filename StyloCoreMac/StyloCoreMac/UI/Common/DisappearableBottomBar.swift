//
//  DisappearableBottomBar.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-02-18.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

protocol DisappearableBottomBar {
    
    func disposeOnTop(of topView: NSView)
    
}

extension DisappearableBottomBar where Self: NSView {
    
    func disposeOnTop(of topView: NSView) {
        
        // add it to the resourceEditorScrollView
        // see http://stackoverflow.com/questions/2872840/how-do-i-make-an-nsview-move-to-the-front-of-all-nsviews
        topView.addSubview(self, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
        
        // Create a constraint of the form "view1.attr1 <relation> view2.attr2 * multiplier + constant".
        let bottomConstraint = NSLayoutConstraint(item: self, attribute:NSLayoutConstraint.Attribute.bottom, relatedBy:NSLayoutConstraint.Relation.equal, toItem:topView, attribute:NSLayoutConstraint.Attribute.bottom, multiplier:1, constant:0)
        
        let leadingConstraint = NSLayoutConstraint(item: self, attribute:NSLayoutConstraint.Attribute.leading, relatedBy:NSLayoutConstraint.Relation.equal, toItem:topView, attribute:NSLayoutConstraint.Attribute.leading, multiplier:1, constant:0)
        
        let trailingConstraint = NSLayoutConstraint(item: self, attribute:NSLayoutConstraint.Attribute.trailing, relatedBy:NSLayoutConstraint.Relation.equal, toItem:topView, attribute:NSLayoutConstraint.Attribute.trailing, multiplier:1, constant:0)
        
        topView.addConstraint(bottomConstraint)
        topView.addConstraint(leadingConstraint)
        topView.addConstraint(trailingConstraint)
        topView.needsUpdateConstraints = true
    }
    
}
