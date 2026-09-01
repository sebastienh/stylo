//
//  NSView+TrackingArea.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-11-12.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

extension NSView {
    
    func addGlobalTrackingArea() {
        
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited), owner: self, userInfo: nil))
    }
    
}
