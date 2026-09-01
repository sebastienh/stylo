//
//  HTMLOListElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLOListElement : HTMLElement {
//    attribute boolean reversed;
//    attribute long start;
//    attribute DOMString type;
//};

///
/// "The ol element represents a list of items, where the items have been intentionally ordered, 
/// such that changing the order would change the meaning of the document."
///
/// see http://www.w3.org/TR/html5/grouping-content.html#the-ol-element
///
public final class HTMLOListElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    ///
    /// "If present, it indicates that the list is a descending list (..., 3, 2, 1)."
    ///
    ///  attribute boolean reversed;
    ///
    var reversed: Bool
    
    ///
    /// "The start attribute, if present, must be a valid integer giving the ordinal 
    /// value of the first list item."
    ///
    /// attribute long start;
    /// 
    public var start: Int?
    
    //    attribute DOMString type;
    var type: DOMString
    
    public init(document: Document?) {
        
        self.reversed = false
        self.type = ""
        self.start = 1
        
        super.init(document: document, localName: "ol")
    }
    
    public override func whitespacesExtendedIntersectionRange(_ range: NSRange, inString string: String) -> NSRange? {

        for child in self.children.elements {

            guard let li = child as? HTMLLIElement else {
                continue
            }
            
            guard let liRange = li.range else {
                return nil
            }

            if liRange.lowerBound <= range.lowerBound {

                let whitespacesExtendedElementRange = string.extendsWithLastSpaces(liRange)

                if range.upperBound <= whitespacesExtendedElementRange.upperBound {
                    return whitespacesExtendedElementRange
                }
            }
        }
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLOListElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLOListElement {
        
        return super.cloneNode(deep) as! HTMLOListElement
    }
    
    ///
    override public func createInstance() -> HTMLOListElement {
        
        return HTMLOListElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLOListElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        copy.reversed = self.reversed
        copy.start = self.start
        copy.type = self.type
    }
}
