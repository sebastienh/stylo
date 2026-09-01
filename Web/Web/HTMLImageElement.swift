//
//  HTMLImageElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//[NamedConstructor=Image(optional unsigned long width, optional unsigned long height)]
//interface HTMLImageElement : HTMLElement {
//    attribute DOMString alt;
//    attribute DOMString src;
//    
//    attribute DOMString crossOrigin;
//    attribute DOMString useMap;
//    attribute boolean isMap;
//    attribute unsigned long width;
//    attribute unsigned long height;
//    readonly attribute unsigned long naturalWidth;
//    readonly attribute unsigned long naturalHeight;
//    readonly attribute boolean complete;
//};

/// > An img element represents an image.
///
/// see http://www.w3.org/TR/html5/embedded-content-0.html#the-img-element
public final class HTMLImageElement: HTMLElement {
    
    /// > The alt, src IDL attributes must reflect the respective 
    /// > content attributes of the same name.
    ///
    //    attribute DOMString alt;
    public var alt: DOMString = ""
    
    /// Attribute to keep the alt text region out of a source string
    public var altRegion: SourceStringRegion?
    
    //    attribute DOMString src;
    public var src: DOMString = ""
    
    /// > The crossOrigin IDL attribute must reflect the crossorigin content attribute, 
    /// > limited to only known values.
    ///
    //    attribute DOMString crossOrigin;
    public var crossOrigin: DOMString = ""
    
    /// > The useMap IDL attribute must reflect the usemap content attribute.
    ///
    //    attribute DOMString useMap;
    public var useMap: DOMString?
    
    /// > The isMap IDL attribute must reflect the ismap content attribute.
    ///
    //    attribute boolean isMap;
    public var isMap: Bool = false
    
    //    attribute unsigned long width;
    public var width: Int = 0
    
    //    attribute unsigned long height;
    public var height: Int = 0
    
    //    readonly attribute unsigned long naturalWidth;
    public internal(set) var naturalWidth: Int = 0
    
    //    readonly attribute unsigned long naturalHeight;
    public internal(set) var naturalHeight: Int = 0
    
    //    readonly attribute boolean complete;
    public internal(set) var complete: Bool = false
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "img")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLImageElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLImageElement {
        
        return super.cloneNode(deep) as! HTMLImageElement
    }
    
    ///
    override public func createInstance() -> HTMLImageElement {
        
        return HTMLImageElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLImageElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        copy.alt = self.alt
        copy.altRegion = self.altRegion
        copy.src = self.src
        copy.crossOrigin = self.crossOrigin
        copy.useMap = self.useMap
        copy.isMap = self.isMap
        copy.width = self.width
        copy.height = self.height
        copy.naturalWidth = self.naturalWidth
        copy.naturalHeight = self.naturalHeight
        copy.complete = self.complete
    }
    
}
