//
//  UnicodeLetter.swift
//  CommonStylo
//
//  Created by Sébastien Hamel on 2015-02-22.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public enum UnicodeLetter: UniChar {
    
    case    A       =   0x41      /* A */
    case    B       =   0x42      /* B */
    case    C       =   0x43      /* C */
    case    D       =   0x44      /* D */
    case    E       =   0x45      /* E */
    case    F       =   0x46      /* F */
    case    G       =   0x47      /* G */
    case    H       =   0x48      /* H */
    case    I       =   0x49      /* I */
    case    J       =   0x4a      /* J */
    case    K       =   0x4b      /* K */
    case    L       =   0x4c      /* L */
    case    M       =   0x4d      /* M */
    case    N       =   0x4e      /* N */
    case    O       =   0x4f      /* O */
    case    P       =   0x50      /* P */
    case    Q       =   0x51      /* Q */
    case    R       =   0x52      /* R */
    case    S       =   0x53      /* S */
    case    T       =   0x54      /* T */
    case    U       =   0x55      /* U */
    case    V       =   0x56      /* V */
    case    W       =   0x57      /* W */
    case    X       =   0x58      /* X */
    case    Y       =   0x59      /* Y */
    case    Z       =   0x5a      /* Z */
    case    a       =   0x61      /* a */
    case    b       =   0x62      /* b */
    case    c       =   0x63      /* c */
    case    d       =   0x64      /* d */
    case    e       =   0x65      /* e */
    case    f       =   0x66      /* f */
    case    g       =   0x67      /* g */
    case    h       =   0x68      /* h */
    case    i       =   0x69      /* i */
    case    j       =   0x6a      /* j */
    case    k       =   0x6b      /* k */
    case    l       =   0x6c      /* l */
    case    m       =   0x6d      /* m */
    case    n       =   0x6e      /* n */
    case    o       =   0x6f      /* o */
    case    p       =   0x70      /* p */
    case    q       =   0x71      /* q */
    case    r       =   0x72      /* r */
    case    s       =   0x73      /* s */
    case    t       =   0x74      /* t */
    case    u       =   0x75      /* u */
    case    v       =   0x76      /* v */
    case    w       =   0x77      /* w */
    case    x       =   0x78      /* x */
    case    y       =   0x79      /* y */
    case    z       =   0x7a      /* z */
    
    // return true if the codePoint is a letter.
    public static func isUnicodeLetter(_ uniChar: UniChar) -> Bool {
        
        if let _ = UnicodeLetter(rawValue: uniChar) {
            return true;
        }
        return false;
    }
    
    public static func isLowercaseLetter(_ uniChar: UniChar) -> Bool {
        
        if let letter = UnicodeLetter(rawValue: uniChar) {
            
            switch letter {
                
            case .a: return true
            case .b: return true
            case .c: return true
            case .d: return true
            case .e: return true
            case .f: return true
            case .g: return true
            case .h: return true
            case .i: return true
            case .j: return true
            case .k: return true
            case .l: return true
            case .m: return true
            case .n: return true
            case .o: return true
            case .p: return true
            case .q: return true
            case .r: return true
            case .s: return true
            case .t: return true
            case .u: return true
            case .v: return true
            case .w: return true
            case .x: return true
            case .y: return true
            case .z: return true
                
            default:
                
                break
            }
        }
        
        return false
    }
    
    public static func isUppercaseLetter(_ uniChar: UniChar) -> Bool {
        
        if let letter = UnicodeLetter(rawValue: uniChar) {
            
            switch letter {
                
            case .A: return true
            case .B: return true
            case .C: return true
            case .D: return true
            case .E: return true
            case .F: return true
            case .G: return true
            case .H: return true
            case .I: return true
            case .J: return true
            case .K: return true
            case .L: return true
            case .M: return true
            case .N: return true
            case .O: return true
            case .P: return true
            case .Q: return true
            case .R: return true
            case .S: return true
            case .T: return true
            case .U: return true
            case .V: return true
            case .W: return true
            case .X: return true
            case .Y: return true
            case .Z: return true
                
            default:
                
                break
            }
        }
        
        return false
    }
    
    public static func convertLowercaseIfNeeded(_ uniChar: UniChar) -> UniChar {
        
        if let letter = UnicodeLetter(rawValue: uniChar) {
        
            switch letter {
            
            case .A: return §UnicodeLetter.a
            case .B: return §UnicodeLetter.b
            case .C: return §UnicodeLetter.c
            case .D: return §UnicodeLetter.d
            case .E: return §UnicodeLetter.e
            case .F: return §UnicodeLetter.f
            case .G: return §UnicodeLetter.g
            case .H: return §UnicodeLetter.h
            case .I: return §UnicodeLetter.i
            case .J: return §UnicodeLetter.j
            case .K: return §UnicodeLetter.k
            case .L: return §UnicodeLetter.l
            case .M: return §UnicodeLetter.m
            case .N: return §UnicodeLetter.n
            case .O: return §UnicodeLetter.o
            case .P: return §UnicodeLetter.p
            case .Q: return §UnicodeLetter.q
            case .R: return §UnicodeLetter.r
            case .S: return §UnicodeLetter.s
            case .T: return §UnicodeLetter.t
            case .U: return §UnicodeLetter.u
            case .V: return §UnicodeLetter.v
            case .W: return §UnicodeLetter.w
            case .X: return §UnicodeLetter.x
            case .Y: return §UnicodeLetter.y
            case .Z: return §UnicodeLetter.z
                
            default:
                
                break
                
            }
        }
        
        return uniChar
    }
    
}

