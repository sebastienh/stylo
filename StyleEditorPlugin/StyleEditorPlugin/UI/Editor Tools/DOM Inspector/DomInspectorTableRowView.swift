//
//  DomInspectorTableRowView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-08.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Web
import Common

/// see http://stackoverflow.com/questions/11127764/how-to-customize-disclosure-cell-in-view-based-nsoutlineview
final class DomInspectorTableRowView: NSTableRowView {

    var domRenderable: DomRenderable!
    
    var item: Node?
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.backgroundColor = NSColor.clear
    }
    
    required init?(coder decoder: NSCoder) {
        
        super.init(coder: decoder)
        self.backgroundColor = NSColor.clear
    }
}
