//
//  EditorManager+Focusable.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-10-30.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import os

extension EditorManager: Focusable {

    func disableFocus() {
        
        styledStoreManager.changeFocusMode(.disabled)
    }
    
    func updateFocusAttributes(forVisibleTopElements visibleTopElements: ContiguousArray<Element>, document: Document, originStringAction stringAction: StringAction) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateFocusAttributes(forVisibleTopElements: %@)", log: Log.WriterCommon.all, type: .info, %%visibleTopElements)
        #endif
        
        guard let visibleRange = self.renderer.visibleRange else {
            assertionFailure("Error: visibleRange is nil")
            return
        }

        let selectionRange: NSRange? = {
            if self.isFirstResponder {
                return renderer.selectedRange()
            }
            return nil
        }()
        
        if let selectionRange = selectionRange, selectionRange.length > 0 {
            return
        }
        
        guard let stylableActionResult = styledStoreManager.changeSelection(visibleTopElements: visibleTopElements, document: document, selectionRange: selectionRange, visibleRange: visibleRange) else {
            assertionFailure("Error: stylableActionResult is nil")
            return
        }
        
        self.updateCompilationUnit(withChange: nil, result: stylableActionResult)
        self.applyDifferentAttributes(stylableActionResult, fromOriginStringAction: stringAction)
        WriterNotification.didChangeTemporaryAttributes.sendNotification(self.renderer)
    }
    
    func clearFocusedRange() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("clearFocusedRange()", log: Log.WriterCommon.all, type: .info)
        #endif
        
        guard let focusedRange = self.temporaryAttributedRange, focusedRange.length > 0 else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("focusedRange is nil", log: Log.WriterCommon.all, type: .info)
            #endif
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("clearFocusedRange()", log: Log.WriterCommon.all, type: .info)
        os_log("focusedRange: %@", log: Log.WriterCommon.all, type: .info, %%focusedRange)
        #endif
        
        self.renderer.removeTemporaryAttributes(forCharacterRange: focusedRange)
        self.temporaryAttributedRange = nil
        WriterNotification.didChangeTemporaryAttributes.sendNotification(self.renderer)
    }
    
    func clearFocusAttributes() {
        
        self.styledStoreManager.clearFocusedAttributes()
        self.clearFocusedRange()
        WriterNotification.didChangeTemporaryAttributes.sendNotification(self.renderer)
    }
    
    func changeFocusMode(_ focusMode: FocusMode) {
        
        styledStoreManager.changeFocusMode(focusMode)
    }
    
    func clearPreviousFocusStateIfNecessary() {
        
        self.clearFocusAttributes()
    }
    
    func setApplicationFocusType() {
        
        self.styledStoreManager.changeFocusMode(StyloApplication.shared.focusMode.value)
    }
    
}
