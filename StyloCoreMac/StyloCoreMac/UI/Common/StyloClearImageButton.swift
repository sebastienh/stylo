//
//  StyloClearImageButton.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-18.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

final class StyloClearImageButton: StyloButton {
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        self.image!.backgroundColor = NSColor.clear
    }
    
    
    
}


