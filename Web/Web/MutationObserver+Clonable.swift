//
//  MutationObserver+Clonable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-17.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

extension MutationObserver : Clonable {
    
    public typealias ClonableType = MutationObserver
    
    
    /// clone() method needed to implement the protocol 
    /// Clonable.
    public func clone() -> MutationObserver {
        
        let clone = MutationObserver(mutationCallback: self.mutationCallback)
        
        for mutationRecord in recordQueue {
            
            clone.recordQueue.append(mutationRecord)
        }
        
        for node in nodes {
            
            clone.nodes.append(node)
        }
        
        return clone
    }
    
}
