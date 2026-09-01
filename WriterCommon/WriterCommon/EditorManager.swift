//
//  EditorManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-07-29.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import Igloo
import PromiseKit
import os

public class EditorManager<StylableStore: Store&StylableStoreType&IdentifiableStoreType>: StringStylable {
    
    typealias StylableStore = StylableStore
    
    var currentStyleAssemblyIdentifier: String = ""
    
    public let compilationUnit: Dynamic<CompilationUnit?> = Dynamic<CompilationUnit?>(nil)
    
    public let globalAttributes: Dynamic<GlobalAttributes?>
    
    public var paragraphAttributes: [NSAttributedString.Key : Any]? {
        
        guard let globalAttributes = self.globalAttributes.value else {
            assertionFailure("Error: globalAttributes is nil")
            return nil
        }
        
        guard let textStylePreview = globalAttributes.stylePreview as? TextStylePreview else {
            assertionFailure("Error: textStylePreview is nil")
            return nil
        }
        
        return textStylePreview.pAttributes
    }
    
    public var previousFlashTopElements: ContiguousArray<Element>?
    
    public var previousFlashRange: NSRange?

    public var visibleRange: NSRange? {
        
        assert(Thread.isMainThread)
        return renderer.visibleRange
    }
    
    public var visibleRangeAsync: Promise<NSRange?> {
        
        return renderer.visibleRangeAsync
    }
    
    public var selectedRange: NSRange?

    private var needsFocusClearing: Bool = false
    
    let textStorage: NSTextStorage
    
    let renderer: SourceStringAttributesRenderer
    
    var styledStoreManager: StyledStoreManager<StylableStore>
    
    var currentChangeDescription: SourceStringChangeDescription?
    
    public var styleAssemblyDescriptor: StyleAssemblyDescriptor {
        
        return styledStoreManager.styleAssemblyDescriptor
    }
    
    public let selectionStatistics: Dynamic<TextStatistics?> =  Dynamic<TextStatistics?>(nil)
    
    let dispatcher: Dispatcher
    
    var string: String {
        
        return textStorage.string
    }
    
    public var isFirstResponder: Bool = false {
        didSet {
            if !isFirstResponder {
                self.selectedRange = nil
                self.selectionStatistics.setValue(nil)
            }
        }
    }
    
    init(renderer: SourceStringAttributesRenderer, styledStoreManager: StyledStoreManager<StylableStore>, styleAssemblyDescriptor: StyleAssemblyDescriptor, textStorage: NSTextStorage, dispatcher: Dispatcher) {
        
        self.renderer = renderer
        self.styledStoreManager = styledStoreManager
        self.textStorage = textStorage
        self.globalAttributes = Dynamic<GlobalAttributes?>(nil)
        self.dispatcher = dispatcher
        self.applyStringAttributes(fromOriginStringAction: StringAction.`init`)
        self.applyGlobalAttributes()
    }
    
    func updateAttributes(using documentStoreActionResult: DocumentStoreActionResult, withChange change: SourceStringChangeDescription, visibleTopElements: ContiguousArray<Element>?, document: Document) -> StylableActionResult? {
        
        guard let stylableActionResult = styledStoreManager.updateAttributes(using: documentStoreActionResult, withChange: change, visibleTopElements: visibleTopElements, document: document, isFirstResponder: self.isFirstResponder) else {
            assertionFailure("Error: stylableActionResult is nil")
            return nil
        }
        
        self.updateCompilationUnit(withChange: change, result: stylableActionResult)
        return stylableActionResult
    }
    
    func didSetStyle() {
        
        self.renderer.didSetStyle()
    }
    
    public func flashText(withRange range: NSRange) {
        
        if self.temporaryAttributedRange != nil {
            self.styledStoreManager.clearFocusedAttributes()
            self.clearFocusedRange()
        }
        self.renderer.flashText(withRange: range)
    }
    
    public func removeFlash() {
        
        self.renderer.removeFlash()
    }
    
    public func ensureCompleteLayout() {
        
        self.renderer.ensureCompleteLayout()
    }
    
    func updateAttributesAsync(using documentStoreActionResult: DocumentStoreActionResult, withChange change: SourceStringChangeDescription, visibleTopElements: ContiguousArray<Element>?, document: Document) -> Promise<(StyleAssemblyDescriptor, StylableActionResult)> {
        
        return styledStoreManager.updateAttributesAsync(using: documentStoreActionResult, withChange: change, visibleTopElements: visibleTopElements, document: document, isFirstResponder: self.isFirstResponder)
    }
    
    func reinitializeStyledStore(withDocument document: Document, withSourceStringChangeDescription changeDescription: SourceStringChangeDescription, visibleTopElements: ContiguousArray<Element>?) throws -> StylableActionResult? {
        
        guard let stylableActionResult = try styledStoreManager.reinitializeStyledStore(withDocument: document, withSourceStringChangeDescription: changeDescription, visibleTopElements: visibleTopElements, isFirstResponder: isFirstResponder, selectedRange: changeDescription.endRange) else {
            assertionFailure("Error: stylableActionResult is nil")
            return nil
        }
        updateCompilationUnit(withChange: changeDescription, result: stylableActionResult)
        return stylableActionResult
    }
    
    public func updateStylePreviewSync() {
        
        self.styledStoreManager.updateStylePreviewSync()
    }
    
    public func updateStylePreviewAsync() -> Promise<Void> {
        
        return self.styledStoreManager.updateStylePreviewAsync()
    }
    
    func updateCompilationUnit(withChange change: SourceStringChangeDescription?, result: StylableActionResult) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateCompilationUnit(withChange: %@, result: %@)", log: Log.WriterCommon.all, type: .info, %%change?.range, %%result)
        #endif
        
        #if DEBUG
        if self.focusType.value != nil {
            assert(result.renderingProcessingResults?.count == 2)
        }
        #endif
        
        let compilationUnit = CompilationUnit(change: change, result: result)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("%@.compilationUnit.setValue(%@)", log: Log.WriterCommon.all, type: .info, %%ObjectIdentifier(self), %%compilationUnit)
        #endif
        
        self.compilationUnit.setValue(compilationUnit)
    }
        
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Focusable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var isFocused: Bool {
        
        return self.focusType.value != nil
    }
    
    public let focusType = Dynamic<FocusType?>(nil)
    
    public var temporaryAttributedRange: NSRange?
    
    
}
