//
//  NSViewController+Additions.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-03.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

extension NSViewController: ViewControllersAccessor {
    
    public var windowController: StyloWindowController? {
        
        let window = self.view.window
        return window?.windowController as? StyloWindowController
    }
}
