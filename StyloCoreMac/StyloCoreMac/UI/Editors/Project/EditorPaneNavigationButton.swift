//
//  EditorPaneNavigationButton.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-07-14.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class EditorPaneNavigationButton: MacDisableableButton {
    
    override func mouseDown(with event: NSEvent) {
        
        // stop events propagation
        guard let action = self.action else {
            assertionFailure("Error: self.action is nil")
            return
        }
        
        // stylo #864: Navigations clicks should not
        // translate to window resize
        self.target?.perform(action, with: self)
    }
    
}
