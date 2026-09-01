//
//  TokenId.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-09-26.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

struct TokenId : Hashable {
    
    var hashValue: Int {
        get {
            // better hashing may be needed in the future
            return value.hashValue
        }
    }
    
    let value: UInt16
    
    init(value: UInt16) {
        self.value = value
    }
    
}

func == (lhs:TokenId, rhs:TokenId) -> Bool {
    return lhs.value == rhs.value
}
