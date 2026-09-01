//
//  CSSStyleSheetSet.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-31.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

final class CSSStyleSheetSet {
    
    let name: DOMString
    
    var styleSheetList: StyleSheetList
    
    init(name: DOMString) {
        
        self.name = name
        self.styleSheetList = StyleSheetList()
    }
    
    func addStyleSheet(_ styleSheet: CSSStyleSheet) {
        
        styleSheetList.addStyleSheet(styleSheet)
    }
    
    func isStyleSheetInSet(_ styleSheet: CSSStyleSheet) -> Bool {
        
        for styleSheetInSet in styleSheetList {
            
            if styleSheetInSet.href == styleSheet.href {
                
                return true
            }
        }
        
        return false
    }
    
    /// Method that returns true if the set is enabled
    /// def : An enabled CSS style sheet set is a CSS style sheet set of 
    /// which each CSS style sheet has its disabled flag unset.
    /// see http://dev.w3.org/csswg/cssom/#enabled-css-style-sheet-set
    func isEnabled() -> Bool {
        
        for styleSheet in self {
         
            if !styleSheet.disabled {
                
                return false
            }
        }
        return true
    }
    
}
