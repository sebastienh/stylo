//
//  DocumentState.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-08-31.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import os
import Common

public class DocumentState: State {
    
//    private var styloDocumentStore: StyloDocumentStore?
//
    /// strong reference to the unique MarkdownDocumentStore
    /// in the document.
    private var markdownDocumentStore: [MarkdownDocumentStore] {
        
        return self.stores.filter { (arg0) -> Bool in
            
            let (_, value) = arg0
            if value is MarkdownDocumentStore {
                return true
            }
            return false
            }.compactMap { (arg0) -> MarkdownDocumentStore? in
                
                let (_, value) = arg0
                return value as? MarkdownDocumentStore
        }
        
    }

    // for the moment we keep all StylesheetDocumentStore in an
    // array without taking care ogg grouping them by style, it
    // may change in the futur.
    private var stylesheetDocumentStores: [StylesheetDocumentStore] {
        
        return self.stores.filter { (arg0) -> Bool in
            
            let (_, value) = arg0
            if value is StylesheetDocumentStore {
                return true
            }
            return false
            }.compactMap { (arg0) -> StylesheetDocumentStore? in
                
                let (_, value) = arg0
                return value as? StylesheetDocumentStore
        }
    }
    
    // independent style stores reference
    private var styleAssemblyStores: [StyleAssemblyStore] {
        
        return self.stores.filter { (arg0) -> Bool in
            let (_, value) = arg0
            if value is StyleAssemblyStore {
                return true
            }
            return false
        }.compactMap { (arg0) -> StyleAssemblyStore? in
            let (_, value) = arg0
            return value as? StyleAssemblyStore
        }
    }
    
    
    private var stores: [String: IdentifiableStoreType]
    
    init() {
        
        self.stores = [String: IdentifiableStoreType]()
//        self.stylesheetDocumentStores = [StylesheetDocumentStore]()
//        self.styleAssemblyStores = [StyleStore]()
    }
    
    public func prepareForRevert() {
        
        for stylesheetDocumentStore in self.stylesheetDocumentStores {
            self.stores.removeValue(forKey: stylesheetDocumentStore.identifier)
        }
        for styleAssemblyStore in self.styleAssemblyStores {
            self.stores.removeValue(forKey: styleAssemblyStore.identifier)
        }
    }
    
    public func remove<S: Store & IdentifiableStoreType>(store: S) {
        
        self.stores.removeValue(forKey: store.identifier)
    }
    
    /// Add a store to the global state
    public func add<S: Store & IdentifiableStoreType>(store: S) {
        
        self.stores[store.identifier] = store
    }
    
    /// Disable a specific store. When  store is disabled
    /// it doesn't handle actions anymore.
    func disable<S: Store>(store: S) {
        
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("disable(...) missing implementation.", log: Log.WriterCommon.all, type: .error)
        #endif
    }
}
