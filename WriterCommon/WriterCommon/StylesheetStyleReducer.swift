//
//  StylesheetStyleReducer.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit
import Common
import os

public class StylesheetStyleReducer: Reducer, SerialReducer {

    public var serialQueue: DispatchQueue {
        return serialCompilationQueue
    }
    
    let serialCompilationQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialCompilationQueue = DispatchQueue(label: Constants.Queues.CssStyleStoreCompilationQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
    }
    
    public func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
            
        var result: ActionResult?
        
        guard let stylesheetStyleStore = store as? StylesheetStyleStore else {
            assertionFailure("Error: store is not StylesheetStyleStore")
            return nil
        }
        
        guard let stylableStoreAction = action as? StylableStoreAction else {
            assertionFailure("Error: action is not StylableStoreAction")
            return nil
        }
        
        switch stylableStoreAction {
        case .updateAttributedString(let change):
            self.updateStoreAttributedString(in: stylesheetStyleStore, withChange: change)
            
        case .precomputeFadeStyles:
            break
            
        case .applySourceStringChange(let change, let documentResults, let visibleTopElements, let document, let isFirstResponder):
            let updateStoreRenderingProcessingResult = self.updateStoreAttributes(store: stylesheetStyleStore, description: change, updateDocumentResults: documentResults, visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder, selectedRange: nil)
            if !updateStoreRenderingProcessingResult.isEmpty {
                result = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: updateStoreRenderingProcessingResult)
            }
        case .computeInitialAttributes(let visibleTopElements, let document, let isFirstResponder, let selectionRange):
            let renderingResults = self.computeInitialAttributes(store: stylesheetStyleStore, visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder, selectedRange: selectionRange)
            if !renderingResults.isEmpty {
                result = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: renderingResults)
            }
            
        case .clearFocusedAttributes(let focusMode):
            
            switch focusMode {
            case .disabled:
                assertionFailure("Error: should not send scroll action when not in focus mode")
                break
            case .enabled:
                stylesheetStyleStore.focusAttributesString = AttributedStringChangeRecorder(string: stylesheetStyleStore.stylableString.string)
            }
            
        case .flash(let topElements, let range, let document):
            assertionFailure("Error: unimplemented action .flash")
            break
            
        case .changeFocusMode(let focusMode):
            stylesheetStyleStore.focusMode.setValue(focusMode)
        case .changeSelection(let selectionRange, let visibleTopElements, let document):
            break
        case .clearSelectorHighlightString:
            break
            
        case .updateSelectorHighlightString(let string):
            break
        }
        return result
    }
}
