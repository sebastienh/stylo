//
//  TokenReader.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-11.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

protocol TokenReader {
    
    mutating func read() -> Token
    
    mutating func reRead() -> Token
}
