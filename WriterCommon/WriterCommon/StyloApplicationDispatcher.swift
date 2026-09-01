//
//  StyloApplicationDispatcher.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-11-12.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

public class StyloApplicationDispatcher: Dispatcher {

//    typealias StateType = ApplicationState
    
    public let state: State
    
    public init() {
        
        self.state = ApplicationState()
    }
}
