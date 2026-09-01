//
//  AttributeMatchClassType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

enum AttributeMatchClassType: String, CSSDOMAllowedClass {

    case ExactMatch = "exact-match"
    case IncludeMatch = "include-match"
    case DashMatch = "dash-match"
    case PrefixMatch = "prefix-match"
    case SuffixMatch = "suffix-match"
    case SubstringMatch = "substring-match"
}
