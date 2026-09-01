//
//  CSSTextDecorationLine+Equatable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

extension CSSTextDecorationLine : Equatable {
    
}

public func ==(lhs: CSSTextDecorationLine, rhs: CSSTextDecorationLine) -> Bool {
    
    if lhs.textDecorationLineArray.count != rhs.textDecorationLineArray.count {

        return false
    }
    
    for lhsTextDecorationLine in lhs {
        
        var found: Bool = false
        
        for rhsTextDecorationLine in rhs {
         
            if lhsTextDecorationLine == rhsTextDecorationLine {
                
                found = true
                break
            }
        }
        
        if !found {
            
            return false
        }
    }
    
    return true
}
