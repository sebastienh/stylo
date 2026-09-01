//
//  AutocompleteTableView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-02-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

final class AutocompleteTableView: NSTableView {
    
    override func awakeFromNib() {
        
        intercellSpacing = NSMakeSize(0, 0)
        
        super.awakeFromNib()
    }

}
