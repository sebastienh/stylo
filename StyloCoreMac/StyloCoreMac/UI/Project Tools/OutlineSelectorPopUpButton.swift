//
//  OutlineSelectorPopUpButton.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-08.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class OutlineSelectorPopUpButton: NSPopUpButton {
        
//    override var intrinsicContentSize: NSSize {
//
//        let intrinsicContentSize = super.intrinsicContentSize
//        return NSMakeSize(intrinsicContentSize.width + 4, intrinsicContentSize.height)
//    }
    
    private var arrowColor: NSColor = NSColor.red
    
    private let cornerRadius: CGFloat = 5.0
    
    private let borderWidth: CGFloat = 1.4
    
    private var popUpIndicatorView: NSView? {
        for subview in self.subviews {
            if subview.className == "NSPopUpIndicatorView" {
                return subview
            }
        }
        return nil
    }
    
    private var buttonTextField: NSView? {
        for subview in self.subviews {
            if subview.className == "NSButtonTextField" {
                return subview
            }
        }
        return nil
    }
    
    init() {
        super.init(frame: NSZeroRect, pullsDown: false)
        self.wantsLayer = true
        self.layer?.borderWidth = self.borderWidth
        self.layer?.cornerRadius = self.cornerRadius
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.layer?.borderWidth = self.borderWidth
        self.layer?.cornerRadius = self.cornerRadius
        updateAppearance()
    }
    
    override open func viewDidMoveToWindow() {
        
        super.viewDidMoveToWindow()
        updateAppearance()
    }
    
    override func viewWillDraw() {
        super.viewWillDraw()
        updateAppearance()
    }
    
    override open func viewDidChangeEffectiveAppearance() {
        
        super.viewDidChangeEffectiveAppearance()
        updateAppearance()
    }
    
    private func updateAppearance() {
        
         let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
         switch appearanceName {
         case .darkAqua?:
             
            self.layer?.borderColor = NSColor.quaternaryLabelColor.cgColor
         case .aqua?:
            self.layer?.borderColor = NSColor(calibratedRed: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
         default:
             assert(false)
         }
    }
}
