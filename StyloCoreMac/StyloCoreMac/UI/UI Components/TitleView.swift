//
//  TitleView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-11.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

open class TitleView: NSVisualEffectView {
    
    override open var interiorBackgroundStyle: NSView.BackgroundStyle {
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            return .dark
        case .aqua?:
            return .light
        default:
            assert(false)
            return .normal
        }
    }
    
    override open func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        updateAppearance()
    }
    
    override open func viewDidChangeEffectiveAppearance() {
        updateAppearance()
        super.viewDidChangeEffectiveAppearance()
    }
    
    private func updateAppearance() {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            self.blendingMode = .withinWindow
            self.material = .titlebar
        case .aqua?:
            self.blendingMode = .withinWindow
            self.material  = .titlebar
        default:
            assert(false)
        }
    }
}
