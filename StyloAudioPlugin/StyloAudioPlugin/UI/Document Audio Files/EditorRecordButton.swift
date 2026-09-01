//
//  EditorRecordButton.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-02.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa

class EditorRecordButton: RecordButton {
    
    let documentAudioFilesId: String?
    
    init(documentAudioFilesId: String) {
        
        self.documentAudioFilesId = documentAudioFilesId
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        
        self.documentAudioFilesId = ""
        super.init(coder: coder)
    }
    
//    override func startPulsating() {
//        
//        if self.window != nil {
//            
//            if shouldChangeImage {
//                let bundle = Bundle(for: type(of: self))
//                guard let image = bundle.image(forResource: NSImage.Name("recording-button-editor-title")) else {
//                    assertionFailure("Error: image with name \"recording-button-editor-title\" is nil")
//                    return
//                }
//                
//                self.image = image
//            }
//            pulsating = true
//        }
//        else {
//            shouldStartPulsating = true
//        }
//    }
//    
//    override func stopPulsating() {
//        
//        if shouldChangeImage {
//            let bundle = Bundle(for: type(of: self))
//            guard let image = bundle.image(forResource: NSImage.Name("record-button-editor-title")) else {
//                assertionFailure("Error: image with name \"recording-button-editor-title\" is nil")
//                return
//            }
//            
//            self.image = image
//        }
////        self.layer?.removeAnimation(forKey: "animateOpacity")
//        pulsating = false
//        shouldStartPulsating = false
//    }
}
