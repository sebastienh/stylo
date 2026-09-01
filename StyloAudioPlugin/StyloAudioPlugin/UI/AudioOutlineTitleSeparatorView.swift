//
//  AudioOutlineTitleSeparatorView.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-31.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//
import Cocoa

class AudioOutlineTitleSeparatorView: NSVisualEffectView {
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        updateAppearance()
    }
    
    override func viewDidChangeEffectiveAppearance() {
        updateAppearance()
        super.viewDidChangeEffectiveAppearance()
    }
    
    private func updateAppearance() {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            self.blendingMode = .behindWindow
            self.material = .titlebar
        case .aqua?:
            self.blendingMode = .withinWindow
            self.material = .titlebar
        default:
            assert(false)
        }
    }
    
}
