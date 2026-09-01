//
//  NSColor+Assets.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-10-16.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

public func cgColor(named name: String, bundle: Bundle? = nil) -> CGColor? {
  
    return nsColor(named: name, bundle: bundle).cgColor
}

public func nsColor(named name: String) -> NSColor {

    return nsColor(named: name, bundle: nil)
}

public func nsColor(named name: String, bundle: Bundle?) -> NSColor {
    
    let color = NSColor(named: NSColor.Name(string: name), bundle: bundle)
    assert(color != nil)
    return color!
}

