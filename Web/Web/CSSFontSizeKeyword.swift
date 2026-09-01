//
//  CSSFontSizeKeyword.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public enum CSSFontSizeKeyword: String {
    
    case XXSmall = "xx-small"
    case XSmall = "x-small"
    case Small = "small"
    case Medium = "medium"
    case Large = "large"
    case XLarge = "x-large"
    case XXLarge = "xx-large"
    case Larger = "larger"
    case Smaller = "smaller"
    
    public static var values: [CSSFontSizeKeyword] {
        
        return [
            .XXSmall,
            .XSmall,
            .Small,
            .Medium,
            .Large,
            .XLarge,
            .XXLarge,
            .Larger,
            .Smaller
        ]
    }
}
