//
//  StylesheetEditButton.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-18.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class StylesheetEditButton: NSButton {
    
    var stylesheetTableCellView: StylesheetTableCellView? {
        var responder: NSResponder? = self.nextResponder
        while responder != nil {
            if let stylesheetTableCellView = responder as? StylesheetTableCellView {
                return stylesheetTableCellView
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
}
