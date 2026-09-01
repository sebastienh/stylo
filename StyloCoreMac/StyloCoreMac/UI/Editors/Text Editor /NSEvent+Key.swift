//
//  NSEvent+ArrowKey.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-08-06.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation

import Cocoa
import WriterCommon
import Common
import os

extension NSEvent {

    var isArrowKey: Bool {
        
        guard self.type == .keyDown else {
            return false
        }
        
        return self.keyCode == 123 || self.keyCode == 124 || self.keyCode == 125 || self.keyCode == 126
    }

    var isEscapeKey: Bool {
        
        return self.keyCode == 53
    }
    
    var isDeleteKey: Bool {
        
        return self.keyCode == 51
    }
    
    var isCutText: Bool {
        
        return self.keyCode == 7 && self.modifierFlags.contains(.command)
    }
    
    var isCopyText: Bool {
        
        return self.keyCode == 6 && self.modifierFlags.contains(.command)
    }
    
    var isTextEntry: Bool {
        
        if self.isEscapeKey {
            return false
        }
        
        if self.isCutText {
            return false
        }
        
        if self.isCopyText {
            return false
        }
        
        return true
    }
}
