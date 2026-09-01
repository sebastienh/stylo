//
//  UnicodeWhitespace.swift
//  CommonStylo
//
//  Created by Sébastien Hamel on 2015-02-22.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public enum UnicodeWhitespace: UniChar {
    
    case    whitespace              =   0x20        /* NMUnichar.Whitespace */
    case    characterTabulation     =   0x09        /* ConstellationUnichar.CharacterTabulation */
    case    lineFeed                =   0x0a        /* ConstellationUnichar.LineFeed */
    
    // see http://dev.w3.org/csswg/css-syntax/#whitespace
    public static func isUnicodeWhitespace(_ uniChar: UniChar) -> Bool {
        
        if let _ = UnicodeWhitespace(rawValue: uniChar) {
            return true;
        }
        return false;
    }
}
