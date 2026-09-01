//
//  FilterBackgroundView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-21.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import StyloCoreMac

class FilterBackgroundView: NSView {
    
    private var alphaView: ColoredView?
    
    private let cornerRadius: CGFloat = 5.0
        
    override open func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        self.wantsLayer = true

        addAlphaView()
        updateAppearance()
    }
    
    override open func viewDidChangeEffectiveAppearance() {
        updateAppearance()
        super.viewDidChangeEffectiveAppearance()
    }
    
    private func addAlphaView() {
        
        if self.alphaView == nil {
        
            let alphaView = ColoredView()
            alphaView.cornerRadius = self.cornerRadius
            alphaView.borderWidth = 0.5
            
            
            
            alphaView.translatesAutoresizingMaskIntoConstraints = false
            self.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(alphaView, positioned: .below, relativeTo: nil)
            
            NSLayoutConstraint(item: alphaView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: alphaView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: alphaView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: alphaView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
            self.needsUpdateConstraints = true
            self.alphaView = alphaView
        }
    }
    
    private func updateAppearance() {

        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            self.wantsLayer = true
            self.layer?.backgroundColor = NSColor.clear.cgColor
            self.layer?.cornerRadius = self.cornerRadius
            self.alphaView?.layer?.borderColor = NSColor.darkGray.cgColor
            self.alphaView?.backgroundColor = NSColor.black.withAlphaComponent(0.2)
        case .aqua?:
            self.wantsLayer = true
            self.layer?.backgroundColor = NSColor.clear.cgColor
            self.layer?.cornerRadius = self.cornerRadius
            self.alphaView?.layer?.borderColor = NSColor.systemGray.withAlphaComponent(0.6).cgColor
            self.alphaView?.backgroundColor = NSColor.systemGray.withAlphaComponent(0.1)
        default:
            assert(false)
        }
    }
    
}
