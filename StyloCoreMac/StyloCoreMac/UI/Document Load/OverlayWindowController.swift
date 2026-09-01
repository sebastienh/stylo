//
//  OverlayWindowController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-08-12.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

final class OverlayWindowController: NSWindowController {
    
    init(frame: NSRect) {
        let window = NSWindow(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
        super.init(window: window)
        
//        window.contentViewController = DocumentLoadViewController()
        window.backgroundColor = NSColor.blue.withAlphaComponent(0.3)
        window.isOpaque = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
//        window!.backgroundColor = NSColor.blue.withAlphaComponent(0.3)
//        window!.isOpaque = false
//        window.backgroundColor = NSColor.blue//gray.withAlphaComponent(0.3)
    }
    
}
