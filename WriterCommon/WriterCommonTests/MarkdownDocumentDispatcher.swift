//
//  MarkdownDocumentDispatcher.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-07-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

class MarkdownDocumentDispatcher: Dispatcher {
    
    public let state: State
    
    public init(state: MarkdownDocumentState) {
        
        self.state = state
    }
    
}
