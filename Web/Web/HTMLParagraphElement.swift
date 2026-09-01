//
//  HTMLParagraphElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common 

///
/// "The p element represents a paragraph."
/// see http://www.w3.org/TR/html5/grouping-content.html#the-p-element
///
public final class HTMLParagraphElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "p")
    }
    
    override func resolveFirstLetterSourceStringSegment(in string: String) -> (SourceStringSegment, Element)? {
        
        if let sourceStringSegment = firstLetterSourceStringSegment(in: string) {
            return (sourceStringSegment, self)
        }
        return nil
    }
    
    override func resolveFirstLineSourceStringSegment(in string: String) -> (SourceStringSegment, Element)? {

        if let sourceStringSegment = firstLineSourceStringSegment(in: string) {
            return (sourceStringSegment, self)
        }
        return nil
    }

    ///
    /// In paragraph we only focus on the sentence if and only if the cursor
    /// is in the paragraph.
    /// stylo #1006
    public override func whitespacesExtendedIntersectionRange(_ range: NSRange, inString string: String) -> NSRange? {
        
        guard let intersectingRange = self.intersectingRange(withRange: range, inString: string) else {
            return nil
        }
        
        // remove the last line feeds from the range
        var finalLineFeedsTrimmedRange = intersectingRange
        
        while let lastChar = string.charAt(finalLineFeedsTrimmedRange.upperBound-1), lastChar == §UnicodeCharacter.lineFeed {
            finalLineFeedsTrimmedRange = NSMakeRange(finalLineFeedsTrimmedRange.location, finalLineFeedsTrimmedRange.length-1)
        }
        
        if finalLineFeedsTrimmedRange.lowerBound <= range.lowerBound {
            
            let whitespacesExtendedElementRange = string.extendsWithLastSpaces(finalLineFeedsTrimmedRange)
            
            if range.upperBound == whitespacesExtendedElementRange.upperBound, range.upperBound > 0 {
                // if the last charactet is a line feed we are technically outside the element
                if let lastChar = string.charAt(range.upperBound-1), lastChar == §UnicodeCharacter.lineFeed {
                    return nil
                }
                return whitespacesExtendedElementRange
            }
            else if range.upperBound <= whitespacesExtendedElementRange.upperBound {
                return whitespacesExtendedElementRange
            }
        }
        return nil
    }
    
    private func intersectingRange(withRange range: NSRange, inString string: String) -> NSRange? {
        
        guard let paragraphRegion = self.sourceStringFragment as? SourceStringRegion else {
            assertionFailure("Error: paragraphRegion is nil")
            return nil
        }
        
        for (index, sourceStringSegment) in paragraphRegion.sourceStringSegments.enumerated() {
            
            guard var segmentRange = sourceStringSegment.range else {
                assertionFailure("Error: segmentRange is nil")
                continue
            }
            
            // we extend the last segment to include all spaces before the new line
            if index == paragraphRegion.sourceStringSegments.count-1 {
                segmentRange = string.extendsWithLastSpaces(segmentRange)
            }
            
            if segmentRange.location <= range.location {
                if range.upperBound <= segmentRange.upperBound {
                    return segmentRange
                }
            }
        }
        return nil
    }
    
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLParagraphElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLParagraphElement {
        
        return super.cloneNode(deep) as! HTMLParagraphElement
    }
    
    ///
    override public func createInstance() -> HTMLParagraphElement {
        
        return HTMLParagraphElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLParagraphElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
