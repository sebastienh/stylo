//
//  StaticHtmlPreviewBackgroundView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-05-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common

class StaticHtmlPreviewBackgroundView: NSView, BackgroundColorBindable {
    
    override var isFlipped: Bool {
        
        return true 
    }
    
}
