//
//  MarkdownDocumentReducer+StringAttributes.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2017-12-29.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Common
import Web
import Igloo
import os

extension MarkdownDocumentReducer {
    
    @discardableResult
    func updateDocumentSync(store: MarkdownDocumentStore, description: SourceStringChangeDescription, shouldUpdateAttributes: Bool) -> [UpdateDocumentResult] {
        
        return store.serialCompilationQueue.sync { () -> [UpdateDocumentResult] in
            return self.updateDocument(store: store, description: description)
        }
    }
    
    ///
    /// This method updates the string attributes and returns the deletedNodes
    /// and the new inserted elements.
    ///
    func updateDocumentAsync(store: MarkdownDocumentStore, description: SourceStringChangeDescription) -> Promise<[UpdateDocumentResult]> {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Asynchronous handling start", log: Log.WriterCommon.all, type: .info)
        #endif
        
        return Promise<[UpdateDocumentResult]> { fulfill, reject in
            serialCompilationQueue.async {
                fulfill(self.updateDocument(store: store, description: description))
            }
        }
    }

    func updateDocument(store: MarkdownDocumentStore, description: SourceStringChangeDescription) -> [UpdateDocumentResult] {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start updateDocument", log: Log.WriterCommon.all, type: .info)
        #endif
        
        var results = [UpdateDocumentResult]()
        
        let markdownCompilationResult = self.compileTokens(markdownDocumentStore: store, sourceStringChangeDescription: description)
        
        if let markdownCompilationResult = markdownCompilationResult {
                
            let updateDocumentResult = self.createOrUpdateDocument(in: store, markdownCompilationResult: markdownCompilationResult)
            
            assert(updateDocumentResult != nil)
            if let updateDocumentResult = updateDocumentResult {
                results.append(updateDocumentResult)
            }
            
            // we may have to recompile some ranges...
            if let recompileRequiredRanges = markdownCompilationResult.recompileRequiredRanges {
                
                for recompileRequiredRange in recompileRequiredRanges {
                    
                    let description = SourceStringChangeDescription(range: recompileRequiredRange, stringReplacement: nil, changeLength: 0, targetString: description.targetString)
                    
                    let markdownCompilationResult = self.compileTokens(markdownDocumentStore: store, sourceStringChangeDescription: description, recompilation: true)
                    
                    if let markdownCompilationResult = markdownCompilationResult {
                               
                        guard let updateDocumentResult = self.createOrUpdateDocument(in: store, markdownCompilationResult: markdownCompilationResult) else {
                            assertionFailure("Error: updateDocumentResult is nil")
                            continue 
                        }
                        results.append(updateDocumentResult)
                    }
                }
            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("no change in the input.", log: Log.WriterCommon.all, type: .info)
        #endif
        return results
    }
}
