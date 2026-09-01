//
//  SmallConicalStyleButton.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-01-15.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import QuartzCore
import WriterCommon

fileprivate let enabledStrokeColor: CGColor = CGColor(gray: 0.5, alpha: 1)

fileprivate let disabledColor: CGColor = CGColor(gray: 0.5, alpha: 0.3)

fileprivate let disabledStrokeColor: CGColor = CGColor(gray: 0.5, alpha: 1)

fileprivate let grayColors: [CGColor] = [
    CGColor(gray: 0.1, alpha: 1),
    CGColor(gray: 0.2, alpha: 1),
    CGColor(gray: 0.3, alpha: 1),
    CGColor(gray: 0.4, alpha: 1),
    CGColor(gray: 0.5, alpha: 1),
    CGColor(gray: 0.4, alpha: 1)
]

class SmallConicalStyleButton: ConicalStyleButton {
    
    override var lineWidth: CGFloat {
        
        return 2.2
    }
    
    override var insideLineWidth: CGFloat {
        
        return 3.8
    }
    
    override var insideBorderInsets: CGFloat {
        
        return lineWidth+insideLineWidth+1
    }
    
    override var insideInsets: CGFloat {
        
        return 7
    }
    
    override var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            super.isEnabled = newValue
            self.needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        if isEnabled {
            if self.state == .on {
                drawGrayedOut()
            }
            else {
                super.drawClear()
            }
        }
        else {
            obscure()
        }
    }
    
    private func drawGrayedOut() {
        
        let enabledColor = NSColor.gray
        
        let insideInsets = lineWidth+insideLineWidth+1
        let insideCircleRect = self.bounds.insetBy(dx: insideInsets, dy: insideInsets)
        let insideCircleWidth = insideCircleRect.width
        let insideCircleRadius = (insideCircleWidth / 2.0)
        let insideCirclePath = NSBezierPath(roundedRect: insideCircleRect, xRadius: insideCircleRadius, yRadius: insideCircleRadius)
        
        insideCirclePath.lineWidth = insideLineWidth
        enabledColor.setStroke()
        insideCirclePath.stroke()
        
        let outsideInsets = lineWidth
        let outsideCircleRect = self.bounds.insetBy(dx: outsideInsets, dy: outsideInsets)
        let outsideCircleWidth = outsideCircleRect.width
        let outsideCircleRadius = (outsideCircleWidth / 2.0)
        let outerCirclePath = NSBezierPath(roundedRect: outsideCircleRect, xRadius: outsideCircleRadius, yRadius: outsideCircleRadius)
        
        outerCirclePath.lineWidth = insideLineWidth
        enabledColor.setStroke()
        outerCirclePath.stroke()
    }
    
    override func mouseDown(with event: NSEvent) {
        if self.isEnabled {
            super.forwardMouseDownEvent(with: event)
        }
    }
}
    
