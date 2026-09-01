//
//  TwoCirclesLayer.swift
//  Stylo
//
//  Created by Sebastien hamel on 2018-10-24.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os

fileprivate let circleWidth: CGFloat = 12

class CircleLayer: CAShapeLayer {
    
    private var circlePath: CGPath {
        
        let radius = circleWidth / 2.0
        let rectPath = NSMakeRect(3, self.bounds.origin.y, circleWidth, circleWidth)
        let circlePath = NSBezierPath(roundedRect: rectPath, xRadius: radius, yRadius: radius)
        return circlePath.CGPath
    }
    
    init(with frame: CGRect, lineWidth: CGFloat, strokeColor: CGColor) {
        
        super.init()
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.fillColor = CGColor.clear
        self.frame = frame
        self.path = circlePath
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
}
