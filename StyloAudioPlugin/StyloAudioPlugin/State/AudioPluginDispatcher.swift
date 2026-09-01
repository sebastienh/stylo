//
//  AudioPluginDispatcher.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-08-29.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Igloo

public class AudioPluginDispatcher: Dispatcher {
    
    public let state: State
    
    public var audioPluginState: AudioPluginState? {
        return state as? AudioPluginState
    }
    
    public init(state: AudioPluginState) {
        
        self.state = state
    }
}
