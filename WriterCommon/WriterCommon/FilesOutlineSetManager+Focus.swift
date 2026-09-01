//
//  FilesOutlineSetManager+Focus.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-11-16.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web

extension FilesOutlineSetManager {
    
    func setFocusMode(_ focusMode: FocusMode) {
        
        for filesOutline in self.filesOutlines.values {
            filesOutline.setFocusMode(focusMode)
        }
    }
    
    func disableFocus() {
        
        for filesOutline in self.filesOutlines.values {
            filesOutline.disableFocus()
        }
    }
    
}
