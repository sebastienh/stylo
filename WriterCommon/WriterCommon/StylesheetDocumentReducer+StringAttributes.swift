//
//  StylesheetDocumentReducer+StringAttributes.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-06-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Common
import Web
import os

extension StylesheetDocumentReducer {

    func updateDocumentSync(store: StylesheetDocumentStore, description: SourceStringChangeDescription, shouldUpdateAttributes: Bool = false) -> [UpdateDocumentResult]? {
    
        return serialCompilationQueue.sync {
            return self.updateDocument(store: store, description: description, shouldUpdateAttributes: shouldUpdateAttributes)
        }
    }
    
    func updateDocumentAsync(store: StylesheetDocumentStore, description: SourceStringChangeDescription) -> Promise<[UpdateDocumentResult]?> {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Asynchronous handling start", log: Log.WriterCommon.all, type: .info)
        #endif
        
        return Promise<[UpdateDocumentResult]?> { fulfill, reject in
            serialCompilationQueue.async {
                fulfill(self.updateDocument(store: store, description: description))
            }
        }
    }
    
    func updateDocument(store: StylesheetDocumentStore, description: SourceStringChangeDescription, shouldUpdateAttributes: Bool = true) -> [UpdateDocumentResult]? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateDocument(store: %@, description: %@, shouldUpdateAttributes: %@)", log: Log.WriterCommon.all, type: .info, %%store, %%description, %%shouldUpdateAttributes)
        #endif
        
        let compilationResult = self.compileStylesheet(description: description, store: store)
        
        assert(compilationResult != nil)
        if let compilationResult = compilationResult {
            
            // trig a stylesheet changed event
            switch compilationResult {
            case .declarations:
                store.stylesheet.setValue(store.stylesheet.value)
            case .selectorList:
                store.stylesheet.setValue(store.stylesheet.value)
            case .complete(let stylesheet):
                store.stylesheet.setValue(stylesheet)
            case .rules(_, _, _):
                store.stylesheet.setValue(store.stylesheet.value)
            case .replace(let stylesheet, _):
                store.stylesheet.setValue(stylesheet)
            }
            
            let updateDocumentResult = self.createOrUpdateDocument(in: store, stylesheetCompilationResult: compilationResult, description: description)
            
            if let updateDocumentResult = updateDocumentResult {
                return [updateDocumentResult]
            }
            return nil
        }
        return nil
    }
}
