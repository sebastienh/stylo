//
//  StylesheetStyleStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import Web

public class StylesheetStyleStore: Store, StylableStoreType, IdentifiableStoreType {
    
    public typealias ReducerType = StylesheetStyleReducer
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString
    
    /// Reference to the associated reducer
    public var reducer: StylesheetStyleReducer
    
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
    
    /// This flag indicates if the there is pending changes
    /// in the
    /// NW-797
    public var pendingStyleChanges = Dynamic<Bool>(false)
    
    required public init(string: String, focusMode: FocusMode, resourceComputedStyle: ResourceComputedStyle, highlightSelectors: SelectorList? = nil) {
    
        self.attributesStore = AttributedStringChangeRecorder(string: string)
        self.resourceComputedStyle = resourceComputedStyle
        self.reducer = StylesheetStyleReducer(storeIdentifier: self.identifier)
        self.focusMode = Dynamic<FocusMode>(focusMode)
        self.highlightSelectors = highlightSelectors
        if focusMode != .disabled {
            self.focusAttributesString = AttributedStringChangeRecorder(string: string)
        }
    }
    
}
