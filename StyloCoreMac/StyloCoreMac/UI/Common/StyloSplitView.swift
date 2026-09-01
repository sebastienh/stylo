//
//  StyloSplitView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-08-31.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

class StyloSplitView: NSSplitView {
    
    override var dividerThickness: CGFloat {
        return 1
    }
    
    override var dividerColor: NSColor {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            return NSColor(deviceRed: 82/255, green: 77/255, blue: 81/255, alpha: 1)
        case .aqua?:
            return NSColor(deviceRed: 218/255, green: 212/255, blue: 214/255, alpha: 1)
        default:
            assertionFailure("Error: unsupporrted appearanceName: \(String(describing: appearanceName))")
            return NSColor(deviceRed: 82/255, green: 77/255, blue: 81/255, alpha: 1)
        }
    }
    
    override var isOpaque: Bool {
        
        #if ALPHA_COLOR_ENABLED
        return false
        #else
        return true
        #endif 
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.layer?.isOpaque = true
//        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
//        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        self.needsLayout = true
    }
}
