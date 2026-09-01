//
//  StyleTitlePanelView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-01-29.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon

final class StyleTitlePanelView: NSVisualEffectView {
 
    override func mouseDown(with event: NSEvent) {
     
        // we intercept to mouse down...
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        listenToAppearanceChange()
    }
    
    private func updateAppearance() {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            self.blendingMode = .behindWindow
            self.material = .sidebar
        case .aqua?:
            self.blendingMode = .behindWindow
            self.material = .sidebar
        default:
            assert(false)
        }
    }
    
    private func listenToAppearanceChange() {
        self.appearance = StyloApplication.shared.computedAppearance.value?.appearance ?? AppearanceMode.dark.appearance
        updateAppearance()
        StyloApplication.shared.computedAppearance.subscribe({ [weak self](appearanceMode) in
            self?.appearance = appearanceMode?.appearance ?? AppearanceMode.dark.appearance
            self?.updateAppearance()
        }, observer: self)
    }
    
    deinit {
        
        StyloApplication.shared.computedAppearance.unsubscribe(observer: self)
    }
    
}

