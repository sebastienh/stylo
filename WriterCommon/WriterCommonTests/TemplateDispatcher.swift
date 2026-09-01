//
//  TemplateDispatcher.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-08-09.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

class TemplateDispatcher: Dispatcher {
    
    public let state: State
    
    public init(state: TemplateState) {
        
        self.state = state
    }
    
}
