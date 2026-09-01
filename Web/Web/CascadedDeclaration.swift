//
//  CascadedDeclaration.swift
//  Web
//
//  Created by Sebastien hamel on 2019-01-19.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

struct CascadedDeclaration {
    
    /// This returned specificity is the maximum specificity
    /// of all complex selectors
    var maxSpecificity: SelectorSpecificity {
        
        var highestSpecificity: SelectorSpecificity = complexSelectors.first!.selectorSpecificity
        
        for complexSelector in complexSelectors {
            
            let complexSelectorSpecificity = complexSelector.selectorSpecificity
            
            if complexSelectorSpecificity > highestSpecificity {
                highestSpecificity = complexSelectorSpecificity
            }
        }
        return highestSpecificity
    }
    
    let declaration: CSDeclaration
    
    let styleRule: CSSStyleRule
    
    let complexSelectors: [ComplexSelector]
    
    let order: Int
    
    init(declaration: CSDeclaration, styleRule: CSSStyleRule, complexSelectors: [ComplexSelector], order: Int) {
        
        self.declaration = declaration
        self.styleRule = styleRule
        self.complexSelectors = complexSelectors
        self.order = order
    }
    
    func isEqual(other: Any) -> Bool {
        
        if let other = other as? CascadedDeclaration {
        
            if !declaration.equals(to: other.declaration) {
                return false
            }
            if !styleRule.equals(to: other.styleRule) {
                return false
            }
            if maxSpecificity != other.maxSpecificity {
                return false
            }
            return true
        }
        return false
    }
}

extension CascadedDeclaration: Equatable {
    
    static func ==(lhs: CascadedDeclaration, rhs: CascadedDeclaration) -> Bool {
        
        return lhs.isEqual(other: rhs)
    }
}
