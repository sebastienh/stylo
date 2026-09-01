//
//  AudioFilesStore.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-07.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Igloo
import Common

class AudioFilesStore: Store, IdentifiableStoreType {
    
    typealias ReducerType = AudioFilesReducer
    
    var identifier: String
    
    let recordingAudioFile: Dynamic<String?>
    
    let reducer: AudioFilesReducer
    
    init() {
        self.identifier = UUID().uuidString
        self.recordingAudioFile = Dynamic<String?>(nil)
        self.reducer = AudioFilesReducer(storeIdentifier: self.identifier)
    }
    
}
