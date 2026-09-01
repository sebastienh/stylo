//
//  CSSPropertyValueContainer+TextDecorationLine.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-23.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

public extension CSSPropertyValueContainer {
    
    public func isTextDecorationLineNone() -> Bool {
        
        switch self {
            
        case .textDecorationLine(let textDecorationLine):
            
            if textDecorationLine.textDecorationLineArray.count > 1 {
             
                return false
            }
            else if let textDecorationLineValue = textDecorationLine.textDecorationLineArray.first {
                
                if textDecorationLineValue == .noUnderline {
                    
                    return true
                }
            }
            
        default:
            
            assert(false, "Expecting textDecorationLine.")
            return false
        }
        
        return false
    }
    
}
