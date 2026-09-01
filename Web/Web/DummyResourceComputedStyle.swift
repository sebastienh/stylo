//
//  DummyResourceComputedStyle.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-10-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public class DummyResourceComputedStyle: ComputedStyle {

    public var styleDefinition: StyleDefinition {
        
        return CSSStyle(id: "dsdsd")
    }
    
    public var paragraphStyle: [NSAttributedString.Key : Any]? {
        return [:]
    }
    
    public init() {
        
    }
    
    public func updateParagraphStyle(withAttributes attributes: [NSAttributedString.Key : Any]) {
        
    }
    
    public func attributes(for element: Element, filterContext: FilterContext) -> [[NSAttributedString.Key: Any]]? {
        
        return []
    }
    
    public func pseudoAttributes(for pseudoElement: PseudoElement, withElement element: Element, filterContext: FilterContext) -> [[NSAttributedString.Key: Any]]? {
        
        return []
    }
    
    public func computedStyle(forElement element: Element, filterContext: FilterContext) -> ComputedStyleDeclaration?  {
        
        return RawComputedStyle()
    }
    
    public func pseudoElements(for element: Element, filterContext: FilterContext) -> [PseudoElement]? {
        return nil
    }
    
    public func evaluateEphemeralStyle(for element: Element, filterContext: FilterContext) {
        // do nothign
    }
    
    public func computedStyle(forPseudoElement pseudoElement: PseudoElement, withElement element: Element, filterContext: FilterContext) -> ComputedStyleDeclaration? {
        return RawComputedStyle()
    }
    
    public func updateAttributes(for element: Element, with textAttributes: [NSAttributedString.Key: Any], andDecorationAttributes decorationAttributes: [NSAttributedString.Key: Any]?, filterContext: FilterContext) {
        
        // do nothing
    }
    
    public func updatePseudoAttributes(for pseudoElement: PseudoElement, withElement element: Element, with textAttributes: [NSAttributedString.Key: Any], andDecorationAttributes decorationAttributes: [NSAttributedString.Key: Any]?, filterContext: FilterContext) {
        
        // do nothing
    }
    
}
