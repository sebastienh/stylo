//
//  ProjectTextEditorsOutlineView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

class ProjectTextEditorsOutlineView: NSOutlineView {
    
    override var intercellSpacing: NSSize {
        set {}
        get {
            return NSMakeSize(0, 0.5)
        }
    }
    
    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        
        if identifier == NSOutlineView.disclosureButtonIdentifier {
            return nil
        }
        
        return super.makeView(withIdentifier: identifier, owner: owner)
    }
    
}
