//
//  SourceStringAttributesRenderer.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-04.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

#if os(OSX)
    public typealias PlateformTextViewType = NSTextView
#else
    public typealias PlateformTextViewType = UITextView
#endif

public protocol SourceStringAttributesRenderer: AnyObject {
    
    var id: EditorId { get }
    
    var isVisible: Bool { get }
    
    var visibleRange: NSRange? { get }
    
    var visibleRangeAsync: Promise<NSRange?> { get }
    
    var visibleRect: NSRect { get }
    
    var forceSetTypingAttributes: Bool { get set }
    
    var isFirstResponder: Bool { get }
    
    var caretColor: PlateformColorType? { get set }
    
    func makeFirstResponder()
    
    func bindToEditable()
    
    func handleGlobalAttributes(_ globalAttributes: GlobalAttributes?)
    
    func getTypingAttributes() -> [NSAttributedString.Key: Any]
    
    func setTypingAttributes(from attributes: [NSAttributedString.Key: Any])
    
    func updateTypingAttributes(from compiledAttributes: [NSAttributedString.Key: Any], in range: NSRange)
    
    func updateTypingAtttributes(fromLocation location: Int, containsFocusAttributes: Bool)
    
    func setNeedsAttributesUpdate()
    
    func updateCursorPositionIfNeeded(changeDescription: SourceStringChangeDescription)
    
    func display()
    
    func lineRange(from range: NSRange) -> NSRange?
    
    func applyTemporaryAttributes(_ attributes: [([NSAttributedString.Key: Any], NSRange)])
    
    func removeTemporaryAttributes(forCharacterRange characterRange: NSRange)
    
    func applyGlobalAttributes(globalAttributes: GlobalAttributes?)
    
    func removeViewingFontAttributes()
    
    func ensureCompleteLayout()
    
    func didSetStyle()
    
    func selectedRange() -> NSRange
    
    func setUndoSelectedRange(_ charRange: NSRange)
    
    func flashText(withRange range: NSRange)
    
    func removeFlash()
}

extension SourceStringAttributesRenderer where Self: PlateformTextViewType & EditableView & Observer {
    
    public func bindToEditable() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("%@.bindToEditable()", log: Log.WriterCommon.all, type: .info, %%ObjectIdentifier(self))
        #endif
        
        guard let editableManager = self.editableManager else {
            assertionFailure("Error: self.editableManager is nil")
            return
        }
        
        guard let editorManager = editableManager.editor(for: self.id) else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        if let globalAttributes = editorManager.globalAttributes.value {
            self.handleGlobalAttributes(globalAttributes)
        }
        
        editorManager.globalAttributes.subscribe({ [weak self](udpatedValue) in
            self?.handleGlobalAttributes(udpatedValue)
        }, observer: self)
        
        editorManager.compilationUnit.subscribe({ [weak self](compilationUnit) in
            self?.handleCompilationUnit(compilationUnit)
        }, observer: self)
    }
    
    public func handleCompilationUnit(_ compilationUnit: CompilationUnit?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("%@.handleCompilationUnit(%@)", log: Log.WriterCommon.all, type: .info, %%ObjectIdentifier(self), %%compilationUnit)
        #endif
        
        assert(Thread.isMainThread)
        guard let compilationUnit = compilationUnit else {
            return
        }

        self.setNeedsAttributesUpdate()
        self.updateTypingAttributes(fromCompilationUnit: compilationUnit)
    }
    
    public func updateTypingAttributes(fromCompilationUnit compilationUnit: CompilationUnit?) {
        
        let _affectedRange: NSRange? = {
            // make sure we apply the typing attributes

            if let change = compilationUnit?.change, change.range.length == 0 && change.range.location > 0 {
                return change.range
            }
            else {
                let selectedRange = self.selectedRange()
                if selectedRange.length == 0 && selectedRange.location > 0 {
                    return selectedRange
                }
            }
            return nil
        }()
        
        // make sure we apply the typing attributes
        guard let affectedRange = _affectedRange else  {
            // it can be nil if there is no text
            // at the new cursor location
            return
        }
        
        assert(affectedRange.location > 0)
        
        self.updateTypingAtttributes(fromLocation: affectedRange.location-1, containsFocusAttributes: compilationUnit?.containsFocusAttributes == true)
    }
    
    public func updateTypingAtttributes(fromLocation location: Int, containsFocusAttributes: Bool = false) {
        
        guard var typingAttributes = self.computeTypingAttributes(fromLocation: location) else {
            // stylo #1238: we fixed this bug by leaving the typing
            // attributes as is by returning nil.
            // So nil is expected. 
            return
        }

        if containsFocusAttributes {
            self.updateTypingAttributesWithFocusAttributes(&typingAttributes, fromFocusAttributesAtLocation: location)
        }
        
        self.setTypingAttributes(from: typingAttributes)
    }
    
    private func updateTypingAttributesWithFocusAttributes(_ typingAttributes: inout [NSAttributedString.Key : Any], fromFocusAttributesAtLocation location: Int) {
        
        guard let textStorage = self.textStorage else {
            assertionFailure("Error: self.textStorage is nil")
            return
        }
        
        assert(textStorage.layoutManagers.count == 1)
        guard let layoutManager = textStorage.layoutManagers.first else {
            assertionFailure("Error: layoutManager is nil")
            return
        }
        if let color = layoutManager.temporaryAttribute(.foregroundColor, atCharacterIndex: location, effectiveRange: nil) {
            typingAttributes[.foregroundColor] = color
        }
    }
    
    private func computeTypingAttributes(fromLocation location: Int) -> [NSAttributedString.Key : Any]? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("computeTypingAttributes(fromLocation: %@)", log: Log.WriterCommon.all, type: .debug, %%location)
        #endif
        
        guard let textStorage = self.textStorage else {
            assertionFailure("Error: self.textStorage is nil")
            return nil
        }
        
        guard location != textStorage.length else {
            assertionFailure("Error: location == textStorage.length")
            return nil
        }
        
        var textStorageAttributes: [NSAttributedString.Key : Any]?
        
        // go back until we reach a new line
        var index = location
        while !textStorage.isNewLine(at: index) {
            
            if textStorage.isWhitespace(at: index) {
                index -= 1
                continue
            }
            else {
                textStorageAttributes = textStorage.attributes(at: index, effectiveRange: nil)
                break
            }
        }
        
        return textStorageAttributes
    }
    
    public func didSetStyle() {
        
        self.needsUpdateConstraints = true
        self.ensureCompleteLayout()
        self.setSelectedRange(selectedRange)
    }
    
    public func applyTemporaryAttributes(_ attributes: [([NSAttributedString.Key: Any], NSRange)]) {
        
        guard let layoutManager = self.layoutManager else {
            assertionFailure("Error: self.layoutManager is nil")
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Applying temporaryAttributes %@ to layoutManager: %@.", log: Log.WriterCommon.all, type: .debug, %%attributes, %%ObjectIdentifier(layoutManager))
        #endif
        
        for (values, range) in attributes {
//            #if DEBUG
//            for value in values {
//                assert(value.key.isTemporary)
//            }
//            #endif
            layoutManager.addTemporaryAttributes(values, forCharacterRange: range)
        }
    }
    
    public func updateCursorPositionIfNeeded(changeDescription: SourceStringChangeDescription) {
        
        let selectedRange = self.selectedRange()
        let location = selectedRange.location
        
        guard let textStorage = self.textStorage else {
            assertionFailure("Error: self.textStorage is nil")
            return
        }
        
        if textStorage.isCursorInsideHeaderTag(at: location) || textStorage.isHeaderTagStart(at: location) {
            textStorage.moveCursorToEndOfHiddenHeaderTag(from: location, in: self)
        }
    }
    
    public var isVisible: Bool {
        
        return self.window != nil
    }
    
    public var visibleRange: NSRange? {
        
        assert(Thread.isMainThread)
        return self.getVisibleRange()
    }
    
    public var visibleRangeAsync: Promise<NSRange?> {
        return Promise<NSRange?> { fulfill, reject in
            DispatchQueue.main.async { [weak self] in
                fulfill(self?.getVisibleRange())
            }
        }
    }
    
    public func getTypingAttributes() -> [NSAttributedString.Key: Any] {
        
        return self.typingAttributes
    }
    
    public func setTypingAttributes(from attributes: [NSAttributedString.Key: Any]) {
        
        assert(Thread.isMainThread)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setTypingAttributes(from: %@)", log: Log.WriterCommon.all, type: .debug, %%attributes)
        #endif
        
        var filteredAttributes = attributes
        filteredAttributes.removeValue(forKey: StyloAttribute.headingTagAfter.key)
        filteredAttributes.removeValue(forKey: StyloAttribute.headingTagBefore.key)
        filteredAttributes.removeValue(forKey: StyloAttribute.caretColor.key)
        if !filteredAttributes.isEmpty {
            self.forceSetTypingAttributes = true
            self.typingAttributes = filteredAttributes
            self.forceSetTypingAttributes = false
        }
    }
    
    public func updateTypingAttributes(from compiledAttributes: [NSAttributedString.Key: Any], in range: NSRange) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateTypingAttributes(from: %@, in: %@", log: Log.WriterCommon.all, type: .debug, %%compiledAttributes, %%range)
        #endif
        
        let _selectedRange = self.selectedRange()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("selectedRange is: %@", log: Log.WriterCommon.all, type: .info, %%_selectedRange)
        os_log("attributes range is: %@", log: Log.WriterCommon.all, type: .info, %%range)
        #endif

        if range.upperBound == _selectedRange.location || NSLocationInRange(_selectedRange.location, range) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("update typing attributes from compiled ones: %@", log: Log.WriterCommon.all, type: .info, %%compiledAttributes)
            #endif
            self.forceSetTypingAttributes = true
            var filteredAttributes = compiledAttributes
            filteredAttributes.removeValue(forKey: StyloAttribute.headingTagAfter.key)
            filteredAttributes.removeValue(forKey: StyloAttribute.headingTagBefore.key)
            if !filteredAttributes.isEmpty {
                self.typingAttributes = filteredAttributes
            }
            self.forceSetTypingAttributes = false
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED 
            os_log("No update to typingAttributes.", log: Log.WriterCommon.all, type: .info)
            #endif
        }
    }
    
    /// Method that returns the attributes that should be used for the typing
    /// attributes according to the selectedRange parameter.
    public func getTypingAttributes(for selectedRange: NSRange, computedTypingAttributes: [NSAttributedString.Key: Any]?) -> [NSAttributedString.Key: Any]? {
        
        // the current implementation is simple. It simply returns
        // the last valid attributes that were assigned by the compilation
        // process to closest range before the selectedRange received as
        // a parameter.
        var _computedTypingAttributes = computedTypingAttributes
        
        if spaceBefore(selectedRange: selectedRange) {
            
            for spaceIncompatibleAttribute in NSAttributedString.spaceIncompatibleAttributes {
                _computedTypingAttributes?.removeValue(forKey: spaceIncompatibleAttribute)
            }
        }
        return _computedTypingAttributes
    }
  
    public func removeViewingFontAttributes() {
        
        self.font = nil
        self.textColor = nil
    }
    
    public func setNeedsAttributesUpdate() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("needs attributes update start", log: Log.WriterCommon.all, type: .info)
        #endif
        
        assert(Thread.isMainThread)
        // not needed, performance optimisation
        setNeedsDisplay(self.visibleRect)

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("needs attributes update stop", log: Log.WriterCommon.all, type: .info)
        #endif
    }
    
    /// Function that returns the line range that is part of
    /// the selected range.
    public func lineRange(from range: NSRange) -> NSRange? {
        
        assert(Thread.isMainThread)
        if let layoutManager = layoutManager, let textContainer = textContainer {
            
            // Convert it to a glyph range
            let matchingGlyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
            
            // line fragment rect at location range
            let rect = layoutManager.lineFragmentRect(forGlyphAt: matchingGlyphRange.location, effectiveRange: nil)
            
            // obtain the line range for the line fragment rect
            return layoutManager.glyphRange(forBoundingRect: rect, in: textContainer)
            
        }
        return nil
    }

    public func applyGlobalAttributes(globalAttributes: GlobalAttributes?) {
        
        DispatchQueue.asyncOnMain { [weak self] in
            
            // Apply document attributes
            let editableManager = self?.editableManager

            assert(editableManager != nil)

            let newColor = globalAttributes?.backgroundColor
            
            assert(newColor != nil)
            if let newColor = newColor {
                
                self?.backgroundColor = newColor
            }
            
            self?.caretColor = globalAttributes?.caretColor
        }
    }
    
    private func getVisibleRange() -> NSRange? {
        
        if let textStorage = self.textStorage {
            
            if let layoutManager = textStorage.layoutManagers.first {
                
                if let textContainer = layoutManager.textContainers.first {
                    
                    let glyphRange = layoutManager.glyphRange(forBoundingRect: self.visibleRect, in: textContainer)
                    return layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
                }
            }
        }
        return nil
    }
    
    private func spaceBefore(selectedRange range: NSRange) -> Bool {
        
        let location = range.location
        if let char = self.textStorage!.mutableString.charAt(location), isWhiteSpace(char) {
            return true
        }
        return false
    }
    
    private func selectionColor(from color: PlateformColorType) -> PlateformColorType? {
        
        return color.complemented()
    }
    
}

