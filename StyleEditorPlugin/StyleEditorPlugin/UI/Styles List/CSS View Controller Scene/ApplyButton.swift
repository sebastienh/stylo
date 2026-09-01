//
//  ApplyButton.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-08.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class ApplyButton: NSButton {

    private var disabledAttibuteTitle: NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: Constants.CSS.Editor.DisabledApplyButtonColor,
            NSAttributedString.Key.font: self.font!,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    private var enabledAttibuteTitle: NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: Constants.CSS.Editor.EnabledApplyButtonColor,
            NSAttributedString.Key.font: self.font!,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    override var isEnabled: Bool {
        
        get {
            return super.isEnabled
        }
        set {
            
            if newValue {
                self.attributedTitle = enabledAttibuteTitle
            }
            else {
                self.attributedTitle = disabledAttibuteTitle
            }
            super.isEnabled = newValue
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        
        self.attributedTitle = disabledAttibuteTitle
    }

}

