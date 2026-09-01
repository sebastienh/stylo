//
//  HTMLLIElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLLIElement : HTMLElement {
//    attribute long value;
//};

///
/// "The li element represents a list item. If its parent element is an ol, or ul, 
/// then the element is an item of the parent element's list, as defined for those 
/// elements. Otherwise, the list item has no defined list-related relationship 
/// to any other li element."
///
/// see http://www.w3.org/TR/html5/grouping-content.html#the-li-element
///
public final class HTMLLIElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    //    attribute long value;
    var value: Int?
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "li")
    }
    
    public override func whitespacesExtendedIntersectionRange(_ range: NSRange, inString string: String) -> NSRange? {

        guard !shouldDelegateFocusHandlingToChild(inRange: range, inString: string) else {
            return nil
        }

        return super.whitespacesExtendedIntersectionRange(range, inString: string)
    }
    
    private func shouldDelegateFocusHandlingToChild(inRange range: NSRange, inString string: String) -> Bool {
        
        // if one of our descendant list or blockquote element contains the
        // range we let this element handle it.
        for child in self.children.elements {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("li child element type: %@ with text: %@", log: Log.WriterCommon.all, type: .info, %%child.localName, %%child.textValue)
            #endif
            
            if child is HTMLParagraphElement {
                continue
            }
               
            if child.localName == "strong"
                || child.localName == "em"
                || child.localName == "code"
                || child.localName == "a"
                || child.localName == "span" {
                continue
            }
            
            guard let childRange = child.range else {
                continue
            }
            
            if childRange.lowerBound <= range.lowerBound {
                let whitespacesExtendedElementRange = string.extendsWithLastSpaces(childRange)
                if range.upperBound <= whitespacesExtendedElementRange.upperBound {
                    return true
                }
            }
        }
        return false
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLLIElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLLIElement {
        
        return super.cloneNode(deep) as! HTMLLIElement
    }
    
    ///
    override public func createInstance() -> HTMLLIElement {
        
        return HTMLLIElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLLIElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        copy.value = self.value
    }
    
}
