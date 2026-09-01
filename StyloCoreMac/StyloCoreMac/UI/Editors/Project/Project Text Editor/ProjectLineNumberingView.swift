//
//  ProjectLineNumberingView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-09-16.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import Common
import WriterCommon
import os

final class ProjectLineNumberingView: EditorSideView {
    
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
                return hash// + " "
            }
            return nil
        }
        
        private var textAttributedString: NSAttributedString? {
            
            guard let hashString = self.hashString else {return nil}
            
            var attributes = self.attributes
            let font = attributes[.font] as! NSFont
            
            let smallerSizeFont = NSFont.init(descriptor: font.fontDescriptor, size: 14.0)
            attributes[.font] = smallerSizeFont
            return NSAttributedString(string: hashString, attributes: attributes)
        }
        
        private var attributedString: NSAttributedString? {
            
            guard let hashString = self.hashString else {return nil}
            return NSAttributedString(string: hashString, attributes: self.attributes)
        }
        
        init(level: Int, baseline: CGFloat, attributes: [NSAttributedString.Key: Any], collapsed: Bool = false) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("HeaderMarker(level: %@, baseline: %@, attributes: ..., collapsed: %@)", log: Log.StyloCore.all, type: .info, %%level, %%baseline, %%collapsed)
            #endif
            
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
            
            let origin = rect.width - boudingRect.width - 4.0
            return NSMakeRect(origin, baseline + InterfaceConstants.Markdown.Editor.Insets.height, boudingRect.width, boudingRect.height)
        }
    }
    
    private struct LineNumberingUpdateInstance: Equatable {
        
        let frame: NSRect
        let string: String
        
        init(frame: NSRect, string: String) {
            self.frame = frame
            self.string = string
        }
        
        static func ==(lhs: LineNumberingUpdateInstance, rhs: LineNumberingUpdateInstance) -> Bool {
            if lhs.frame != rhs.frame {
                return false
            }
            if lhs.string != rhs.string {
                return false
            }
            return true
        }
    }
    
    private var currentContext : CGContext? {
        return NSGraphicsContext.current?.cgContext
    }
    
    private var markers: [HeaderMarker]
    
    private var lineInformationValid: Bool = true
    
    
    
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
    
    
    var globalContentView: NSClipView?
    
    private var documentManager: DocumentManager? {
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: textManager is nil")
            return nil
        }
        
        return textManager.textDocument?.documentManager
    }
    
    private var textManager: TextManager? {
        
        guard let projectTextEditor = self.clientTextView as? ProjectTextEditor else {
            assertionFailure("Error: projectTextEditor is nil")
            return nil
        }
        
        guard let textManager = projectTextEditor.editableManager as? TextManager else {
            assertionFailure("Error: textManager is nil")
            return nil
        }
        
        return textManager
    }
    
    override init(frame frameRect: NSRect) {
        
        self.markers = [HeaderMarker]()
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        
        self.markers = [HeaderMarker]()
        super.init(coder: coder)
    }
    
    func setClientWiew(_ textView: NSTextView) {
        
        // clean existing listeners
        stopListeningToClientView()
        clientTextView = textView
    }
    
    func setContentView(_ contentView: NSClipView) {
        
        stopListeningToBoundsChange()
        self.globalContentView = contentView
    }
    
    func startListening() {
        
        listenToBoundsChange()
    }
    
    func stopListening() {
        
        stopListeningToClientView()
        stopListeningToBoundsChange()
    }
    
    private func stopListeningToClientView() {
        
        // clean existing listeners
        NotificationCenter.default.removeObserver(self, name: NSView.boundsDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: WriterNotification.didChangeTemporaryAttributes.name, object: nil)
    }
    
    private func listenToBoundsChange() {
        
        guard let globalContentView = self.globalContentView else {
            assertionFailure("Error: self.globalContentView is nil")
            return
        }
        
        guard let clientTextView = self.clientTextView else {
            assertionFailure("Error: self.clientTextView is nil")
            return
        }
        
        globalContentView.postsBoundsChangedNotifications = true
        
        NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: globalContentView, queue: OperationQueue.main) { [weak self] (notification) in
            self?.clientTextViewDidProcessEditing(notification)
        }
        
        NotificationCenter.default.addObserver(forName: WriterNotification.didCompleteAttributesRendering.name, object: clientTextView, queue: OperationQueue.main) { [weak self] (notification) in
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Received notification: %@", log: Log.StyloCore.all, type: .info, %%notification.name )
            #endif
            
            self?.clientTextViewDidProcessEditing(notification)
        }
        
        NotificationCenter.default.addObserver(forName: WriterNotification.didChangeTemporaryAttributes.name, object: clientTextView, queue: OperationQueue.main) { [weak self] (notification) in
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Received notification: %@", log: Log.StyloCore.all, type: .info, %%notification.name )
            #endif
            
            self?.updateLines()
        }
        
        textManager?.compilationUnit.subscribe({ [weak self](_) in
            DispatchQueue.syncOnMain { [weak self] in
                self?.updateLines()
            }
            }, observer: self)
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: self.documentManager is nil")
            return
        }
        
        documentManager.globalStyleId.subscribe({ [weak self](_) in
            DispatchQueue.asyncOnMain { [weak self] in
                self?.updateLines()
            }
        }, observer: self)
    }
    
    private func stopListeningToBoundsChange() {
        
        NotificationCenter.default.removeObserver(self, name: NSView.boundsDidChangeNotification, object: nil)
    }
    
    private var lastLineNumberingUpdate: LineNumberingUpdateInstance?
    
    private var lineNumberingUpdate: LineNumberingUpdateInstance? {
        
        guard let textStorage = self.textStorage else {
            assert(false)
            return nil
        }
        
        guard let globalContentView = self.globalContentView else {
            assertionFailure("Error: self.globalContentView is nil")
            return nil
        }
        
        return LineNumberingUpdateInstance(frame: globalContentView.frame, string: textStorage.string)
    }
    
    @objc func clientTextViewDidProcessEditing(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Received notification: %@", log: Log.StyloCore.all, type: .info, %%notification.name )
        #endif
        
        switch notification.name {
        case WriterNotification.didCompleteAttributesRendering.name: fallthrough
        case NSView.boundsDidChangeNotification:
            updateLines()
        default:
            assertionFailure("Error: unhandled notification")
        }
    }
    
    func updateLinesIfNeeded() {
        
        guard let lineNumberingUpdate = self.lineNumberingUpdate else {
            assertionFailure("Error: self.lineNumberingUpdate is nil")
            return
        }
        
        if self.lastLineNumberingUpdate != lineNumberingUpdate {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("lineNumberingUpdate are different: old: %@ vs new: %@", log: Log.StyloCore.all, type: .info, %%self.lastLineNumberingUpdate, %%lineNumberingUpdate)
            #endif
            
            updateLines(lineNumberingUpdate: lineNumberingUpdate)
        }
    }
    
    func updateLines() {
        
        updateLines(lineNumberingUpdate: nil)
    }
    
    private func updateLines(lineNumberingUpdate: LineNumberingUpdateInstance?) {
        
        self.lastLineNumberingUpdate = self.lineNumberingUpdate
        self.lineInformationValid = false
        self.needsDisplay = true
    }
    
    override func viewWillDraw() {
        super.viewWillDraw()
        self.lineInformationValid = false
        self.updateLineInformation()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("draw dirtyRect: %@ in self: %@", log: Log.StyloCore.all, type: .info, %%dirtyRect, %%ObjectIdentifier(self).hashValue)
        #endif
        
        super.draw(dirtyRect)
        assert(self.lineInformationValid)
        if !self.lineInformationValid {
            self.updateLineInformation()
        }
        
        if let backgroundColor = self.backgroundColor {
            let color = NSColor(cgColor: backgroundColor)
            color?.setFill()
            dirtyRect.fill()
        }
        
        if self.visibleRect != .zero {
            saveGState { ctx in
                for marker in markers {
                    if let markerRect = marker.drawingRect(in: self.frame),
                        NSIntersectsRect(dirtyRect, markerRect), self.needsToDraw(markerRect) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("draw marker in rect: %@", log: Log.StyloCore.all, type: .info, %%markerRect)
                        #endif
                        
                        marker.draw(in: self.frame, ctx)
                    }
                }
            }
        }
    }
    
    private func updateLineInformation() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateLineInformation() ", log: Log.StyloCore.all, type: .info)
        #endif
        
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
        
        guard let textView = layoutManager.firstTextView else {
            assertionFailure("Error: textView is nil")
            return 
        }
        
        let selectedTextAttributes = textView.selectedTextAttributes
        let selectedRange = textView.selectedRange()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("selectedRange: %@ ", log: Log.StyloCore.all, type: .info, %%selectedRange)
        #endif
        
        textStorage.enumerateAttribute(startHeadingTagAttributeKey, in: range) { (value, attrRange, stop) in
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("startHeadingTagAttributeKey with value: %@ in range: %@", log: Log.StyloCore.all, type: .info, %%value, %%attrRange)
            #endif
            
            guard let _value = value else {
                return
            }
            
            guard let value = _value as? NSNumber else {
                assertionFailure("Error: value is not NSNumber")
                return
            }
            
            let intValue = value.intValue
                
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("startHeadingTagAttributeKey with intValue: %@", log: Log.StyloCore.all, type: .info, %%intValue)
            #endif
            
            let charAfterRange = NSMakeRange(attrRange.lowerBound, 1)
            let glyphsRange = layoutManager.glyphRange(forCharacterRange: charAfterRange, actualCharacterRange: nil)
            
            let boudingRect = layoutManager.boundingRect(forGlyphRange: glyphsRange, in: textContainer)
            let attributes = textStorage.attributes(at: attrRange.location, effectiveRange: nil)
            
            var allAttributes: [NSAttributedString.Key: Any] = [:]
            for attribute in attributes {
                allAttributes[attribute.key] = attribute.value
            }
            
            let temporaryAttributes = layoutManager.temporaryAttributes(atCharacterIndex: attrRange.location, effectiveRange: nil)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("temporaryAttributes attributes %@ from layout manager: %@", log: Log.StyloCore.all, type: .info, %%temporaryAttributes, %%layoutManager)
            #endif
            
            for attribute in temporaryAttributes {
                if attribute.key.isTemporary {
                    allAttributes[attribute.key] = attribute.value
                }
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("attrRange: %@", log: Log.StyloCore.all, type: .info, %%attrRange)
            os_log("selectedRange: %@", log: Log.StyloCore.all, type: .info, %%selectedRange)
            #endif
            
            if attrRange.intersects(selectedRange) {
                for selectedTextAttribute in selectedTextAttributes {
                    allAttributes[selectedTextAttribute.key] = selectedTextAttribute.value
                }
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("adding attributes %@ to header at range: %@", log: Log.StyloCore.all, type: .info, %%allAttributes, %%attrRange)
            #endif
            
            let headingMarker = HeaderMarker(level: intValue, baseline: boudingRect.minY, attributes: allAttributes)
            markers.append(headingMarker)
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end func updateLineInformation() ", log: Log.StyloCore.all, type: .info)
        #endif
        
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
