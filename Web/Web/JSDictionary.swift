//
//  JSDictionary.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-11.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

import Foundation

class JSDictionary {
    
    var values: [String:JSDictionaryMember]
    var globalIndex: Int
    
    init() {
        
        values = [String:JSDictionaryMember]()
        self.globalIndex = 0
    }
    
}
