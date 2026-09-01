//
//  ConicalStyleButton.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-01-15.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import QuartzCore
import WriterCommon

public class ConicalStyleButton: AppearanceFollowerButton, CALayerDelegate, StyleManagerBindable {
    
    public var textStylePreview: TextStylePreview? {
        didSet {
            if let _textStylePreview = self.textStylePreview {
                apply(textStylePreview: _textStylePreview)
            }
        }
    }
    
    var lineWidth: CGFloat {
        
        return 2.8
    }
    
    var insideLineWidth: CGFloat {
        
        return 2.0
    }
    
    var insideBorderInsets: CGFloat {
        
        return lineWidth+insideLineWidth+1.2
    }
    
    var insideInsets: CGFloat {
        
        return 8.6
    }
    
    /// Where the arc should end, measured in degrees, where 0 = "3 o'clock".
    
    @IBInspectable var endAngle: CGFloat = 0
    
    /// What is the full angle of the arc, measured in degrees, e.g. 180 = half way around, 360 = all the way around, etc.
    
    @IBInspectable var maxAngle: CGFloat = 360
    
    /// What is the shape at the end of the arc.
    
    var disabledLayer: CAShapeLayer?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func viewDidChangeEffectiveAppearance() {
        
        super.viewDidChangeEffectiveAppearance()
        self.needsDisplay = true
    }
    
    override public func draw(_ dirtyRect: NSRect) {
        
        drawClear()
        if self.state == .off {
            obscure()
        }
    }
    
    func drawClear() {
        
        let borderColor = nsColor(named: "StyleIconBorderColor")
        
        // outside border
        let borderInsets: CGFloat = 1.25
        let borderCircleRect = self.bounds.insetBy(dx: borderInsets, dy: borderInsets)
        let borderCircleWidth = borderCircleRect.width
        let borderCircleRadius = (borderCircleWidth / 2.0)
        let borderCirclePath = NSBezierPath(roundedRect: borderCircleRect, xRadius: borderCircleRadius, yRadius: borderCircleRadius)
        
        borderColor.setFill()
        borderCirclePath.fill()
        
        let outerInsets: CGFloat = 2
        let outerCircleRect = self.bounds.insetBy(dx: outerInsets, dy: outerInsets)
        let outerCircleWidth = outerCircleRect.width
        let outerCircleRadius = (outerCircleWidth / 2.0)
        let outerCirclePath = NSBezierPath(roundedRect: outerCircleRect, xRadius: outerCircleRadius, yRadius: outerCircleRadius)
        
        elementColors[.body]?.setFill()
        outerCirclePath.fill()
        
        assert(bounds.size.width == bounds.size.height)
        let middleCircleRect = self.bounds.insetBy(dx: insideInsets, dy: insideInsets)
        let startAngle = -endAngle + maxAngle
        let center = NSPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = middleCircleRect.width/2
        var angle = startAngle
        
        for i in 1...colors.count {
            
            let percent = CGFloat(i) / CGFloat(colors.count)
            let endAngle = startAngle - percent * maxAngle
            
            let path = NSBezierPath()
            path.appendArc(withCenter: center, radius: radius, startAngle: angle, endAngle: endAngle-2, clockwise: true)
            path.lineWidth = lineWidth
            colors[i-1].setStroke()
            path.stroke()
            angle = endAngle
        }
    }
    
    func obscure(amount: CGFloat = 0.6) {
    
        nsColor(named: "StyleIconObscureColor").setFill()

        let borderInsets: CGFloat = 2
        let borderCircleRect = self.bounds.insetBy(dx: borderInsets, dy: borderInsets)
        let borderCircleWidth = borderCircleRect.width
        let borderCircleRadius = (borderCircleWidth / 2.0)
        let borderCirclePath = NSBezierPath(roundedRect: borderCircleRect, xRadius: borderCircleRadius, yRadius: borderCircleRadius)
        borderCirclePath.fill()
    }
    
    override public func viewDidChangeBackingProperties() {
        
        self.needsDisplay = true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StyleManagerBindable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var colors: [NSColor] = [
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray,
        NSColor.gray
    ]
    
    public weak var styleManager: StyleManager! {
        willSet {
            if let styleManager = styleManager {
                self.unsubscribe(to: styleManager)
            }
        }
        didSet {
            assert(styleManager != nil)
            if let styleManager = styleManager {
                subscribe(to: styleManager)
            }
        }
    }
    
    public func updateAppearance() {
        
        if self.isEnabled {
            if state == NSControl.StateValue.on {
                animateOn()
            }
            else if state == NSControl.StateValue.off {
                animateOff()
            }
        }
        else {
            animateDisabled()
        }
        self.needsDisplay = true
    }
    
    override public func mouseDown(with event: NSEvent) {
        
        self.nextResponder?.mouseDown(with: event)
    }
    
    func forwardMouseDownEvent(with event: NSEvent) {
     
        super.mouseDown(with: event)
    }
    
    public func animateOn() {
        
        self.state = .on
        self.needsDisplay = true
    }
    
    public func animateMixed() {
        
        self.state = .mixed
        self.needsDisplay = true
    }
    
    public func animateOff() {
        
        self.state = .off
        self.needsDisplay = true
    }
    
    public func animateDisabled() {
        
        self.needsDisplay = true
    }
    
    var elementColors: [TextStylePreview.Element: NSColor] = [
        .body: NSColor.gray
    ]
    
    func textPreviewColorsArray(from textStylePreview: TextStylePreview) -> [NSColor] {
        
        var colors = [NSColor]()
        
        elementColors[.body] = textStylePreview.backgroundColor ?? NSColor.gray

        // 1
        if let color = textStylePreview.h1Color {
            colors.append(color)
            colors.append(color)
            colors.append(color)
            colors.append(color)
        }
        
        // 4
        if let color = textStylePreview.h2Color {
            colors.append(color)
            colors.append(color)
        }
        
        // 7
        if let color = textStylePreview.h3Color {
            colors.append(color)
            colors.append(color)
        }

        // 10
        if let color = textStylePreview.foregroundColor(for: .h4) {
            colors.append(color)
        }
        
        // 12
        if let color = textStylePreview.foregroundColor(for: .h5) {
            colors.append(color)
        }
        
        // 11
        if let color = textStylePreview.foregroundColor(for: .h4Tag) {
            colors.append(color)
        }
        
        // 6
        if let color = textStylePreview.h2TagColor {
            colors.append(color)
        }
        
        // 3
        if let color = textStylePreview.h1TagColor {
            colors.append(color)
        }
        
        if let color = textStylePreview.foregroundColor(for: .code) {
            colors.append(color)
            colors.append(color)
            colors.append(color)
        }
        
        // 15
        if let color = textStylePreview.pColor {
            colors.append(color)
            colors.append(color)
            colors.append(color)
            colors.append(color)
            colors.append(color)
            colors.append(color)
        }
        
        if let color = textStylePreview.foregroundColor(for: .hr) {
            colors.append(color)
            colors.append(color)
            colors.append(color)
        }
        
        if let color = textStylePreview.foregroundColor(for: .blockquote) {
            colors.append(color)
            colors.append(color)
            colors.append(color)
        }
        
        return colors
    }
    
    public func apply(textStylePreview: TextStylePreview) {
        
        self.colors.removeAll(keepingCapacity: true)
        self.colors.append(contentsOf: textPreviewColorsArray(from: textStylePreview))
        self.needsDisplay = true
    }
}

