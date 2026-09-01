//
//  CustomHighlightRowSelectionView.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-10-18.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa


class CustomHighlightRowSelectionView: NSVisualEffectView {
    
    override var allowsVibrancy: Bool {
        return true
    }
    
    override var isEmphasized: Bool {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var selected: Bool = false {
        didSet {
            self.isHidden = !selected
            self.needsDisplay = true
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
        handleAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        handleAppearance()
    }
    
    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        handleAppearance()
    }
    
    private func configure() {
        
        self.blendingMode = .behindWindow
    }
    
    private func handleAppearance() {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            self.material = .dark
        case .aqua?:
            self.material = .mediumLight
        default:
            assert(false)
            self.material = .dark
        }
    }
    
}
