//
//  CSSStyle+ViewingStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-09-23.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

extension CSSStyle {
    
    /// This property returns a the CSSStyleDeclaration built from the current
    /// CSSStyle that applies to paragraph and can be used to viewing the document.
    // Mainly used for "Browse All Versions..." functionality.
    ///
    /// NW-1057
    public var viewingStyleDeclaration: ComputedStyleDeclaration? {
        
        let (viewingDocument, paragraphElement) = self.viewingDocument
        
        assert(viewingDocument != nil)
        assert(paragraphElement != nil)
        if let viewingDocument = viewingDocument, let paragraphElement = paragraphElement {
            
            let resourceComputedStyle = ResourceComputedStyle(styleDefinition: self)
            resourceComputedStyle.computeElementsStyles(document: viewingDocument, filterContext: FilterContext())
            return resourceComputedStyle.computedStyle(forElement:paragraphElement)
        }
        return nil
    }
    
    private var viewingDocument: (HtmlDocument?, HTMLParagraphElement?) {
        
        let viewingDocument = HtmlDocument.Create(nil)
        let body: HTMLBodyElement? = viewingDocument?.body
        
        assert(viewingDocument != nil)
        assert(body != nil)
        if let body = body {
            
            var exception = Exception()
            let paragraphElement = HTMLParagraphElement(document: viewingDocument)
            body.append(paragraphElement, exception: &exception)
            return (viewingDocument, paragraphElement)
        }
        return (nil, nil)
    }
}
