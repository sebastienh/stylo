//
//  MutationObserverRegistry.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-17.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

struct MutationObserverRegistry {
    
    var registeredObservers: [MutationObserver : MutationObserverInit]
    
    var transientRegisteredObservers : [MutationObserver : MutationObserverInit]
    
    init() {
        self.registeredObservers = [MutationObserver : MutationObserverInit]()
        self.transientRegisteredObservers = [MutationObserver : MutationObserverInit]()
    }
    
    
    
}
