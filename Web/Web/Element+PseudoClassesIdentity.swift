//
//  PseudoClassesIdentifiableElement.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension Element {
    
    func treePseudoClassesIdentity(withFilterContext filterContext: FilterContext) -> TreePseudoClassesIdentity {
        
        var treePseudoClassesIdentity: TreePseudoClassesIdentity = ""
        
        // we do not need a peudo classes identity for css elements 
        guard !(self is CSSDOMElement) else {
            return treePseudoClassesIdentity
        }
        
        for (index, ancestor) in self.inclusiveAncestorsElements.enumerated() {
            
            if index != 0 {
                treePseudoClassesIdentity += "."
            }
            
            let pseudoClassesOptions = filterContext.pseudoClassesOptions(forElement: ancestor)
            treePseudoClassesIdentity += "\(ancestor.localName)-\(pseudoClassesOptions.description)"
        }
        
        return treePseudoClassesIdentity
    }
}
