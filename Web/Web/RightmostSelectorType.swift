//
//  RightmostSelectorType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-06.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

enum RightmostSelectorType {
    
    case id(DOMString)
    case pseudoElement(DOMString)
    case pseudoClass(DOMString)
    case tag(DOMString)
    case `class`(DOMString)
    case generic
    case invalid
    
    var isPseudoClass: Bool {
        switch self {
        case .pseudoClass(_):
            return true
        default:
            return false
        }
    }
    
    var isHighlight: Bool {
        switch self {
        case .pseudoClass(let string):
            return string == §PseudoSelectorType.highlight
        default:
            return false
        }
    }
    
}
