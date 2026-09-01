//
//  StyloWindow+AccessoryView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-19.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

extension StyloWindow {
    
    /// Method to add a view to the title bar.
    func addTitleBarAccessoryViewToTitleBar(_ titlebarAccesoryViewController: NSTitlebarAccessoryViewController, layoutAttribute: NSLayoutConstraint.Attribute) {
        
        titlebarAccesoryViewController.layoutAttribute = layoutAttribute
        
        addTitlebarAccessoryViewController(titlebarAccesoryViewController)
    }
    
//    func hideTitleBar() {
//    
//        titlebarAppearsTransparent = true   
//    }
    
}
