//
//  StyloWindowController+Themes.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

extension StyloWindowController {
    
    /**
     *  Method to toggle the right panel. It is a decorator method
     *  fo the real handler which is the split view.
     *
     *  @param sender Sender Object.
     */
    @IBAction func toggleThemesPanel(_ sender: AnyObject? = nil) {
        
        if themesShown {
            dismissThemesPanel(sender)
        }
        else {
            showThemesPanel(sender)
        }
    }
    
    private func showThemesPanel(_ sender: AnyObject? = nil) {
        
        // do we really want the user to edit pure CSS in Stylo?
        assertionFailure("Error: method should be replaced with something else")
    }
    
    private func dismissThemesPanel(_ sender: AnyObject? = nil) {

        // do we really want the user to edit pure CSS in Stylo?
        assertionFailure("Error: method should be replaced with something else")
    }
}
