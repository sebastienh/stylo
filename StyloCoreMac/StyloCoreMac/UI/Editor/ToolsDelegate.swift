//
//  ToolsDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-13.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

protocol ToolsDelegate: class {
    
    func showDomTool(_ sender: Any)
    
    func showErrorTool(_ sender: NSButton)
}
