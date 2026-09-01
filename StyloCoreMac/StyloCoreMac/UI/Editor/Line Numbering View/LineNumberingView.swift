//
//  LineNumberingView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-01-28.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon

final class LineNumberingView: EditorSideView {
    
    override var intrinsicContentSize: NSSize {
        
        return NSSize(width: 80.0, height: NSView.noIntrinsicMetric)
    }
    
    override var isOpaque: Bool {
        return true
    }
    
    override var isFlipped: Bool {
        return true
    }
    
    private struct HeaderMarker {
        
        let level: Int
        let baseline: CGFloat
        let collapsed: Bool
        let attributes: [NSAttributedString.Key: Any]
        
        private var hashString: String? {
            if let hash = "######".slice(0, end: level) {
                return hash + " "
            }
            return nil
        }
    
        private var attributedString: NSAttributedString? {
        
            guard let hashString = self.hashString else {return nil}
            return NSAttributedString(string: hashString, attributes: self.attributes)
        }
        
        init(level: Int, baseline: CGFloat, attributes: [NSAttributedString.Key: Any], collapsed: Bool = false) {
            
            self.level = level
            self.baseline = baseline
            self.attributes = attributes
            self.collapsed = collapsed
        }
        
        func draw(in rect: NSRect, _ context: CGContext) {
            
            guard let drawingRect = self.drawingRect(in: rect) else {return}
            guard let attributedString = self.attributedString else {return}
            attributedString.draw(in: drawingRect)
        }
        
        func drawingRect(in rect: NSRect) -> NSRect? {
            
            guard let attributedString = self.attributedString else {return nil}
            let boudingRect = attributedString.boundingRect(with: NSSize(width: CGFloat.infinity, height: CGFloat.infinity), options: NSString.DrawingOptions.usesFontLeading)
            
            let origin = rect.width - boudingRect.width
            return NSMakeRect(origin, baseline + InterfaceConstants.Markdown.Editor.Insets.height , boudingRect.width, boudingRect.height)
        }
    }
    
    private var currentContext : CGContext? {
        return NSGraphicsContext.current?.cgContext
    }
    
    private var markers: [HeaderMarker]
    
    private var lineInformationValid: Bool = false
    
    private weak var clientTextView: NSTextView?
    
    private var textStorage: NSTextStorage? {
        
        return clientTextView?.textStorage
    }
    
    private var layoutManager: NSLayoutManager? {
        
        return clientTextView?.layoutManager
    }
    
    private var textContainer: NSTextContainer? {
        
        return clientTextView?.textContainer
    }
    
    static let startHeadingTagAttributeKey = StyloAttribute.headingTagBefore.key
    
    override init(frame frameRect: NSRect) {

        self.markers = [HeaderMarker]()
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {

        self.markers = [HeaderMarker]()
        super.init(coder: coder)
    }

    func setClientWiew(_ textView: NSTextView) {
        
        let notificationCenter = NotificationCenter.default
        
        // clean existing listeners
        notificationCenter.removeObserver(self, name: WriterNotification.didCompleteAttributesRendering.name, object: nil)
        notificationCenter.removeObserver(self, name: NSView.boundsDidChangeNotification, object: nil)
        
        clientTextView = textView
        
        assert(clientTextView != nil)
        if let clientTextView = clientTextView {

            NotificationCenter.default.addObserver(forName: WriterNotification.didCompleteAttributesRendering.name, object: clientTextView, queue: nil) { [weak self](notification) in
                self?.clientTextViewDidProcessEditing(notification)
            }
            
            if let contentView = clientTextView.enclosingScrollView?.contentView {
            
                NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: contentView, queue: nil) { [weak self](notification) in
                    self?.clientTextViewDidProcessEditing(notification)
                }
            }
        }
    }
    
    @objc func clientTextViewDidProcessEditing(_ notification: Notification) {
        
        self.lineInformationValid = false
        self.needsDisplay = true
    }
    
    override func viewWillDraw() {
        super.viewWillDraw()
        if !self.lineInformationValid {
            self.updateLineInformation()
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        assert(self.lineInformationValid)
        
        if let backgroundColor = self.backgroundColor {
            let color = NSColor(cgColor: backgroundColor)
            color?.setFill()
            dirtyRect.fill()
        }
        
        saveGState { ctx in
            for marker in markers {
                if let markerRect = marker.drawingRect(in: self.frame),
                    NSIntersectsRect(dirtyRect, markerRect) {
                    marker.draw(in: self.frame, ctx)
                }
            }
        }
    }
    
    private func updateLineInformation() {
        
        guard let textStorage = self.textStorage else {
            assert(false)
            return
        }
        
        guard let layoutManager = self.layoutManager else {
            assert(false)
            return
        }
        
        guard let textContainer = self.textContainer else {
            assert(false)
            return
        }
        
        guard let visibleRect = self.clientTextView?.visibleRect else {
            assert(false)
            return
        }
        
        markers.removeAll(keepingCapacity: true)
        
        let visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: visibleRect, in: textContainer)
        var range: NSRange = NSMakeRange(0, 0)
        layoutManager.characterRange(forGlyphRange: visibleGlyphRange, actualGlyphRange: &range)
        let startHeadingTagAttributeKey = LineNumberingView.startHeadingTagAttributeKey
        
//        #if DEBUG
//        print("textStorage: \(textStorage.attributedSubstring(from: NSMakeRange(0, 1000)))")
//        #endif
        
        textStorage.enumerateAttribute(startHeadingTagAttributeKey, in: range) { (value, attrRange, stop) in
            
            let value = value as? NSNumber
            
            if let intValue = value?.intValue {
            
                let boudingRect = layoutManager.boundingRect(forGlyphRange: attrRange, in: textContainer)
                let attributes = textStorage.attributes(at: attrRange.location, effectiveRange: nil)
                let headingMarker = HeaderMarker(level: intValue, baseline: boudingRect.minY, attributes: attributes)
                markers.append(headingMarker)
            }
        }
        
        self.lineInformationValid = true
    }
    
    fileprivate func saveGState(_ drawStuff: (_ ctx:CGContext) -> ()) -> () {
        
        if let context = self.currentContext {
            
            context.saveGState ()
            drawStuff(context)
            context.restoreGState ()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
