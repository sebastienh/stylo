//
//  TextManager+NSTextStorageDelegate.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-17.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Markdown
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

extension TextManager: NSTextStorageDelegate {
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        if editedMask.contains(.editedCharacters) {
            self.editedRange = editedRange
        }
    }
    
    public func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {

        if editedMask.contains(.editedCharacters) {

            guard let editorId = self.editorId(forTextStorage: textStorage) else {
                assertionFailure("Error: editorId is nil")
                return
            }
            
            guard let editorManager = self.editorManagers.values[editorId] else {
                assertionFailure("Error: editorManager is nil")
                return
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("willProcessEditing start, in TextManager: editedRange: %@, changeInLength: %d", log: Log.WriterCommon.textStorage, type: .info, %%editedRange, delta)
            #endif

            let rangeString = textStorage.getRangeAndReplacementSubstring()

            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("willProcessEditing rangeString: %@", log: Log.WriterCommon.textStorage, type: .info, %%rangeString)
            #endif
            
            assert(rangeString != nil)
            if let rangeString = rangeString {

                let changeDescription = SourceStringChangeDescription(range: rangeString.range, stringReplacement: rangeString.replacementSubstring, changeLength: delta, targetString: textStorage.string)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("willProcessEditing changeDescription: %@", log: Log.WriterCommon.textStorage, type: .debug, %%changeDescription)
                os_log("willProcessEditing changeDescription replacement string: %@", log: Log.WriterCommon.textStorage, type: .debug, %%changeDescription.stringReplacement)
                os_log("willProcessEditing currentChangeDescription: %@", log: Log.WriterCommon.textStorage, type: .debug, %%currentChangeDescription)
                #endif
                
                if changeDescription.changeType != .unchanged {
                    
//                    handleNewLineAttributes(textStorage, description: changeDescription)
                    
                    // pureAddition, range: {0, 0}, changeLength: 1, stringReplacement: Optional("^")
                    // pureReplace, range: {0, 1}, changeLength: 0, stringReplacement: Optional("ê")
                    let currentChangeDescription = editorManager.currentChangeDescription
                    
                    if let currentChangeDescription = currentChangeDescription, changeDescription.changeType == .pureReplace
                        && currentChangeDescription.changeLength == 1 && changeDescription.changeLength == 0
                        && currentChangeDescription.range.location == changeDescription.range.location
                        && currentChangeDescription.range.length == 0 && changeDescription.range.length == 1 {
                        
                        let changeDescription = currentChangeDescription.same(with: changeDescription.utf16SubsequenceReplacement, targetString: changeDescription.targetString)
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("willProcessEditing replaced changeDescription with: %@", log: Log.WriterCommon.textStorage, type: .debug, %%changeDescription)
                        #endif
                        
                        handleSourceChange(sourceStringChangeDescription: changeDescription, forEditorId: editorId)
                    }
                    else {
                    
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("willProcessEditing sourceStringChangeDescription: %@", log: Log.WriterCommon.textStorage, type: .debug, %%changeDescription)
                        #endif

                        handleSourceChange(sourceStringChangeDescription: changeDescription, forEditorId: editorId)
                    }
                }
            }
            else {

                // we got an error: recompile everything
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("rangeString is nil. Recompile everything.", log: Log.WriterCommon.textStorage, type: .error)
                #endif
                let sourceStringChangeDescription = SourceStringChangeDescription(attributedString: textStorage, originalAttributedString: nil)
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("sourceStringChangeDescription: %@", log: Log.WriterCommon.textStorage, type: .info, %%sourceStringChangeDescription)
                #endif

                handleSourceChange(sourceStringChangeDescription: sourceStringChangeDescription, forEditorId: editorId)
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("willProcessEditing rangeString is nil.", log: Log.WriterCommon.textStorage, type: .debug)
            #endif
        }
    }
}
