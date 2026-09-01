//
//  JsonDispatcher.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-08-09.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

class JsonDispatcher: Dispatcher {
    
    public let state: State
    
    public init(state: JsonState) {
        
        self.state = state
    }
    
}
