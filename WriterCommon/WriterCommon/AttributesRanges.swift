//
//  AttributesRanges.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-05.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

public enum AttributesRanges {
    
    case pending
    case computed(ranges: [NSRange])
    case applied
}
