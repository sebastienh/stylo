//
//  CirclesStyleButton.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-12-08.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import QuartzCore
import WriterCommon

public class CirclesStyleButton: AppearanceFollowerButton, CALayerDelegate, StyleManagerBindable {
    
    public var textStylePreview: TextStylePreview? {
        didSet {
            if let _textStylePreview = self.textStylePreview {
                apply(textStylePreview: _textStylePreview)
            }
        }
    }
    
    var lineWidth: CGFloat {
        
        return 6.0
    }
    
    var insideInsets: CGFloat {
        
        return 12.6
    }
    
    /// Where the arc should end, measured in degrees, where 0 = "3 o'clock".
    
    @IBInspectable var endAngle: CGFloat = 0
    
    /// What is the full angle of the arc, measured in degrees, e.g. 180 = half way around, 360 = all the way around, etc.
    @IBInspectable var maxAngle: CGFloat = 360
    
    /// What is the shape at the end of the arc.
    var disabledLayer: CAShapeLayer?
    
    private var shouldDrawBorder: Bool = false
    
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
        
        if shouldDrawBorder {
            drawBorder()
        }
        
//        let outerInsets: CGFloat = 2
//        let outerCircleRect = self.bounds.insetBy(dx: outerInsets, dy: outerInsets)
//        let outerCircleWidth = outerCircleRect.width
//        let outerCircleRadius = outerCircleWidth / 2.0
//        let outerCirclePath = NSBezierPath(roundedRect: outerCircleRect, xRadius: outerCircleRadius, yRadius: outerCircleRadius)
//
//        elementColors[.h1]?.setFill()
//        outerCirclePath.fill()
//
//
        
        let color1 = elementColors[.h1Tag] ?? NSColor.gray
        self.drawCircle(outerInsets: 2, withColor: color1)
        
        let color2 = elementColors[.h1] ?? NSColor.gray
        self.drawCircle(outerInsets: 8, withColor: color2)
        
        let color3 = elementColors[.code] ?? NSColor.gray
        self.drawCircle(outerInsets: 12, withColor: color3)
        
        let color4 = elementColors[.p] ?? NSColor.gray
        self.drawCircle(outerInsets: 16, withColor: color4)
        
//
//        assert(bounds.size.width == bounds.size.height)
//        let middleCircleRect = self.bounds.insetBy(dx: insideInsets, dy: insideInsets)
//        let startAngle = -endAngle + maxAngle
//        let center = NSPoint(x: frame.width / 2, y: frame.height / 2)
//        print("middleCircleRect.width: \(middleCircleRect.width)")
//        let radius = middleCircleRect.width/2
//        var angle = startAngle
//
//        for i in 1...colors.count {
//
//            let percent = CGFloat(i) / CGFloat(colors.count)
//            let endAngle = startAngle - percent * maxAngle
//
//            let path = NSBezierPath()
//            path.appendArc(withCenter: center, radius: radius, startAngle: angle, endAngle: endAngle-2, clockwise: true)
//            path.lineWidth = lineWidth
//            colors[i-1].setStroke()
//            path.stroke()
//            angle = endAngle
//        }
    }
    
    private func drawCircle(outerInsets: CGFloat = 2, withColor color: NSColor) {
        
        let circleRect = self.bounds.insetBy(dx: outerInsets, dy: outerInsets)
        let circleWidth = circleRect.width
        let circleRadius = circleWidth / 2.0
        let circlePath = NSBezierPath(roundedRect: circleRect, xRadius: circleRadius, yRadius: circleRadius)
        
        color.setFill()
        circlePath.fill()
    }
    
    
    private func drawBorder() {
        
        let borderColor = nsColor(named: "StyleIconBorderColor")
        
        // outside border
        let borderInsets: CGFloat = 1.25
        let borderCircleRect = self.bounds.insetBy(dx: borderInsets, dy: borderInsets)
        let borderCircleWidth = borderCircleRect.width
        let borderCircleRadius = (borderCircleWidth / 2.0)
        let borderCirclePath = NSBezierPath(roundedRect: borderCircleRect, xRadius: borderCircleRadius, yRadius: borderCircleRadius)
        
        borderColor.setFill()
        borderCirclePath.fill()
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
                subscribeToAppearanceChange()
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
            elementColors[.h1] = color
        }
        
        // 4
        if let color = textStylePreview.h2Color {
            colors.append(color)
            colors.append(color)
            elementColors[.h2] = color
        }
        
        // 7
        if let color = textStylePreview.h3Color {
            colors.append(color)
            colors.append(color)
            elementColors[.h3] = color
        }

        // 10
        if let color = textStylePreview.foregroundColor(for: .h4) {
            colors.append(color)
            elementColors[.h4] = color
        }
        
        // 12
        if let color = textStylePreview.foregroundColor(for: .h5) {
            colors.append(color)
            elementColors[.h5] = color
        }
        
        // 11
        if let color = textStylePreview.foregroundColor(for: .h4Tag) {
            colors.append(color)
            elementColors[.h4Tag] = color
        }
        
        // 6
        if let color = textStylePreview.h2TagColor {
            colors.append(color)
            elementColors[.h2Tag] = color
        }
        
        // 3
        if let color = textStylePreview.h1TagColor {
            colors.append(color)
            elementColors[.h1Tag] = color
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
            elementColors[.p] = color
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
