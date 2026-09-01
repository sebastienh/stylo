//
//  StylableStateType.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-08-29.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo

public protocol StylableStoreType: StylableStringContainer {
    
    /// queues on which we access the document, it is defined here
    /// because we may need to queue to provide read access to the document
    /// from outside the local Reducer
    var serialCompilationQueue: DispatchQueue { get }
    
    /// The string used to record attributes. 
    var attributesStore: StylableString { get }
    
    var focusAttributesString: StylableString? { get }
    
    var focusMode: Dynamic<FocusMode> { get }
    
    var resourceComputedStyle: ResourceComputedStyle { get }
    
    /// This flag indicates if the there is pending changes
    /// in the
    /// NW-797
    var pendingStyleChanges: Dynamic<Bool> { get }
    
    var selectorHighlightString: Dynamic<String?> { get }
    
    var highlightSelectors: SelectorList? { get set }
    
    init(string: String, focusMode: FocusMode, resourceComputedStyle: ResourceComputedStyle, highlightSelectors: SelectorList?)
    
    func updateAttributesString(withChange change: SourceStringChangeDescription)
    
}

extension StylableStoreType where Self: Store {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StylableStringContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var stylableString: StylableString {
        
        return attributesStore
    }
    
    public func updateAttributesString(withChange change: SourceStringChangeDescription) {
        
        self.attributesStore.update(with: change)
    }
    
}
