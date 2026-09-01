//
//  RecordingBackgroundActivity.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-11-04.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import WriterCommon

class RecordingBackgroundActivity: BackgroundActivity {
    
    static let shared: RecordingBackgroundActivity = RecordingBackgroundActivity()
    
    var name: String {
        return "recording"
    }
    
    var requiresEditorControlsDisplay: Bool {
        return true
    }
    
    private init() {
        
    }
}
