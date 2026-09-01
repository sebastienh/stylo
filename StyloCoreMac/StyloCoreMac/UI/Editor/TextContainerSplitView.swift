//
//  TextContainerSplitView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-08-05.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

final class TextContainerSplitView: NSSplitView {
    
    override var dividerThickness: CGFloat {
        
        return 0
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        self.translatesAutoresizingMaskIntoConstraints = false 
    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
