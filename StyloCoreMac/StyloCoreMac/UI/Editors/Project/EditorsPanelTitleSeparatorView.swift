//
//  EditorsPanelTitleSeparatorView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-12-28.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

/// This class is expected to replace all NSBox ( Horozontal Line
/// and Vertical Line) in my interface so I can more easily change
/// the color of them.
public class EditorsPanelTitleSeparatorView: NSView {
    
    internal var visibleBackgroundColor: CGColor?
    
    override public var acceptsFirstResponder: Bool {
        
        return true
    }
    
    override public var isOpaque: Bool {
        
        return false
    }
    
    override public var allowsVibrancy: Bool {
        
        return true
    }
    
    var backgroundColor: CGColor {
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            return NSColor(deviceRed: 82/255, green: 77/255, blue: 81/255, alpha: 1).cgColor
        case .aqua?:
            return NSColor(deviceRed: 218/255, green: 212/255, blue: 214/255, alpha: 1).cgColor
        default:
            assertionFailure("Error: unsupporrted appearanceName: \(String(describing: appearanceName))")
            return NSColor(deviceRed: 82/255, green: 77/255, blue: 81/255, alpha: 1).cgColor
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        layer?.backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
        layer?.backgroundColor = backgroundColor
    }
    
    public override func viewDidChangeEffectiveAppearance() {
        layer?.backgroundColor = backgroundColor
        super.viewDidChangeEffectiveAppearance()
    }
    
    public override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        layer?.backgroundColor = backgroundColor
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        layer?.backgroundColor = backgroundColor
    }
    
    override public func mouseDragged(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func mouseDown(with event: NSEvent) {
        
        // nothing
    }
    
    override public func mouseMoved(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func mouseUp(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func mouseExited(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func mouseEntered(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func otherMouseDragged(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func rightMouseDragged(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        
        return true
    }
}
