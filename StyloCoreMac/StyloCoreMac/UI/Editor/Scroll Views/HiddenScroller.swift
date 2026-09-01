//
//  HiddenScrollView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-19.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

public final class HiddenScroller: NSScroller {
    
    override public class func scrollerWidth(for controlSize: NSControl.ControlSize, scrollerStyle: NSScroller.Style) -> CGFloat {
            
        return 0
    }
    
}
