//
//  DrawingView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-04.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

final class DrawingView: NSView {
    
    
    fileprivate var currentContext : CGContext? {
        
        return NSGraphicsContext.current?.cgContext
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        assert(Thread.isMainThread)
        self.needsDisplay = true
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        assert(Thread.isMainThread)
        self.needsDisplay = true 
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        assert(Thread.isMainThread)
        super.draw(dirtyRect)
        
        saveGState { ctx in
            self.drawNiceContents(ctx)
        }
    }
    
    func drawNiceContents(_ currentContext : CGContext) {
        
        let innerRect = self.bounds.insetBy(dx: 20.0, dy: 20.0)
    
        currentContext.setFillColor (red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0) // Green
        currentContext.fillEllipse (in: innerRect)
    
        currentContext.setStrokeColor (red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) // Blue
        currentContext.setLineWidth (6.0)
        currentContext.strokeEllipse (in: innerRect)
    }
    
    fileprivate func saveGState(_ drawStuff: (_ ctx:CGContext) -> ()) -> () {
        
        if let context = self.currentContext {
            
            context.saveGState ()
            drawStuff(context)
            context.restoreGState ()
        }
    }
}
