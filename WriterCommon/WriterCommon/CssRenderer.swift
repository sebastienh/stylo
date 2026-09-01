//
//  CssRenderer.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-06-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import os

class CssRenderer: SerialRenderer, Visitor, CSSDOMVisitor {
    
    var deletedNodes: ContiguousArray<Node>?
    
    let resourceComputedStyle: ResourceComputedStyle
    
    /// This variable is used if the element is the element responsible
    /// for setting the document attributes. In the HTML case it is the "body"
    /// element and in the CSS case it is the "stylesheet" element.
    var documentAttributes: [NSAttributedString.Key : Any]? {
        
        didSet {
            if let documentBackgroundColor = self.documentAttributes?[NSAttributedString.Key.backgroundColor] as? PlateformColorType  {
                self.documentBackgroundColor = documentBackgroundColor
            }
        }
    }
    
    var documentBackgroundColor: PlateformColorType?
    
    var documentCaretColor: PlateformColorType?
    
    var contentString: StylableString {
        return renderingContext.contentString
    }
    
    let document: CSSDOMDocument
    
    private var addedAttributes: [AttributesRange]
    
    private var setAttributes: [AttributesRange]
    
    private var deletedAttributes: [AttributesRange]
    
    var focusType: FocusType?
    
    let renderingContext: RenderingContext
    
    var filterContext: FilterContext
    
    var renderedTopElements: ContiguousArray<Element>?
    
    var flashedElements: ContiguousArray<Element>?
    
    var defaultEphemeralOptions: PseudoClassesOptions = .empty
    
    private let lock = NSLock()
    
    init(resourceComputedStyle: ResourceComputedStyle, renderingContext: RenderingContext,  document: CSSDOMDocument) {
        
        self.resourceComputedStyle = resourceComputedStyle
        self.parentStack = Stack<RenderNodeInfo>()
        self.renderingContext = renderingContext
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
        lock.withCriticalSection {
            self.deletedAttributes.append(attributesRange)
        }
    }
    
    func addSetAttributesRange(_ attributesRange: AttributesRange) {
        lock.withCriticalSection {
            self.setAttributes.append(attributesRange)
        }
    }
    
    func addAddedAttributesRange(_ attributesRange: AttributesRange) {
        lock.withCriticalSection {
            self.addedAttributes.append(attributesRange)
        }
    }
    
//    let textDecorationAttributesRecorder: NSMutableAttributedString
    
    /// This is the method to call from outside to create a render tree
    /// from the top of a Document using a ResourceComputedStyle
    func process(_ document: Document) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("DOMRender process(...)", log: Log.WriterCommon.all, type: .info)
        #endif
        
        let visitableDocumentElement = document.rootDocumentElement as? CSSDOMVisitable
        
        assert(visitableDocumentElement != nil)
        if let visitableDocumentElement = visitableDocumentElement {
            visitableDocumentElement.accept(self)
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("End DOMRender process(...)", log: Log.WriterCommon.all, type: .info)
        #endif
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
        
        self.document.styleSheet.acceptSingle(self)
        
        
        // simulate the "children" iteration normally done in the accept method.
        for node in elements {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("rendering element: %@ with sourceStringSegment: %@", log: Log.WriterCommon.all, type: .info, %%node.localName, %%String(describing: node.sourceStringSegment))
            #endif
            
            // FIXME: this visitor should be generalised
            let visitableElement = node as? CSSDOMVisitable
            
            assert(visitableElement != nil)
            if let visitableElement = visitableElement {
                visitableElement.accept(self)
            }
        }
        
        #if false
        if let attributesRecorder = contentString as? AttributedStringChangeRecorder {
            os_log("string attributes after: %@", log: Log.WriterCommon.all, type: .info, %%attributesRecorder.debugAttributesString)
        }
        #endif
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Affected ranges: ", log: Log.WriterCommon.all, type: .info)
        for addedAttributes in self.addedAttributes {
            os_log("..affected range: %@ with attributes: %@", log: Log.WriterCommon.all, type: .info, %%NSStringFromRange(addedAttributes.range), %%addedAttributes.attributes)
        }
        #endif
        
        assert(contentString.documentAttributes != nil)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("End DOMRender process(...)", log: Log.WriterCommon.all, type: .info)
        #endif
        
        return RenderingProcessingResult(documentAttributes: self.contentString.documentAttributes, addedAttributes:  self.addedAttributes, setAttributes: self.setAttributes, deletedAttributes: self.deletedAttributes, renderedTopElements: self.renderedTopElements, focusType: self.focusType)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSDOMVisitor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @discardableResult
    func visit(_ node: CSSDOMDocument) -> RenderNodeInfo? {
        
        // nothing to do
        return nil
    }
    
    @discardableResult
    func visit(_ node: CSSDOMElement) -> RenderNodeInfo? {
        
        //        if node.localName == §CSSElementType.StyleRule {
        //            paintBlock(element: node)
        //        }
//        paintBlock(element: node)
        return RenderNodeInfo(node: nil, visitChildren: true)
    }
    
    @discardableResult
    func visit(_ node: CSSDOMStyleSheetElement) -> RenderNodeInfo? {
        
        paintDocumentElement(element: node)
        
        // in the case of css we apply the font attributes at the style-sheet level
        // to avoid spaces being not well managed.
        if self.renderingType == .complete {
            paintCssStylesheetElement(stylesheetElement: node)
        }
        
        assert(documentAttributes != nil)
        return RenderNodeInfo(node: nil, visitChildren: true)
    }
    
    @discardableResult
    func visit(_ node: CSSDOMTokenElement) -> RenderNodeInfo? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("contentString length: %d", log: Log.WriterCommon.all, type: .info, contentString.length)
        os_log("rendering token element: %@ with sourceStringSegment: %@", log: Log.WriterCommon.all, type: .info, %%node.localName, %%String(describing: node.sourceStringSegment))
        #endif
        
        var exclusionRanges = [NSRange]()
        paintTextElement(element: node, updateType: .add, exclusionRanges: &exclusionRanges)
        return RenderNodeInfo(node: nil, visitChildren: true)
    }
    
    @discardableResult
    func visit(_ node: Element) -> RenderNodeInfo? {
        
//        paintTextElement(element: node)
        return RenderNodeInfo(node: nil, visitChildren: true)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Visitor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func paintPseudoElements(element: Element, updateType: PaintingUpdateType = .add, exclusionRanges: inout [NSRange]) {
        
        // do nothing
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Visitor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias NodeInfoType = RenderNodeInfo
    
    var parentStack: Stack<RenderNodeInfo>
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// The stylesheet element only paint the font to the entire string.
    private func paintCssStylesheetElement(stylesheetElement: CSSDOMStyleSheetElement) {
        
        if let computedStyle = resourceComputedStyle.computedStyle(forElement:stylesheetElement) {
            
            let textAttributes = TextStylizer.shared.textStyle(from: computedStyle, element: stylesheetElement)
            
            #if false
            if let attributesRecorder = contentString as? AttributedStringChangeRecorder {
                os_log("string attributes before: %@", log: Log.WriterCommon.all, type: .info, %%attributesRecorder.debugAttributesString)
            }
            #endif
            
            // just making sure
            if let textAttributes = textAttributes, textAttributes.count > 0 {
                
                let fontValue = textAttributes[NSAttributedString.Key.font] as? NSFont
                
                assert(fontValue != nil)
                if let fontValue = fontValue, let paragraphStyle = self.paragraphStyle(using: fontValue) {
                    
                    contentString.setGlobalAttributes(
                        [NSAttributedString.Key.font: fontValue, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                }
            }
            
            #if false
            if let attributesRecorder = contentString as? AttributedStringChangeRecorder {
                os_log("string attributes after: %@", log: Log.WriterCommon.all, type: .info, %%attributesRecorder.debugAttributesString)
            }
            #endif
        }
    }
    
    private func paragraphStyle(using font: NSFont) -> NSParagraphStyle? {
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let screenFont = font.screenFont(with: NSFontRenderingMode.defaultRenderingMode)
        let charWidth = screenFont.advancement(forGlyph: NSGlyph(" ")).width
        paragraphStyle.defaultTabInterval = charWidth*4
        paragraphStyle.tabStops = []
        return paragraphStyle
    }
    
}
