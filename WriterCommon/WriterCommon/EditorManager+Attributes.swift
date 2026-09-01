//
//  EditorManager+Attributes.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-01.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

/// Because of a bug in Apple Swift version 5.2.4
/// we cannot define this as an extension on StylableString
/// protocol directly. We may want to change this when
/// Apple releases a new Swift version.
extension EditorManager {
    
    func applyStringAttributes(fromStylableActionResult stylableActionResult: StylableActionResult, originStringAction stringAction: StringAction) {

        DispatchQueue.syncOnMain { [weak self] in
            self?.applyDifferentAttributes(stylableActionResult, fromOriginStringAction: stringAction)
        }
    }
    
    ///
    /// This method is responsible for assigning the all attributed string
    /// to the renderer according to the defined style assembly
    /// for the renderer.
    ///
    /// @precondition: styledStoreManagers dictionary is not empty
    /// @precondition: styledStoreManagers contains an entry for the renderer.id
    ///
    public func applyStringAttributes(fromOriginStringAction stringAction: StringAction) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyStringAttributes()", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        guard let attributes = self.styledStoreManager.attributes else {
            assertionFailure("Error: temporaryAttributes is nil")
            return
        }
        
        // focus attributes
        let focusAttributes = styledStoreManager.focusAttributes
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyStringAttributes -> focusAttributes %@", log: Log.WriterCommon.all, type: .debug, %%focusAttributes)
        #endif
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Setting text storage attributes to %@.", log: Log.WriterCommon.all, type: .debug, %%attributes)
        #endif
        
        DispatchQueue.syncOnMain { [weak self] in
            
            // capture textStorage
            guard let textStorage = self?.textStorage else {
                assertionFailure("Error: self.textStorage is nil")
                return
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            let startTime = Date()
            os_log("applyStringAttributes start time: %@.", log: Log.WriterCommon.all, type: .debug, %%startTime)
            #endif
            
            // source attributes
            textStorage.beginEditing()
            for (values, range) in attributes {
                textStorage.addAttributes(values, range: range)
            }
            textStorage.endEditing()
            
            if let focusAttributes = focusAttributes {
                self?.applyFocusAttributes(fromAttributes: focusAttributes, stringAction: stringAction)
            }
            
            self?.ensureLayout()
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            let endTime = Date()
            os_log("applyStringAttributes end time: %@.", log: Log.WriterCommon.all, type: .debug, %%endTime)
            let interval: DateInterval = DateInterval(start: startTime, end: endTime)
            os_log("applyStringAttributes duration: %@.", log: Log.WriterCommon.all, type: .debug, %%interval.duration)
            #endif
        }
    }
    
    ///
    /// This method is responsible for assigning the attributed string
    /// to the renderer according to the defined style assembly
    /// for the renderer.
    ///
    /// Async version.
    ///
    /// @precondition: styledStoreManagers dictionary is not empty
    /// @precondition: styledStoreManagers contains an entry for the renderer.id
    ///
    public func applyStringAttributesAsync(fromOriginStringAction stringAction: StringAction) -> Promise<Void> {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyStringAttributesAsync()", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        guard let attributes = styledStoreManager.attributes else {
            assertionFailure("Error: temporaryAttributes is nil")
            return Promise(error: NWError.custom(message: "Error: temporaryAttributes is nil"))
        }
        
        // focus attributes
        let focusAttributes = styledStoreManager.focusAttributes
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyStringAttributesAsync -> focusAttributes %@", log: Log.WriterCommon.all, type: .debug, %%focusAttributes)
        #endif
        
        return Promise<Void> { [weak self] fulfill, reject in
            
            // capture textStorage
            guard let textStorage = self?.textStorage else {
                assertionFailure("Error: self.textStorage is nil")
                reject(NWError.custom(message: "Error: self.textStorage is nil"))
                return
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Setting text storage string value to %@.", log: Log.WriterCommon.all, type: .debug, %%attributedString.string)
            #endif
            
            textStorage.beginEditing()
            for (values, range) in attributes {
                textStorage.addAttributes(values, range: range)
            }
            textStorage.endEditing()
            
            if let focusAttributes = focusAttributes {
                self?.applyFocusAttributes(fromAttributes: focusAttributes, stringAction: stringAction)
            }

            self?.ensureLayout()
            fulfill(())
        }
    }
    
    public func applyGlobalAttributes() {
        
        guard let globalAttributes = styledStoreManager.globalAttributes else {
            assertionFailure("Error: globalAttributes is nil")
            return
        }
        
        self.globalAttributes.setValue(globalAttributes)
        renderer.applyGlobalAttributes(globalAttributes: globalAttributes)
    }
    
    private func updateAttributesRangesWithPendingRequests(_ attributesRanges: [([NSAttributedString.Key: Any], NSRange)], pendingRequests: Queue<SourceStringChangeDescription>) -> [([NSAttributedString.Key: Any], NSRange)] {
        
        assert(Thread.isMainThread)
        var updatedRanges = attributesRanges

        // we update the ranges with the requests
        pendingRequests.execute { request in
            updatedRanges = updateAttributesRanges(updatedRanges, with: request)
        }
        return updatedRanges
    }
    
    private func updateAttributesRanges(_ attributesRanges: [([NSAttributedString.Key: Any], NSRange)], with request: SourceStringChangeDescription) -> [([NSAttributedString.Key: Any], NSRange)] {

        assert(Thread.isMainThread)
        var result = [([NSAttributedString.Key: Any], NSRange)]()
        for (values, range) in attributesRanges {
            
            let ranges = range.update(with: request)
            if let ranges = ranges {
                for range in ranges {
                    result.append((values, range))
                }
            }
        }
        return result
    }
    
    func ensureLayout() {
        
        assert(Thread.isMainThread)
        
        // We removed this to not make useless calls, but we need to make sure
        // that it is not necessary in fact. Some preliminary testing indicate
        // that it is not necessary.
        guard let layoutManager = textStorage.layoutManagers.first else {
            // for testing purpose we dont fail 
            return
        }

        assert(layoutManager.textContainers.count == 1)
        guard let textContainer = layoutManager.textContainers.first else {
            assertionFailure("Error: layoutManager.textContainers.first is nil")
            return
        }

        layoutManager.ensureLayout(for: textContainer)
    }
    
    func ensureLayout(forCharacterRange characterRange: NSRange) {
        
        assert(Thread.isMainThread)
        
        // We removed this to not make useless calls, but we need to make sure
        // that it is not necessary in fact. Some preliminary testing indicate
        // that it is not necessary.
        assert(textStorage.layoutManagers.count == 1)
        guard let layoutManager = textStorage.layoutManagers.first else {
            assertionFailure("Error: rendererTextStorage.layoutManagers.first is nil")
            return
        }

        layoutManager.ensureLayout(forCharacterRange: characterRange)
    }
    
}

