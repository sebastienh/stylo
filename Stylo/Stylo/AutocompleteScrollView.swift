//
//  AutocompleteScrollView.swift
//  Nebula Writer
//
//  Created by Sebastien hamel on 2016-02-18.
//  Copyright © 2016 Nebula Media. All rights reserved.
//

import Foundation
import Cocoa

class AutocompleteScrollView: NSScrollView {
    
    override var intrinsicContentSize: NSSize {
        
        return documentView!.intrinsicContentSize
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
}