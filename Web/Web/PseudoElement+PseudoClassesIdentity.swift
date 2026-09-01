//
//  PseudoElement+PseudoClassesIdentifiableElement.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension PseudoElement {
    
    func treePseudoClassesIdentity(withElement element: Element, filterContext: FilterContext) -> TreePseudoClassesIdentity {
        
        var elementTreePseudoClassesIdentity = element.treePseudoClassesIdentity(withFilterContext: filterContext)
        elementTreePseudoClassesIdentity += ".\(self.localName)"
        return elementTreePseudoClassesIdentity
    }
}
