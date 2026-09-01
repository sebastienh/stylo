/*
 
 ------------------------------------------------------------------------------------
 CustomBadge.m
 ------------------------------------------------------------------------------------
 CustomBadge is an UIView which draws a customizable badge on any other view.
 The latest version has separation between style and rendering.
 This class is the core of CustomBadge where the actual rendering happens.
 It recommended to use the convenient allocators instead of the init methods.
 ------------------------------------------------------------------------------------
 
 The MIT License (MIT)
 
 Copyright (c) 2014 Sascha Paulus
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

//
//  CustomBadge.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-05.
//  Copyright © 2017 Textually Inc. All rights reserved.
//
// see https://github.com/ckteebe/CustomBadge

import Foundation
import Cocoa
import Common
import Web

class CustomBadge: NSButton {
    
    
    var badgeText: String
    
    var badgeCornerRoundness: CGFloat
    
    var badgeScaleFactor: CGFloat
    
    var badgeStyle: BadgeStyle
    
    // I recommend to use one of the allocators like customBadgeWithString
    init(withString string: String, scale: CGFloat, style: BadgeStyle) {
        
        self.badgeText = string
        self.badgeStyle = style
        self.badgeCornerRoundness = 0.4
        self.badgeScaleFactor = scale
        
        super.init(frame: NSMakeRect(0, 0, 25, 25))
        
        self.wantsLayer = true
        self.layer!.backgroundColor = NSColor.clear.cgColor
        
        autoBadgeSize(withString: string)
    }
    
    required init?(coder: NSCoder) {
        
        self.badgeText = ""
        self.badgeStyle = BadgeStyle.defaultStyle
        self.badgeCornerRoundness = 0.4
        self.badgeScaleFactor = 1.0
        
        super.init(coder: coder)
        self.wantsLayer = true
    }
 
    // Creates a Badge with a given Text in default BadgeStyle and normal scale
    static func customBadge(withString string: String) -> CustomBadge {
        
        return CustomBadge(withString: string, scale: 1.0, style: BadgeStyle.defaultStyle)
    }
    
    // Creates a Badge with a given Text in default BadgeStyle and given scale
    static func customBadge(withString string: String, withScale scale: CGFloat) -> CustomBadge {
    
        return CustomBadge(withString: string, scale: scale, style: BadgeStyle.defaultStyle)
    }
    
    // Creates a Badge with a given Text in given BadgeStyle and normal scale
    static func customBadge(withString string: String, withStyle style: BadgeStyle) -> CustomBadge {
    
        return CustomBadge(withString: string, scale: 1.0, style: style)
    }
    
    // Creates a Badge with a given Text in given BadgeStyle and a given scale
    static func customBadge(withString string: String, withScale scale: CGFloat, withStyle style: BadgeStyle) -> CustomBadge {
    
        return CustomBadge(withString: string, scale: scale, style: style)
    }
    
    // Use this method if you want to change the badge text after the first rendering
    func autoBadgeSize(withString string: String) {
        
        let retValue: CGSize
        let rectWidth: CGFloat
        let rectHeight: CGFloat
        
        let fontAttr: Dictionary = [
            NSAttributedString.Key.font : fontForBadge(withSize: 12)
        ]
        
        let stringSize: CGSize = (string as NSString).size(withAttributes: fontAttr as [NSAttributedString.Key : Any])
        
        let flexSpace: CGFloat
        
        if string.length >= 2 {
            
            flexSpace = CGFloat(string.length)
            rectWidth = 25 + (stringSize.width + flexSpace)
            rectHeight = 25
            retValue = NSMakeSize(rectWidth*badgeScaleFactor, rectHeight*badgeScaleFactor)
        } else {
            retValue = NSMakeSize(25*badgeScaleFactor, 25*badgeScaleFactor);
        }
        self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
        self.badgeText = string
        assert(Thread.isMainThread)
        self.needsDisplay = true
    }
    
    // Draws the Badge with Quartz
    private func drawRoundedRect(withContext context: CGContext, withRect rect: CGRect) {
    
        context.saveGState()
    
        // CGRectGetMaxY(rect)*self.badgeCornerRoundness;
        let radius: CGFloat = rect.maxY*self.badgeCornerRoundness
    
        // CGRectGetMaxY(rect)*0.10;
        let puffer: CGFloat = rect.maxY*0.10
    
        // CGRectGetMaxX(rect) - puffer;
        let maxX: CGFloat = rect.maxX - puffer
    
        // CGRectGetMaxY(rect) - puffer;
        let maxY: CGFloat = rect.maxY - puffer
    
        // CGRectGetMinX(rect) + puffer;
        let minX: CGFloat = rect.minX + puffer
    
        // CGRectGetMinY(rect) + puffer;
        let minY: CGFloat = rect.minY + puffer
    
        context.beginPath();
        context.setFillColor(self.badgeStyle.badgeInsetColor.cgColor)
        context.addArc(center: NSMakePoint(maxX-radius, minY+radius), radius: radius, startAngle: CGFloat.pi+(CGFloat.pi/2), endAngle: 0, clockwise: false)
        context.addArc(center: NSMakePoint(maxX-radius, maxY-radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: false)
        context.addArc(center: NSMakePoint(minX+radius, maxY-radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: false)
        context.addArc(center: NSMakePoint(minX+radius, minY+radius), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi+CGFloat.pi/2, clockwise: false)

        if self.badgeStyle.badgeShadow {
            context.setShadow(offset: NSMakeSize(1.0, 1.0), blur: 3.0, color: NSColor.black.cgColor)
        }
    
        context.fillPath()
        context.restoreGState()
    }

    // Draws the Badge Shine with Quartz
    private func drawShine(withContext context: CGContext, withRect rect: CGRect) {
    
        context.saveGState()
    
        let radius: CGFloat = rect.maxY*self.badgeCornerRoundness
        let puffer: CGFloat = rect.maxY*0.10
        let maxX: CGFloat = rect.maxX - puffer
        let maxY: CGFloat = rect.maxY - puffer
        let minX: CGFloat = rect.minX + puffer
        let minY: CGFloat = rect.minY + puffer
        context.beginPath()
        context.addArc(center: NSMakePoint(maxX-radius, minY+radius), radius: radius, startAngle: CGFloat.pi+(CGFloat.pi/2), endAngle: 0, clockwise: false)
        context.addArc(center: NSMakePoint(maxX-radius, maxY-radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: false)
        context.addArc(center: NSMakePoint(minX+radius, maxY-radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: false)
        context.addArc(center: NSMakePoint(minX+radius, minY+radius), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi+CGFloat.pi/2, clockwise: false)
        context.clip()
    
        let num_locations: size_t = 2
        let locations: [CGFloat] = [0.0, 0.4]
        let components: [CGFloat] = [0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4]

        let cspace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient: CGGradient = CGGradient(colorSpace: cspace, colorComponents: components, locations: locations, count: num_locations)!
    
        let sPoint: CGPoint = NSMakePoint(0, 0)
        let ePoint: CGPoint = NSMakePoint(0, maxY)
        
        context.drawLinearGradient(gradient, start: sPoint, end: ePoint, options: CGGradientDrawingOptions(rawValue: 0))
        context.restoreGState()
    }

    // Draws the Badge Frame with Quartz
    private func drawFrame(withContext context: CGContext,  withRect rect: CGRect) {
        
        let radius: CGFloat = rect.maxY*self.badgeCornerRoundness
        let puffer: CGFloat = rect.maxY*0.10
    
        let maxX: CGFloat = rect.maxX - puffer
        let maxY: CGFloat = rect.maxY - puffer
        let minX: CGFloat = rect.minX + puffer
        let minY: CGFloat = rect.minY + puffer
    
    
        context.beginPath()
        
        var lineSize: CGFloat = 2
        
        if self.badgeScaleFactor > 1 {
            lineSize += self.badgeScaleFactor*0.25
        }
        context.setLineWidth(lineSize)
        context.setStrokeColor(self.badgeStyle.badgeFrameColor!.cgColor)
        context.addArc(center: NSMakePoint(maxX-radius, minY+radius), radius: radius, startAngle: CGFloat.pi+(CGFloat.pi/2), endAngle: 0, clockwise: false)
        context.addArc(center: NSMakePoint(maxX-radius, maxY-radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: false)
        context.addArc(center: NSMakePoint(minX+radius, maxY-radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: false)
        context.addArc(center: NSMakePoint(minX+radius, minY+radius), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi+CGFloat.pi/2, clockwise: false)
        context.closePath()
        context.strokePath()
    }
    
    
    private func fontForBadge(withSize size: CGFloat) -> NSFont {
        
        switch badgeStyle.badgeFontType {
            
        case .BadgeStyleFontTypeHelveticaNeueMedium:
            
            return NSFont(name: §CSSFontFamilyKeyword.Helvetica, size: size)!
            
        case .BadgeStyleFontTypeHelveticaNeueLight:
            
            return NSFont(name: §CSSFontFamilyKeyword.HelveticaNeue, size: size)!
        }
    }

    override func draw(_ dirtyRect: NSRect) {
    
        let context: CGContext = NSGraphicsContext.current!.cgContext
    
        drawRoundedRect(withContext: context, withRect: dirtyRect)
    
        if self.badgeStyle.badgeShining {
            drawShine(withContext: context, withRect: dirtyRect)
        }
    
        if self.badgeStyle.badgeFrame {
            drawFrame(withContext: context, withRect: dirtyRect)
        }
    
        if self.badgeText.length > 0 {
            
            var sizeOfFont: CGFloat = 13.5*badgeScaleFactor
            
            if self.badgeText.length < 2 {
                sizeOfFont += sizeOfFont * 0.20
            }
            
            let textFont: NSFont = fontForBadge(withSize: sizeOfFont)
            
            let fontAttr: Dictionary = [ NSAttributedString.Key.font : textFont, NSAttributedString.Key.foregroundColor : self.badgeStyle.badgeTextColor]
            let textSize: CGSize = (self.badgeText as NSString).size(withAttributes: fontAttr)
            let textPoint: CGPoint = NSMakePoint((dirtyRect.size.width/2-textSize.width/2), (dirtyRect.size.height/2-textSize.height/2) - 1)
            (self.badgeText as NSString).draw(at: textPoint, withAttributes: fontAttr)
        }
    }


}
