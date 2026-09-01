//
//  StyledStoreManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

extension PlateformColorType {
    
    var hsba:(h: CGFloat, s: CGFloat,b: CGFloat,a: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h: h, s: s, b: b, a: a)
    }
}

/// The StyledStoreManager is responsible for managing
/// the attributes for an associated style assembly. It is
/// the style that is applied to the document. Not the style
/// managed by the style manager.
public class StyledStoreManager<StylableStore: Store&StylableStoreType&IdentifiableStoreType>: NSObject, Observer, AnyStylable {
    
    public var priority: ObserverPriority {
        return .background
    }
       
    var selectedTextAttributes = Dynamic<[NSAttributedString.Key : Any]?>(nil)
        
    let styleAssemblyDescriptor: StyleAssemblyDescriptor
    
    internal private(set) var styledStore: StylableStore
    
    weak var styleAssemblyStore: StyleAssemblyStore?
    
    var highlightSelectors: SelectorList? {
        
        return styledStore.highlightSelectors
    }
    
    let dispatcher: Dispatcher
    
    //////////////////////////////////////////////
    //////////// AnyStylable protocol ////////////
    //////////////////////////////////////////////
    
    public var globalAttributes: GlobalAttributes? {
        
        guard let documentAttributes = self.documentAttributes.value else {
            assertionFailure("Error: self.documentAttributes.value is nil")
            return nil
        }
        
        guard let stylePreview = self.stylePreview.value else {
            assertionFailure("Error: self.stylePreview.value is nil")
            return nil
        }
        
        guard let selectedTextAttributes = self.selectedTextAttributes.value else {
            assertionFailure("Error: self.selectedTextAttributes.value is nil")
            return nil
        }
        
        return GlobalAttributes(documentAttributes: documentAttributes, stylePreview: stylePreview, selectedTextAttributes: selectedTextAttributes)
    }
    
    private let documentAttributes = Dynamic<DocumentAttributes?>(nil)

    public let stylePreview = Dynamic<StylePreview?>(nil)
    
    var attributes: [([NSAttributedString.Key: Any], NSRange)]? {
        return try? self.dispatcher.readSync(store: styledStore, in: styledStore.serialCompilationQueue, with: { [weak self]() throws -> [([NSAttributedString.Key: Any], NSRange)]? in
            return self?.styledStore.stylableString.allAttributes
        })
    }
    
    var focusAttributes: [([NSAttributedString.Key: Any], NSRange)]? {
        return try? self.dispatcher.readSync(store: styledStore, in: styledStore.serialCompilationQueue, with: { [weak self]() throws -> [([NSAttributedString.Key: Any], NSRange)]? in
            return self?.styledStore.focusAttributesString?.allAttributes
        })
    }
    
    init(styleAssemblyDescriptor: StyleAssemblyDescriptor, styledStore: StylableStore, styleAssemblyStore: StyleAssemblyStore, dispatcher: Dispatcher) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("init StyleStoreManager -> style store id: %@", log: Log.WriterCommon.all, type: .debug, %%styledStore.identifier)
        #endif
        
        self.styleAssemblyDescriptor = styleAssemblyDescriptor
        self.styledStore = styledStore
        self.styleAssemblyStore = styleAssemblyStore
        self.dispatcher = dispatcher
        super.init()
    }
    
    @discardableResult
    func clearHighlight(document: Document, isFirstResponder: Bool, selectedRange: NSRange?) -> StylableActionResult? {
        
        dispatcher.sync(store: styledStore, action: StylableStoreAction.clearSelectorHighlightString.syncAction)
        guard let stylableActionResult = try? compileInitialAttributes(visibleTopElements: nil, document: document, isFirstResponder: isFirstResponder, selectedRange: selectedRange) else {
            assertionFailure("Error: stylableActionResult is nil")
            return nil
        }
        
        self.updateDocumentAttributes(stylableActionResult.documentAttributes)
        return stylableActionResult
    }
    
    @discardableResult
    public func highlight(with selectorString: String, document: Document, isFirstResponder: Bool, selectedRange: NSRange?) -> StylableActionResult? {
        
        dispatcher.sync(store: styledStore, action: StylableStoreAction.updateSelectorHighlightString(string: selectorString).syncAction)
        guard let stylableActionResult = try? compileInitialAttributes(visibleTopElements: nil, document: document, isFirstResponder: isFirstResponder, selectedRange: selectedRange) else {
            assertionFailure("Error: stylableActionResult is nil")
            return nil
        }
        
        self.updateDocumentAttributes(stylableActionResult.documentAttributes)
        return stylableActionResult
    }
    
    public func changeFocusMode(_ focusMode: FocusMode)  {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyFocusMode(%@) to style store with id: %@", log: Log.WriterCommon.all, type: .debug, focusMode.stringValue, %%self.styledStore.identifier)
        #endif
    
        
        let changeFocusAction = StylableStoreAction.changeFocusMode(focusMode: focusMode).syncAction
        self.dispatcher.sync(store: self.styledStore, action: changeFocusAction)
    }
    
    public func changeSelection(visibleTopElements: ContiguousArray<Element>, document: Document, selectionRange: NSRange?, visibleRange: NSRange) -> StylableActionResult? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("changeSelection(visibleTopElements: %@, selectionRange: %@, visibleRange: %@)", log: Log.WriterCommon.all, type: .info, %%visibleTopElements, %%selectionRange, %%visibleRange)
        #endif
        
        assert(self.styledStore.focusMode.value != .disabled, "focusType is nil in store with id: \(self.styledStore.identifier)")
        
        let  changeSelectionAction = StylableStoreAction.changeSelection(selectionRange: selectionRange, visibleTopElements: visibleTopElements, document: document).syncAction
        let selectionResult = self.dispatcher.sync(store: self.styledStore, action: changeSelectionAction)
        return selectionResult as? StylableActionResult
    }
    
    public func clearFocusedAttributes() {
        guard StyloApplication.shared.focusMode.value != .disabled else {
            return
        }
        
        dispatcher.sync(store: self.styledStore, action: StylableStoreAction.clearFocusedAttributes(focusMode: StyloApplication.shared.focusMode.value).syncAction)
    }
    
    func attributes(in range: NSRange) -> [([NSAttributedString.Key: Any], NSRange)]? {
        
        return self.styledStore.stylableString.attributes(in: range)
    }
    
    func subscribeToStylePreviewChange() {
        
        guard let styleAssemblyStore = self.styleAssemblyStore else {
            assertionFailure("Error: self.styleAssemblyStore is nil")
            return
        }
        
        self.updateSelectionAttributesFromStylePreview()
        styleAssemblyStore.stylePreview.subscribe({ [weak self] (stylePreview) in
            self?.updateSelectionAttributesFromStylePreview()
        }, observer: self)
    }
    
    func unsubscribeToStylePreviewChange() {
        
        guard let styleAssemblyStore = self.styleAssemblyStore else {
            assertionFailure("Error: self.styleAssemblyStore is nil")
            return
        }
        
        styleAssemblyStore.stylePreview.unsubscribe(observer: self)
    }
    
    func updateStylePreviewSync() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateStylePreviewSync()", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        guard let styleAssemblyStore = self.styleAssemblyStore else {
            assertionFailure("Error: self.styleAssemblyStore is nil")
            return
        }
        
        let textStylePreviewAction = StyleAssemblyAction.updateStylePreview.syncAction
        let actionResult = self.dispatcher.sync(store: styleAssemblyStore, action: textStylePreviewAction)
        
        guard let styleDocumentResult = actionResult as? StyleDocumentResult else {
            assertionFailure("Error: actionResult is not StyleDocumentResult")
            return
        }
        
        guard let stylePreview = styleDocumentResult.stylePreview else {
            assertionFailure("Error: styleDocumentResult.stylePreview is nil")
            return
        }
        
        self.stylePreview.setValue(stylePreview)
        applySelectionAttributes(from: stylePreview)
    }
    
    @discardableResult
    func updateStylePreviewAsync() -> Promise<Void> {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateStylePreviewAsync()", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        guard let styleAssemblyStore = self.styleAssemblyStore else {
            let errorText =  "Error: self.styleAssemblyStore is nil"
            assertionFailure(errorText)
            return Promise(error: NWError.custom(message: errorText))
        }
        
        return Promise<Void> { fulfill, reject in

            firstly {
                self.dispatcher.async(store: styleAssemblyStore, action: StyleAssemblyAction.updateStylePreview.asyncAction)
            }.then { actionResult -> Void in
                
                guard let styleDocumentResult = actionResult as? StyleDocumentResult else {
                    assertionFailure("Error: actionResult is not StyleDocumentResult")
                    return
                }
                
                guard let stylePreview = styleDocumentResult.stylePreview else {
                    assertionFailure("Error: styleDocumentResult.stylePreview is nil")
                    return
                }
                
                self.stylePreview.setValue(stylePreview)
                self.applySelectionAttributes(from: stylePreview)
                fulfill(())
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error while computing text style preview: %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
                reject(error)
            }
        }
    }
    
    func updateSelectionAttributesFromStylePreview() {
        
        guard let styleAssemblyStore = self.styleAssemblyStore else {
            assertionFailure("Error: self.styleAssemblyStore is nil")
            return
        }
        
        guard let stylePreview = styleAssemblyStore.stylePreview.value else {
            assertionFailure("Error: styleAssemblyStore.stylePreview.value is nil")
            return
        }
        
        applySelectionAttributes(from: stylePreview)
    }
    
//    func reinitializeStyledStoreSync(withDocument document: Document, withSourceStringChangeDescription changeDescription: SourceStringChangeDescription) throws {
//
//        guard let styleValue = self.styleAssemblyStore?.style.value else {
//            assertionFailure("Error: styleValue is nil")
//            return
//        }
//
//        var string = self.styledStore.stylableString.string
//        string.update(withSourceStringChangeDescription: changeDescription)
//
//        // here we need to create a StylableStore which will be responsible
//        // for computing the text attributes using a style
//        let styledStore = StylableStore(string: string, styleValue: styleValue, attributesRenderingType: self.styleAssemblyDescriptor.attributesRenderingType, document: document)
//
//        self.styledStore = styledStore
//
//        try self.compileInitialAttributesSync()
//        try self.updateStylePreviewSync()
//    }
    
    func reinitializeStyledStoreAsync(withDocument document: Document, visibleTopElements: ContiguousArray<Element>?, isFirstResponder: Bool, selectedRange: NSRange?) -> Promise<Void> {
        
        #if DEBUG
        validateVisibleTopElements(visibleTopElements)
        #endif
        
        guard let styleAssemblyStore = self.styleAssemblyStore else {
            let errorText = "Error: styleAssemblyStore is nil"
            assertionFailure(errorText)
            return Promise(error: NWError.custom(message: errorText))
        }
        
        guard let resourceComputedStyle = styleAssemblyStore.resourceComputedStyle else {
            let errorText = "Error: resourceComputedStyle is nil"
            assertionFailure(errorText)
            return Promise(error: NWError.custom(message: errorText))
        }
        
        // here we need to create a StylableStore which will be responsible
        // for computing the text attributes using a style
        let styledStore = StylableStore(string: self.styledStore.stylableString.string, focusMode: StyloApplication.shared.focusMode.value, resourceComputedStyle: resourceComputedStyle, highlightSelectors: self.highlightSelectors)
        
        self.styledStore = styledStore
        self.changeFocusMode(StyloApplication.shared.focusMode.value)
        
        return Promise<Void> { fulfill, reject in
            firstly {
                self.compileInitialAttributesAsync(visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder, selectedRange: selectedRange)
            }.then {
                self.updateStylePreviewAsync()
            }.then {
                fulfill(())
            }.catch { error in
                assertionFailure("Error: \(error)")
                reject(error)
            }
        }
    }
  
    ///
    /// Method responsible for compiling the initial attributes recorder
    /// values in all StyledStoreManager.
    ///
    /// 1. it sets the proper style
    ///
    func compileInitialAttributesAsync(visibleTopElements: ContiguousArray<Element>?, document: Document, isFirstResponder: Bool, selectedRange: NSRange?) -> Promise<Void> {
        
        #if DEBUG
        validateVisibleTopElements(visibleTopElements)
        #endif
        
        let computeInitialAttributesAction = StylableStoreAction.computeInitialAttributes(visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder, selectedRange: selectedRange).asyncAction
        
        return Promise<Void> { fulfill, reject in
            firstly {
                self.dispatcher.async(store: styledStore, action: computeInitialAttributesAction)
            }.then { compilationResult in
                if let stylableActionResult = compilationResult as? StylableActionResult {
                    self.updateDocumentAttributes(stylableActionResult.documentAttributes)
                    fulfill(())
                }
                else {
                    let errorText = "Error: compilationResult is not StylableActionResult"
                    assertionFailure(errorText)
                    reject(NWError.custom(message: errorText))
                }
            }.catch { error in
                assertionFailure("Error: \(error)")
                reject(error)
            }
        }
    }
    
    ///
    /// Method responsible for compiling the initial attributes recorder
    /// values in all StyledStoreManager.
    ///
    /// 1. it sets the proper style
    ///
    func compileInitialAttributes(visibleTopElements: ContiguousArray<Element>?, document: Document, isFirstResponder: Bool, selectedRange: NSRange?) throws -> StylableActionResult? {
        
        let computeInitialAttributesAction = StylableStoreAction.computeInitialAttributes(visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder, selectedRange: selectedRange)
        let compilationResult = try self.dispatcher.online(store: styledStore, action: computeInitialAttributesAction)
        
        guard let stylableActionResult = compilationResult as? StylableActionResult else {
            assertionFailure("Error: compilationResult is not StylableActionResult")
            return nil
        }
        return stylableActionResult
    }
    
    func updateAttributes(using documentStoreActionResult: DocumentStoreActionResult, withChange change: SourceStringChangeDescription, visibleTopElements: ContiguousArray<Element>?, document: Document, isFirstResponder: Bool) -> StylableActionResult? {

        guard let updateDocumentResults = documentStoreActionResult.updateDocumentResults else {
            assertionFailure("Error: updateDocumentResults is nil")
            return nil
        }
        
        let applyStringChangeAction = StylableStoreAction.applySourceStringChange(change: change, documentResults: updateDocumentResults, visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder).syncAction
        
        let compilationResult = self.dispatcher.sync(store: styledStore, action: applyStringChangeAction)
        
        guard let stylableActionResult = compilationResult as? StylableActionResult else {
            assertionFailure("Error: compilationResult is not StylableActionResult")
            return nil
        }
        
        #if DEBUG && DEBUG_LOGS_ENABLED
        guard let renderingProcessingResults = stylableActionResult.renderingProcessingResults else {
            assertionFailure("Error: renderingProcessingResults is nil")
            return nil
        }
        
        debugPrint("**********************************************")
        debugPrint("********renderingProcessingResults************")
        debugPrint("**********************************************")
        for renderingProcessingResult in renderingProcessingResults {
            debugPrint(renderingProcessingResult.debugDescription)
        }
        debugPrint("**********************************************")
        debugPrint("**********************************************")
        debugPrint("**********************************************")
        #endif
        
        self.updateDocumentAttributes(stylableActionResult.documentAttributes)
        
        return stylableActionResult
    }
    
    func reinitializeStyledStore(withDocument document: Document, withSourceStringChangeDescription changeDescription: SourceStringChangeDescription, visibleTopElements: ContiguousArray<Element>?, isFirstResponder: Bool, selectedRange: NSRange?) throws -> StylableActionResult? {
        
        let applyStringChangeAction = StylableStoreAction.updateAttributedString(change: changeDescription).syncAction
        self.dispatcher.sync(store: styledStore, action: applyStringChangeAction)
//
        guard let stylableActionResult = try self.compileInitialAttributes(visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder, selectedRange: selectedRange) else {
            assertionFailure("Error: stylableActionResult is nil")
            return nil
        }
        
        return stylableActionResult
    }
    
    func updateAttributesAsync(using documentStoreActionResult: DocumentStoreActionResult, withChange change: SourceStringChangeDescription, visibleTopElements: ContiguousArray<Element>?, document: Document, isFirstResponder: Bool) -> Promise<(StyleAssemblyDescriptor, StylableActionResult)> {
        
        #if DEBUG
        validateVisibleTopElements(visibleTopElements)
        #endif
        
        guard let updateDocumentResults = documentStoreActionResult.updateDocumentResults else {
            let errorString = "Error: updateDocumentResults is nil"
            assertionFailure(errorString)
            return Promise(error: NWError.custom(message: errorString))
        }
        
        let applyStringChangeAction = StylableStoreAction.applySourceStringChange(change: change, documentResults: updateDocumentResults, visibleTopElements: visibleTopElements, document: document, isFirstResponder: isFirstResponder).asyncAction
        
        return Promise<(StyleAssemblyDescriptor, StylableActionResult)> { fulfill, reject in
            
            firstly {
                self.dispatcher.async(store: styledStore, action: applyStringChangeAction)
            }.then { actionResult in
                if let stylableActionResult = actionResult as? StylableActionResult {
                    self.updateDocumentAttributes(stylableActionResult.documentAttributes)
                    fulfill((self.styleAssemblyDescriptor, stylableActionResult))
                }
                else {
                    let errorText = "Error: compilationResult is not StylableActionResult"
                    assertionFailure(errorText)
                    reject(NWError.custom(message: errorText))
                }
            }.catch { error in
                reject(error)
            }
        }
    }
    
    func applySelectionAttributes(from stylePreview: StylePreview) {
           
        guard let selectionAttributes = stylePreview as? SelectionAttributes else {
            assertionFailure("Error: stylePreview is no SelectionAttributes")
            return
        }
            
        updateSelectionAttributes(from: selectionAttributes)
    }
    
    func precomputeFadeStyles(document: Document) {
        
        let precomputeFadeStylesAction = StylableStoreAction.precomputeFadeStyles(document: document)
        self.dispatcher.async(store: styledStore, action: precomputeFadeStylesAction.asyncAction)
    }
    
    private func updateSelectionAttributes(from selectionAttributes: SelectionAttributes) {
        
        let computeTextSelectionAttributes = self.computeTextSelectionAttributes(from: selectionAttributes)
        
        assert(computeTextSelectionAttributes != nil)
        self.selectedTextAttributes.setValue(computeTextSelectionAttributes)
    }
    
    private func computeTextSelectionAttributes(from selectionAttributes: SelectionAttributes) -> [NSAttributedString.Key : Any]? {
        
        let backgroundBaseColor = selectionAttributes.backgroundBaseColor
        let foregroundBaseColor = selectionAttributes.foregroundBaseColor
        
        assert(backgroundBaseColor != nil)
        assert(foregroundBaseColor != nil)
        if let foregroundBaseColor = foregroundBaseColor, let backgroundBaseColor = backgroundBaseColor {
            
            let selectedTextBackgroundColor: PlateformColorType
            let selectedTextForegroundColor: PlateformColorType
            
            
            if backgroundBaseColor.hsba.s  > 0.7 {
                
                selectedTextBackgroundColor = backgroundBaseColor.lighter()
                selectedTextForegroundColor = foregroundBaseColor
            }
            else if backgroundBaseColor.hsba.s  > 0.5 {
                
                selectedTextBackgroundColor = backgroundBaseColor.darkened()
                selectedTextForegroundColor = foregroundBaseColor
            }
            else {
                
                selectedTextBackgroundColor = backgroundBaseColor.darkened()
                selectedTextForegroundColor = foregroundBaseColor
            }
            
            return [
                
                NSAttributedString.Key.foregroundColor: selectedTextForegroundColor,
                NSAttributedString.Key.backgroundColor: selectedTextBackgroundColor
            ]
        }
        return nil
    }
    
    public func updateDocumentAttributes(_ documentAttributes: DocumentAttributes?) {
        
        self.documentAttributes.setValue(documentAttributes, sameExecutionStack: true)
//        
//            _updateDocumentAttributes(documentAttributes)
//        }
//        else {
//            DispatchQueue.main.async { [weak self] in
//                self?._updateDocumentAttributes(documentAttributes)
//            }
//        }
    }
    
    private func _updateDocumentAttributes(_ documentAttributes: DocumentAttributes?) {
        
        self.documentAttributes.setValue(documentAttributes, sameExecutionStack: true)
//        self.backgroundColor.setValue(documentAttributes?.backgroundColor, sameExecutionStack: true)
    }
    
    #if DEBUG
    private func validateVisibleTopElements(_ visibleTopElements: ContiguousArray<Element>?) {
        
        // we can assume that the value in the styled store is the right one
        // because we are required to send a change focus type to the styled
        // before compiling new attributes with any other actions which in turn
        // need to have a visibleTopElements parameter to be passed
        
        if self.styledStore.focusMode.value != .disabled {
            assert(visibleTopElements != nil)
        }
        else {
            assert(visibleTopElements == nil)
        }
    }
    #endif
}
