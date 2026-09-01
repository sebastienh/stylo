//
//  CSSTextDecorationLineKeyword.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-04-17.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

public enum CSSTextDecorationLineKeyword: String {
    
    case `none` = "none"
    case underline = "underline"
    case overline = "overline"
    case lineThrough = "line-through"
    
    public static var values: [CSSTextDecorationLineKeyword] {
        
        return [
            .`none`,
            .underline,
            .overline,
            .lineThrough
        ]
    }
    
}
