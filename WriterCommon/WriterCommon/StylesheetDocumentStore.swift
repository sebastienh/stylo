//
//  StylesheetDocumentStore.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Markdown
import Common
import PromiseKit
import Igloo

public final class StylesheetDocumentStore: Store, IdentifiableStoreType, FailableStoreType, EditableStoreType, DocumentStoreType {
    
    public typealias ReducerType = StylesheetDocumentReducer
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString
    
    /// Reference to the associated reducer
    public let reducer: StylesheetDocumentReducer
    
    var disabled: Bool
    
    var stylesheet: Dynamic<CSSStyleSheet?>
    
    let origin: CSSOrigin
    
    /// queues on which we access the document, it is defined here
    /// because we may need to queue to provide read access to the document
    /// from outside the local Reducer
    public var serialCompilationQueue: DispatchQueue {
        return reducer.serialCompilationQueue
    }
    
    let hasPendingChanges: Dynamic<Bool>
    
    var lastAppliedStylesheet: CSSStyleSheet?
    
    public let document = Dynamic<Document?>(nil)
    
    public let appearances: DynamicSet<AppearanceMode>
    
    public let alwaysAllowPartialCompilation: Bool
    
    init(origin: CSSOrigin, appearances: Set<AppearanceMode>, alwaysAllowPartialCompilation: Bool = false) {

        self.disabled = false
        self.stylesheet = Dynamic<CSSStyleSheet?>(nil)
        self.origin = origin
        self.reducer = StylesheetDocumentReducer(storeIdentifier: identifier)
        self.hasPendingChanges = Dynamic<Bool>(false)
        self.appearances = DynamicSet<AppearanceMode>(appearances)
        self.alwaysAllowPartialCompilation = alwaysAllowPartialCompilation
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EditableStoreType protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public let sourceString: Dynamic<String?> = Dynamic<String?>(nil)
    
    public var editingChanges = DynamicArray<SourceStringChangeDescription>()
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: FailableStoreType protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public let errorMessages = DynamicArray<Message>()
    
    public let storeState = Dynamic<FailableStoreState>(FailableStoreState.source)
    
}
