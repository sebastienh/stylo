//
//  AudioPluginState.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-08-29.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Igloo
import os
import Common

public class AudioPluginState: State {
    
    private var stores: [String: IdentifiableStoreType]
    
    init() {
        
        self.stores = [String: IdentifiableStoreType]()
    }
    
    public func add<S>(store: S) where S : IdentifiableStoreType, S : Store {
        
        self.stores[store.identifier] = store
    }
}
