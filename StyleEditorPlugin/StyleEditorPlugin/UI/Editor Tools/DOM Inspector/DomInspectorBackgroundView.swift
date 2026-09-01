//
//  DomInspectorBackgroundView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-07.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import StyloCoreMac

class DomInspectorBackgroundView: NSView, BackgroundColorBindable {
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
    }
    
    required init?(coder decoder: NSCoder) {
        
        super.init(coder: decoder)
        self.wantsLayer = true
        
        // default color 
        self.backgroundColor = InterfaceConstants.EditorTools.DomInspector.BackgroundColor.cgColor
    }
}
