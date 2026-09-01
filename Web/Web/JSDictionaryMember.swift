//
//  JSDictionaryMember.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-11.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

final class JSDictionaryMember {
    
    var value: Any?
    var present: Bool
    var index: Int
    
    init(_ index: Int) {
        self.index = index
        self.present = false
    }
    
    init(_ index: Int, _ value: Any) {
        self.index = index
        self.value = value
        self.present = true
    }
}
