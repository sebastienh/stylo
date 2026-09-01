//
//  DocumentAudioFilesView.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-11-02.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa

class DocumentAudioFilesView: NSView {
    
    weak var delegate: DocumentAudioFilesViewDelegate?
    
    override func mouseEntered(with event: NSEvent) {
        delegate?.showRightButtons()
    }
    
    override func mouseExited(with event: NSEvent) {
        delegate?.hideRightButtonsIfNecessary()
    }
    
    func createTrackingArea() {
        
        let options = NSTrackingArea.Options.activeInActiveApp.union(.mouseEnteredAndExited).union(.inVisibleRect)
        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
}
