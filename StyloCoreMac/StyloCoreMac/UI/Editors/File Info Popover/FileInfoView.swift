//
//  TextStatisticsView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-28.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os

final class FileInfoView: NSView, BackgroundColorBindable {
    
    @IBInspectable var backgroundColor: NSColor? {
        didSet {
            self.needsLayout = true
        }
    }
 
    weak var fileInfoViewController: FileInfoViewController?
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
