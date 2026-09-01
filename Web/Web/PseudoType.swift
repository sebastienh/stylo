//
//  PseudoType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-01.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

enum PseudoType {
    
    case elementSelector(firstColonToken: Token, secondColonToken: Token)
    case classSelector(firstColonToken: Token)
    
    var lookahead: Int {
        
        switch self {
            
        case .classSelector(_):
            return 1
        case .elementSelector(_, _):
            return 2
        }
    }
    
    var startIndex: Int? {
        
        switch self {
            
        case .classSelector(let firstColonToken):
            return firstColonToken.sourceStringSegment?.startIndex
            
        case .elementSelector(let firstColonToken, _):
            return firstColonToken.sourceStringSegment?.startIndex
        }
    }
}
