//
//  AppearancesPopUpButton.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-12-10.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class AppearancesPopUpButton: NSPopUpButton {
    
    override var intrinsicContentSize: NSSize {
        let intrinsicContentSize = super.intrinsicContentSize
        return NSMakeSize(intrinsicContentSize.width + 4, intrinsicContentSize.height)
    }
    
}
