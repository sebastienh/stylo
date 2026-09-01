//
//  MarkdownDocumentReducer.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-08-31.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Markdown
import Igloo
import os

public struct MarkdownDocumentReducer: Reducer, SerialReducer {

    let serialCompilationQueue: DispatchQueue

    init(storeIdentifier: String) {
        
        self.serialCompilationQueue = DispatchQueue(label: Constants.Queues.MarkdownDocumentStoreCompilationQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
    }
    
    public var serialQueue: DispatchQueue {
        
        return serialCompilationQueue
    }
    
    public func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        var result: ActionResult?
        
        guard let markdownDocumentStore = store as? MarkdownDocumentStore else {
            assertionFailure("Error: store is not MarkdownDocumentStore")
            return nil
        }
        
        switch action {
        case let statisticallyAnalysableStoreAction as StatisticsAction:
        
            switch statisticallyAnalysableStoreAction {
            case .hide:
                self.handleHide(in: markdownDocumentStore)
            case .show:
                self.handleShow(in: markdownDocumentStore)
            case .startWritingSession:
                self.handleCreateWritingSession(in: markdownDocumentStore)
            case .updateStatistics:
                self.updateStatistics(in: markdownDocumentStore)
            case .load: fallthrough
            case .writingSessionsMetadata: fallthrough
            case .selectionStatistics:
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not handling statisticallyAnalysableStoreAction: %@", log: Log.WriterCommon.all, type: .error, %%statisticallyAnalysableStoreAction)
                #endif
                assert(false)
                break
            }
            
        case let directoryAction as DirectoryAction:
            
            switch directoryAction {
            case .setParentId(let id):
                markdownDocumentStore.parentID.setValue(id, sameExecutionStack: true)
            case .rename(let name):
                markdownDocumentStore.name.setValueIfDifferent(name, notify: true, sameExecutionStack: true)
            case .updatePathComponents(let path):
                markdownDocumentStore.pathComponents.replaceItems(withItems: path)
            default:
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not handling action type: %@", log: Log.WriterCommon.all, type: .error, %%directoryAction)
                #endif
                break
            }
            
        case let editableStoreAction as EditableStoreAction:
            
            switch editableStoreAction {
                
            case .setString(let string):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("setString action handling with string: %@", log: Log.WriterCommon.all, type: .info, %%string)
                #endif
                
                markdownDocumentStore.sourceString.setValue(string)
                self.saveEditingChange(string: string, in: markdownDocumentStore)
                
            case .sourceStringChanged(let description):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("sourceStringChanged action handling with description: %@", log: Log.WriterCommon.all, type: .debug, %%description)
                #endif
                
                markdownDocumentStore.sourceString.value?.update(withSourceStringChangeDescription: description)
                
                // We always compute the attributes even if:
                // description.changeLength == 0 && description.stringReplacement.length == 0
                // because we want to compute the document attributes even in the case a document
                // is empty.
                self.saveEditingChange(description: description, in: markdownDocumentStore)
                let updates = self.updateDocument(store: markdownDocumentStore, description: description)
                result = DocumentStoreActionResult.updated(updates: updates)
                self.serialQueue.async(flags: .barrier) {
                    markdownDocumentStore.htmlPreviewString.setValue(nil)
                }
                
            // only load the sourceString into the store
            case .loadString(let url):
                
                do {
                    let contents = try String(contentsOf: url)
                    
                    /// Take a copy of the string used to create this style sheet the goal is
                    /// to make the serialisation faster because we have the String.
                    markdownDocumentStore.sourceString.setValue(contents)
                    result = EditableActionResult.loadedString(string: contents)
                }
                catch {
                    let error = NWError.unableToLoad(url: url)
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                    #endif
                    assertionFailure("Error: \(error)")
                }
                
            case .resetPendingChanges:
                assertionFailure("Error: unhandled action")
                break
            }
            
        case let documentStoreAction as DocumentStoreAction:
            switch documentStoreAction {
                
            case .compileInitialDocument(let description):
                
                let updates = self.updateDocument(store: markdownDocumentStore, description: description)
                result = DocumentStoreActionResult.updated(updates: updates)
                self.serialQueue.async(flags: .barrier) {
                    markdownDocumentStore.htmlPreviewString.setValue(nil)
                }
            case .topElementsAroundRange(let range):
                
                guard let markdownTokens = markdownDocumentStore.markdownTokens else {
                    assertionFailure("Error: markdownTokens is nil")
                    break
                }
                
                guard let document = markdownDocumentStore.document.value as? HtmlDocument else {
                    assertionFailure("Error: document is nil")
                    break
                }
                
                guard let tokenRange = markdownTokens.rangeOfBlockTokensAround(range: range) else {
                    assertionFailure("Error: tokenRange is nil")
                    break
                }
                
                let topDomNodes: ContiguousArray<Node> = collectTopDomNodes(fromTokenRange: tokenRange, inTokens: markdownTokens, from: document)
                
                let topElements: [Element] = topDomNodes.compactMap { (node) -> Element? in
                    return node as? Element
                }
                
                result = DocumentStoreActionResult.topElementsAroundRange(elements: ContiguousArray<Element>(topElements))
            }
            
        case let textDocumentAction as TextDocumentAction:
            
            switch textDocumentAction {
                
            case .changeMarkdownPresets(let presetsName):
                
                markdownDocumentStore.markdownPresetName = presetsName
                
            case .compileMarkdownTokens(let string):
                
                markdownDocumentStore.env?.clean()
                
                let mardownParser = MarkdownParser(presetName: markdownDocumentStore.markdownPresetName)
                let tokens = mardownParser.parse(string)
                markdownDocumentStore.markdownTokens = tokens
                
            case .cleanState:
                markdownDocumentStore.markdownTokens = nil
                markdownDocumentStore.nodesAttributes.removeAll()
                markdownDocumentStore.tokensAttributes.setValue(nil)
                markdownDocumentStore.document.setValue(nil, notify: false)
            case .renamed(let newName):
                markdownDocumentStore.name.setValue(newName)
            case .updateTokenAttributes:
                updateTokenAttributes(inStore: markdownDocumentStore)
            }
            
        default:
            assertionFailure("Not handling SyncAction type: \(action)")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not handling SyncAction type: %@", log: Log.WriterCommon.all, type: .error, %%action)
            #endif
            break
        }
        
        return result
    }
    
    /// Function that listens to
    private func updateTokenAttributes(inStore store: MarkdownDocumentStore) {
        
        typealias AttributeName = String
        typealias AttributeValue = String
        
        // in a first pass we need to gather all attributes with their positions
        // a Tag is a string with a position
        // [Node: [String: Set<String>] -> [AttributeName: [AttributeValue: [NSRange]]]
        var sectionsAttributesTags: [AttributeName: [AttributeValue: Set<NSRange>]] = [:]
        
        for (node, attributes) in store.nodesAttributes.values {
            
            guard let range = node.sourceStringFragment?.range else {
                assertionFailure("Error: range is nil")
                continue
            }
            
            for (attributeName, attributeValues) in attributes {
                
                for attributeValue in attributeValues {
                    
                    if sectionsAttributesTags[attributeName] == nil {
                        sectionsAttributesTags[attributeName] = [:]
                    }
                    
                    if sectionsAttributesTags[attributeName]![attributeValue] == nil {
                        sectionsAttributesTags[attributeName]![attributeValue] = Set<NSRange>()
                    }
                    
                    sectionsAttributesTags[attributeName]![attributeValue]?.insert(range)
                }
            }
        }
        
        var attributesTagsInputs: [AttributeTagInputSection : Set<AttributeTagInputItem>] = [:]
        
        // in a second pass we create the input items.
        // each AttributeTagInputItem contains an ordered array
        // of all the positions where it's possible to find the
        // AttributeTagInputItem which correspond basically to a value for a particular
        // attribute name.
        //
        // [AttributeName: [AttributeValue: [NSRange]]] -> [AttributeTagInputSection : Set<AttributeTagInputItem>]
        for (sectionString, attributesTags) in sectionsAttributesTags {
            
            // create the section
            let inputSection = AttributeTagInputSection(stringValue: sectionString)
            attributesTagsInputs[inputSection] = Set<AttributeTagInputItem>()
            
            // attributesTags: [AttributeValue: Set<NSRange>]
            for (attributeValue, positions) in attributesTags {
                
                let sortedPositions = positions.sorted { (first, second) -> Bool in
                    return first.location < second.location
                }
                
                let attributeTagInputItem = AttributeTagInputItem(stringValue: attributeValue, ranges: sortedPositions, textId: store.identifier)
                
                assert(attributesTagsInputs[inputSection] != nil)
                attributesTagsInputs[inputSection]?.insert(attributeTagInputItem)
            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        var attributesTagsInputString = ""
        for (_, (attributesTagsInput, values)) in attributesTagsInputs.enumerated() {
            attributesTagsInputString += attributesTagsInput.stringValue + ": ["
            
            for (itemIndex, sectionValue) in values.enumerated() {
                if itemIndex != values.count-1 {
                    attributesTagsInputString += ", "
                }
                
                attributesTagsInputString += sectionValue.stringValue
            }
            attributesTagsInputString += "]\n"
        }
        
        os_log("attributesTagsInputs: %@", log: Log.WriterCommon.all, type: .info, %%attributesTagsInputString)
        #endif
        
        store.tokensAttributes.setValue(attributesTagsInputs)
    }
    
}

