//
//  ProjectOutlineTitleView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-10-31.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

class ProjectOutlineTitleView: NSVisualEffectView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.updateAppearance()
    }
    
    override open func viewDidChangeEffectiveAppearance() {
        self.updateAppearance()
        super.viewDidChangeEffectiveAppearance()
    }
    
    private func updateAppearance() {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            self.blendingMode = .behindWindow
            self.material = .sidebar
        case .aqua?:
            self.blendingMode = .behindWindow
            self.material  = .sidebar
        default:
            assert(false)
        }
    }
}
