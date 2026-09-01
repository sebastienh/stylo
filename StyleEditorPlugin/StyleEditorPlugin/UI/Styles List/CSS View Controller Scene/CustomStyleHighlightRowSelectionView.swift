//
//  CustomStyleHighlightRowSelectionView.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-12-08.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

public class CustomStyleHighlightRowSelectionView: NSVisualEffectView {
    
    override public var allowsVibrancy: Bool {
        return true
    }
    
    public override var canBecomeKeyView: Bool {
        return false
    }
    
    public override var acceptsFirstResponder: Bool {
        return false
    }
    
    override public var isEmphasized: Bool {
        set {}
        get {return false}
    }
    
    public var selected: Bool = false {
        didSet {
            self.isHidden = !selected
            self.needsDisplay = true
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.updateAppearance()
    }
    
    private func configure() {
        self.updateAppearance()
    }
    
    override open func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
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
            self.material = .dark
        case .aqua?:
            self.blendingMode = .withinWindow
            self.material = .mediumLight
        default:
            assert(false)
        }
    }
    
}
