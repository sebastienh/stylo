//
//  SourceSetStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-29.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo

class SourceSetStore: Store {
    
    public var reducer: SourceSetReducer
    
    public typealias ReducerType = SourceSetReducer
    
    convenience init(sourceSetMetadata: SourceSetMetadata) {
        
        self.init()
    }
    
    init() {
        
        self.reducer = SourceSetReducer()
    }
}
