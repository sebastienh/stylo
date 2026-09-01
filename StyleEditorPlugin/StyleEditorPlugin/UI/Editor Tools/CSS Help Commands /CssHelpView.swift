//
//  CssHelpView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import StyloCoreMac

class CssHelpView: NSView, BackgroundColorBindable {
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
        self.backgroundColor = Constants.CSS.HelpPanel.BackgroundColor.cgColor
    }
    
}
