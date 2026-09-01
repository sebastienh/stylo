//
//  RecordButton.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-16.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import StyloCoreMac

class RecordButton: MacDisableableButton {
    
    @IBInspectable var shouldChangeImage: Bool = true
    
    var pulsating: Bool = false
    
    var shouldStartPulsating: Bool = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if shouldStartPulsating {
            self.startPulsating()
        }
    }
    
    func startPulsating() {
        
        if self.window != nil {
            
            let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            pulseAnimation.duration = 0.5
            pulseAnimation.fromValue = 0.4
            pulseAnimation.toValue = 1
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = .greatestFiniteMagnitude
            self.layer?.add(pulseAnimation, forKey: "animateOpacity")
            
            if shouldChangeImage {
                let bundle = Bundle(for: type(of: self))
                guard let image = bundle.image(forResource: NSImage.Name("recording-button-editor-title")) else {
                    assertionFailure("Error: image with name \"recording-button-editor-title\" is nil")
                    return
                }
                
                self.image = image
            }
            pulsating = true
        }
        else {
            shouldStartPulsating = true
        }
    }
    
    func stopPulsating() {
        
        if shouldChangeImage {
            let bundle = Bundle(for: type(of: self))
            guard let image = bundle.image(forResource: NSImage.Name("record-button-editor-title")) else {
                assertionFailure("Error: image with name \"recording-button-editor-title\" is nil")
                return
            }
            
            self.image = image
        }
        self.layer?.removeAnimation(forKey: "animateOpacity")
        pulsating = false
        shouldStartPulsating = false
    }
    
}
