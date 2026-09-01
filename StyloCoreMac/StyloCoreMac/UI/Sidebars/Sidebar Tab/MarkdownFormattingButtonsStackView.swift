//
//  MarkdownFormattingButtonsStackView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-07-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon

class MarkdownFormattingButtonsStackView: NSStackView, DisableableView {
    
    var wasEnabled: Bool = false
    
    var isEnabled: Bool = false {
        didSet {
            changeMarkdownFormattingButtonsEnableState(to: isEnabled)
        }
    }
    
    override var isHidden: Bool {
        didSet {
            changeMarkdownFormattingButtonsHiddenState(to: isHidden)
        }
    }
    
    public func disableUserInteractions() {
    
        self.wasEnabled = self.isEnabled
        changeMarkdownFormattingButtonsEnableState(to: false)
    }
    
    public func enableUserInteractions() {
        
        if self.wasEnabled {
            changeMarkdownFormattingButtonsEnableState(to: true)
        }
    }
    
    private func changeMarkdownFormattingButtonsEnableState(to state: Bool) {
        
        for view in self.views {
            
            let formattingButton = view as? NSButton
            
            assert(formattingButton != nil)
            if let formattingButton = formattingButton {
            
                formattingButton.isEnabled = state
            }
        }
    }
    
    private func changeMarkdownFormattingButtonsHiddenState(to state: Bool) {
        
        for view in self.views {
            
            let formattingButton = view as? NSButton
            
            assert(formattingButton != nil)
            if let formattingButton = formattingButton {
            
                formattingButton.isHidden = state
            }
        }
    }
}
