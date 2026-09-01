//
//  SidebarStylesScroller.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-31.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class SidebarStylesScroller: NSScroller {
    
    override class func scrollerWidth(for controlSize: NSControl.ControlSize, scrollerStyle: NSScroller.Style) -> CGFloat {
        
        return 4
    }
    
}
