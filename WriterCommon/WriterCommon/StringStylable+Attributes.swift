//
//  StringStylable+Attributes.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-03.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os


extension EditorManager {
    
    public func applySourceAttributes(fromRenderingProcessingResult renderingProcessingResult: RenderingProcessingResult) {

        textStorage.applyAttributes(renderingProcessingResult.attributes)
    }

    public func applyFocusAttributes(fromRenderingProcessingResult renderingProcessingResult: RenderingProcessingResult, stringAction: StringAction) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyFocusAttributes(fromRenderingProcessingResult: ...)", log: Log.WriterCommon.all, type: .info)
        os_log("applyFocusAttributes(fromRenderingProcessingResult: %@)", log: Log.WriterCommon.all, type: .info, %%renderingProcessingResult)
        #endif
        
        let attributesRange = textStorage.applyTemporaryAttributes(renderingProcessingResult.attributes)
        self.updateTemporaryAttributedRange(from: .focus(range: attributesRange, originStringAction: stringAction))
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyTemporaryAttributes to layout manager: %@", log: Log.WriterCommon.all, type: .debug, %%textStorage.layoutManagers.first)
        os_log("temporaryAttributes at {2,2} to layout manager: %@", log: Log.WriterCommon.all, type: .debug, %%textStorage.layoutManagers.first?.temporaryAttributes(atCharacterIndex: 2, effectiveRange: nil), %%textStorage.layoutManagers.first)
        #endif
    }
    
    public func applyFocusAttributes(fromAttributes attributes: [([NSAttributedString.Key : Any], NSRange)], stringAction: StringAction) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyFocusAttributes(fromAttributes: %@)", log: Log.WriterCommon.all, type: .info, %%attributes)
        #endif
        
        let attributesRange = textStorage.applyTemporaryAttributes(attributes)
        self.updateTemporaryAttributedRange(from: .focus(range: attributesRange, originStringAction: stringAction))
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyTemporaryAttributes to layout manager: %@", log: Log.WriterCommon.all, type: .debug, %%textStorage.layoutManagers.first)
        os_log("temporaryAttributes at {2,2} to layout manager: %@", log: Log.WriterCommon.all, type: .debug, %%textStorage.layoutManagers.first?.temporaryAttributes(atCharacterIndex: 2, effectiveRange: nil), %%textStorage.layoutManagers.first)
        #endif
    }
    
    public func updateTemporaryAttributedRange(from stringAction: StringAction) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateTemporaryAttributedRange(from: %@)", log: Log.WriterCommon.all, type: .info, %%stringAction)
        #endif
        
        switch stringAction {
        case .`init`: fallthrough
        case .highlight: fallthrough
        case .clearHighlight: fallthrough
        case .changeStyle:
            break
        case .flash(let range):
            if self.temporaryAttributedRange != nil {
                self.temporaryAttributedRange?.formUnion(range)
            }
            else {
                self.temporaryAttributedRange = range
            }
        case .refocus(let range):
            if self.temporaryAttributedRange != nil {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("updateTemporaryAttributedRange -> self.temporaryAttributedRange: %@ formUnion with  range: %@", log: Log.WriterCommon.all, type: .info, %%self.temporaryAttributedRange, %%range)
                #endif
                
                self.temporaryAttributedRange?.formUnion(range)
                
                
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("updateTemporaryAttributedRange -> self.temporaryAttributedRange: %@ set to range: %@", log: Log.WriterCommon.all, type: .info, %%self.temporaryAttributedRange, %%range)
                #endif
                
                self.temporaryAttributedRange = range
            }
        case .edit(let change):
            if let focusedRange = self.temporaryAttributedRange {
                self.temporaryAttributedRange = NSMakeRange(focusedRange.location, focusedRange.length+change.changeLength)
            }
        case .select(let range):
            if self.temporaryAttributedRange != nil {
                self.temporaryAttributedRange?.formUnion(range)
            }
            else {
                self.temporaryAttributedRange = range
            }
        case .focus(let range, let originStringAction):
            if self.temporaryAttributedRange != nil {
                self.temporaryAttributedRange?.formUnion(range)
            }
            else {
                self.temporaryAttributedRange = range
            }
            
            switch originStringAction {
            case .edit(let change):
                if let focusedRange = self.temporaryAttributedRange {
                    self.temporaryAttributedRange = NSMakeRange(focusedRange.location, focusedRange.length+change.changeLength)
                }
            default:
                break
            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateTemporaryAttributedRange -> temporaryAttributedRange: %@)", log: Log.WriterCommon.all, type: .info, %%self.temporaryAttributedRange)
        #endif
    }
    
}
