//
//  CssEditorScroller.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-08.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import StyloCoreMac

final class CssEditorScroller: NSScroller, BackgroundColorBindable {
    
    override class var isCompatibleWithOverlayScrollers: Bool {
        
        return true
    }
    
    var messages: [Message]? {
        
        didSet {
            self.needsDisplay = true
        }
    }
    
    var lineColorAlphaValue: CGFloat {
        
        return 0.2
    }
    
    var paths: [CGMutablePath]
    
    weak var resourceEditorView: ResourceEditorView!
    
    var strokeWidth: CGFloat {
        
        return 1.0
    }
    
    fileprivate var currentContext : CGContext? {
        
        return NSGraphicsContext.current?.cgContext
    }
    
    override init(frame frameRect: NSRect) {
        
        self.paths = [CGMutablePath]()
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        //        self.layer!.backgroundColor = NSColor(calibratedRed: 42/255, green: 41/255, blue: 40/255, alpha: 1).cgColor
    }
    
    required init?(coder: NSCoder) {
        
        self.paths = [CGMutablePath]()
        
        super.init(coder: coder)
        
        self.scrollerStyle = NSScroller.Style.overlay
        self.wantsLayer = true
        
        //        self.layer!.backgroundColor = NSColor(calibratedRed: 42/255, green: 41/255, blue: 40/255, alpha: 1).cgColor
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        clearExistingPaths()
        updateMessageIndicators()
        
        super.draw(dirtyRect)
    }
    
    fileprivate func clearExistingPaths() {
        
        if let context = self.currentContext {
            
            context.saveGState()
            
            for path in paths {
                
                erase(path: path, in: context)
            }
            
            context.restoreGState()
        }
        paths.removeAll(keepingCapacity: true)
    }
    
    fileprivate func erase(path: CGPath, in context: CGContext) {
        
        // setting the context
        context.setLineWidth(strokeWidth)
        context.setStrokeColor(self.layer!.backgroundColor!)
        
        context.addPath(path)
        
        // draw the line
        context.drawPath(using: CGPathDrawingMode.stroke)
    }
    
    fileprivate func updateMessageIndicators() {
        
        if let messages = messages {
            
            for message in messages {
                
                if let messageVerticalPosition = verticalPosition(for: message) {
                    
                    drawMessageIndicator(at: messageVerticalPosition, for: message)
                }
            }
        }
    }
    
    fileprivate func drawMessageIndicator(at position: CGFloat, for message: Message) {
        
        if let context = self.currentContext {
            
            context.saveGState()
            drawLine(in: context, at: position, for: message)
            context.restoreGState()
        }
    }
    
    fileprivate func verticalPosition(for message: Message) -> CGFloat? {
        
        // this position is a percentage
        if let relativePosition = resourceEditorView.relativeVerticalPosition(for: message) {
            
            // we want to know the value of this percentage locally
            return relativePosition*self.frame.height
        }
        
        return nil
    }
    
    fileprivate func drawLine(in context: CGContext, at position: CGFloat, for message: Message) {
        
        // setting the context
        context.setLineWidth(strokeWidth)
        let _lineColor = lineColor(for: message)
        context.setStrokeColor(_lineColor)
        
        let width = self.bounds.width
        
        // create the path
        let path = CGMutablePath()
        path.move(to: NSMakePoint(0, position))
        path.addLine(to: NSMakePoint(width, position))
        path.closeSubpath()
        
        context.addPath(path)
        
        // draw the line
        context.drawPath(using: CGPathDrawingMode.stroke)
        
        paths.append(path)
        
    }
    
    fileprivate func lineColor(for message: Message) -> CGColor {
        
        switch message.messageSeverity {
        case .Alert:
            return CGColor(red: 1, green: 0, blue: 0, alpha: lineColorAlphaValue)
        case .Critical:
            return CGColor(red: 1, green: 0, blue: 0, alpha: lineColorAlphaValue)
        case .Debug:
            return CGColor(red: 1, green: 0, blue: 0, alpha: lineColorAlphaValue)
        case .Emergency:
            return CGColor(red: 1, green: 0, blue: 0, alpha: lineColorAlphaValue)
        case .Error:
            return CGColor(red: 1, green: 0, blue: 0, alpha: lineColorAlphaValue)
        case .Informational:
            return CGColor(red: 1, green: 0, blue: 0, alpha: lineColorAlphaValue)
        case .Notice:
            return CGColor(red: 1, green: 0, blue: 0, alpha: lineColorAlphaValue)
        case .Warning:
            return CGColor(red: 1, green: 0, blue: 0, alpha: lineColorAlphaValue)
        }
    }
    
}
