//
//  AudioSliderCell.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-14.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa

class AudioSliderCell: NSSliderCell {
    
    override func stopTracking(last lastPoint: NSPoint, current stopPoint: NSPoint, in controlView: NSView, mouseIsUp flag: Bool) {
        
        super.stopTracking(last: lastPoint, current: stopPoint, in: controlView, mouseIsUp: flag)
        guard let audioSlider = controlView as? AudioSlider else {
            assertionFailure("Error: controlView is not AudioSlider")
            return
        }
        
        if flag {
            guard let audioFileViewController = audioSlider.target as? AudioFileViewController else {
                assertionFailure("Error: audioSlider.target is not AudioFileViewController")
                return
            }
            if audioFileViewController.wasPlayingWhenPaused {
                audioFileViewController.playAtNewPosition(audioSlider)
            }
        }
    }
    
    override func startTracking(at startPoint: NSPoint, in controlView: NSView) -> Bool {
        
        let value = super.startTracking(at: startPoint, in: controlView)
        
        guard let audioSlider = controlView as? AudioSlider else {
            assertionFailure("Error: controlView is not AudioSlider")
            return value
        }
        
        guard let audioFileViewController = audioSlider.target as? AudioFileViewController else {
            assertionFailure("Error: audioSlider.target is not AudioFileViewController")
            return value
        }
        
        audioFileViewController.pause(audioSlider)
        return value
    }
}
