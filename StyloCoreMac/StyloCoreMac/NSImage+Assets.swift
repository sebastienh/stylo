//
//  NSImage+Assets.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-27.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

public func nsImage(named name: String) -> NSImage {

    return nsImage(named: name, bundle: nil)
}

public func nsImage(named name: String, bundle: Bundle?) -> NSImage {
    
    if let bundle = bundle {
        let image = bundle.image(forResource: NSImage.Name(string: name))
        assert(image != nil)
        return image!
    }
    
    let image = NSImage(named: NSImage.Name(string: name))
    assert(image != nil)
    return image!
}
