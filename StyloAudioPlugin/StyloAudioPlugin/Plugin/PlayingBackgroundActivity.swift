//
//  PlayingBackgroundActivity.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-11-12.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon

class PlayingBackgroundActivity: BackgroundActivity {
    
    static let shared: PlayingBackgroundActivity = PlayingBackgroundActivity()
    
    var name: String {
        return "playing"
    }
    
    var requiresEditorControlsDisplay: Bool {
        return true
    }
    
    private init() {
        
    }
}
