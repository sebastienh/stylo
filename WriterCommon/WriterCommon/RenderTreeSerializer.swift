//
//  RenderTreeSerializer.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-12-25.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

/// Loosely based on the HtmlSerializer
class RenderTreeSerializer {
    
    /// Singleton instance.
    static var shared = RenderTreeSerializer()
    
    fileprivate init() {
        
    }
    
    /// Serializing RenderTree node
    public func serializeRenderObject<T: RenderObject>(renderObject: T) -> String {
        
        return commonSerializeRenderObject(renderObject: renderObject)
    }
    
    fileprivate func commonSerializeRenderObject(renderObject: RenderObject) -> String {
        
        // 1. Let s be a string, and initialise it to the empty string.
        var s = ""
        
        //        s += serializeOpenTag(fromRenderObject: renderObject)
        
        // 3. For each child node of the node, in tree order, run the following steps:
        var child = renderObject.firstChild
        
        while let _child = child {
            
            // 1. Let current node be the child node being processed.
            let  currentRenderObject = _child as! RenderObject
            
            s += serializeOpenTag(fromRenderObject: currentRenderObject)
            
            // Append the value of running the HTML fragment serialization algorithm on the current
            // node element (thus recursing into this algorithm for that element), followed by a "<" (U+003C) character,
            // a U+002F SOLIDUS character (/), tagname again, and finally a U+003E GREATER-THAN SIGN character (>).
            s += commonSerializeRenderObject(renderObject: currentRenderObject)
            
            s += serializeCloseTag(fromRenderObject: currentRenderObject)
            
            child = _child.nextSibling
        }
        
        //        s += serializeCloseTag(fromRenderObject: renderObject)
        
        return s
    }
    
    fileprivate func serializeOpenTag(fromRenderObject renderObject: RenderObject) -> String {
        
        // 1. Let s be a string, and initialise it to the empty string.
        var s = "<"
        
        s += renderObjectText(fromRenderObject: renderObject)
        
        s += " "
        
        s += renderAssociatedElementLocalName(fromRenderObject: renderObject)
        
        s += ">"
        
        return s
        
    }
    
    fileprivate func renderAssociatedElementLocalName(fromRenderObject renderObject: RenderObject) -> String {
        
        if let element = renderObject.element {
            
            return "localName=\"\(element.localName)\""
        }
        
        return "localName=\"\nil\""
    }
    
    fileprivate func serializeCloseTag(fromRenderObject renderObject: RenderObject) -> String {
        
        // 1. Let s be a string, and initialise it to the empty string.
        var s = "</"
        
        s += renderObjectText(fromRenderObject: renderObject)
        
        s += ">"
        
        return s
    }
    
    fileprivate func renderObjectText(fromRenderObject renderObject: RenderObject) -> String {
        
        switch renderObject {
            
        case _ as RenderText:
            
            return "renderText"
            
        case _ as RenderBlock:
            
            return "renderBlock"
            
        case _ as RenderInline:
            
            return "renderInline"
            
        case _ as RenderParagraph:
            
            return "renderParagraph"
            
        case _ as RenderDocumentElement:
            
            return "renderDocumentElement"
            
        case _ as RenderDocumentFragment:
            
            return "renderDocumentFragment"
            
        default:
            
            return "unknown"
        }
    }
    
    
}
