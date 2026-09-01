//
//  JsonStyleStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import Web

public class JsonStyleStore: Store, StylableStoreType, IdentifiableStoreType {
    
    public typealias ReducerType = JsonStyleReducer
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString
    
    /// Reference to the associated reducer
    public var reducer: JsonStyleReducer
    
    /// queues on which we access the document, it is defined here
    /// because we may need to queue to provide read access to the document
    /// from outside the local Reducer
    public var serialCompilationQueue: DispatchQueue {
        return reducer.serialCompilationQueue
    }
    
    public var documentConcurrentQueue: DispatchQueue {
        return reducer.documentConcurrentQueue
    }
    
    public var attributesStoreConcurrentQueue: DispatchQueue {
        return reducer.attributesStoreConcurrentQueue
    }
    
    public var attributesCompilationSerialQueue: DispatchQueue {
        return reducer.attributesCompilationSerialQueue
    }
    
    /// The string used to record attributes.
    public let attributesStore: StylableString
    
    public let resourceComputedStyle: ResourceComputedStyle
    
    public let focusMode: Dynamic<FocusMode>
    
    public var focusAttributesString: StylableString?
    
    public var previousRenderedTopElements: ContiguousArray<Element>?
    
    /// This flag indicates if the there is pending changes
    /// in the
    /// NW-797
    public var pendingStyleChanges = Dynamic<Bool>(false)
    
    public let selectorHighlightString: Dynamic<String?> = Dynamic<String?>(nil)
    
    public var highlightSelectors: SelectorList?
    
    required public init(string: String, focusMode: FocusMode, resourceComputedStyle: ResourceComputedStyle, highlightSelectors: SelectorList?) {
    
        self.attributesStore = AttributedStringChangeRecorder(string: string)
        self.resourceComputedStyle = resourceComputedStyle
        self.reducer = JsonStyleReducer(storeIdentifier: self.identifier)
        self.focusMode = Dynamic<FocusMode>(focusMode)
        self.highlightSelectors = highlightSelectors
        if focusMode != .disabled {
            self.focusAttributesString = AttributedStringChangeRecorder(string: string)
        }
    }
    
}
