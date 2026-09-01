//
//  ExtendedOutlineViewDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

protocol ExtendedOutlineViewDelegate: class {
    
    func outlineView(_ outlineView: NSOutlineView, didClickedRow row: NSInteger)
    
}
