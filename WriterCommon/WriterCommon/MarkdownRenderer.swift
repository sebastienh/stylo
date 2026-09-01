//
//  MarkdownRenderer.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-06-23.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Markdown
import Common
import NaturalLanguage
import Web
import os

/// The RenderTreeCreatorVisitor models both RenderTreeCreator and Visitor. Each
/// new kind of document must define
final class MarkdownRenderer: SerialRenderer, Visitor, HtmlDomVisitor {
    
    typealias DocumentType = HtmlDocument
    
    var deletedNodes: ContiguousArray<Node>?
    
    let resourceComputedStyle: ResourceComputedStyle
    
    /// This variable is used if the element is the element responsible
    /// for setting the document attributes. In the HTML case it is the "body"
    /// element and in the CSS case it is the "stylesheet" element.
    var documentAttributes: [NSAttributedString.Key : Any]?
    
    var documentBackgroundColor: PlateformColorType? {
        return self.documentAttributes?[NSAttributedString.Key.backgroundColor] as? PlateformColorType
    }
    
    var documentCaretColor: PlateformColorType? {
        return self.documentAttributes?[StyloAttribute.caretColor.key] as? PlateformColorType
    }
    
    var contentString: StylableString {
        return renderingContext.contentString
    }
    
    let document: HtmlDocument
    
    private var addedAttributes: [AttributesRange]
    
    private var setAttributes: [AttributesRange]
    
    private var deletedAttributes: [AttributesRange]
    
    var focusType: FocusType? {
        return self.renderingContext.focusType
    }
    
    var flashedRange: NSRange? {
        return renderingContext.focusType?.flashedRange
    }
    
    let renderingContext: RenderingContext
    
    var filterContext: FilterContext
    
    var renderedTopElements: ContiguousArray<Element>?
    
    var previousRenderedTopElements: ContiguousArray<Element>?
    
    private var paragraphStyle: [NSAttributedString.Key : Any]? {
        
        if let paragraphStyle = self.resourceComputedStyle.paragraphStyle {
            return paragraphStyle
        }
        
        var exception = Exception()
        let document = HtmlDocument.Create()!
        let paragraphElement = HTMLParagraphElement(document: document)
        let body = document.body
        body?.appendChild(paragraphElement, exception: &exception)
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: self.resourceComputedStyle.styleDefinition)
        
        resourceComputedStyle.computeElementsStyles(document: document, filterContext: FilterContext())
        guard let computedStyle = resourceComputedStyle.computedStyle(forElement:paragraphElement) else {
            assertionFailure("Error: computedStyle is nil for paragraphElement")
            return nil
        }
        
        guard var textAttributes = TextStylizer.shared.textStyle(from: computedStyle, element: paragraphElement) else {
            assertionFailure("Error: textAttributes is nil")
            return nil
        }
        
        textAttributes.removeValue(forKey: .backgroundColor)
        
        self.resourceComputedStyle.updateParagraphStyle(withAttributes: textAttributes)
        
        return textAttributes
    }
    
    init(resourceComputedStyle: ResourceComputedStyle, renderingContext: RenderingContext,  document: HtmlDocument) {
        
        self.resourceComputedStyle = resourceComputedStyle
        self.parentStack = Stack<RenderNodeInfo>()
        self.renderingContext = renderingContext
        self.renderedTopElements = ContiguousArray<Element>()
        self.filterContext = renderingContext.filterContext
        
        self.document = document
        self.addedAttributes = [AttributesRange]()
        self.setAttributes = [AttributesRange]()
        self.deletedAttributes = [AttributesRange]()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Renderer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func addDeleteAttributesRange(_ attributesRange: AttributesRange) {
        self.deletedAttributes.append(attributesRange)
    }
    
    func addSetAttributesRange(_ attributesRange: AttributesRange) {
        self.setAttributes.append(attributesRange)
    }
    
    func addAddedAttributesRange(_ attributesRange: AttributesRange) {
        self.addedAttributes.append(attributesRange)
    }
    
    func addRendererTopElement(_ element: Element) {
        self.renderedTopElements?.append(element)
    }
    
    @discardableResult
    func process(elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?) -> RenderingProcessingResult {
        
        // we don't use these deletedNodes yet 
        self.deletedNodes = deletedNodes
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("DOMRender process(...)", log: Log.WriterCommon.all, type: .info)
        os_log("DOMRender number of elements to process: %d", log: Log.WriterCommon.all, type: .info, elements.count)
        #endif
        
        #if false
        if let attributesRecorder = contentString as? AttributedStringChangeRecorder {
            os_log("string attributes before: %@", log: Log.WriterCommon.all, type: .info, %%attributesRecorder.debugAttributesString)
        }
        #endif
        
        switch renderingType {
        case .complete:
            self.renderComplete(elements: elements, deletedNodes: deletedNodes)
        case .edit:
            self.renderEdit(elements: elements, deletedNodes: deletedNodes)
        case .selection:
            self.renderSelection(elements: elements, deletedNodes: deletedNodes)
        case .flash:
            self.renderScroll(elements: elements, deletedNodes: deletedNodes)
        }
        
        #if false
        if let attributesRecorder = contentString as? AttributedStringChangeRecorder {
            os_log("string attributes after: %@", log: Log.WriterCommon.all, type: .info, %%attributesRecorder.debugAttributesString)
        }
        #endif
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Affected ranges: ", log: Log.WriterCommon.all, type: .debug)
        for addedAttributes in self.addedAttributes {
            os_log("..affected range: %@ with attributes: %@", log: Log.WriterCommon.all, type: .debug, %%NSStringFromRange(addedAttributes.range), %%addedAttributes.attributes)
        }
        #endif
        
        assert(contentString.documentAttributes != nil)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("End DOMRender process(...)", log: Log.WriterCommon.all, type: .info)
        #endif
        
        return buildRenderingProcessingResult()
    }
    
    /// This is the method to call from outside to create a render tree
    /// from the top of a Document using a ResourceComputedStyle
    func process(_ document: Document) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("DOMRender process(...)", log: Log.WriterCommon.all, type: .info)
        #endif
        
        let visitableDocumentElement = document.rootDocumentElement as? HtmlDomVisitable
        
        assert(visitableDocumentElement != nil)
        if let visitableDocumentElement = visitableDocumentElement {
            visitableDocumentElement.accept(self)
        }
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("End DOMRender process(...)", log: Log.WriterCommon.all, type: .info)
        #endif
    }
    
    private func renderComplete(elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?) {
        
        if let element = elements.first {
            let completeRange = NSMakeRange(0, self.contentString.length)
            self.contentString.removeAttribute(StyloAttribute.headingTagBefore.key, range: completeRange)
            self.remove(attributes: [StyloAttribute.headingTagBefore.key: true], in: completeRange, from: element)
        }
        
        process(elements: document.body.children.elements)
    }
    
    private func renderEdit(elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?) {
        
        assert(self.deletedNodes != nil, "Error: deletedNodes is nil")
        if let deletedNodes = self.deletedNodes {
            for deletedNode in deletedNodes {
                if let heading = deletedNode as? HTMLHeadingElement {
                    self.removeBeforeHeadingTagAttributes(fromDeletedElement: heading)
                }
            }
        }
        
        // we only need to do this if we are in focus mode
        if let focusType = self.focusType {
            
            switch focusType {
            case .bloc:
                self.renderFocusBloc(elements: elements, deletedNodes: deletedNodes)
            case .paragraph: fallthrough
            case .sentence:
                self.process(elements: elements)
            case .flash:
                fatalError()
            }
        }
        else {
            process(elements: elements)
        }
    }
    
    private func renderSelection(elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?) {
        
        // we only need to do this if we are in focus mode
        if let focusType = self.focusType {
            
            switch focusType {
            case .bloc:
                self.renderFocusBloc(elements: elements, deletedNodes: deletedNodes)
            case .paragraph: fallthrough
            case .sentence:
                self.process(elements: elements)
            case .flash:
                fatalError()
            }
        }
    }
    
   
    
    private func renderScroll(elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?) {
        
        // we only need to do this if we are in focus mode
        if let focusType = self.focusType {
            
            switch focusType {
            case .bloc: fallthrough
            case .paragraph: fallthrough
            case .sentence:
                // nothing to do
                assertionFailure("Error: should not render focus")
                break
            case .flash:
                process(elements: elements)
            }
        }
        else {
            process(elements: elements)
        }
    }
    
    ///
    /// This method renders a selection when the user changes it by clicking somewhere
    /// and we are in focus mode (if we are not, there is nothing to do).
    ///
    /// Everything that is in the focused bloc should be rendered with the :focus
    /// ephemeral option and everything else should be rendered with the :fade
    /// ephemeral option.
    ///
    private func renderFocusBloc(elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?) {
        
        (document.documentElement as? HTMLHtmlElement)?.acceptSingle(self)
        document.body.acceptSingle(self)
        
//        #if DEBUG
        for element in elements {

            guard let htmlElment = element as? HTMLElement else {
                assertionFailure("Error: element is not HTMLElement")
                return
            }

            if !(htmlElment is HTMLBodyElement) && !(htmlElment is HTMLHtmlElement) {
                htmlElment.accept(self)
                addRendererTopElement(element)
            }
        }
//        #else
//        DispatchQueue.concurrentPerform(iterations: elements.count) { (index) in
//            let element = elements[index]
//
//            guard let htmlElment = element as? HTMLElement else {
//                assertionFailure("Error: element is not HTMLElement")
//                return
//            }
//
//            if !(htmlElment is HTMLBodyElement) && !(htmlElment is HTMLHtmlElement) {
//                htmlElment.accept(self)
//                addRendererTopElement(element)
//            }
//        }
//        #endif
    }
    
    private func process(elements: ContiguousArray<Element>) {
        
        (document.documentElement as? HTMLHtmlElement)?.acceptSingle(self)
        document.body.acceptSingle(self)
        
//        #if DEBUG
        for element in elements {

            guard let htmlElment = element as? HTMLElement else {
                assertionFailure("Error: element is not HTMLElement")
                return
            }

            if !(htmlElment is HTMLBodyElement) && !(htmlElment is HTMLHtmlElement) {
                htmlElment.accept(self)
                addRendererTopElement(element)
            }
        }
//        #else
//        DispatchQueue.concurrentPerform(iterations: elements.count) { (index) in
//            let element = elements[index]
//
//            guard let htmlElment = element as? HTMLElement else {
//                assertionFailure("Error: element is not HTMLElement")
//                return
//            }
//
//            if !(htmlElment is HTMLBodyElement) && !(htmlElment is HTMLHtmlElement) {
//                htmlElment.accept(self)
//                addRendererTopElement(element)
//            }
//        }
//        #endif
    }
    
    private func buildRenderingProcessingResult() -> RenderingProcessingResult {
        
        #if DEBUG
        var result = RenderingProcessingResult(documentAttributes: self.contentString.documentAttributes, addedAttributes: self.addedAttributes, setAttributes: self.setAttributes, deletedAttributes: self.deletedAttributes, renderedTopElements: self.renderedTopElements, focusType: self.focusType)
        
        result.targetString = contentString.string
        assert(result.targetString != nil)
        
        // this is true before we synchronize the attributes changes
        // with the pending
        for addedAttributesRange in addedAttributes {
            
            let attributes = addedAttributesRange.attributes
            let range = addedAttributesRange.range
            
            if let headerLevelValue = attributes[StyloAttribute.headingTagBefore.key] as? NSNumber {
                
                let attributedStringChangeRecorder = contentString as! AttributedStringChangeRecorder
                
                let attributedString = attributedStringChangeRecorder.attributedString
                
                let headerString = attributedString.attributedSubstring(from: NSMakeRange(range.location, range.length-1)).string
                let expectedHeaderString = "######".slice(0, end: headerLevelValue.intValue)!
                
                assert(headerString == expectedHeaderString, "expected: \"\(expectedHeaderString)\", received: \"\(headerString)\"")
                assert(attributedString.attributedSubstring(from: NSMakeRange(range.location+headerLevelValue.intValue, 1)).string == " ")
                
            }
        }
        return result
        #else
        return RenderingProcessingResult(documentAttributes: self.contentString.documentAttributes, addedAttributes: self.addedAttributes, setAttributes: self.setAttributes, deletedAttributes: self.deletedAttributes, renderedTopElements: self.renderedTopElements, focusType: self.focusType)
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Visitor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias NodeInfoType = RenderNodeInfo
    
    var parentStack: Stack<RenderNodeInfo>
    
    func pop() {
        // nothing to do
    }
    
    func push(_ nodeInfo: RenderNodeInfo) {
        // nothing to do
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlDomVisitor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @discardableResult
    func visit(_ node: HtmlDocument) -> RenderNodeInfo? {
        
        return nil
    }
    
    @discardableResult
    func visit(_ node: HTMLHtmlElement) -> RenderNodeInfo? {
        
        //        paintDocumentElement(element: node)
        return RenderNodeInfo(node: nil, visitChildren: true)
    }
    
    @discardableResult
    func visit(_ node: HTMLBodyElement) -> RenderNodeInfo? {
        
        self.filterContext.updatePseudoClassesOptions(forElement: node, with: self.filterContext.highlightPseudoOptions)
        self.filterContext.updatePseudoClassesOptions(forElement: self.document.documentElement, with: [])
        
        self.paintDocumentElement(element: node)
        
        if renderingType == .complete {
            self.paintParagraphStyle(from: node)
        }
        
        self.paintTextElement(element: node)
        return RenderNodeInfo(node: nil, visitChildren: true)
    }
    
    @discardableResult
    func visit(_ node: HTMLHeadElement) -> RenderNodeInfo? {
        
        return RenderNodeInfo(node: nil, visitChildren: true)
    }
    
    @discardableResult
    func visit(_ node: HTMLTitleElement) -> RenderNodeInfo? {
        
        return nil
    }
    
    @discardableResult
    func visit(_ node: HTMLStyleElement) -> RenderNodeInfo? {
        
        return nil
    }
    
    @discardableResult
    func visit(_ node: MarkdownElement) -> RenderNodeInfo? {
        
        return paint(node: node, withFocusOptions: self.focusOptions(forElement: node))
    }
    
    func visit(_ node: HTMLParagraphElement) -> RenderNodeInfo? {
        
        assertionFailure("Error: should not pass here.")
        paintTextElement(element: node)
        return RenderNodeInfo(node: nil, visitChildren: true)
    }
    
    @discardableResult
    func visit(_ node: HTMLElement) -> RenderNodeInfo? {
        
        return paint(node: node, withFocusOptions: self.focusOptions(forElement: node))
    }
    
    @discardableResult
    func visit(_ node: HTMLPreElement) -> RenderNodeInfo? {
        
        // we do not paint PreElement
        return RenderNodeInfo(node: nil, visitChildren: true)
    }
    
    /// we do nothing whe visiting the Text node since it is not the element
    /// that contains the source string segment value.
    @discardableResult
    func visit(_ node: Text) -> RenderNodeInfo? {
        
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    private var elementsPseudoClassesOptions: [Element: PseudoClassesOptions] = [:]
    
    private func paint(node: HTMLElement, withFocusOptions focusOptions: PseudoClassesOptions?) -> RenderNodeInfo? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("paint(node: %@)", log: Log.WriterCommon.all, type: .info, %%node.localName)
        #endif

        if let pseudoOptions = self.pseudoOptions(forElement: node, withFocusOptions: focusOptions) {
            if !pseudoOptions.isEmpty {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("pseudoOptions: %@)", log: Log.WriterCommon.all, type: .info, %%pseudoOptions)
                os_log("self.focusedRange: %@)", log: Log.WriterCommon.all, type: .info, %%self.temporaryAttributedRange)
                #endif
                
                self.filterContext.updatePseudoClassesOptions(forElement: node, with: pseudoOptions)
            }
        }
        paintTextElement(element: node)
        
        if let headingElement = node as? HTMLHeadingElement {
            assignBeforeHeadingTagAttributes(to: headingElement)
        }
        return RenderNodeInfo(node: node, visitChildren: true)
    }
    
    /// ephemeralOptions is responsible for merging the focus attributes
    /// with the filterContext ones.
    private func pseudoOptions(forElement element: Element, withFocusOptions focusOptions: PseudoClassesOptions?) -> PseudoClassesOptions? {
        
        let filterContextEphemeralOptions = filterContext.highlightPseudoOptions
        
        if !filterContextEphemeralOptions.isEmpty  {
            assert(filterContextEphemeralOptions.contains(.highlight))
            if self.filterContext.isElementHighlighted(element) {
                if let focusOptions = focusOptions {
                    return focusOptions.union(filterContextEphemeralOptions)
                }
                else {
                    return filterContextEphemeralOptions
                }
            }
            else {
                
                if var focusOptions = focusOptions {
                
                    // if we are not highlighted we can not be flashed
                    focusOptions.remove(.flash)
                    
                    if !focusOptions.isEmpty {
                        return focusOptions
                    }
                    else {
                        return .fade
                    }
                }
                else {
                    return .fade
                }
            }
        }
        return focusOptions
    }
    
    private func focusOptions(forElement element: HTMLElement) -> PseudoClassesOptions? {
        
        if let focusType = self.renderingContext.focusType {
            
            guard let parentElement = element.parentElement else {
                assertionFailure("Error: parentElement is nil")
                return nil
            }
            
            let parentFocusedRange = self.filterContext.focusedRange(forElement: parentElement)
            
            if let (options, range) = self.focusOptions(forElement: element, focusType: focusType) {
                
                switch focusType {
                case .bloc:
                    self.filterContext.updateFocusedRange(forElement: element, with: range)
                case .paragraph:
                    
                    // focused range is only defined by the parent element
                    // Note: we do this because we dont want e.g. a "strong" element
                    // to reset the focused ranged. Since, rendering goes top down
                    // the parent element will be the only one to set the focusedRange
                    // value.
                    if let parentFocusedRange = parentFocusedRange {
                        self.filterContext.updateFocusedRange(forElement: element, with: parentFocusedRange)
                    }
                    else {
                        self.filterContext.updateFocusedRange(forElement: element, with: range)
                    }
                    
                case .sentence:
                    
                    // focused range is only defined by the parent element
                    // Note: we do this because we dont want e.g. a "strong" element
                    // to reset the focused ranged. Since, rendering goes top down
                    // the parent element will be the only one to set the focusedRange
                    // value.
                    if let parentFocusedRange = parentFocusedRange {
                        switch element {
                        case is HTMLImageElement:
                            let length = range?.length ?? 0
                            if length >= parentFocusedRange.length {
                                self.filterContext.updateFocusedRange(forElement: element, with: range)
                            }
                            else {
                                self.filterContext.updateFocusedRange(forElement: element, with: parentFocusedRange)
                            }
                        case is HTMLParagraphElement:
                            // paragraph is always the range determining element in case
                            // of sentence focus mode
                            self.filterContext.updateFocusedRange(forElement: element, with: range)
                        default:
                            self.filterContext.updateFocusedRange(forElement: element, with: parentFocusedRange)
                        }
                    }
                    else {
                        self.filterContext.updateFocusedRange(forElement: element, with: range)
                    }
                    
                case .flash:

                    self.filterContext.updateFocusedRange(forElement: element, with: range)
                }
                
                return options
            }
            else if let parentFocusedRange = parentFocusedRange, let range = element.range, parentFocusedRange.lowerBound <= range.lowerBound && range.upperBound <= parentFocusedRange.upperBound {
                
                // we forward the parent focused range to make childs of this child
                // know about it.
                self.filterContext.updateFocusedRange(forElement: element, with: parentFocusedRange)
                return self.filterContext.pseudoClassesOptions(forElement: parentElement).ephemerals
            }
            else {
                switch focusType {
                case .bloc: fallthrough
                case .paragraph: fallthrough
                case .sentence:
                    return self.filterContext.defaultPseudoClassesOptions(forElement: element)
                case .flash:
                    return nil
                }
            }
        }

        return nil
    }
    
    private func focusOptions(forElement node: HTMLElement, focusType: FocusType?) -> (options: PseudoClassesOptions, range: NSRange?)? {
        
        guard let focusType = focusType else {
            return nil
        }
        
        switch focusType {
        case .flash(let flashedRange):
            if let flashedRange = flashedRange {
                if node.isContained(in: flashedRange) {
                    return (.flash, nil)
                }
            }
        case .bloc:
            
            guard let editedRange = self.editedRange else {
                return nil
            }
            
            // if the editor is not the first responder we dont want to
            // put the focus.
            if let isFirstResponder = self.isFirstResponder, isFirstResponder {
            
                guard let parentElement = node.parentElement else {
                    assertionFailure("Error: parentElement is nil")
                    return nil
                }
                
                let parentElementOptions = self.filterContext.pseudoClassesOptions(forElement: parentElement)
                
                if parentElementOptions.contains(.focus) {
                    return (.focus, nil)
                }
                else {
                    return node.focusEphemeralOptions(from: editedRange, focusType: focusType, inString: self.contentString.string)
                }
            }
            return nil
            
        case .paragraph:
            
            switch self.renderingType {
            case .complete: fallthrough
            case .edit: fallthrough
            case .selection:
                
                var inheritedOptions: (options: PseudoClassesOptions, range: NSRange?)? {
                    
                    guard let parentElement = node.parentElement else {
                        assertionFailure("Error: parentElement is nil")
                        return nil
                    }
                    
                    let parentElementOptions = self.filterContext.pseudoClassesOptions(forElement: parentElement)
                    
                    if parentElementOptions.contains(.focus) {
                        return (.focus, nil)
                    }
                    else {

                        return node.focusEphemeralOptions(from: editedRange, focusType: focusType, inString: self.contentString.string)
                    }
                }
                
                guard let editedRange = self.editedRange else {
                    return nil
                }
                
                // if the editor is not the first responder we dont want to
                // put the focus.
                if let isFirstResponder = self.isFirstResponder, isFirstResponder {
                    
                    switch node {
                    case let code as HTMLCodeElement:
                        if code.isInline {
                            return inheritedOptions
                        }
                        else {
                            return node.focusEphemeralOptions(from: editedRange, focusType: focusType, inString: self.contentString.string)
                        }
                    case is HTMLParagraphElement: fallthrough
                    case is HTMLLIElement: fallthrough
                    case is HTMLPreElement: fallthrough
                    case is HTMLHeadingElement:
                        return node.focusEphemeralOptions(from: editedRange, focusType: focusType, inString: self.contentString.string)
                    default:
                        return inheritedOptions
                    }
                }
                return nil
                
            case .flash:
                // we are clearing the attributes
                break
            }
            
        case .sentence:
        
            switch self.renderingType {
            case .complete: fallthrough
            case .edit: fallthrough
            case .selection:
                
                guard let editedRange = self.editedRange else {
                    return nil
                }
                
                // if the editor is not the first responder we dont want to
                // put the focus.
                if let isFirstResponder = self.isFirstResponder, isFirstResponder {
                    return node.focusEphemeralOptions(from: editedRange, focusType: focusType, inString: self.contentString.string)
                }
                return nil
                
            case .flash:
                // we are clearing the attributes
                break
            }
        }
        return nil
    }
    
    
    private func removeBeforeHeadingTagAttributes(fromDeletedElement element: HTMLElement) {
        
        guard let stringRange = self.stringChange else {
            assertionFailure("Error: self.stringChange is nil")
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("removeBeforeHeadingTagAttributes(to: %@)", log: Log.WriterCommon.all, type: .info, %%element)
        #endif
        
        if let range = element.sourceStringFragment?.range {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("removeBeforeHeadingTagAttributes -> extendedRange: %@", log: Log.WriterCommon.all, type: .info, %%range)
            os_log("removeBeforeHeadingTagAttributes -> contentString: %@", log: Log.WriterCommon.all, type: .info, %%contentString.permanentAttributesString)
            #endif
            
            if let updatedRanges = range.update(with: stringRange) {
                
                // we can keep only the first one
                guard let updatedRange = updatedRanges.first else {
                    assertionFailure("Error: updatedRanges is not nil, why would its first range...")
                    return
                }
                
                let lineRange = contentString.lineRange(for: updatedRange)
                
                contentString.removeAttribute(StyloAttribute.headingTagBefore.key, range: lineRange)
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("removeBeforeHeadingTagAttributes -> removed attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%StyloAttribute.headingTagBefore.key, %%lineRange)
                #endif
                
                deletedAttributes.append(AttributesRange([StyloAttribute.headingTagBefore.key: false], lineRange, element.localName))
            }
        }
    }
    
    private func assignBeforeHeadingTagAttributes(to headingElement: HTMLHeadingElement) {
        
        guard let beforeTagSegment = headingElement.beforeTagSegment else {return}
        guard let range = beforeTagSegment.range else {return}
        guard let level = headingElement.level else {return}
        
        #if DEBUG
        if let headerTagString = self.contentString.substring(from: range) {
            assert(headerTagString == "######".slice(0, end: level)!)
        }
        #endif
        
        let levelValue = NSNumber(integerLiteral: level)
        
        var effectiveRange = NSMakeRange(0, 0)
        let attributeValue = contentString.attribute(StyloAttribute.headingTagBefore.key, at: range.location, effectiveRange: &effectiveRange)
        
        if attributeValue == nil {
            
            let totalRange = self.totalRange(fromElement: headingElement, range: range, extendSpacesBefore: false, extendSpacesAfter: true, spacesCountAfter: 1)
            updateDifferentRange(attributes: [StyloAttribute.headingTagBefore.key : levelValue], in: totalRange, from: headingElement, updateType: .add)
        }
        else if let attributeValue = attributeValue as? NSNumber {
            
            if attributeValue.intValue != level || effectiveRange.upperBound != range.upperBound+1 {
                
                let totalRange = self.totalRange(fromElement: headingElement, range: range, extendSpacesBefore: false, extendSpacesAfter: true, spacesCountAfter: 1)
                
                updateDifferentRange(attributes: [StyloAttribute.headingTagBefore.key : levelValue], in: totalRange, from: headingElement, updateType: .add)
            }
        }
    }
    
    /// The stylesheet element only paint the font to the entire string.
    private func paintParagraphStyle(from element: Element) {
        
        if let paragraphStyle = self.paragraphStyle {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("paintParagraphStyle() -> paragraphStyle: %@", log: Log.WriterCommon.all, type: .info, %%paragraphStyle)
            #endif
            
            #if false
            if let attributesRecorder = contentString as? AttributedStringChangeRecorder {
                os_log("string attributes before: %@", log: Log.WriterCommon.all, type: .info, %%attributesRecorder.debugAttributesString)
            }
            #endif
            
            // just making sure
            assert(!paragraphStyle.isEmpty)
            if !paragraphStyle.isEmpty {
                
                var paragraphStyle = paragraphStyle
                paragraphStyle[NSAttributedString.Key.paragraphStyle] = NSMutableParagraphStyle.default
                self.update(attributes: paragraphStyle, in: self.contentString.completeRange, from: element, updateType: .set)
                self.contentString.setDocumentFont(fromAttributes: paragraphStyle)
            }
            
            #if false
            if let attributesRecorder = contentString as? AttributedStringChangeRecorder {
                os_log("string attributes after: %@", log: Log.WriterCommon.all, type: .info, %%attributesRecorder.debugAttributesString)
            }
            #endif
        }
    }
    
    
    
}
