//
//  CSSTextDecorationLineValidatorDelegate.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-28.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation


final class CSSTextDecorationLineValidatorDelegate {
    
    init() {
         
    }
    
    func validateNoneIsAloneIfPresent(_ textDecorationLine: CSSTextDecorationLine) -> Bool {
        
        for type in textDecorationLine {
         
            if type == CSSTextDecorationLineType.noUnderline {
             
                // there must be only one entry if none is present
                return textDecorationLine.textDecorationLineArray.count == 1
            }
        }
        
        return true
    }
    
}
