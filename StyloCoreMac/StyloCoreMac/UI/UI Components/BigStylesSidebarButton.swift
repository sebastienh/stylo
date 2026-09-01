//
//  BigStylesSidebarButton.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-08.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import QuartzCore
import Cocoa
import Common
import os

fileprivate let layerFrameWidth: CGFloat = 18.0
fileprivate let circleWidth: CGFloat = 12
fileprivate let buttonHeight: CGFloat = 60.0
fileprivate let lineWidth: CGFloat = 2.0

fileprivate let firstCircleColor: CGColor = NSColor(calibratedRed: 247/255, green: 58/255, blue: 31/255, alpha: 1.0).cgColor
fileprivate let secondCircleColor: CGColor = NSColor(calibratedRed: 254/255, green: 190/255, blue: 45/255, alpha: 1.0).cgColor

fileprivate let firstDisableCircleColor: CGColor = NSColor.gray.cgColor
fileprivate let secondDisableCircleColor: CGColor = NSColor.gray.cgColor

public class BigStylesSidebarButton: AppearanceFollowerButton, CALayerDelegate {

    internal var firstCircleLayer: CircleLayer?
    
    internal var secondCircleLayer: CircleLayer?
    
    // MARK: Setup & Initialization
    
    override open var isEnabled: Bool {
        
        get {
            return super.isEnabled
        }
        set {
            super.isEnabled = newValue
            
            if newValue {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Enabling BigStylesSidebarButton", log: Log.StyloCore.all, type: .info)
                #endif
                enable()
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Disabling BigStylesSidebarButton", log: Log.StyloCore.all, type: .info)
                #endif
                disable()
            }
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.setup(firstColor: firstCircleColor, secondColor: secondCircleColor)
        
    }
    override init(frame: NSRect) {
        
        assert(frame.size.width == layerFrameWidth)
        assert(frame.size.height == buttonHeight)
        super.init(frame: frame)
        self.wantsLayer = true
        self.setup(firstColor: firstCircleColor, secondColor: secondCircleColor)
    }
    
    internal func setup(firstColor: CGColor, secondColor: CGColor) {
        

        
        if self.firstCircleLayer == nil && self.secondCircleLayer == nil {
        
            wantsLayer = true
            layer?.masksToBounds = true
            layer?.delegate = self
            layer?.frame = self.bounds
            
            let rects = circlesRects(from: self.bounds)
            
            self.firstCircleLayer = CircleLayer(with: rects[0], lineWidth: lineWidth, strokeColor: firstColor)
            self.firstCircleLayer?.delegate = self
            self.layer?.addSublayer(self.firstCircleLayer!)
            self.secondCircleLayer = CircleLayer(with: rects[1], lineWidth: lineWidth, strokeColor: secondColor)
            self.secondCircleLayer?.delegate = self
            self.layer?.addSublayer(self.secondCircleLayer!)
        }
        
        self.setupContentScale()
        
        if let firstCircleLayer = self.firstCircleLayer {
            
            firstCircleLayer.strokeColor = firstColor
            firstCircleLayer.setNeedsDisplay()
        }
        
        if let secondCircleLayer = self.secondCircleLayer {
            
            secondCircleLayer.strokeColor = secondColor
            secondCircleLayer.setNeedsDisplay()
        }
    }
    
    private func disable() {
        
        setup(firstColor: firstDisableCircleColor, secondColor: secondDisableCircleColor)
    }
    
    private func enable() {
        
        setup(firstColor: firstCircleColor, secondColor: secondCircleColor)
    }
    
    private func setCirclesColors(colors: [CGColor]) {
        
        setup(firstColor: colors[0], secondColor: colors[1])
    }
    
    private func circlesRects(from rect: NSRect) -> [NSRect] {
        
        let origin: CGFloat = 8
        let space: CGFloat = 2
        
        let firstRect = NSMakeRect(1, origin, layerFrameWidth, layerFrameWidth)
        let secondRect = NSMakeRect(1, origin+layerFrameWidth+space, layerFrameWidth, layerFrameWidth)
        
        return [firstRect, secondRect]
    }

    override open func draw(_ dirtyRect: NSRect) {
        
    }

    override open func mouseDown(with event: NSEvent) {
        
        if self.isEnabled {
        
            let gray = CGColor(gray: 0.5, alpha: 1)
            setCirclesColors(colors: [gray, gray, gray])
            super.mouseDown(with: event)
            
            let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.setCirclesColors(colors: [firstCircleColor, secondCircleColor])
            }
        }
    }
    
    private func setupContentScale() {
        
        if let backingScaleFactor = self.window?.backingScaleFactor {
            
            self.layer!.contentsScale = backingScaleFactor
            self.firstCircleLayer!.contentsScale = backingScaleFactor
            self.secondCircleLayer!.contentsScale = backingScaleFactor
        }
    }
}
