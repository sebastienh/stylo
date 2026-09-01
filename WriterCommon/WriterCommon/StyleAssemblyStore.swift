//
//  StyleStore.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web

public final class StyleAssemblyStore: Store, IdentifiableStoreType, StylePreviewable {
    
    public var stylePreview: Dynamic<StylePreview?>
    
    public typealias ReducerType = StyleAssemblyReducer
    
    /// Unique identifier for this store
    public let identifier: String = UUID().uuidString
    
    public internal(set) var style: Dynamic<CSSStyle?>
    
    /// Reference to the associated reducer
    public let reducer: StyleAssemblyReducer
    
    public let editedLanguage: Language
    
    public let id: StyleAssemblyIdentifier
    
    var serialQueue: DispatchQueue {
        return reducer.serialQueue
    }
    
    init(editedLanguage: Language, id: StyleAssemblyIdentifier) {
        
        self.editedLanguage = editedLanguage
        self.id = id
        self.style = Dynamic<CSSStyle?>(nil)
        self.stylePreview = Dynamic<StylePreview?>(nil)
        self.reducer = StyleAssemblyReducer(storeIdentifier: identifier)
    }
}


