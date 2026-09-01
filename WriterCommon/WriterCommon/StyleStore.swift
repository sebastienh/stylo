//
//  StyleStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-06-19.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web

public final class StyleStore: Store, IdentifiableStoreType {
    
    public typealias ReducerType = StyleReducer
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString
    
    public let editedLanguage: Language
    
    public let selectedStyle = Dynamic<Bool>(false)
    
    public let title = Dynamic<String>("Untitled")
    
    public let styleAssemblies: DynamicDictionary<StyleAssemblyDescriptor, StyleAssembly.Id>
    
    public let registrantCounts: DynamicDictionary<StyleAssemblyDescriptor, Int>
    
    /// Reference to the associated reducer
    public let reducer: StyleReducer
    
    var serialQueue: DispatchQueue {
        return reducer.serialQueue
    }
    
    init(title: String, editedLanguage: Language) {
        
        self.title.setValue(title)
        self.editedLanguage = editedLanguage
        self.styleAssemblies = DynamicDictionary<StyleAssemblyDescriptor, StyleAssembly.Id>()
        self.registrantCounts = DynamicDictionary<StyleAssemblyDescriptor, Int>()
        self.reducer = StyleReducer(storeIdentifier: identifier)
    }
}
