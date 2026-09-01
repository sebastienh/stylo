//
//  FlippedClippedView.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class FlippedClippedView: NSClipView {
    
    override var isFlipped: Bool {
        return true
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
}
