//
//  MarkdownDocumentReducer+HtmlDocument.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-24.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Markdown
import Common
import PromiseKit
import os

extension MarkdownDocumentReducer: DocumentReducerType {
    
    /// Return the root elements of the updated document,
    /// or nil if the document was created.
    @discardableResult
    func createOrUpdateDocument(in store: MarkdownDocumentStore, markdownCompilationResult: MarkdownCompilationResult) -> UpdateDocumentResult? {
        
        switch markdownCompilationResult {
            
        case .complete(let tokens):
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("start createOrUpdateDocument", log: Log.WriterCommon.all, type: .info)
            os_log("Compiled tokens: %@", log: Log.WriterCommon.all, type: .debug, %%tokens.toString())
            #endif
            
            let document = createDocument(markdownDocumentStore: store, markdownTokens: tokens)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("New markdown document: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createDefault().serializeHTMLFragment(document))
            #endif
            store.document.setValue(document)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("New markdown document in store: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createDefault().serializeHTMLFragment(store.document.value!))
            #endif
            
            return UpdateDocumentResult(type: .complete, document: document, rootElements: nil, deletedNodes: nil, attributesBlocsChange: nil)
            
        case .partial(let markdownPartialCompilationResult):
            
            var rootElements = ContiguousArray<Element>()
            
            let deleted = markdownPartialCompilationResult.deletedTopDomNodes
            let tokens = markdownPartialCompilationResult.tokens
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("deleted %d from the document.", log: Log.WriterCommon.all, type: .info, deleted.count)
            
            for node in deleted {
                if let element = node as? Element {
                    debugPrint("element: \(element.localName)")
                }
                else if let text = node as? CharacterData {
                    debugPrint("text: \(text.data)")
                }
                else {
                    debugPrint("node: \(node.nodeName), \(node.nodeType)")
                }
            }
            
            os_log("Old markdown document: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createDefault().serializeHTMLFragment(store.document.value!))
            #endif
            
            if let updatedRootElements = updateMarkdownDocument(markdownDocumentStore: store, deletedDomNodes: deleted, replacementTokens: tokens, sourceStringChangeDescription: markdownPartialCompilationResult.changeDescription) {
            
                // compile document
                rootElements.append(contentsOf: updatedRootElements)
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("New markdown document: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createDefault().serializeHTMLFragment(store.document.value!))
            #endif
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("end", log: Log.WriterCommon.all, type: .info)
            #endif
            
            guard let document = store.document.value else {
                assertionFailure("Error: store.document is nil")
                return nil
            }
            
            return UpdateDocumentResult(type: .partial, document: document, rootElements: rootElements, deletedNodes: deleted, attributesBlocsChange: markdownPartialCompilationResult.attributesBlocsChange)
        }
    }
    
    private func createDocument(markdownDocumentStore: MarkdownDocumentStore, markdownTokens: Tokens) -> HtmlDocument {
        
        markdownDocumentStore.markdownTokens = markdownTokens
        
        // Create the HtmlDocument that will be th head of all created elements
        let markdownDomRenderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        let result = markdownDomRenderer.render(markdownTokens)
        markdownDocumentStore.nodesAttributes.removeAll(notify: false)
        markdownDocumentStore.nodesAttributes.update(withValues: markdownDomRenderer.nodesAttributes)
        return result
    }
    
    /// Function that updates the document and return the root elements
    /// of the added elements (the childs of the document fragment).
    private func updateMarkdownDocument(markdownDocumentStore: MarkdownDocumentStore, deletedDomNodes: ContiguousArray<Node>, replacementTokens: Tokens, sourceStringChangeDescription: SourceStringChangeDescription?) -> ContiguousArray<Element>? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start updateMarkdownDocument", log: Log.WriterCommon.all, type: .info)
        #endif
        
        // Create the DocumentFragment that will be th head of all created elements
        let documentFragment = DocumentFragment(document: nil)
        
        // get top html nodes from the MarkdownDomRenderer
        let markdownDomRenderer = MarkdownDomRenderer(parentContainer: documentFragment)

        // we have already a reference to the returned element,
        // it is the document fragment
        removeNodesAttributes(forDeletedNodes: deletedDomNodes, from: markdownDocumentStore)
        markdownDomRenderer.render(replacementTokens)
        markdownDocumentStore.nodesAttributes.update(withValues: markdownDomRenderer.nodesAttributes)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("New fragment compiled from replacementTokens: %@", log: Log.WriterCommon.all, type: .info, %%HTMLSerializer.createDefault().serializeHTMLFragment(documentFragment))
        #endif
        
        #if DEBUG
        if let childNodes = documentFragment.childNodes {
            for childNode in childNodes {
                if let element = childNode as? Element {
                    assert(element.nwElementId != nil)
                }
            }
        }
        #endif
        
        let htmlDocument = markdownDocumentStore.document.value as! HtmlDocument
        let (nodeToInsertBefore, elements) = htmlDocument.replaceBodyChilds(deletedDomNodes, withDocumentFragment: documentFragment)
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end", log: Log.WriterCommon.all, type: .info)
        #endif
        return elements
    }

    private func removeNodesAttributes(forDeletedNodes deletedNodes: ContiguousArray<Node>, from store: MarkdownDocumentStore) {
        
        for deletedNode in deletedNodes {
            
            if let containerNode = deletedNode as? ContainerNode {
                if let childs = containerNode.childNodes {
                    removeNodesAttributes(forDeletedNodes: childs.asArray(), from: store)
                }
            }

            // there is no need to notify at this point since we
            // will do it when we will update
            store.nodesAttributes.removeValue(forKey: deletedNode, notify: false)
        }
    }
    
}
