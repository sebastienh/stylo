//
//  LanguageTableCellView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-03-02.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

final class LanguageTableCellView: NSTableCellView {
    
//    ///
//    /// Variable to hold the autocompletion message. This is the description
//    /// message that is displayed at the bottom of the autocompletion
//    ///
//    var message: String!
//    
//    ///
//    /// Variable to hold the value of the selected key.
//    ///
//    var key: String!
    
    ///
    /// dynamic variable that returns the desired width for the
    /// table cell view. We leave this calculation to the table cell view
    ///
    var desiredWidth: CGFloat {
        
        return self.textField!.intrinsicContentSize.width + 12
    }
    
    var selected: Bool = false {
        
        didSet {
            self.needsLayout = true 
        }
    }
    
    private var backgroundColor: CGColor? {
        
        get {
            return self.layer?.backgroundColor
        }
        set {
            self.layer?.backgroundColor = newValue
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
    }
    
    required init?(coder decoder: NSCoder) {
        
        super.init(coder: decoder)
        self.wantsLayer = true
    }
    
    override func layout() {
        
        updateSelectedBackgroundColor()
        super.layout()
    }
    
    private func updateSelectedBackgroundColor() {
        
        if selected {
            backgroundColor = cgColor(named: "SelectedAutocompleteBackgroundColor")
        } else {
            backgroundColor = cgColor(named: "UnselectedAutocompleteBackgroundColor")
        }
    }
}
