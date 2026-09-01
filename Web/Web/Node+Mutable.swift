//
//  Node+Mutable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-11.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

enum InterestedObserverPairedString : String {
 
    case None = ""
    case OldValue = "oldValue"
}


extension Node : Mutable {
    
    // Method to remove a registered observer from the 
    // list of registered observer of the current context object
    func removeRegisteredObserver(_ observer: MutationObserver) {
        
        mutationObserverRegistry?.registeredObservers.removeValue(forKey: observer)
    }
    
    // Method to register a mutation observer along with options 
    // in the current context object
    func registerObserver(_ observer: MutationObserver, withOptions options: MutationObserverInit) {
        
        mutationObserverRegistry?.registeredObservers.updateValue(options, forKey: observer)
    }
}

























