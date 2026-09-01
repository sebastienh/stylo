//
//  ProjectOutlineTilteView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-12-21.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class ProjectOutlineHeaderView: NSVisualEffectView {
    
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
