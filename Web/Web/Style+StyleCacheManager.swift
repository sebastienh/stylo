//
//  StyleManager+StyleCacheManager.swift
//  Web
//
//  Created by Sebastien hamel on 2015-05-09.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol StyleCacheManager {
    
    
}

extension Style : StyleCacheManager {
    
    func initializeStyleCache() {
        
        
    }
    
    func reinitializeForStyleSheet(styleSheet: CSSStyleSheet, invalidate: Bool = true) {
        
        if invalidate {
            
            // when a style sheet is changed only sorted rules for
            // this style sheet need to be recomputed.
            invalidateSortedRulesMapForStyleSheet(styleSheet)
            
            // when a style sheet is changed only applicable rules for
            // this style sheet need to be recomputed.
            invalidateStyleSheetApplicableRulesCacheForStyleSheet(styleSheet)
            
            // when a style sheet is changed all computed element styles
            // need to be recalculated
            invalidateElementStyleCache()
        }
        
        // when a style sheet is changed we need to recompute all
        // sorting rules information.
        initializeSortedRulesMapsInformationForStyleSheet(styleSheet)
        
        // TODO: make sur that's the only things that could be
        // initialized, or think about a way to optimize this.
    }
    
}