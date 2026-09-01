//
//  DisableableButton.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-07-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon

open class MacDisableableButton: NSButton, DisableableButton {
    
    public var wasEnabled: Bool = false
    
    public func disableUserInteractions() {
    
        self.wasEnabled = self.isEnabled
        self.isEnabled = false
    }
    
    public func enableUserInteractions() {
        
        if self.wasEnabled {
            self.isEnabled = true
        }
    }
}
