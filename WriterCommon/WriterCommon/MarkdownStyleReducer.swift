//
//  StyledStoreReducer.swift
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
import Web

public class MarkdownStyleReducer: Reducer, SerialReducer {
    
    public var serialQueue: DispatchQueue {
        return serialCompilationQueue
    }
    
    let serialCompilationQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialCompilationQueue = DispatchQueue(label: Constants.Queues.MarkdownStyleStoreCompilationQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
    }
    
    public func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        guard let markdownStyleStore = store as? MarkdownStyleStore else {
            assertionFailure("Error: store is not MarkdownStyleStore")
            return nil
        }
        
        switch action {
        case let stylableStoreAction as StylableStoreAction:
            return try self.handleStylableStoreAction(stylableStoreAction, in: markdownStyleStore)
        case let statisticsAction as StatisticsAction:
            return try self.handleStatisticsAction(statisticsAction, in: markdownStyleStore)
        default:
            assertionFailure("Error: unhandled action: \(action)")
            break
        }
        return nil
    }
    
    private func handleStatisticsAction(_ statisticsAction: StatisticsAction, in markdownStyleStore: MarkdownStyleStore) throws -> ActionResult? {
        switch statisticsAction {
        case .load: fallthrough
        case .updateStatistics: fallthrough
        case .startWritingSession: fallthrough
        case .show: fallthrough
        case .hide: fallthrough
        case .writingSessionsMetadata:
            assertionFailure("Error: unsupported action")
            return nil
        case .selectionStatistics(let selectionRange):
            let selectionStatistics = self.selectionStatistics(fromSelectionRange: selectionRange, in: markdownStyleStore)
            return StatisticsResult.selectionStatisitics(statistics: selectionStatistics)
        }
    }
    
    private func handleStylableStoreAction(_ stylableStoreAction: StylableStoreAction, in markdownStyleStore: MarkdownStyleStore) throws -> ActionResult? {
        
        var result: ActionResult?
        
        switch stylableStoreAction {
        case .precomputeFadeStyles(let document):
            
            let resourceComputedStyle = markdownStyleStore.resourceComputedStyle
            
            let filterContext = FilterContext(highlightSelectors: nil, defaultPseudoClassesOptions: .fade)
            
            guard let htmlDocument = document as? HtmlDocument else {
                assertionFailure("Error: document is not HtmlDocument")
                return result
            }
            
            // this is for non-highlight mode
            filterContext.updatePseudoClassesOptions(forElement: htmlDocument.body, with: [])
            filterContext.updatePseudoClassesOptions(forElement: htmlDocument.documentElement, with: [])
            resourceComputedStyle.computeElementsStyles(document: htmlDocument, filterContext: filterContext)
            
            // this is for highlight mode
            filterContext.updatePseudoClassesOptions(forElement: htmlDocument.body, with: .highlight)
            filterContext.updatePseudoClassesOptions(forElement: htmlDocument.documentElement, with: [])
            resourceComputedStyle.computeElementsStyles(document: htmlDocument, filterContext: filterContext)
            
            // highlight with h1 and p highlight
            for p in htmlDocument.getElementsByTagName("p").elements {
                filterContext.updatePseudoClassesOptions(forElement: p, with: .highlight)
            }
            for h1 in htmlDocument.getElementsByTagName("h1").elements {
                filterContext.updatePseudoClassesOptions(forElement: h1, with: .highlight)
            }
            resourceComputedStyle.computeElementsStyles(document: htmlDocument, filterContext: filterContext)
            
            
        case .applySourceStringChange(let change, let documentResults, let visibleTopElements, let document, let isFirstResponder):
            
            var renderingResults: [RenderingProcessingResult] = []
            
            let updateStoreRenderingResult = self.updateStoreAttributes(store: markdownStyleStore, description: change, updateDocumentResults: documentResults, visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder, selectedRange: nil)
            
            if !updateStoreRenderingResult.isEmpty {
                renderingResults.append(contentsOf: updateStoreRenderingResult)
            }
            if !renderingResults.isEmpty {
                result = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: renderingResults)
            }
            
        case .updateAttributedString(let change):
            
            self.updateStoreAttributedString(in: markdownStyleStore, withChange: change)
            
        case .computeInitialAttributes(let visibleTopElements, let document, let isFirstResponder, let selectedRange):
            let renderingResults = self.computeInitialAttributes(store: markdownStyleStore, visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder, selectedRange: selectedRange)
            if !renderingResults.isEmpty {
                result = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: renderingResults)
            }
        case .clearFocusedAttributes(let focusMode):
            
            switch focusMode {
            case .disabled:
                assertionFailure("Error: should not send scroll action when not in focus mode")
                break
            case .enabled:
                #if CONCURENT_RENDERING
                markdownStyleStore.focusAttributesString = AttributedStringChangeRecorder(string: markdownStyleStore.string)
                #else
                markdownStyleStore.focusAttributesString = AttributedStringChangeRecorder(string: markdownStyleStore.string)
                #endif
            }
            
        case .flash(let topElements, let range, let document):
            
            guard let htmlDocument = document as? HtmlDocument else {
                assertionFailure("Error: htmlDocument is nil")
                break
            }
            
            guard let renderingProcessingResult = self.applyFlash(store: markdownStyleStore, toTopElements: topElements, htmlDocument: htmlDocument, inRange: range) else {
                assertionFailure("Error: renderingProcessingResult is nil")
                break
            }
            result = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: [renderingProcessingResult])
            
        case .changeFocusMode(let focusMode):
            
            markdownStyleStore.focusMode.setValue(focusMode)
            
            switch focusMode {
            case .disabled:
                markdownStyleStore.focusAttributesString = nil
            case .enabled:
                #if CONCURENT_RENDERING
                markdownStyleStore.focusAttributesString = AttributedStringChangeRecorder(string: markdownStyleStore.string)
                #else
                markdownStyleStore.focusAttributesString = AttributedStringChangeRecorder(string: markdownStyleStore.string)
                #endif
            }
            
        case .changeSelection(let selectionRange, let visibleTopElements, let document):
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("handle action changeSelection(selectionRange: %@, visibleTopElements: %@)", log: Log.WriterCommon.all, type: .info, %%selectionRange, %%visibleTopElements.map({$0.localName}))
            #endif
            
            guard let renderingProcessingResult = self.applySelectionChange(toTopElements: visibleTopElements, document: document, selectionRange: selectionRange, in: markdownStyleStore) else {
                assertionFailure("Error: renderingProcessingResult is nil")
                break
            }
            result = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: [renderingProcessingResult])
            
        case .clearSelectorHighlightString:
            
            markdownStyleStore.highlightSelectors = nil
            markdownStyleStore.selectorHighlightString.setValue(nil)
            
        case .updateSelectorHighlightString(let selectorString):
            
            let selectorList = self.selectorList(from: selectorString)
            assert(selectorList != nil)
            selectorList?.prepareSelectorChains()
            markdownStyleStore.highlightSelectors = selectorList
            markdownStyleStore.selectorHighlightString.setValue(selectorString)
            
        }
        return result
        
        
    }
    
    
}
