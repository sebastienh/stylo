//
//  ComputedStyle.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public protocol ComputedStyle {
    
    var styleDefinition: StyleDefinition { get }
    
    var paragraphStyle: [NSAttributedString.Key : Any]? { get }
    
    func updateParagraphStyle(withAttributes attributes: [NSAttributedString.Key : Any])
    
    func attributes(for element: Element, filterContext: FilterContext) -> [[NSAttributedString.Key: Any]]?
    
    func pseudoAttributes(for pseudoElement: PseudoElement, withElement element: Element, filterContext: FilterContext) -> [[NSAttributedString.Key: Any]]? 
    
    func pseudoElements(for element: Element, filterContext: FilterContext) -> [PseudoElement]?
    
    func evaluateEphemeralStyle(for element: Element, filterContext: FilterContext) 
    
    func computedStyle(forElement element: Element, filterContext: FilterContext) -> ComputedStyleDeclaration? 
    
    func computedStyle(forPseudoElement pseudoElement: PseudoElement, withElement element: Element, filterContext: FilterContext) -> ComputedStyleDeclaration?
    
    func updateAttributes(for element: Element, with textAttributes: [NSAttributedString.Key: Any], andDecorationAttributes decorationAttributes: [NSAttributedString.Key: Any]?, filterContext: FilterContext)
    
    func updatePseudoAttributes(for pseudoElement: PseudoElement, withElement element: Element, with textAttributes: [NSAttributedString.Key: Any], andDecorationAttributes decorationAttributes: [NSAttributedString.Key: Any]?, filterContext: FilterContext) 
}
