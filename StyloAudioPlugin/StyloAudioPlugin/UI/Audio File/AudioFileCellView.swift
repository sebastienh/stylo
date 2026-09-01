//
//  AudioFileCellView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon

class AudioFileCellView: NSTableCellView {
    
    var audioFileViewController: AudioFileViewController?
    
    var isShowingPlaybackControls: Bool {
        
        guard let audioFileViewController = self.audioFileViewController else {
            assertionFailure("Error: self.audioFileViewController is nil")
            return false
        }
        
        return audioFileViewController.isShowingPlaybackView
    }
}
