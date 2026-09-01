//
//  NoIssuesView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-01-30.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import StyloCoreMac
import Cocoa

class NoIssuesView: NSView, BackgroundColorBindable {
    
    @IBInspectable dynamic var backgroundColor: CGColor? {
        
        get {
            return self.layer?.backgroundColor
        }
        set {
            self.layer?.backgroundColor = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
    }
    
    override func updateLayer() {
        
        let colorName = NSColor.Name("UnselectedTableCellViewBackgroundColor")
        let color = NSColor(named: colorName)
        
        assert(color != nil)
        if let color = color {
            
            self.backgroundColor = color.cgColor
        }
        super.updateLayer()
    }
    
}
