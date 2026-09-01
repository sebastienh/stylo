//
//  RenderObject.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-02.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web
import os

/// Note: The renderObject is dependant on the style
/// since the pseudo elements are style specific.
class RenderObject : TreeNode, RenderTreeVisitable {
    
    // we dont want the RenderObject to retain the element if it is deleted from
    // the DOM Document... We can not use unowned since we want to control the way
    // the RenderObject is released.
    weak var element: Element?
    
    /// This variable is used if the element is the element responsible
    /// for setting the document attributes. In the HTML case it is the "body"
    /// element and in the CSS case it is the "stylesheet" element.
    var documentAttributes: [NSAttributedString.Key : Any]?
    
    /// Reference to the parent ResourceStyleRenderTree.
    unowned let parentResourceStyleRenderTree: ResourceStyleRenderTree
    
    /// Specify if the element is for documentAttributes.
    var documentAttributesElement: Bool = false

    
    /// Most basic constructor with only a reference to the
    /// parentResourceStyleRenderTree.
    convenience init(parentResourceStyleRenderTree: ResourceStyleRenderTree) {
        
        self.init(element: nil, parentResourceStyleRenderTree: parentResourceStyleRenderTree)
    }
    
    /// RenderObject constructor.
    /// A RenderObject is the junction between an element, the element computed style (RenderStyle) and
    /// A ResourceStyleRenderTree which points to the RenderTree and the resource to be styled.
    init(element: Element?, parentResourceStyleRenderTree: ResourceStyleRenderTree) {
        
        self.element = element
        self.parentResourceStyleRenderTree = parentResourceStyleRenderTree
        
        super.init()
    }
    
    /// Add an entry in the list of impacted elements by pseudo-elements ranges.
    func recordElementExclusionRange(for element: Element, range: NSRange) {
        
//        if parentResourceStyleRenderTree.elementsImpactedByPseudoElements.index(forKey: element) == nil {
//            
//            self.parentResourceStyleRenderTree.elementsImpactedByPseudoElements[element] = [NSRange]()
//        }
//        
//        self.parentResourceStyleRenderTree.elementsImpactedByPseudoElements[element]!.append(range)
    }
    
    func hasExclusionRanges(element: Element?) -> Bool {
        
//        if let element = element, let _ = parentResourceStyleRenderTree.elementsImpactedByPseudoElements.index(forKey: element) {
//
//            return true
//        }
//
        return false
    }
    
    func rangesMinusImpactedRange(for element: Element, range: NSRange) -> [NSRange] {
        
//        let pseudoRanges = parentResourceStyleRenderTree.elementsImpactedByPseudoElements[element]!
//
//        return range.substractsRanges(pseudoRanges)
        fatalError("missing implementation")
    }
    
    func paint(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        paintPseudoElements(element: self.element , contentString: contentString, resourceComputedStyle: resourceComputedStyle)
    }
    
    func paintTemporary(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        paintTemporaryPseudoElements()
    }
    
    func removeChild(_ child: RenderObject) {
        
        super.removeChild(child)
    }
    
    func apply(attributes: [NSAttributedString.Key : Any]?, to range: NSRange, contentString: StylableString) {
        
        //        printDebugInfo(element: element!, textAttributes: textAttributes, range: range)
        
        // http://stackoverflow.com/questions/25007289/swift-editing-uitextview-from-inside-callback-crashes-app
        if contentString.isValidRange(range) {
            contentString.addAttributes(attributes, range: range)
        }
    }
    
    func printDebugInfo(element: Element, textAttributes: [NSAttributedString.Key : AnyObject]?, range: NSRange, contentString: StylableString) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("RenderText paint().", log: Log.WriterCommon.all, type: .info)
        os_log("Painting range %@.", log: Log.WriterCommon.all, type: .debug, %%NSStringFromRange(range))
        os_log("Setting attributes for element: %@", log: Log.WriterCommon.all, type: .info, %%element.localName)
        os_log("Setting attributes on string: %@", log: Log.WriterCommon.all, type: .info, %%contentString)
        os_log("Element is: %@", log: Log.WriterCommon.all, type: .info, %%element.localName)
        os_log("Attributes applied to range: %@", log: Log.WriterCommon.all, type: .info, %%NSStringFromRange(range))
        #endif
        
        if let textAttributes = textAttributes {
            
            for (name, value) in textAttributes {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Applying attribute: %@ with value: %@", log: Log.WriterCommon.all, type: .info, %%name, %%value)
                #endif
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Document attributes parsing implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func layoutDocumentAttributes(resourceComputedStyle: ResourceComputedStyle) {
        
        if let element = element, let computedStyle = resourceComputedStyle.computedStyleForElement(element) {
            
            let textStylizer = TextStylizer.shared
            documentAttributes = textStylizer.textStyle(from: computedStyle, element: element)
            
            if documentAttributes == nil {
                
                 documentAttributes = textStylizer.textStyle(from: computedStyle, element: element)
            }
            
            assert(documentAttributes != nil)
        }
        else {
            
            debugPrint("Dealocated element : no layout performed.")
        }
    }
    
    func paintDocumentAttributes(contentString: StylableString) {
        
        // just making sure
        if let _ = element, let documentAttributes = documentAttributes, documentAttributes.count > 0 {
            
            contentString.documentAttributes = DocumentAttributes(attrs: documentAttributes)
        }
        else {
            
            debugPrint("Didn't assigned any document attributes")
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: RenderTreeVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    func accept<Visitor: RenderTreeVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        fatalError("Missing subl")
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate func updateRenderStyle() {
        
        // nothing to do
    }

    fileprivate func paintPseudoElements(element: Element?, contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
//        if let element = element {
//            
//            if let pseudoElements = resourceComputedStyle.pseudoElements(for: element) {
//                
//                for pseudoElement in pseudoElements {
//                
//                    let ran = pseudoElement.resolveRange(for: contentString.string, withElement: element)
//                    let pseudoElementComputedStyle = resourceComputedStyle.computedStyleForElement(pseudoElement)
//                    let textStylizer = TextStylizer.shared
//                    let textAttributes = textStylizer.textStyle(from: pseudoElementComputedStyle, element: pseudoElement)
//                    
//                    if let textAttributes = textAttributes, textAttributes.count > 0 {
//                        
//                        let pseudoRanges = computeRanges(for: pseudoElement)
//                        
//                        if let pseudoRanges = pseudoRanges, pseudoRanges.count > 0 {
//                            
//                            for range in pseudoRanges {
//                                
//                                if hasExclusionRanges(element: element) {
//                                
//                                    let elementSpecificRanges = rangesMinusImpactedRange(for: impactedElement!, range: range)
//                                
//                                    for elementSpecificRange in elementSpecificRanges {
//                                    
//                                        apply(attributes: textAttributes, to: elementSpecificRange, contentString: contentString)
//                                        if let impactedElement = impactedElement {
//                                            recordElementExclusionRange(for: impactedElement, range: elementSpecificRange)
//                                        }
//                                    }
//                                }
//                                else {
//                                    
//                                    apply(attributes: textAttributes, to: range, contentString: contentString)
//                                    if let impactedElement = impactedElement {
//                                        recordElementExclusionRange(for: element, range: range)
//                                    }
//                                }
//                                pseudoElement.sourceStringFragment = nil
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    
    fileprivate func paintTemporaryPseudoElements() {
        
        // nothgin to do
    }
    
    func computeRanges(for element: Element?) -> [NSRange]? {
        
        if let element = element {
            
            var _ranges = [NSRange]()
            
            if let sourceStringSegment = element.sourceStringFragment as? SourceStringSegment {
                
                let position = sourceStringSegment
                
                let range = position.range
                
                assert(range != nil)
                if let range = range {
                    
                    _ranges.append(range)
                }
            }
            else if let sourceStringRegion = element.sourceStringFragment as? SourceStringRegion {
                
                var _ranges = [NSRange]()
                
                for sourceStringSegment in sourceStringRegion.sourceStringSegments {
                    
                    let range = sourceStringSegment.range
                    
                    assert(range != nil)
                    if let range = range {
                        
                        _ranges.append(range)
                    }
                }
                
                return _ranges
            }
            
            return _ranges
        }
        return nil
    }
    
}
