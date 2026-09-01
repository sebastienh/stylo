//
//  CSSTextDecorationStyleKeyword.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-04-17.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

public enum CSSTextDecorationStyleKeyword: String {
    
    case solid
    case double
    case dotted
    case dashed
    case wavy
    
    public static var values: [CSSTextDecorationStyleKeyword] {
        
        return [
            .solid,
            .double,
            .dotted,
            .dashed,
            .wavy
        ]
    }
    
}
