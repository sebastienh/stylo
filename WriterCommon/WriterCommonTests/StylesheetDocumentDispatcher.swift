//
//  StylesheetDocumentDispatcher.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-06-08.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

class StylesheetDocumentDispatcher: Dispatcher {
    
    public let state: State
    
    public init(state: StylesheetDocumentState) {
        
        self.state = state
    }
    
}
