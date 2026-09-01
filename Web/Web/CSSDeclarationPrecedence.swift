//
//  CSSDeclarationPrecedence.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-15.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

/// Origin and importance
/// see http://dev.w3.org/csswg/css-cascade-4/#cascade-origin
public enum CSSDeclarationPrecedence : Int, Comparable {
    
    // Transition declarations [CSS3-TRANSITIONS]
    case transitionDeclaration = 10
    
    // Important user agent declarations
    case importantUserAgentDeclaration = 9
    
    // Important user declarations
    case importantUserDeclaration = 8
    
    // Important override declarations [DOM-LEVEL-2-STYLE]
    case importantOverrideDeclaration = 7
    
    // Important author declarations
    case importantAuthorDeclaration = 6
    
    // Animation declarations [CSS3-ANIMATIONS]
    case animationDeclaration = 5
    
    // Normal override declarations [DOM-LEVEL-2-STYLE]
    case normalOverrideDeclaration = 4
    
    // Normal author declarations
    case normalAuthorDeclaration = 3
    
    // Normal user declarations
    case normalUserDeclaration = 2
    
    // Normal user agent declarations
    case normalUserAgentDeclaration = 1
}


public func <(lhs: CSSDeclarationPrecedence, rhs: CSSDeclarationPrecedence) -> Bool {
    
    return §lhs < §rhs
}
// Implementation of == required by Equatable
public func ==(lhs: CSSDeclarationPrecedence, rhs: CSSDeclarationPrecedence) -> Bool {
    
    return §lhs == §rhs
}
