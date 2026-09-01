//
//  StyledMarkdownStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-14.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import Web

public class MarkdownStyleStore: Store, StylableStoreType, IdentifiableStoreType {
    
    public typealias ReducerType = MarkdownStyleReducer
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString
    
    /// Reference to the associated reducer
    public var reducer: MarkdownStyleReducer
    
    /// queues on which we access the document, it is defined here
    /// because we may need to queue to provide read access to the document
    /// from outside the local Reducer
    public var serialCompilationQueue: DispatchQueue {
        return reducer.serialCompilationQueue
    }
    
    /// The string used to record attributes.
    public let attributesStore: StylableString
    
    public let resourceComputedStyle: ResourceComputedStyle
    
    public let focusMode: Dynamic<FocusMode>
    
    public var focusAttributesString: StylableString?
    
    public let selectorHighlightString: Dynamic<String?> = Dynamic<String?>(nil)
    
    public var highlightSelectors: SelectorList?
    
    /// This flag indicates if there is pending changes
    /// in the
    /// NW-797
    public var pendingStyleChanges = Dynamic<Bool>(false)
    
    public var styleId: Dynamic<String?> = Dynamic<String?>(nil)
    
    var string: String {
        
        return self.attributesStore.string
    }
    
    required public init(string: String, focusMode: FocusMode, resourceComputedStyle: ResourceComputedStyle, highlightSelectors: SelectorList? = nil) {
    
        #if CONCURENT_RENDERING
        self.attributesStore = AttributedStringChangeRecorder(string: string)
        #else
        self.attributesStore = AttributedStringChangeRecorder(string: string)
        #endif
        
        self.resourceComputedStyle = resourceComputedStyle
        self.reducer = MarkdownStyleReducer(storeIdentifier: self.identifier)
        self.focusMode = Dynamic<FocusMode>(focusMode)
        self.highlightSelectors = highlightSelectors
        
        if focusMode != .disabled {
            #if CONCURENT_RENDERING
            self.focusAttributesString = AttributedStringChangeRecorder(string: string)
            #else
            self.focusAttributesString = AttributedStringChangeRecorder(string: string)
            #endif
        }
    }
    
    public func updateAttributesString(withChange change: SourceStringChangeDescription) {
        
        self.attributesStore.update(with: change)
        self.focusAttributesString?.update(with: change)
    }
}
