//
//  AudioFilesReducer.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-07.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Igloo

class AudioFilesReducer: NSObject, Reducer, SerialReducer {

    let serialQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialQueue = DispatchQueue(label: Constants.Queues.AudioFilesQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
        super.init()
    }
    
    func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        fatalError("missing implementation")
    }
}
