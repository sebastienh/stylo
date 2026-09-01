//
//  UnicodeHexDigit.swift
//  CommonStylo
//
//  Created by Sébastien Hamel on 2015-02-22.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public enum UnicodeHexDigit: UniChar {
    
    case    zero        =   0x30        /* ConstellationUnichar.Zero */
    case    one         =   0x31        /* ConstellationUnichar.One */
    case    two         =   0x32        /* ConstellationUnichar.Two */
    case    three       =   0x33        /* ConstellationUnichar.Three */
    case    four        =   0x34        /* ConstellationUnichar.Four */
    case    five        =   0x35        /* ConstellationUnichar.Five */
    case    six         =   0x36        /* ConstellationUnichar.Six */
    case    seven       =   0x37        /* ConstellationUnichar.Seven */
    case    height      =   0x38        /* ConstellationUnichar.Height */
    case    nine        =   0x39        /* ConstellationUnichar.Nine */
    case    A           =   0x41        /* A */
    case    B           =   0x42        /* B */
    case    C           =   0x43        /* C */
    case    D           =   0x44        /* D */
    case    E           =   0x45        /* E */
    case    F           =   0x46        /* F */
    case    a           =   0x61        /* a */
    case    b           =   0x62        /* b */
    case    c           =   0x63        /* c */
    case    d           =   0x64        /* d */
    case    e           =   0x65        /* e */
    case    f           =   0x66        /* f */
    
    // verify the code point is an hex digit.
    public static func isUnicodeHexDigit(_ uniChar: UniChar) -> Bool {
        
        if let _ = UnicodeHexDigit(rawValue: uniChar)  {
            return true;
        }
        return false;
    }
}
