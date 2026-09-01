//
//  StylesheetDocumentState.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-06-08.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
@testable import WriterCommon

public class StylesheetDocumentState: State {
    
    // for the moment we keep all StylesheetDocumentStore in an
    // array without taking care ogg grouping them by style, it
    // may change in the futur.
    var stylesheetDocumentStore: StylesheetDocumentStore?
    
    init() {
        
    }
    
    /// Add a store to the global state
    public func add<S: Store>(store: S) {
        
        switch store {

        case let stylesheetDocumentStore as StylesheetDocumentStore:
            
            self.stylesheetDocumentStore = stylesheetDocumentStore

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
