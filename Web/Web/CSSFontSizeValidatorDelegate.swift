//
//  CSSFontSizeValidatorDelegate.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation


final class CSSFontSizeValidatorDelegate {
    
    init() {
         
    }
    
    func validateFontSizeValueIsNonNegative(_ value: CGFloat) -> Bool {
        
        if value < 0 {
            return false
        }
        return true
    }
    
}
