//
//  ThemeSetStore.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-11-15.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo

public final class ThemeSetStore: Store, IdentifiableStoreType {
    
    public typealias ReducerType = ThemeSetReducer
    
    /// Reference to the associated reducer
    public let reducer: ThemeSetReducer
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString
    
    public var themes: DynamicArray<ThemeStore> = DynamicArray<ThemeStore>()
    
    init() {
        
        self.reducer = ThemeSetReducer()
    }
    
}
