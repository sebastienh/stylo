//
//  HTMLQuoteElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//
//interface HTMLQuoteElement : HTMLElement {
//    attribute DOMString cite;
//};

///
/// "The blockquote element represents content that is quoted from another source, 
/// optionally with a citation which must be within a footer or cite element, and 
/// optionally with in-line changes such as annotations and abbreviations."
///
/// see http://www.w3.org/TR/html5/grouping-content.html#the-blockquote-element
public final class HTMLQuoteElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    //    attribute DOMString cite;
    var cite: DOMString
    
    public init(document: Document? = nil) {
        
        self.cite = ""
        
        super.init(document: document, localName: "blockquote")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLQuoteElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLQuoteElement {
        
        return super.cloneNode(deep) as! HTMLQuoteElement
    }
    
    ///
    override public func createInstance() -> HTMLQuoteElement {
        
        return HTMLQuoteElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLQuoteElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        copy.cite = self.cite
    }
    
    ///
    /// In quote we only focus on the sentence if and only if the cursor
    /// is in the paragraph.
    /// stylo #1006
    public override func whitespacesExtendedIntersectionRange(_ range: NSRange, inString string: String) -> NSRange? {

        if self.intersectsRange(range) {
        
            guard let intersectingRange = self.intersectingRange(withRange: range) else {
                assertionFailure("Error: intersectingRange is nil")
                return nil
            }
            
            for child in self.children.elements {

                guard let paragraph = child as? HTMLParagraphElement else {
                    continue
                }

                if let _ = paragraph.whitespacesExtendedIntersectionRange(range, inString: string) {
                    
                    return string.extendsWithLastSpaces(intersectingRange)
                }
            }
        }
        return nil
    }
    
    private func intersectingRange(withRange range: NSRange) -> NSRange? {
        
        guard let quoteRegion = self.sourceStringFragment as? SourceStringRegion else {
            assertionFailure("Error: quoteRegion is nil")
            return nil
        }
        
        for sourceStringSegment in quoteRegion.sourceStringSegments {
            
            guard let segmentRange = sourceStringSegment.range else {
                assertionFailure("Error: segmentRange is nil")
                continue
            }
            
            if segmentRange.location <= range.location {
                if range.upperBound <= segmentRange.upperBound {
                    return segmentRange
                }
            }
        }
        return nil
    }
    
}
