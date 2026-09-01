//
//  StylesheetsScrollView.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-18.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class StylesheetsScrollView: NSScrollView {
    
    private var containingScrollView: NSScrollView? {
        
        var view: NSView? = self.superview
        while view != nil {
            if let scrollView = view as? NSScrollView {
                return scrollView
            }
            view = view?.superview
        }
        return nil
    }
    
    override func scrollWheel(with event: NSEvent) {
        self.containingScrollView?.scrollWheel(with: event)
    }
    
}
