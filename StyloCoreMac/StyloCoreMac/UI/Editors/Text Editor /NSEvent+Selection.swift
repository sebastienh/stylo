//
//  NSEvent+Selection.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-06-28.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

extension NSEvent {
    
    var isSelection: Bool {
        
        if self.keyCode == 123 || self.keyCode == 124 || self.keyCode == 125 || self.keyCode == 126 {
            if self.modifierFlags.contains(.shift) {
                return true
            }
        }
        
        return false
    }
    
}
