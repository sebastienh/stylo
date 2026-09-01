//
//  StyloDocumentDispatcher.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-08-31.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

public class StyloDocumentDispatcher: Dispatcher {
    
    public let state: State
    
    public var documentState: DocumentState? {
        return state as? DocumentState
    }
    
    public init(state: DocumentState) {
        
        self.state = state
    }    
}
