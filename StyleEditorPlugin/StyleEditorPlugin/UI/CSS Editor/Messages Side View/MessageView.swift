//
//  MessageView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-19.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import StyloCoreMac

final class MessageView: NSView {
    
    override var isOpaque: Bool {
        
        return true
    }
    
    var messages: [Message]?
    
    var displayedMessages: [CustomBadge]
    
    weak var resourceEditorView: ResourceEditorView!
    
    var messageIndicatorPopupDelegate: MessageIndicatorPopupDelegate!
    
    let badgeStyle: BadgeStyle = BadgeStyle(textColor: NSColor.black, insetColor: NSColor.red, frameColor: NSColor.blue, frame: true, shadow: false, shining: true, fontType: .BadgeStyleFontTypeHelveticaNeueLight)
    
    override var isFlipped: Bool {
        
        return true
    }
    
    fileprivate var currentContext : CGContext? {
        
        return NSGraphicsContext.current?.cgContext
    }
    
    override init(frame frameRect: NSRect) {
        
        self.displayedMessages = [CustomBadge]()
        
        super.init(frame: frameRect)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        
        self.displayedMessages = [CustomBadge]()
        
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        assert(Thread.isMainThread)
        super.draw(dirtyRect)

        if let message = messages?.first {
            if let messageEditorRect = resourceEditorView.rect(from: message) {
                addMessageIndicator(for: message, at: messageEditorRect.origin.y)
            }
        }
        updateVisibleLeftIndicators(in: dirtyRect)
    }
    
    fileprivate func addMessageIndicator(for message: Message, at position: CGFloat) {
        
        let customBadge = CustomBadge(withString: "1", scale: 1.0, style: self.badgeStyle)
        
        customBadge.frame = NSMakeRect(5, position, 15, 15)
        
        customBadge.target = self
        customBadge.action = #selector(MessageView.handleMessageIndicatorClicked)
        
        self.addSubview(customBadge)
    }
    
    @objc func handleMessageIndicatorClicked(_ sender: Any) {
        
        
        if let messageIndicator = sender as? CustomBadge, let messageIndicatorPopupDelegate = messageIndicatorPopupDelegate {
        
            // messageIndicatorPopupDelegate.showMessageIndicatorPopup(with: <#T##[Message]#>, relativeTo: <#T##NSRect#>, in: <#T##NSView#>)
            
            
            debugPrint("Clicked on: \(messageIndicator.badgeText)" )
        }
    }
    
    func updateLeftIndicators(messages: [Message]?) {
        
        self.messages = messages
        
        updateVisibleLeftIndicators(in: self.visibleRect)
    }
    
    
    func updateVisibleLeftIndicators(in rect: NSRect? = nil) {
        
        let _rect: NSRect = rect ?? self.visibleRect
        
        if let messages = messages {
            
            for message in messages {
                
                if let messageRect = displayRect(from: message) {
                    
                    if let messageIndicatorView = messageView(message, with: messageRect) {
                        
                        //
                    }
                    else {
                        
                        addMessageIndicator(for: message, at: messageRect.origin.y)
                    }
                }
            }
        }
    }
    
    fileprivate func viewFirstVisible() {
        
    }
    
    

    
    
    fileprivate func messageView(_ message: Message, with rect: NSRect) -> CustomBadge? {
        
        return nil
    }
    
    
    fileprivate func displayRect(from message: Message) -> NSRect? {
        
        return resourceEditorView.rect(from: message)
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
