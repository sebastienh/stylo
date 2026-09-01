//
//  ProgressBar.swift
//  ProgressKit
//
//  Created by Kauntey Suryawanshi on 31/07/15.
//  Copyright (c) 2015 Kauntey Suryawanshi. All rights reserved.
//
import Foundation
import Cocoa

@IBDesignable
open class ProgressBar: DeterminateAnimation {
    
    open var borderLayer = CAShapeLayer()
    open var progressLayer = CAShapeLayer()
    
    var percentRange: (lowerBound: CGFloat, upperBound: CGFloat)? {
        
        didSet {
            updateProgress()
        }
    }
    
    var progressFrameComplete: NSRect!
    
    @IBInspectable open var borderColor: NSColor = NSColor.black {
        didSet {
            notifyViewRedesigned()
        }
    }
    
    override open func updateLayer() {
        
        borderLayer.backgroundColor = cgColor(named: "SidebarStylesProgressScrollerBackground")
        progressLayer.backgroundColor = cgColor(named: "SidebarStylesProgressScroller")
        super.updateLayer()
    }
    
    override func notifyViewRedesigned() {
        
        super.notifyViewRedesigned()
        self.layer?.cornerRadius = self.frame.height / 2
        borderLayer.borderColor = cgColor(named: "SidebarStylesProgressScrollerBackground")
        progressLayer.backgroundColor = cgColor(named: "SidebarStylesProgressScroller")
    }
    
    override func configureLayers() {
        
        super.configureLayers()
        
        borderLayer.frame = self.bounds
        borderLayer.cornerRadius = borderLayer.frame.height / 2
        borderLayer.borderWidth = 0.0
        self.layer?.addSublayer(borderLayer)
        
        self.progressFrameComplete = NSInsetRect(borderLayer.bounds, 0.5, 0.5)
        
        progressLayer.frame = self.progressFrameComplete
        progressLayer.frame.size.width = (borderLayer.bounds.width - 6)
        progressLayer.cornerRadius = progressLayer.frame.height / 2
        progressLayer.backgroundColor = cgColor(named: "SidebarStylesProgressScroller")
        borderLayer.addSublayer(progressLayer)
    }
    
    override func updateProgress() {
        
        if let percentRange = percentRange {
            
            let endPercent = 1 - percentRange.upperBound
            
            let x = progressFrameComplete.origin.x + self.progressFrameComplete.width * percentRange.lowerBound
            let width = self.progressFrameComplete.width - (progressFrameComplete.width * percentRange.lowerBound) - (progressFrameComplete.width * endPercent)
            
            let frame = NSMakeRect(x, progressFrameComplete.origin.y, width, progressFrameComplete.size.height)
            
            CATransaction.begin()
            if animated {
                CATransaction.setAnimationDuration(0.2)
            } else {
                CATransaction.setDisableActions(true)
            }
            let timing = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            CATransaction.setAnimationTimingFunction(timing)
            progressLayer.frame = frame
            CATransaction.commit()
        }
    }
}










