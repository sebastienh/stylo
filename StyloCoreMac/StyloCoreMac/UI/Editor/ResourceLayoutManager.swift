//
//  ResourceLayoutManager.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-08-31.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import os

fileprivate enum TextDecorationLineType {
    
    case overline
    case underline
    case strikethrough
}

public final class ResourceLayoutManager: NSLayoutManager {
    
    public var address: Int {
        return unsafeBitCast(self, to: Int.self)
    }
    
    public override init() {
        super.init()
        self.usesFontLeading = false
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.usesFontLeading = false
    }
    
    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
    public override func invalidateGlyphs(forCharacterRange charRange: NSRange, changeInLength delta: Int, actualCharacterRange actualCharRange: NSRangePointer?) {
        
        os_log("(%@) invalidateGlyphs(forCharacterRange: %@, changeInLength: origin, actualCharacterRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%charRange, %%delta, %%actualCharRange)
        
        super.invalidateGlyphs(forCharacterRange: charRange, changeInLength: delta, actualCharacterRange: actualCharRange)
    }

    public override func invalidateLayout(forCharacterRange charRange: NSRange, actualCharacterRange actualCharRange: NSRangePointer?) {
        
        os_log("(%@) invalidateLayout(forCharacterRange: %@, actualCharacterRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%charRange, %%actualCharRange)
        
        super.invalidateLayout(forCharacterRange: charRange, actualCharacterRange: actualCharRange)
    }

    public override func invalidateDisplay(forCharacterRange charRange: NSRange) {
        
        os_log("(%@) invalidateDisplay(forCharacterRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%charRange)
        
        super.invalidateDisplay(forCharacterRange: charRange)
    }

    public override func invalidateDisplay(forGlyphRange glyphRange: NSRange) {
     
        os_log("(%@) invalidateDisplay(forGlyphRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%glyphRange)
        
        super.invalidateDisplay(forGlyphRange: glyphRange)
    }

    public override func processEditing(for textStorage: NSTextStorage, edited editMask: NSTextStorageEditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {

        os_log("(%@) processEditing(for: textStorage, edited: %@, range: %@, changeInLength: %@, invalidatedRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%editMask, %%newCharRange, %%delta, %%invalidatedCharRange)
        
        super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
    }

    public override func ensureGlyphs(forCharacterRange charRange: NSRange) {
     
        os_log("(%@) ensureGlyphs(forCharacterRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%charRange)
        
        super.ensureGlyphs(forCharacterRange: charRange)
    }

    public override func ensureGlyphs(forGlyphRange glyphRange: NSRange) {
        
        os_log("(%@) ensureGlyphs(forGlyphRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%glyphRange)
        
        super.ensureGlyphs(forGlyphRange: glyphRange)
    }

    public override func ensureLayout(forCharacterRange charRange: NSRange) {
     
        os_log("(%@) ensureGlyphs(forCharacterRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%charRange)
        
        super.ensureLayout(forCharacterRange: charRange)
    }

    public override func ensureLayout(forGlyphRange glyphRange: NSRange) {
        
        os_log("(%@) ensureLayout(forGlyphRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%glyphRange)
        
        super.ensureLayout(forGlyphRange: glyphRange)
    }

    public override func ensureLayout(for container: NSTextContainer) {
        
        os_log("(%@) ensureLayout(for: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%container)
        
        super.ensureLayout(for: container)
    }

    public override func ensureLayout(forBoundingRect bounds: NSRect, in container: NSTextContainer) {
        
        os_log("(%@) ensureLayout(forBoundingRect: %@, in: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%bounds, %%container)
        
        super.ensureLayout(forBoundingRect: bounds, in: container)
    }

    public override func setGlyphs(_ glyphs: UnsafePointer<CGGlyph>, properties props: UnsafePointer<NSLayoutManager.GlyphProperty>, characterIndexes charIndexes: UnsafePointer<Int>, font aFont: NSFont, forGlyphRange glyphRange: NSRange) {
        
        os_log("(%@) setGlyphs(glyphs: %@, properties: %@, characterIndexes: %@, font: %@, forGlyphRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%glyphs, %%props, %%charIndexes, %%aFont, %%glyphRange)
        
        super.setGlyphs(glyphs, properties: props, characterIndexes: charIndexes, font: aFont, forGlyphRange: glyphRange)
    }
    #endif
    
    override public func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: NSPoint) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("(%@) drawGlyphs(glyphsToShow: %@, at: origin)", log: Log.StyloCore.all, type: .debug, %%self.address, %%glyphsToShow,  %%origin)
        #endif
        
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
        handleOverlineAttribute(forGlyphRange: glyphsToShow, at: origin)
    }
    
    private func handleOverlineAttribute(forGlyphRange glyphsToShow: NSRange, at origin: NSPoint) {
        
        let glyphRange = glyphsToShow
        let textStorage = self.textStorage
        let textContainer = self.textContainers.first
        
        assert(textStorage != nil)
        assert(textContainer != nil)
        if let textContainer = textContainer, let textStorage = textStorage {
            
            let characterRange = self.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)

            textStorage.enumerateAttribute(NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle), in: characterRange, options: NSAttributedString.EnumerationOptions.reverse) { (attributeValue, range, stop) in
                
                if let number = attributeValue as? NSNumber, number.intValue != 0 {
                    
                    if let trimmedCharacterRange = trim(range: range) {
                        
                        let attributeGlyphRange = self.glyphRange(forCharacterRange: trimmedCharacterRange, actualCharacterRange: nil)
                        
                        let lineBoundingRect = insetsAdjustedBoundingRect(forGlyphRange: attributeGlyphRange, in: textContainer)

                        let baselineOffsetAttribute = textStorage.attribute(NSAttributedString.Key.baselineOffset, at: range.location, longestEffectiveRange: nil, in: range) as! CGFloat?
                        let baselineOffset = baselineOffsetAttribute ?? 0
                        var effectiveRange = NSMakeRange(0, 0)
                        lineFragmentUsedRect(forGlyphAt: attributeGlyphRange.location, effectiveRange: &effectiveRange)
                        
                        // while we are under the last glyph index of the attributeGlyphRange
                        while effectiveRange.location <= attributeGlyphRange.location + attributeGlyphRange.length {
                            
                            if let (trimmedRect, trimmedRange) = trimmedFragmentRect(for: effectiveRange, in: textContainer) {
                                
                                let rect = NSIntersectionRect(lineBoundingRect, trimmedRect)
                                drawOverline(forGlyphRange: trimmedRange, underlineType: NSUnderlineStyle(rawValue: Int(truncating: number)), baselineOffset: baselineOffset, lineFragmentRect: rect, lineFragmentGlyphRange: trimmedRange, containerOrigin: origin)
                            }
                            
                            let newLocation = effectiveRange.location + effectiveRange.length
                            if newLocation < glyphsToShow.upperBound {
                                lineFragmentUsedRect(forGlyphAt: effectiveRange.location + effectiveRange.length, effectiveRange: &effectiveRange)
                            }
                            else {
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func trimmedFragmentRect(for glyphsRange: NSRange, in textContainer: NSTextContainer) -> (NSRect, NSRange)? {
        
        let characterRange = self.characterRange(forGlyphRange: glyphsRange, actualGlyphRange: nil)

        let trimmedCharacterRange = trim(range: characterRange)
        
        assert(trimmedCharacterRange != nil)
        if let trimmedCharacterRange = trimmedCharacterRange, !trimmedCharacterRange.isEmpty {

            let trimmedGlyphRange = self.glyphRange(forCharacterRange: trimmedCharacterRange, actualCharacterRange: nil)
            let lineFragmentUsedRect = self.lineFragmentUsedRect(forGlyphAt: trimmedGlyphRange.location, effectiveRange: nil)
            let lineBoundingRect = insetsAdjustedBoundingRect(forGlyphRange: trimmedGlyphRange, in: textContainer)
            let interectedRect = NSIntersectionRect(lineBoundingRect, lineFragmentUsedRect)

            return (interectedRect, trimmedGlyphRange)
        }
        return nil
    }
    
    private func drawOverline(forGlyphRange glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: NSRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: NSPoint) {
        
        if let attribute = textStorage!.attribute(NSAttributedString.Key(rawValue: §StyloAttribute.overlineColor), at: lineGlyphRange.location, longestEffectiveRange: nil, in: lineGlyphRange) {
        
            let underlineStyleAttributeValue = textStorage!.attribute(NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle), at: lineGlyphRange.location, longestEffectiveRange: nil, in: lineGlyphRange)
            
            if let underlineStyleAttributeValue = underlineStyleAttributeValue {
            
                    if let styloUnderlineStyle = StyloUnderlineStyle(rawValue: underlineStyleAttributeValue as! Int) {
                    
                    switch styloUnderlineStyle {
                        
                    case .wavy:
                        
                        drawWavyLine(textDecorationLineType: .overline, color: attribute as! NSColor, lineRect: lineRect)
                        
                    case .double:
                        
                        drawDoubleLine(textDecorationLineType: .overline, color: attribute as! NSColor, lineRect: lineRect)
                        
                    case .dashed:
                        
                        drawDashedLine(textDecorationLineType: .overline, color: attribute as! NSColor, lineRect: lineRect)
                        
                    case .dotted:
                        
                        drawDottedLine(textDecorationLineType: .overline, color: attribute as! NSColor, lineRect: lineRect)
                        
                    case .solid:
                        
                        drawLine(textDecorationLineType: .overline, color: attribute as! NSColor, lineRect: lineRect)
                    }
                }
            }
        }
    }
    
    override public func drawUnderline(forGlyphRange glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: NSRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: NSPoint) {
        
        if let styloUnderlineStyle = StyloUnderlineStyle(rawValue: underlineVal.rawValue) {
            
            switch styloUnderlineStyle {
                
            case .wavy:
                
                let _textStorage = self.textStorage!
                let _characterRange = characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
                
                _textStorage.enumerateAttribute(NSAttributedString.Key.underlineStyle, in: _characterRange, options: NSAttributedString.EnumerationOptions.reverse) { (attributeValue, range, stop) in
                    
                    if attributeValue != nil {
                        
                        let attributeGlyphRange = self.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                        let textContainer = self.textContainers.first!
                        let _lineBoundingRect = insetsAdjustedBoundingRect(forGlyphRange: attributeGlyphRange, in: textContainer)
                        if let _attribute = _textStorage.attribute(NSAttributedString.Key.underlineColor, at: range.location, longestEffectiveRange: nil, in: range) {
                        
                            drawWavyLine(textDecorationLineType: .underline, color: _attribute as! NSColor, lineRect: _lineBoundingRect)
                        }
                    }
                }
                
            default:
                
                super.drawUnderline(forGlyphRange: glyphRange, underlineType: underlineVal, baselineOffset: baselineOffset, lineFragmentRect: lineRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
            }
        }
    }
    
    // Here we change the strokeColor for the strickethrough if the NSUnderlineColorAttributeName is defined
    override public func drawStrikethrough(forGlyphRange glyphRange: NSRange, strikethroughType strikethroughVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: NSRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: NSPoint) {
        
        let _textStorage = self.textStorage!
        let _characterRange = characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        
        var drawnStrikethrough: Bool = false
        
        if let attribute = _textStorage.attribute(NSAttributedString.Key(rawValue: §StyloAttribute.strikethroughColor), at: _characterRange.location, longestEffectiveRange: nil, in: _characterRange) {

            var attributeGlyphRange = self.glyphRange(forCharacterRange: _characterRange, actualCharacterRange: nil)
            attributeGlyphRange = NSIntersectionRange(attributeGlyphRange, glyphRange)
            
            let context: CGContext = NSGraphicsContext.current!.cgContext
        
            if let styloUnderlineStyle = StyloUnderlineStyle(rawValue: strikethroughVal.rawValue) {
            
                switch styloUnderlineStyle {
                    
                case .wavy:
                    
                    let textContainer = self.textContainers.first!
                    let _lineFragmentRect = insetsAdjustedBoundingRect(forGlyphRange: attributeGlyphRange, in: textContainer)
                    
                    drawWavyLine(textDecorationLineType: .strikethrough, color: attribute as! NSColor, lineRect: _lineFragmentRect)
                    
                default:
                    
                    context.saveGState()
                    context.setStrokeColor((attribute as! NSColor).cgColor)
                    super.drawStrikethrough(forGlyphRange: glyphRange, strikethroughType: strikethroughVal, baselineOffset: baselineOffset, lineFragmentRect: lineRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
                    
                    context.restoreGState()
                }
                drawnStrikethrough = true
            }
        }
        if let attribute = self.temporaryAttribute(NSAttributedString.Key(rawValue: §StyloAttribute.strikethroughColor), atCharacterIndex: _characterRange.location, longestEffectiveRange: nil, in: _characterRange) {
            
            var attributeGlyphRange = self.glyphRange(forCharacterRange: _characterRange, actualCharacterRange: nil)
            attributeGlyphRange = NSIntersectionRange(attributeGlyphRange, glyphRange)
            
            let context: CGContext = NSGraphicsContext.current!.cgContext
        
            if let styloUnderlineStyle = StyloUnderlineStyle(rawValue: strikethroughVal.rawValue) {
            
                switch styloUnderlineStyle {
                    
                case .wavy:
                    
                    let textContainer = self.textContainers.first!
                    let _lineFragmentRect = insetsAdjustedBoundingRect(forGlyphRange: attributeGlyphRange, in: textContainer)
                    
                    drawWavyLine(textDecorationLineType: .strikethrough, color: attribute as! NSColor, lineRect: _lineFragmentRect)
                    
                default:
                    
                    context.saveGState()
                    context.setStrokeColor((attribute as! NSColor).cgColor)
                    super.drawStrikethrough(forGlyphRange: glyphRange, strikethroughType: strikethroughVal, baselineOffset: baselineOffset, lineFragmentRect: lineRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
                    
                    context.restoreGState()
                }
                drawnStrikethrough = true
            }
        }
        if !drawnStrikethrough {
            
            super.drawStrikethrough(forGlyphRange: glyphRange, strikethroughType: strikethroughVal, baselineOffset: baselineOffset, lineFragmentRect: lineRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
        }
    }
    
    private func drawDashedLine(textDecorationLineType: TextDecorationLineType, color: NSColor, lineRect: NSRect) {
        
        if !lineRect.equalTo(NSZeroRect) {
            
            // in the case of the dashed line we only need it for overline
            assert(textDecorationLineType == .overline)
            
            let lineWidth: CGFloat = lineRect.height/10.0
            let dashLength: CGFloat = lineRect.height/2.0
            let voidLength: CGFloat = lineRect.height/4.0
            
            let (origin, destination) = overlinePositions(from: lineRect, factor: lineWidth*2)
            
            color.set()
            
            // create the path
            let path = NSBezierPath()
            path.move(to: origin)
            path.line(to: destination)
            path.lineCapStyle = .butt
            path.lineWidth = lineWidth
            
            let length: CGFloat = destination.x - origin.x
            let pattern = constructPattern(dashLength: dashLength, voidLength: voidLength, length: length)
            path.setLineDash(pattern, count: pattern.count, phase: 0.0)
            path.stroke()
        }
    }
    
    private func drawDottedLine(textDecorationLineType: TextDecorationLineType, color: NSColor, lineRect: NSRect) {
        
        if !lineRect.equalTo(NSZeroRect) {
            
            assert(textDecorationLineType == .overline)
            
            let lineWidth: CGFloat = lineRect.height/22.0
            let lineDisplacementFactor: CGFloat = lineWidth*2
            
            let startPosition = CGPoint(x: NSMinX(lineRect), y: NSMinY(lineRect) + lineDisplacementFactor)
            let endPosition = CGPoint(x: NSMaxX(lineRect), y: NSMinY(lineRect) + lineDisplacementFactor)
            
            color.set()

            let dashLength: CGFloat = lineRect.height/7.35
            let voidLength: CGFloat = dashLength
        
            // create the path
            let path = NSBezierPath()
            path.move(to: startPosition)
            path.line(to: endPosition)
            path.lineCapStyle = .butt
            path.lineWidth = lineWidth
            
            let length: CGFloat = endPosition.x - startPosition.x
            let pattern = constructPattern(dashLength: dashLength, voidLength: voidLength, length: length)
            path.setLineDash(pattern, count: pattern.count, phase: 0.0)
            path.stroke()
        }
    }
    
    private func drawLine(textDecorationLineType: TextDecorationLineType, color: NSColor, lineRect: NSRect) {
        
        if !lineRect.equalTo(NSZeroRect) {
            
            assert(textDecorationLineType == .overline)
            
            let lineWidth: CGFloat = lineRect.height/22.0
            let lineDisplacementFactor: CGFloat = lineWidth*2
            
            let startPosition = CGPoint(x: NSMinX(lineRect), y: NSMinY(lineRect) + lineDisplacementFactor)
            let endPosition = CGPoint(x: NSMaxX(lineRect), y: NSMinY(lineRect) + lineDisplacementFactor)
            
            color.set()
            
            // create the path
            let path = NSBezierPath()
            path.move(to: startPosition)
            path.line(to: endPosition)
            path.lineWidth = lineWidth
            path.stroke()
        }
    }
    
    private func drawDoubleLine(textDecorationLineType: TextDecorationLineType, color: NSColor, lineRect: NSRect) {
        
        if !lineRect.equalTo(NSZeroRect) {
            
            assert(textDecorationLineType == .overline)
            
            let lineWidth: CGFloat = lineRect.height/30.0
            let lineSpacing: CGFloat = lineWidth*2
            
            let startPosition = CGPoint(x: NSMinX(lineRect), y: NSMinY(lineRect) + lineSpacing)
            let endPosition = CGPoint(x: NSMaxX(lineRect), y: NSMinY(lineRect) + lineSpacing)
            
            color.set()
            
            // create the first path
            let path = NSBezierPath()
            path.lineWidth = lineWidth
            path.move(to: startPosition)
            path.line(to: endPosition)
            path.stroke()
            
            let path2 = NSBezierPath()
            path2.lineWidth = lineWidth
            path2.move(to: NSMakePoint(startPosition.x, startPosition.y + lineSpacing))
            path2.line(to: NSMakePoint(endPosition.x, endPosition.y + lineSpacing))
            path2.stroke()
        }
    }
    
    private func drawWavyLine(textDecorationLineType: TextDecorationLineType, color: NSColor, lineRect: NSRect) {
        
        if !lineRect.equalTo(NSZeroRect) {
        
            let startPosition: CGPoint
            let endPosition: CGPoint
            let lineWidth: CGFloat = 1.0
            
            switch textDecorationLineType {
                
            case .overline:
                
                startPosition = CGPoint(x: NSMinX(lineRect), y: NSMinY(lineRect) + lineWidth)
                endPosition = CGPoint(x: NSMaxX(lineRect), y: NSMinY(lineRect) + lineWidth)
                
            case .strikethrough:
                
                startPosition = CGPoint(x: NSMinX(lineRect), y: NSMinY(lineRect) + lineRect.height/2)
                endPosition = CGPoint(x: NSMaxX(lineRect), y: NSMinY(lineRect) + lineRect.height/2)
                
            case .underline:
                
                startPosition = CGPoint(x: NSMinX(lineRect), y: NSMaxY(lineRect))
                endPosition = CGPoint(x: NSMaxX(lineRect), y: NSMaxY(lineRect))
            }
            
            color.set()
            
            let amplitude: CGFloat = 1.0
            let length: CGFloat = 10.0
            let path = NSBezierPath()
            path.move(to: startPosition)
            path.lineWidth = lineWidth
            
            let origin = startPosition
            var _x: CGFloat = startPosition.x
            
            while _x < endPosition.x {
            
                var x: CGFloat! = nil
                
                for angle in stride(from: 0.0, through: 360.0, by: 80.0) {
                    x = _x + CGFloat(angle/360.0) * length
                    let y = origin.y - CGFloat(sin(angle/180.0 * Double.pi)) * amplitude
                    path.line(to: CGPoint(x: x, y: y))
                    
                    if x >= endPosition.x {
                        break
                    }
                }
                _x += length
            }

            path.stroke()
        }
    }
    
    private func constructPattern(dashLength: CGFloat, voidLength: CGFloat, length: CGFloat) -> [CGFloat] {
        
        var pattern = [CGFloat]()
        var _patternLength: CGFloat = 0.0
        
        while _patternLength <= length {
            
            var leftSpace = length - _patternLength
            let dashAllowedLength = dashLength >= leftSpace ? leftSpace : dashLength
            
            pattern.append(dashAllowedLength)
            
            if dashAllowedLength != dashLength {
                break
            }
            
            _patternLength += dashAllowedLength
            leftSpace = length - _patternLength
            let spaceAllowedLength = voidLength >= leftSpace ? leftSpace : voidLength
            
            if spaceAllowedLength != voidLength {
                break
            }
            
            pattern.append(spaceAllowedLength)
            _patternLength += spaceAllowedLength
        }
        
        return pattern
    }
    
    private func overlinePositions(from rect: NSRect, factor: CGFloat = 0) -> (CGPoint, CGPoint) {
        
        let origin = CGPoint(x: NSMinX(rect), y: NSMinY(rect) + factor)
        let destination = CGPoint(x: NSMaxX(rect), y: NSMinY(rect) + factor)
        
        return (origin, destination)
    }
    
    private func lineStyle(from underlineStyle: NSUnderlineStyle) -> StyloUnderlineStyle? {
        
        if let styloUnderlineStyle = StyloUnderlineStyle(rawValue: underlineStyle.rawValue) {
            
            return styloUnderlineStyle
        }
        return nil
    }
    
    private func trim(range: NSRange) -> NSRange? {
        
        return self.textStorage?.trim(range: range)
    }
    
    private func insetsAdjustedBoundingRect(forGlyphRange glyphRange: NSRange, in container: NSTextContainer) -> NSRect {
        
        var boundingRect = self.boundingRect(forGlyphRange: glyphRange, in: container)
        boundingRect.origin.y += InterfaceConstants.Markdown.Editor.Insets.height
        return boundingRect
    }
    
}
