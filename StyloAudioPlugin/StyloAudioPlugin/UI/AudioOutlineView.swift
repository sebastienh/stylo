//
//  AudioFilesOutline.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

class AudioOutlineView: NSOutlineView {
    
    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        
        if identifier == NSOutlineView.disclosureButtonIdentifier {
            
            return nil
        }
        return super.makeView(withIdentifier: identifier, owner: owner)
    }
}

