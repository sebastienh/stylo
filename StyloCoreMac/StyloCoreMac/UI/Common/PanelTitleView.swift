//
//  PanelTitleView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-27.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon

final class PanelTitleView: NSView {

    override var isOpaque: Bool {
        
        return true
    }
    
    @IBInspectable dynamic var backgroundColor: CGColor {

        get {
            return self.layer!.backgroundColor!
        }
        set {
            self.layer!.backgroundColor = newValue
        }
    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)
        self.wantsLayer = true
        self.backgroundColor = InterfaceConstants.TitlePanel.BackgroundColor.cgColor
    }
    
    override func viewWillMove(toWindow newWindow: NSWindow?) {
        
        super.viewWillMove(toWindow: newWindow)
    }
}
