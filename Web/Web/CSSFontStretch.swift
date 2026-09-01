//
//  CSSFontStretch.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

enum CSSFontStretch : String {
    
    case Normal = "normal"
    case UltraCondensed = "ultra-condensed"
    case ExtraCondensed = "extra-condensed"
    case Condensed = "condensed"
    case SemiCondensed = "semi-condensed"
    case SemiExpanded = "semi-expanded"
    case Expanded = "expanded"
    case ExtraExpanded = "extra-expanded"
    case UltraExpanded = "ultra-expanded"
    case Inherit = "inherit"
    
    func isInherit() -> Bool {
        
        return self == .Inherit
    }
    
}
