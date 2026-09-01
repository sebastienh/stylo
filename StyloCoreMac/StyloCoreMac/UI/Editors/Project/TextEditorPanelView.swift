//
//  TextEditorPanelView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-18.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
      
class TextEditorPanelView: NSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
