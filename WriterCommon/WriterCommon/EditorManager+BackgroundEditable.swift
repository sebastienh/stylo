//
//  EditorManager+BackgroundEditable.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-10-06.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

extension EditorManager: BackgroundEditable {
    
    public func beginBackgroundEditing() {
        
        assert(Thread.isMainThread)
    }

    public func endBackgroundEditing(withVisibleTopElements visibleTopElements: ContiguousArray<Element>, document: Document, visibleCharacterRange: NSRange) {
        
        assert(Thread.isMainThread)
        if !self.isFirstResponder {
            if self.isFocused {
                self.updateFocusAttributes(forVisibleTopElements: visibleTopElements, document: document, originStringAction: StringAction.refocus(range: visibleCharacterRange))
            }
        }
    }
    
}
