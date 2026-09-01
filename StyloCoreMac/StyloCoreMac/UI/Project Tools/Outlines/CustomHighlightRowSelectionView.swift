//
//  CustomHighlightRowSelectionView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-06.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

public class CustomHighlightRowSelectionView: NSVisualEffectView {
    
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
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        
        self.blendingMode = .behindWindow
        self.material = .selection
    }
}
