//
//  UnicodeDigit.swift
//  CommonStylo
//
//  Created by Sébastien Hamel on 2015-02-22.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public enum UnicodeDigit: UniChar {
    
    case    zero                 = 0x30
    case    one                  = 0x31
    case    two                  = 0x32
    case    three                = 0x33
    case    four                 = 0x34
    case    five                 = 0x35
    case    six                  = 0x36
    case    seven                = 0x37
    case    height               = 0x38
    case    nine                 = 0x39
    
    // see http://dev.w3.org/csswg/css-syntax/#digit
    public static func isUnicodeDigit(_ uniChar: UniChar) -> Bool {
        
        if let _ = UnicodeDigit(rawValue: uniChar) {
            
            return true;
        }
        
        return false;
    }
}
