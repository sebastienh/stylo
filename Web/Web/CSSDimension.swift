//
//  CSSDimension.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

enum CSSDimension : String {
    
    case EM = "em"
    
    case EX = "ex"
    
    case CH = "ch"
    
    case REM = "rem"
    
    case VW = "vw"
    
    case VH = "vh"
    
    case VMIN = "vmin"
    
    case VMAX = "vmax"
    
    case CM = "cm"
    
    case MM = "mm"
    
    case IN = "in"
    
    case PX = "px"
    
    case PT = "pt"
    
    case PC = "pc"
    
    case Q = "q"
    
    func cssLengthWithValue(_ value: CGFloat) -> CSSLength {
        
        switch self {
            
        case .CH:
            return CSSLength.ch(value)
            
        case .CM:
            return CSSLength.centimeters(value)
            
        case .EX:
            return CSSLength.ex(value)
            
        case .EM:
            return CSSLength.em(value)
            
        case .IN:
            return CSSLength.in(value)
            
        case .MM:
            return CSSLength.mm(value)
            
        case .Q:
            return CSSLength.q(value)
            
        case .PC:
            return CSSLength.pc(value)
            
        case .PT:
            return CSSLength.pt(value)
            
        case .PX:
            return CSSLength.px(value)
            
        case .REM:
            return CSSLength.rem(value)
            
        case .VH:
            return CSSLength.vh(value)
            
        case .VMAX:
            return CSSLength.vmax(value)
            
        case .VMIN:
            return CSSLength.vmin(value)
            
        case .VW:
            return CSSLength.vw(value)
        }
    }

    
}
