//
//  StringReader.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-11.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation


protocol StringReader: class {
    
    func scan(_ characterIndex : Int) -> Token
    
}

