//
//  CSSTextDecorationLineType+CSSPropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-04-17.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: CSSPropertyValueType protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSSTextDecorationLineType : CSSPropertyValueType {
    
    typealias PropertyValueType = CSSTextDecorationLineType
    
    static func valueFromKeyword(_ string: String) -> CSSTextDecorationLineType? {
        
        if let textDecorationLineKeyword = CSSTextDecorationLineKeyword(rawValue: string) {
            
            switch textDecorationLineKeyword {
                
            case .lineThrough:
                
                return CSSTextDecorationLineType.lineThrough
                
            case .`none`:
                
                return CSSTextDecorationLineType.noUnderline
                
            case .overline:
                
                return CSSTextDecorationLineType.overline
                
            case .underline:
                
                return CSSTextDecorationLineType.underline
            }
        }
        else if let defaultedKeyword = DefaultingType(rawValue: string) {
            
            return CSSTextDecorationLineType.defaulted(defaultedKeyword)
        }
        return nil
    }
    
}
