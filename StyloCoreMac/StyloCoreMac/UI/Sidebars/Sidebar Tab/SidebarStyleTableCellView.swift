//
//  SidebarTableCellView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-31.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

final class SidebarStyleTableCellView: NSTableCellView, BackgroundColorBindable {
    
    override var intrinsicContentSize: CGSize {
        
        return NSSize(width: 26, height: 26)
    }
    
    @IBOutlet var styleButton: SmallConicalStyleButton!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.backgroundStyle = .normal
        createTrackingArea()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.backgroundStyle = .normal
        createTrackingArea()
    }
    
    func update(with styleManager: StyleManager) {
        
        styleButton.styleManager = styleManager
    }

    private func createTrackingArea() {
        
        let options = NSTrackingArea.Options.activeInActiveApp.union(.mouseEnteredAndExited).union(.inVisibleRect)
        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        
        handleMouseOver(true)
    }
    
    override func mouseExited(with event: NSEvent) {
        
        handleMouseOver(false)
    }
    
    private func handleMouseOver(_ over: Bool) {
        
//        if styleButton.isEnabled {
//            if over {
//                if self.styleButton.state == .off {
//                    self.styleButton.state = .mixed
//                    self.styleButton.needsDisplay = true
//                }
//            }
//            else {
//                if self.styleButton.state == .mixed {
//                    self.styleButton.state = .off
//                    self.styleButton.needsDisplay = true
//                }
//            }
//        }
    }
    
}

