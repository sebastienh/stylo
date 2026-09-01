//
//  EditorContentView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class EditorContentView: ColoredView {
    
    private var _forcedWitdhConstraint: NSLayoutConstraint!
    
    public var isContentResizeEnable: Bool = true {
        didSet {
            if isContentResizeEnable {
                //                assert(_forcedWitdhConstraint.isActive)
                //                self._forcedWitdhConstraint.isActive = false
                //                self._forcedWitdhConstraint.priority = .defaultLow
                self.setContentHuggingPriority(.defaultLow, for: .horizontal)
                self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                self.needsUpdateConstraints = true
                
                
            }
            else {
                //                assert(!_forcedWitdhConstraint.isActive)
                //                self._forcedWitdhConstraint.constant = self.frame.width
                //                self._forcedWitdhConstraint.isActive = true
                //                self._forcedWitdhConstraint.priority = .required
                self.setContentHuggingPriority(.required, for: .horizontal)
                self.setContentCompressionResistancePriority(.required, for: .horizontal)
                self.needsUpdateConstraints = true
                
            }
        }
    }
    
    
    override public init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        installForcedWitdhConstraint()
    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        installForcedWitdhConstraint()
    }
    
    private func installForcedWitdhConstraint() {
        
        self._forcedWitdhConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self._forcedWitdhConstraint.priority = .required
        self.addConstraint(self._forcedWitdhConstraint)
        self._forcedWitdhConstraint.isActive = false
        self.needsUpdateConstraints = true
    }
}
