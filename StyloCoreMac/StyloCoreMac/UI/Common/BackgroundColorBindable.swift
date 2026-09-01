//
//  BackgroundColorBindable.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-01.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os
import Cocoa

public protocol BackgroundColorBindable: class {
    
    var backgroundColor: CGColor? { get set }
    
}

extension BackgroundColorBindable where Self: NSView {
    
    public var backgroundColor: CGColor? {
        
        get {
            return self.layer?.backgroundColor
        }
        set {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Updating backgroundColor to: %@", log: Log.StyloCore.all, type: .info, %%newValue)
            #endif
            assert(self.layer != nil)
            self.layer?.backgroundColor = newValue
        }
    }
}
