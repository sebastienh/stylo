//
//  .swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-02-11.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

final class ThemePopoverTableCellView: NSTableCellView, BackgroundColorBindable {
    
    @IBOutlet var checkmark: NSTextField!
    
    var selected: Bool {
        
        didSet {
            if selected {
                self.checkmark.isHidden = false
            }
            else {
                self.checkmark.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        
        selected = false
        super.init(coder: coder)
        self.wantsLayer = true 
    }
    
    override func awakeFromNib() {
        
        checkmark.isBezeled = false
        checkmark.isEditable = false
//        checkmark.drawsBackground = false
        selected = false
        
        super.awakeFromNib()
    }
    
}
