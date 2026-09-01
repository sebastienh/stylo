//
//  EditorManager+Highlight.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-10-30.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

extension EditorManager {

    ///
    /// Method that removes the highlight and recompute the temporary
    /// attributes for the focus if needed.
    ///
    /// When highlighting or un-highlighting we also need to refresh
    /// the focus attributes since the pseudo-classes options have changed.
    ///
    public func clearHighlight(visibleTopElements: ContiguousArray<Element>?, document: Document, selectedRange: NSRange?) {
        
        self.clearFocusedRange()
        self.clearFlashAttributes()
        self.changeFocusMode(.disabled)
        guard let stylableActionResult = self.styledStoreManager.clearHighlight(document: document, isFirstResponder: self.isFirstResponder, selectedRange: selectedRange) else {
            assertionFailure("Error: stylableActionResult is nil")
            return
        }
        self.applyStringAttributes(fromStylableActionResult: stylableActionResult, originStringAction: .clearHighlight)
        self.applyGlobalAttributes()
        self.clearPreviousFocusStateIfNecessary()
        self.setApplicationFocusType()
    }
    
    ///
    /// When highlighting or un-highlighting we also need to refresh
    /// the focus attributes since the pseudo-classes options have changed.
    ///
    public func highlight(with selectorString: String, visibleTopElements: ContiguousArray<Element>?, document: Document, selectedRange: NSRange?) {
        

        self.changeFocusMode(.disabled)
        guard let stylableActionResult = self.styledStoreManager.highlight(with: selectorString, document: document, isFirstResponder: self.isFirstResponder, selectedRange: selectedRange) else {
            assertionFailure("Error: stylableActionResult is nil")
            return
        }
        self.applyStringAttributes(fromStylableActionResult: stylableActionResult, originStringAction: .highlight)
        self.applyGlobalAttributes()
        self.clearFlashAttributes()
        self.clearPreviousFocusStateIfNecessary()
        self.setApplicationFocusType()
    }
}
