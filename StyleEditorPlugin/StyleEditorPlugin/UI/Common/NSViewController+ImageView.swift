//
//  NSViewController+ImageView.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-16.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

extension NSViewController {
    
    var viewImageView: NSImageView? {
        let contentView = self.view
        if let rep = contentView.bitmapImageRepForCachingDisplay(in: contentView.bounds) {
            contentView.cacheDisplay(in: contentView.bounds, to: rep)
            let img = NSImage(size: contentView.bounds.size)
            img.addRepresentation(rep)
            return NSImageView(image: img)
        }
        return nil
    }
    
}
