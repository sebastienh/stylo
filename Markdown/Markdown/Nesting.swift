//
//  Nesting.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


///
/// Token#nesting -> Number
///
/// Level change (number in {-1, 0, 1} set), where:
///
/// -  `1` means the tag is opening
/// -  `0` means the tag is self-closing
/// - `-1` means the tag is closing
///
public enum Nesting: Int {
    
    /// -  `0` means the tag is self-closing
    case selfClosing = 0
    
    /// -  `1` means the tag is opening
    case opening = 1
    
    /// - `-1` means the tag is closing
    case closing = -1
    
    var associatedOpenNesting: Nesting? {
        
        switch self {
        case .closing:
            return .opening
        case .selfClosing:
            return .selfClosing
        case .opening:
            return nil
        }
    }
    
}
