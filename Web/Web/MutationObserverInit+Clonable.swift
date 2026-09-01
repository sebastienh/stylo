//
//  MutationObserverInit+Clonable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-17.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

extension MutationObserverInit: Clonable {
    
    typealias ClonableType = MutationObserverInit
    
    /// clone() method needed to implement the protocol
    /// Clonable.
    func clone() -> MutationObserverInit.ClonableType {
        
        return MutationObserverInit(values: values, globalIndex: globalIndex)
    }
}
