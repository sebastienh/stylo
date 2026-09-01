//
//  MarkdownDocumentState.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-07-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
@testable import WriterCommon

public class MarkdownDocumentState: State {
    
    // for the moment we keep all StylesheetDocumentStore in an
    // array without taking care ogg grouping them by style, it
    // may change in the futur.
    var markdownDocumentStore: MarkdownDocumentStore?
    
    init() {
        
    }
    
    /// Add a store to the global state
    public func add<S: Store>(store: S) {
        
        switch store {
        case let markdownDocumentStore as MarkdownDocumentStore:
            self.markdownDocumentStore = markdownDocumentStore
        default:
            assert(false, "unsupported store type")
        }
    }
    
    /// Disable a specific store. When  store is disabled
    /// it doesn't handle actions anymore.
    func disable<S: Store>(store: S) {
        
        assert(false, "missing implementation")
    }
}
