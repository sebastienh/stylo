//
//  NSImage+String.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-04.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {
    
    static func image(with attributedString: NSAttributedString, backgroundColor: NSColor) -> NSImage {
        
        let boxSize: NSSize = attributedString.size()
        let rect: NSRect = NSMakeRect(0.0, 0.0, boxSize.width, boxSize.height)
        let image: NSImage = NSImage(size: boxSize)
            
        image.lockFocus()
        
        backgroundColor.set()
        __NSRectFill(rect)
        assert(Thread.isMainThread)
        attributedString.draw(in: rect)
        
        image.unlockFocus()
        return image
    }

    static func image(with attributedString: NSAttributedString) -> NSImage {
    
        return NSImage.image(with: attributedString, backgroundColor: NSColor.clear)
    }
    
    static func image(withString string: String) -> NSImage {
    
        let attributedString = NSAttributedString(string: string)
        return NSImage.image(with: attributedString)
    }
    
}
