//
//  SourceStringAttributesRendererMock.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-06-25.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import Igloo
import PromiseKit
@testable import WriterCommon

class SourceStringAttributesRendererMock: SourceStringAttributesRenderer {
    
    var isFirstResponder: Bool {
        return true
    }
    
    var caretColor: PlateformColorType? 
    
    let id: EditorId
    
    var styleAssemblyStore: StyleStore?
    
    var forceSetTypingAttributes: Bool = false
    
    var typingAttributes: [NSAttributedString.Key : Any]
    
    var isVisible: Bool
    
    var visibleRange: NSRange?
    
    var visibleRangeAsync: Promise<NSRange?> {
        return Promise<NSRange?>(error: NWError.custom(message: "Error"))
    }
    
    var visibleRect: NSRect
    
    var textStorage: NSTextStorage?
    
    convenience init() {
        self.init(textStorage: NSTextStorage(), id: UUID().uuidString)
    }
    
    init(textStorage: NSTextStorage, id: EditorId) {
        self.isVisible = true
        self.visibleRect = NSMakeRect(0, 0, 100, 200)
        self.typingAttributes = [:]
        self.textStorage = textStorage
        self.id = id
    }
    
    func updateTypingAtttributes(fromLocation location: Int, containsFocusAttributes: Bool) {
        // nothing
    }
    
    func makeFirstResponder() {
        // nothing
    }
    
    func setUndoSelectedRange(_ charRange: NSRange) {
        // nothing
    }
    
    func selectedRange() -> NSRange {
        fatalError("missing implementation")
    }
    
    func setSelectedRange(_ charRange: NSRange) {
        fatalError("missing implementation")
    }
    
    func removeTemporaryAttributes(forCharacterRange characterRange: NSRange) {
        fatalError("missing implementation")
    }
    
    func flashText(withRange range: NSRange) {
        fatalError("missing implementation")
    }
    
    func removeFlash() {
        fatalError("missing implementation")
    }
    
    func didSetStyle() {
        fatalError("missing implementation")
    }
    
    func handleGlobalAttributes(_ globalAttributes: GlobalAttributes?) {
        fatalError("missing implementation")
    }
    
    func applyGlobalAttributes(globalAttributes: GlobalAttributes?) {
        
    }
    
    func applyTemporaryAttributes(_ attributes: [([NSAttributedString.Key : Any], NSRange)]) {
        fatalError("missing implementation")
    }
    
    func applyViewingFontAttributes(_ attributes: [NSAttributedString.Key : Any]) {
        fatalError("missing implementation")
    }
    
    func bindToEditable() {
        //
    }
    
    func handleStyleStore() {
        fatalError("missing implementation")
    }
    
    func handleDocumentAttributes(_ documentAttributes: DocumentAttributes?) {
        fatalError("missing implementation")
    }
    
    func updateCursorPositionIfNeeded(changeDescription: SourceStringChangeDescription) {
        // nothing to do
    }
    
    func setNeedsAttributesUpdate() {
        fatalError("missing implementation")
    }
    
    func display() {
        fatalError("missing implementation")
    }
    
    func lineRange(from range: NSRange) -> NSRange? {
        fatalError("missing implementation")
    }

    func applyDocumentAttributes(attributesRecorder: AttributedStringChangeRecorder) {
        fatalError("missing implementation")
    }
    
    func applyDocumentAttributes(documentAttributes: DocumentAttributes?) {
        
        fatalError("missing implementation")
    }
    
    func applyAllAttributes<S>(using store: S, dispatcher: Dispatcher) -> Promise<Void> where S : Store, S : StylableStoreType {
        fatalError("missing implementation")
    }
    
    func updateTypingAttributes(from compiledAttributes: [NSAttributedString.Key : Any], in range: NSRange) {
        fatalError("missing implementation")
    }
    
    func setTypingAttributes(from attributes: [NSAttributedString.Key : Any]) {
        
        fatalError("missing implementation")
    }
    
    func getTypingAttributes() -> [NSAttributedString.Key : Any] {
     
        return [:]
    }
    
    func ensureCompleteLayout() {
        
        
    }
    
    func removeViewingFontAttributes() {
        fatalError("missing implementation")
    }
}
