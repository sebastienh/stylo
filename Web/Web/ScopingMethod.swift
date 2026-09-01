//
//  ScopingMethod.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

/// Scoping methods for selectors.
/// see http://dev.w3.org/csswg/selectors/#scoping-method
public enum ScopingMethod {
    
    /// With this method of scoping, selectors match as if the scoping 
    /// root were the root of the document.
    /// see http://dev.w3.org/csswg/selectors/#scope_contained
    case scopeContained
    
    /// With this method of scoping, a selector matches an element only if 
    /// the element is within the scope, even if other components of the 
    /// selector are outside the scope.
    /// see http://dev.w3.org/csswg/selectors/#scope_filtered
    case scopeFiltered
    
    /// With this scoping method, a selector matches an element only if
    /// the element is part if the root element, basically the root element
    /// are the only element that will be evaluated in this case.
    case scopeRoot
    
    /// Default scoping method when [evaluating a selector]
    /// (http://dev.w3.org/csswg/selectors/#evaluate-a-selector)
    case unscoped
    
}
