//
//  NSWindowController+ViewControllersAccessor.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-03.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

import Cocoa
import WriterCommon

extension StyloWindowController: ViewControllersAccessor {
    
    public var windowController: StyloWindowController? {
        
        return self
    }
}
